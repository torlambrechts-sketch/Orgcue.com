-- Shared workspaces for OrgCue: optional sign-in so a team can share one workspace.
--
-- The whole saved app state lives in workspaces.data (jsonb), the same JSON the page keeps in localStorage.
-- Roles: admin > editor > contributor > viewer.
--   * Every member can read the workspace, its members and (admins only) its pending invites.
--   * Admins, editors and contributors can save the workspace through save_workspace(), which checks the
--     version (optimistic locking) and bumps it. Contributors may save because they edit tasks, check-ins,
--     comments and status updates, which live in the same document. Which parts of the document a role may
--     change is enforced in the page (EXT.guard); the database enforces who may write the document at all.
--   * Viewers can read but never save.
--   * Admins manage members (change roles, remove) and invites. Anyone can leave a workspace; the last
--     admin cannot leave or be demoted while other members remain.
--   * create_workspace() makes the creator its admin; accept_invites() adds the signed-in user to every
--     workspace that invited their (confirmed) email address.
-- Realtime is enabled on workspaces so other members' saves arrive live (RLS applies to subscribers).

-- ---------- tables ----------
create table public.workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 1 and 120),
  data jsonb not null default '{}'::jsonb,
  version integer not null default 1,
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users (id) on delete set null
);

create table public.workspace_members (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  email text not null,
  name text,
  role text not null check (role in ('admin', 'editor', 'contributor', 'viewer')),
  joined_at timestamptz not null default now(),
  primary key (workspace_id, user_id)
);
create index workspace_members_user_idx on public.workspace_members (user_id);

create table public.workspace_invites (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  email text not null check (email = lower(btrim(email)) and email like '%_@_%'),
  role text not null check (role in ('admin', 'editor', 'contributor', 'viewer')),
  invited_by uuid default auth.uid() references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (workspace_id, email)
);
create index workspace_invites_email_idx on public.workspace_invites (email);

-- ---------- helpers (SECURITY DEFINER so policies do not recurse into workspace_members' own RLS) ----------
create function public.workspace_role(p_workspace uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select m.role from public.workspace_members m
  where m.workspace_id = p_workspace and m.user_id = auth.uid()
$$;

create function public.role_rank(p_role text)
returns integer
language sql
immutable
set search_path = ''
as $$
  select case p_role when 'admin' then 3 when 'editor' then 2 when 'contributor' then 1 when 'viewer' then 0 else -1 end
$$;

-- the signed-in user's confirmed email, lower case (null when unconfirmed)
create function public.my_confirmed_email()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select lower(u.email) from auth.users u where u.id = auth.uid() and u.email_confirmed_at is not null
$$;

-- ---------- row level security ----------
alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;
alter table public.workspace_invites enable row level security;

-- workspaces: members read; admins delete; all writes of data go through save_workspace()
create policy "members read their workspaces" on public.workspaces
  for select to authenticated using (public.workspace_role(id) is not null);
create policy "admins delete their workspaces" on public.workspaces
  for delete to authenticated using (public.workspace_role(id) = 'admin');

-- members: members see each other; admins change roles; admins remove anyone, anyone removes themselves
create policy "members see fellow members" on public.workspace_members
  for select to authenticated using (public.workspace_role(workspace_id) is not null);
create policy "admins change roles" on public.workspace_members
  for update to authenticated
  using (public.workspace_role(workspace_id) = 'admin')
  with check (public.workspace_role(workspace_id) = 'admin');
create policy "admins remove members, members leave" on public.workspace_members
  for delete to authenticated
  using (public.workspace_role(workspace_id) = 'admin' or user_id = auth.uid());

-- invites: admins manage; invitees see invites to their own confirmed email
create policy "admins and invitees read invites" on public.workspace_invites
  for select to authenticated
  using (public.workspace_role(workspace_id) = 'admin' or email = public.my_confirmed_email());
create policy "admins invite" on public.workspace_invites
  for insert to authenticated
  with check (public.workspace_role(workspace_id) = 'admin' and invited_by = auth.uid());
create policy "admins revoke invites" on public.workspace_invites
  for delete to authenticated using (public.workspace_role(workspace_id) = 'admin');

-- privileges: nothing for anonymous visitors; members may only change the role column
revoke all on public.workspaces, public.workspace_members, public.workspace_invites from anon;
revoke all on public.workspaces, public.workspace_members, public.workspace_invites from authenticated;
grant select, delete on public.workspaces to authenticated;
grant select, delete on public.workspace_members to authenticated;
grant update (role) on public.workspace_members to authenticated;
grant select, insert, delete on public.workspace_invites to authenticated;

-- ---------- keep at least one admin ----------
create function public.keep_one_admin()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.role = 'admin' and (tg_op = 'DELETE' or new.role <> 'admin') then
    -- the workspace itself is being deleted (cascade): nothing to protect
    if not exists (select 1 from public.workspaces w where w.id = old.workspace_id) then
      return case when tg_op = 'DELETE' then old else new end;
    end if;
    if not exists (
      select 1 from public.workspace_members m
      where m.workspace_id = old.workspace_id and m.role = 'admin' and m.user_id <> old.user_id
    ) and exists (
      select 1 from public.workspace_members m
      where m.workspace_id = old.workspace_id and m.user_id <> old.user_id
    ) then
      raise exception 'A workspace needs at least one admin. Make someone else an admin first.'
        using errcode = 'P0001';
    end if;
  end if;
  return case when tg_op = 'DELETE' then old else new end;
end
$$;
create trigger workspace_members_keep_one_admin
  before update or delete on public.workspace_members
  for each row execute function public.keep_one_admin();

-- ---------- functions the page calls ----------
-- create a workspace from the current app state; the creator becomes its admin
create function public.create_workspace(p_name text, p_data jsonb)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid;
  v_email text;
  v_name text;
begin
  if auth.uid() is null then
    raise exception 'Sign in first.' using errcode = '42501';
  end if;
  if octet_length(p_data::text) > 8000000 then
    raise exception 'The workspace is too large to save.' using errcode = '54000';
  end if;
  select u.email, coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1))
    into v_email, v_name from auth.users u where u.id = auth.uid();
  insert into public.workspaces (name, data, created_by, updated_by)
    values (btrim(p_name), coalesce(p_data, '{}'::jsonb), auth.uid(), auth.uid())
    returning id into v_id;
  insert into public.workspace_members (workspace_id, user_id, email, name, role)
    values (v_id, auth.uid(), lower(v_email), v_name, 'admin');
  return v_id;
end
$$;

-- save the whole state when the caller's copy is current; returns {ok, version, updated_by}
create function public.save_workspace(p_id uuid, p_data jsonb, p_expected_version integer)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_role text := public.workspace_role(p_id);
  v_version integer;
begin
  if v_role is null then
    raise exception 'You are not a member of this workspace.' using errcode = '42501';
  end if;
  if public.role_rank(v_role) < public.role_rank('contributor') then
    raise exception 'Viewers cannot save changes.' using errcode = '42501';
  end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' then
    raise exception 'Nothing to save.' using errcode = '22023';
  end if;
  if octet_length(p_data::text) > 8000000 then
    raise exception 'The workspace is too large to save.' using errcode = '54000';
  end if;
  update public.workspaces w
     set data = p_data, version = w.version + 1, updated_at = now(), updated_by = auth.uid()
   where w.id = p_id and w.version = p_expected_version
  returning w.version into v_version;
  if v_version is null then
    select w.version into v_version from public.workspaces w where w.id = p_id;
    return jsonb_build_object('ok', false, 'version', v_version);
  end if;
  return jsonb_build_object('ok', true, 'version', v_version, 'updated_by', auth.uid());
end
$$;

-- pending invites for the signed-in user's confirmed email, with the workspace name
create function public.my_invites()
returns table (workspace_id uuid, workspace_name text, role text, invited_at timestamptz)
language sql
stable
security definer
set search_path = ''
as $$
  select i.workspace_id, w.name, i.role, i.created_at
  from public.workspace_invites i
  join public.workspaces w on w.id = i.workspace_id
  where i.email = public.my_confirmed_email()
    and not exists (select 1 from public.workspace_members m where m.workspace_id = i.workspace_id and m.user_id = auth.uid())
  order by i.created_at
$$;

-- join every workspace that invited the signed-in user's confirmed email; returns the joined workspaces
create function public.accept_invites()
returns table (workspace_id uuid, workspace_name text, role text)
language plpgsql
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_email text := public.my_confirmed_email();
  v_name text;
begin
  if auth.uid() is null or v_email is null then
    return;
  end if;
  select coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1)) into v_name
    from auth.users u where u.id = auth.uid();
  return query
  with inv as (
    delete from public.workspace_invites i where i.email = v_email returning i.workspace_id, i.role
  ), ins as (
    insert into public.workspace_members (workspace_id, user_id, email, name, role)
    select inv.workspace_id, auth.uid(), v_email, v_name, inv.role from inv
    on conflict on constraint workspace_members_pkey do nothing
    returning workspace_members.workspace_id, workspace_members.role
  )
  select ins.workspace_id, w.name, ins.role from ins join public.workspaces w on w.id = ins.workspace_id;
end
$$;

-- leave a workspace; the last member leaving deletes it
create function public.leave_workspace(p_id uuid)
returns text
language plpgsql
security definer
set search_path = ''
as $$
begin
  if public.workspace_role(p_id) is null then
    raise exception 'You are not a member of this workspace.' using errcode = '42501';
  end if;
  if not exists (select 1 from public.workspace_members m where m.workspace_id = p_id and m.user_id <> auth.uid()) then
    delete from public.workspaces w where w.id = p_id;
    return 'deleted';
  end if;
  delete from public.workspace_members m where m.workspace_id = p_id and m.user_id = auth.uid();
  return 'left';
end
$$;

-- function privileges: signed-in users only
revoke all on function public.workspace_role(uuid), public.role_rank(text), public.my_confirmed_email(),
  public.keep_one_admin(), public.create_workspace(text, jsonb), public.save_workspace(uuid, jsonb, integer),
  public.my_invites(), public.accept_invites(), public.leave_workspace(uuid) from public, anon;
grant execute on function public.workspace_role(uuid), public.role_rank(text), public.my_confirmed_email(),
  public.create_workspace(text, jsonb), public.save_workspace(uuid, jsonb, integer),
  public.my_invites(), public.accept_invites(), public.leave_workspace(uuid) to authenticated;

-- ---------- realtime ----------
alter publication supabase_realtime add table public.workspaces;
