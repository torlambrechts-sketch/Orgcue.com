-- OrgCue access, RM72: guest access for clients and partners.
--
-- A guest is a workspace member with role 'guest'. They see only the initiatives shared with them (and the work that
-- hangs off those initiatives: tasks, milestones, comments, documents ...), never the rest of the workspace.
--   workspace_guest_scopes   what a guest may see and do: the initiatives shared with them and their rights
--                            view        read only
--                            contribute  also comment, and update the status and progress of tasks assigned to them
--     A scope row belongs to a member (user_id) or, before they join, to an invite (email, user_id null).
--   orgcue_guest_invite()    an admin invites a guest by email to chosen initiatives, with rights (and optionally the
--                            person they join as); re-inviting changes the invite's scope
--   orgcue_guest_scope_set() an admin changes the initiatives and rights of a guest who has joined
--   accept_invites()         as before; a guest invite's scope moves to the new member
-- Guests see only their own membership row, never the other members. They cannot copy the workspace into a new one,
-- run the integrity check, or read a legacy workspaces.data document.
-- What a guest loads and may change is in 20261110134600_access_guest_load_apply.sql; presence in 20261110134700.
-- Every other role behaves exactly as before.

-- ---------- the guest role ----------
alter table public.workspace_members drop constraint if exists workspace_members_role_check;
alter table public.workspace_members add constraint workspace_members_role_check
  check (role in ('admin', 'editor', 'contributor', 'viewer', 'guest'));
alter table public.workspace_invites drop constraint if exists workspace_invites_role_check;
alter table public.workspace_invites add constraint workspace_invites_role_check
  check (role in ('admin', 'editor', 'contributor', 'viewer', 'guest'));

-- ---------- guest scopes ----------
create table if not exists public.workspace_guest_scopes (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  user_id uuid references auth.users (id) on delete cascade,
  email text check (email is null or (email = lower(btrim(email)) and email like '%_@_%')),
  initiative_ids text[] not null default '{}',
  rights text not null default 'view' check (rights in ('view', 'contribute')),
  updated_by uuid default auth.uid() references auth.users (id) on delete set null,
  updated_at timestamptz not null default now(),
  check (user_id is not null or email is not null)
);
create unique index if not exists workspace_guest_scopes_member_idx
  on public.workspace_guest_scopes (workspace_id, user_id) where user_id is not null;
create unique index if not exists workspace_guest_scopes_invite_idx
  on public.workspace_guest_scopes (workspace_id, email) where user_id is null;
comment on table public.workspace_guest_scopes is
  'What a guest may see and do: the initiatives shared with them and their rights (view, or contribute: comment and update their own tasks). user_id null = a pending invite (email).';

alter table public.workspace_guest_scopes enable row level security;
create policy "admins and the guest read guest scopes" on public.workspace_guest_scopes
  for select to authenticated
  using (public.workspace_role(workspace_id) = 'admin' or user_id = auth.uid());
revoke all on public.workspace_guest_scopes from anon, authenticated;
grant select on public.workspace_guest_scopes to authenticated;

-- the signed-in guest's scope in a workspace (no row when they are not a guest there)
create or replace function public.orgcue_guest_scope(p_ws uuid)
returns table (initiative_ids text[], rights text, person_id text)
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(s.initiative_ids, '{}'), coalesce(s.rights, 'view'), m.person_id
  from public.workspace_members m
  left join public.workspace_guest_scopes s on s.workspace_id = m.workspace_id and s.user_id = m.user_id
  where m.workspace_id = p_ws and m.user_id = auth.uid() and m.role = 'guest'
$$;

-- the initiatives of a workspace that exist, from a list (order kept, duplicates dropped)
create or replace function public.orgcue_guest_clean_ids(p_ws uuid, p_ids text[])
returns text[]
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(array_agg(x.id order by x.o), '{}')
  from (select distinct on (u.id) u.id, u.o from unnest(coalesce(p_ids, '{}')) with ordinality as u(id, o) order by u.id, u.o) x
  where exists (select 1 from public.initiatives i where i.workspace_id = p_ws and i.id = x.id)
$$;

-- an admin invites a guest by email to chosen initiatives; inviting again changes the scope of the open invite
create or replace function public.orgcue_guest_invite(p_ws uuid, p_email text, p_initiatives text[], p_rights text,
                                                      p_person text default null)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_email text := lower(btrim(coalesce(p_email, '')));
  v_ids text[];
begin
  if public.workspace_role(p_ws) is distinct from 'admin' then
    raise exception 'Only admins can invite guests.' using errcode = '42501';
  end if;
  if (select kind from public.workspaces where id = p_ws) is distinct from 'team' then
    raise exception 'Guests can only join a shared workspace.' using errcode = '42501';
  end if;
  if v_email !~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$' then
    raise exception 'Enter a valid email address.' using errcode = '22023';
  end if;
  if coalesce(p_rights, '') not in ('view', 'contribute') then
    raise exception 'Choose view only, or comment and update their tasks.' using errcode = '22023';
  end if;
  if exists (select 1 from public.workspace_members m where m.workspace_id = p_ws and lower(m.email) = v_email) then
    raise exception '% is already a member of this workspace.', v_email using errcode = '23505';
  end if;
  v_ids := public.orgcue_guest_clean_ids(p_ws, p_initiatives);
  if cardinality(v_ids) = 0 then
    raise exception 'Choose at least one initiative to share.' using errcode = '22023';
  end if;
  if p_person is not null then
    if not exists (select 1 from public.people p where p.workspace_id = p_ws and p.id = p_person) then
      raise exception 'There is no person % in this workspace.', p_person using errcode = 'P0002';
    end if;
    if exists (select 1 from public.workspace_members m where m.workspace_id = p_ws and m.person_id = p_person) then
      raise exception 'That person is already linked to a member.' using errcode = '23505';
    end if;
  end if;
  insert into public.workspace_invites (workspace_id, email, role, invited_by, person_id)
  values (p_ws, v_email, 'guest', auth.uid(), p_person)
  on conflict (workspace_id, email) do update
    set role = 'guest', person_id = excluded.person_id, invited_by = excluded.invited_by, created_at = now();
  delete from public.workspace_guest_scopes s where s.workspace_id = p_ws and s.user_id is null and s.email = v_email;
  insert into public.workspace_guest_scopes (workspace_id, email, initiative_ids, rights, updated_by)
  values (p_ws, v_email, v_ids, p_rights, auth.uid());
  return jsonb_build_object('email', v_email, 'initiative_ids', to_jsonb(v_ids), 'rights', p_rights);
end;
$$;

-- an admin changes what a guest who has joined may see and do
create or replace function public.orgcue_guest_scope_set(p_ws uuid, p_user uuid, p_initiatives text[], p_rights text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_ids text[];
  v_email text;
begin
  if public.workspace_role(p_ws) is distinct from 'admin' then
    raise exception 'Only admins can change what guests see.' using errcode = '42501';
  end if;
  select m.email into v_email from public.workspace_members m where m.workspace_id = p_ws and m.user_id = p_user and m.role = 'guest';
  if not found then
    raise exception 'They are not a guest in this workspace.' using errcode = 'P0002';
  end if;
  if coalesce(p_rights, '') not in ('view', 'contribute') then
    raise exception 'Choose view only, or comment and update their tasks.' using errcode = '22023';
  end if;
  v_ids := public.orgcue_guest_clean_ids(p_ws, p_initiatives);
  delete from public.workspace_guest_scopes s where s.workspace_id = p_ws and s.user_id = p_user;
  insert into public.workspace_guest_scopes (workspace_id, user_id, email, initiative_ids, rights, updated_by)
  values (p_ws, p_user, lower(v_email), v_ids, p_rights, auth.uid());
  -- the guest's page reloads its rows when the version moves on
  update public.workspaces w set version = w.version + 1, updated_at = now(), updated_by = auth.uid() where w.id = p_ws;
  return jsonb_build_object('user_id', p_user, 'initiative_ids', to_jsonb(v_ids), 'rights', p_rights);
end;
$$;

-- tidy up: a cancelled invite takes its scope with it; a member who leaves or is removed takes theirs
create or replace function public.orgcue_guest_scope_tidy()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_table_name = 'workspace_invites' then
    delete from public.workspace_guest_scopes s
     where s.workspace_id = old.workspace_id and s.user_id is null and s.email = old.email;
  else
    delete from public.workspace_guest_scopes s where s.workspace_id = old.workspace_id and s.user_id = old.user_id;
  end if;
  return old;
end;
$$;
drop trigger if exists workspace_invites_guest_scope_tidy on public.workspace_invites;
create trigger workspace_invites_guest_scope_tidy after delete on public.workspace_invites
  for each row execute function public.orgcue_guest_scope_tidy();
drop trigger if exists workspace_members_guest_scope_tidy on public.workspace_members;
create trigger workspace_members_guest_scope_tidy after delete on public.workspace_members
  for each row execute function public.orgcue_guest_scope_tidy();

-- ---------- accepting invites (body of 20261110100000_platform2_member_people.sql, plus: a guest invite's scope moves to the member) ----------
create or replace function public.accept_invites()
returns table (workspace_id uuid, workspace_name text, role text)
language plpgsql
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_email text := public.my_confirmed_email();
  v_name text;
  v_person text;
  i record;
begin
  if auth.uid() is null or v_email is null then
    return;
  end if;
  select coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1)) into v_name
    from auth.users u where u.id = auth.uid();
  -- guest invites: the scope becomes the new member's (before the invite is deleted, which would tidy it away)
  delete from public.workspace_guest_scopes s
   where s.user_id = auth.uid()
     and exists (select 1 from public.workspace_guest_scopes p
                  where p.workspace_id = s.workspace_id and p.user_id is null and p.email = v_email)
     and not exists (select 1 from public.workspace_members m where m.workspace_id = s.workspace_id and m.user_id = auth.uid());
  update public.workspace_guest_scopes s set user_id = auth.uid(), updated_at = now()
   where s.user_id is null and s.email = v_email
     and exists (select 1 from public.workspace_invites wi where wi.workspace_id = s.workspace_id and wi.email = v_email and wi.role = 'guest')
     and not exists (select 1 from public.workspace_members m where m.workspace_id = s.workspace_id and m.user_id = auth.uid());
  for i in delete from public.workspace_invites wi where wi.email = v_email returning wi.workspace_id, wi.role, wi.person_id loop
    if exists (select 1 from public.workspace_members m where m.workspace_id = i.workspace_id and m.user_id = auth.uid()) then
      continue;
    end if;
    if i.person_id is not null
       and exists (select 1 from public.people p where p.workspace_id = i.workspace_id and p.id = i.person_id)
       and not exists (select 1 from public.workspace_members m where m.workspace_id = i.workspace_id and m.person_id = i.person_id) then
      v_person := i.person_id;
    else
      v_person := public.orgcue_new_person(i.workspace_id, v_name);
      update public.workspaces w set version = w.version + 1, updated_at = now() where w.id = i.workspace_id;
    end if;
    insert into public.workspace_members (workspace_id, user_id, email, name, role, person_id)
    values (i.workspace_id, auth.uid(), v_email, v_name, i.role, v_person);
    workspace_id := i.workspace_id;
    role := i.role;
    select w.name into workspace_name from public.workspaces w where w.id = i.workspace_id;
    return next;
  end loop;
end;
$$;

-- ---------- what guests may read directly ----------
-- members: guests see only themselves (everyone else as before)
drop policy if exists "members see fellow members" on public.workspace_members;
create policy "members see fellow members" on public.workspace_members
  for select to authenticated
  using (public.workspace_role(workspace_id) is not null
         and (public.workspace_role(workspace_id) <> 'guest' or user_id = auth.uid()));
-- workspaces: a guest never reads a legacy whole-workspace document (data); new workspaces keep it empty
drop policy if exists "members read their workspaces" on public.workspaces;
create policy "members read their workspaces" on public.workspaces
  for select to authenticated
  using (public.workspace_role(id) is not null
         and (public.workspace_role(id) <> 'guest' or data = '{}'::jsonb));

-- ---------- access (body of 20261110090000_data_core.sql, plus the guest role) ----------
create or replace function public.orgcue_access(p_ws uuid, p_token text, p_write boolean)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  w public.workspaces;
  r text;
begin
  select * into w from public.workspaces where id = p_ws;
  if not found then
    raise exception 'Workspace not found' using errcode = 'P0002';
  end if;
  if w.kind in ('demo', 'product') then
    if p_write then raise exception 'This workspace is read-only' using errcode = '42501'; end if;
    return 'viewer';
  end if;
  if w.kind = 'sandbox' then
    if p_token is null or w.token_hash is distinct from encode(extensions.digest(p_token, 'sha256'), 'hex') then
      raise exception 'No access to this workspace' using errcode = '42501';
    end if;
    if w.expires_at < now() then
      raise exception 'This demo session has expired' using errcode = 'P0003';
    end if;
    return 'admin';
  end if;
  r := public.workspace_role(p_ws);
  if r is null then
    raise exception 'No access to this workspace' using errcode = '42501';
  end if;
  if p_write and r = 'viewer' then
    raise exception 'Viewers cannot change data' using errcode = '42501';
  end if;
  if p_write and r = 'guest' and coalesce((select s.rights from public.orgcue_guest_scope(p_ws) s), 'view') <> 'contribute' then
    raise exception 'Guests with view access cannot change data' using errcode = '42501';
  end if;
  return r;
end;
$$;

-- ---------- a guest cannot copy the workspace (body of 20261110100100_platform2_shift_years.sql, plus that check) ----------
create or replace function public.orgcue_create_workspace(p_name text, p_from uuid, p_token text default null)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := gen_random_uuid();
  v_email text;
  v_name text;
  v_person text;
begin
  if auth.uid() is null then
    raise exception 'Sign in first' using errcode = '42501';
  end if;
  if p_from is not null then
    if public.orgcue_access(p_from, p_token, false) = 'guest' then
      raise exception 'Guests cannot copy this workspace' using errcode = '42501';
    end if;
  end if;
  select u.email, coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1)) into v_email, v_name
    from auth.users u where u.id = auth.uid();
  insert into public.workspaces (id, name, kind, created_by, data) values (v_id, btrim(p_name), 'team', auth.uid(), '{}'::jsonb);
  if p_from is not null then
    perform public.orgcue_copy_rows(p_from, v_id);
    if p_from = '00000000-0000-4000-8000-000000000001' then
      perform public.orgcue_shift_years(v_id, public.orgcue_demo_years());
    end if;
  end if;
  select s.value ->> 'person' into v_person from public.settings s where s.workspace_id = v_id and s.id = 'work.me';
  if v_person is null or not exists (select 1 from public.people p where p.workspace_id = v_id and p.id = v_person) then
    v_person := public.orgcue_new_person(v_id, v_name);
  end if;
  insert into public.workspace_members (workspace_id, user_id, email, name, role, person_id)
  values (v_id, auth.uid(), lower(v_email), v_name, 'admin', v_person);
  return v_id;
end;
$$;

-- ---------- the integrity check covers the whole workspace: not for guests (body of 20261110090000_data_core.sql, plus that check) ----------
create or replace function public.orgcue_integrity(p_ws uuid, p_token text default null)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  t record;
  c jsonb;
  n integer;
  res jsonb := '[]'::jsonb;
begin
  if public.orgcue_access(p_ws, p_token, false) = 'guest' then
    raise exception 'Guests cannot run the integrity check' using errcode = '42501';
  end if;
  for t in select name, columns from public.orgcue_tables where scope = 'workspace' loop
    for c in select value from jsonb_array_elements(t.columns) loop
      if c->>'ref' is not null and coalesce((c->>'enforced')::boolean, false) = false
         and exists (select 1 from public.orgcue_tables where name = c->>'ref' and scope = 'workspace') then
        execute format('select count(*) from public.%1$I x where x.workspace_id = $1 and x.%2$I is not null
                         and not exists (select 1 from public.%3$I p where p.workspace_id = $1 and p.id = x.%2$I)',
                       t.name, c->>'name', c->>'ref')
          into n using p_ws;
        if n > 0 then
          res := res || jsonb_build_array(jsonb_build_object('table', t.name, 'column', c->>'name', 'ref', c->>'ref', 'missing', n));
        end if;
      end if;
    end loop;
  end loop;
  return res;
end;
$$;

-- ---------- privileges ----------
revoke all on function public.orgcue_guest_scope(uuid), public.orgcue_guest_clean_ids(uuid, text[]),
  public.orgcue_guest_scope_tidy() from public, anon, authenticated;
revoke all on function public.orgcue_guest_invite(uuid, text, text[], text, text), public.orgcue_guest_scope_set(uuid, uuid, text[], text)
  from public, anon;
grant execute on function public.orgcue_guest_invite(uuid, text, text[], text, text), public.orgcue_guest_scope_set(uuid, uuid, text[], text)
  to authenticated;
revoke all on function public.accept_invites() from public, anon;
grant execute on function public.accept_invites() to authenticated;
revoke all on function public.orgcue_access(uuid, text, boolean) from public, anon, authenticated;
revoke all on function public.orgcue_create_workspace(text, uuid, text), public.orgcue_integrity(uuid, text) from public;
grant execute on function public.orgcue_create_workspace(text, uuid, text) to authenticated;
grant execute on function public.orgcue_integrity(uuid, text) to anon, authenticated;
