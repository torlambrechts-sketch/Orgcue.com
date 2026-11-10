-- OrgCue platform2, RM60: every workspace member is linked to a person.
--
-- A person is a row of public.people (id = initials). When a member is signed in, the page shows them as their person
-- ("me"): their assignments, comments, check-ins and approvals carry that name.
--   workspace_members.person_id   the person a member appears as (null = not linked yet)
--   workspace_invites.person_id   the person an invitee joins as (null = a new person is added when they join)
-- Admins link members with orgcue_link_person(); accept_invites() links new members (to the invited person, or to a new
-- person made from their name); orgcue_create_workspace() links the creator; orgcue_load() returns the caller's person.
-- Adding a person changes the workspace data, so it bumps workspaces.version and other members' pages reload.

alter table public.workspace_members add column if not exists person_id text;
alter table public.workspace_invites add column if not exists person_id text;
create unique index if not exists workspace_members_person_idx
  on public.workspace_members (workspace_id, person_id) where person_id is not null;
comment on column public.workspace_members.person_id is 'The person (people.id) this member appears as; null = not linked yet';
comment on column public.workspace_invites.person_id is 'The person (people.id) the invitee joins as; null = a new person is added when they join';

-- a new person in a workspace, named after a member: initials as id (made unique), last in the name directory
create or replace function public.orgcue_new_person(p_ws uuid, p_name text)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_name text := coalesce(nullif(btrim(regexp_replace(coalesce(p_name, ''), '@.*$', '')), ''), 'New member');
  v_ini text;
  v_id text;
  n integer := 2;
  v_sort integer;
  v_dir integer;
  v_colors text[] := array['#7c4ddb', '#3b6fe0', '#1f9d6b', '#c77a0a', '#e255c9', '#2a9db5'];
begin
  select upper(left(string_agg(left(w, 1), '' order by o), 2)) into v_ini
    from regexp_split_to_table(v_name, '[[:space:]._-]+') with ordinality as t(w, o)
   where w <> '';
  v_ini := coalesce(nullif(v_ini, ''), 'NM');
  v_id := v_ini;
  while exists (select 1 from public.people p where p.workspace_id = p_ws and p.id = v_id) loop
    v_id := v_ini || n;
    n := n + 1;
  end loop;
  select coalesce(max(p.sort), -1) + 1, coalesce(max(p.directory_order), -1) + 1 into v_sort, v_dir
    from public.people p where p.workspace_id = p_ws;
  insert into public.people (workspace_id, id, sort, name, color, directory_order)
  values (p_ws, v_id, v_sort, v_name, v_colors[1 + v_sort % 6], v_dir);
  return v_id;
end;
$$;

-- an admin links a member to a person (p_person), adds them as a new person (p_create) or unlinks them (both null/false)
create or replace function public.orgcue_link_person(p_ws uuid, p_user uuid, p_person text default null, p_create boolean default false)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_name text;
  v_other text;
begin
  if public.workspace_role(p_ws) is distinct from 'admin' then
    raise exception 'Only admins can link members to people.' using errcode = '42501';
  end if;
  select coalesce(m.name, split_part(m.email, '@', 1)) into v_name
    from public.workspace_members m where m.workspace_id = p_ws and m.user_id = p_user;
  if not found then
    raise exception 'They are not a member of this workspace.' using errcode = 'P0002';
  end if;
  if p_create then
    p_person := public.orgcue_new_person(p_ws, v_name);
    update public.workspaces w set version = w.version + 1, updated_at = now(), updated_by = auth.uid() where w.id = p_ws;
  elsif p_person is not null then
    if not exists (select 1 from public.people p where p.workspace_id = p_ws and p.id = p_person) then
      raise exception 'There is no person % in this workspace.', p_person using errcode = 'P0002';
    end if;
    select coalesce(m.name, m.email) into v_other
      from public.workspace_members m where m.workspace_id = p_ws and m.person_id = p_person and m.user_id <> p_user;
    if v_other is not null then
      raise exception 'That person is already linked to %.', v_other using errcode = '23505';
    end if;
  end if;
  update public.workspace_members m set person_id = p_person where m.workspace_id = p_ws and m.user_id = p_user;
  return p_person;
end;
$$;

-- join every workspace that invited the signed-in user's confirmed email, as the invited person or as a new person
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

-- all rows of a workspace, plus its version and (for a team member) the person the caller appears as
create or replace function public.orgcue_load(p_ws uuid, p_token text default null)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  t record;
  res jsonb := '{}'::jsonb;
  rows jsonb;
  w public.workspaces;
  v_role text;
  v_person text;
begin
  v_role := public.orgcue_access(p_ws, p_token, false);
  for t in select name, scope from public.orgcue_tables order by sort loop
    execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%I x where workspace_id = $1', t.name)
      into rows
      using case when t.scope = 'product' then '00000000-0000-4000-8000-000000000002'::uuid else p_ws end;
    res := res || jsonb_build_object(t.name, rows);
  end loop;
  update public.workspaces
     set last_used_at = now(),
         expires_at = case when kind = 'sandbox' then greatest(expires_at, now() + interval '14 days') else expires_at end
   where id = p_ws
  returning * into w;
  if w.kind = 'team' then
    select m.person_id into v_person from public.workspace_members m where m.workspace_id = p_ws and m.user_id = auth.uid();
  end if;
  return jsonb_build_object('version', w.version, 'name', w.name, 'kind', w.kind, 'role', v_role, 'person', v_person, 'tables', res);
end;
$$;

-- a new team workspace for the signed-in user, copied from a workspace they can read. The creator is linked to the
-- person they were in the copied data (settings row work.me), or to a new person.
-- (Redefined in 20261110100100_platform2_shift_years.sql, which also moves demo dates forward.)
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
    perform public.orgcue_access(p_from, p_token, false);
  end if;
  select u.email, coalesce(u.raw_user_meta_data ->> 'name', split_part(u.email, '@', 1)) into v_email, v_name
    from auth.users u where u.id = auth.uid();
  insert into public.workspaces (id, name, kind, created_by, data) values (v_id, btrim(p_name), 'team', auth.uid(), '{}'::jsonb);
  if p_from is not null then
    perform public.orgcue_copy_rows(p_from, v_id);
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

revoke all on function public.orgcue_new_person(uuid, text) from public, anon, authenticated;
revoke all on function public.orgcue_link_person(uuid, uuid, text, boolean) from public, anon;
grant execute on function public.orgcue_link_person(uuid, uuid, text, boolean) to authenticated;
revoke all on function public.accept_invites() from public, anon;
grant execute on function public.accept_invites() to authenticated;
revoke all on function public.orgcue_load(uuid, text), public.orgcue_create_workspace(text, uuid, text) from public;
grant execute on function public.orgcue_load(uuid, text) to anon, authenticated;
grant execute on function public.orgcue_create_workspace(text, uuid, text) to authenticated;
