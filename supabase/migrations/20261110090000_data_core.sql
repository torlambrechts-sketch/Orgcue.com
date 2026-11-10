-- OrgCue data core: every record lives in typed tables, scoped to a workspace.
--
-- Workspaces have a kind:
--   team     a shared workspace with members and roles (workspace_members)
--   sandbox  a private copy of the demo for a visitor without an account; reached with a secret token, expires
--   demo     the demo company; read-only, copied into new sandboxes and workspaces
--   product  OrgCue's own product content (roadmap, feature coverage, vendors); read-only, served to everyone
--
-- Data tables are listed in public.orgcue_tables and are never reached directly by clients: row level security is on
-- with no policies and table privileges are revoked. Clients use the functions below, which check access first.

alter table public.workspaces
  add column if not exists kind text not null default 'team' check (kind in ('team', 'sandbox', 'demo', 'product')),
  add column if not exists token_hash text,
  add column if not exists expires_at timestamptz,
  add column if not exists last_used_at timestamptz;

insert into public.workspaces (id, name, kind, data)
values ('00000000-0000-4000-8000-000000000001', 'Demo company', 'demo', '{}'::jsonb),
       ('00000000-0000-4000-8000-000000000002', 'OrgCue product content', 'product', '{}'::jsonb)
on conflict (id) do nothing;

create table if not exists public.orgcue_tables (
  name text primary key,
  domain text not null,
  scope text not null default 'workspace' check (scope in ('workspace', 'product')),
  title text,
  description text,
  columns jsonb not null,
  sort integer not null default 0
);
alter table public.orgcue_tables enable row level security;
create policy "everyone reads the data dictionary" on public.orgcue_tables for select using (true);
grant select on public.orgcue_tables to anon, authenticated;

-- access: returns the caller's role in the workspace, or raises
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
  return r;
end;
$$;

-- the column list of a data table, without workspace_id and updated_at
create or replace function public.orgcue_columns(p_table text)
returns text[]
language sql
stable
security definer
set search_path = ''
as $$
  select array_agg(column_name::text order by ordinal_position)
  from information_schema.columns
  where table_schema = 'public' and table_name = p_table and column_name not in ('workspace_id', 'updated_at')
$$;

-- copies every workspace-scope row from one workspace to another (foreign keys are deferred, so order does not matter)
create or replace function public.orgcue_copy_rows(p_from uuid, p_to uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  t record;
  cols text;
begin
  set constraints all deferred;
  for t in select name from public.orgcue_tables where scope = 'workspace' order by sort loop
    select string_agg(quote_ident(c), ', ') into cols from unnest(public.orgcue_columns(t.name)) c;
    execute format('insert into public.%1$I (workspace_id, %2$s) select $2, %2$s from public.%1$I where workspace_id = $1', t.name, cols)
      using p_from, p_to;
  end loop;
end;
$$;

create or replace function public.orgcue_clear_rows(p_ws uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  t record;
begin
  set constraints all deferred;
  for t in select name from public.orgcue_tables where scope = 'workspace' order by sort desc loop
    execute format('delete from public.%I where workspace_id = $1', t.name) using p_ws;
  end loop;
end;
$$;

-- all rows of a workspace (product-scope tables come from the product workspace), plus its version
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
  return jsonb_build_object('version', w.version, 'name', w.name, 'kind', w.kind, 'role', v_role, 'tables', res);
end;
$$;

create or replace function public.orgcue_version(p_ws uuid, p_token text default null)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v integer;
begin
  perform public.orgcue_access(p_ws, p_token, false);
  select version into v from public.workspaces where id = p_ws;
  return v;
end;
$$;

-- applies row changes: [{t, op:"upsert", rows:[…]} | {t, op:"delete", ids:[…]}], refusing if the version moved on
create or replace function public.orgcue_apply(p_ws uuid, p_token text, p_changes jsonb, p_version integer)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v integer;
  c jsonb;
  t text;
  cols text;
  upd text;
begin
  perform public.orgcue_access(p_ws, p_token, true);
  select version into v from public.workspaces where id = p_ws for update;
  if p_version is not null and v <> p_version then
    return jsonb_build_object('conflict', true, 'version', v);
  end if;
  if jsonb_typeof(p_changes) <> 'array' or jsonb_array_length(p_changes) > 2000 then
    raise exception 'Bad change list' using errcode = '22023';
  end if;
  set constraints all deferred;
  for c in select value from jsonb_array_elements(p_changes) loop
    t := c->>'t';
    if not exists (select 1 from public.orgcue_tables where name = t and scope = 'workspace') then
      raise exception 'Unknown table %', t using errcode = '22023';
    end if;
    if c->>'op' = 'delete' then
      execute format('delete from public.%I where workspace_id = $1 and id in (select jsonb_array_elements_text($2))', t)
        using p_ws, c->'ids';
    elsif c->>'op' = 'upsert' then
      select string_agg(quote_ident(x), ', '), string_agg(format('%1$I = excluded.%1$I', x), ', ') filter (where x <> 'id')
        into cols, upd from unnest(public.orgcue_columns(t)) x;
      execute format(
        'insert into public.%1$I (workspace_id, %2$s) select $1, %2$s from jsonb_populate_recordset(null::public.%1$I, $2)
         on conflict (workspace_id, id) do update set %3$s, updated_at = now()', t, cols, upd)
        using p_ws, c->'rows';
    else
      raise exception 'Bad operation' using errcode = '22023';
    end if;
  end loop;
  update public.workspaces set version = version + 1, updated_at = now(), updated_by = auth.uid(), last_used_at = now()
   where id = p_ws returning version into v;
  return jsonb_build_object('version', v);
end;
$$;

-- a private copy of the demo for a visitor without an account
create or replace function public.orgcue_new_sandbox()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := gen_random_uuid();
  v_token text := encode(extensions.gen_random_bytes(24), 'hex');
  n integer;
begin
  delete from public.workspaces where kind = 'sandbox' and expires_at < now();
  select count(*) into n from public.workspaces where kind = 'sandbox' and created_at > now() - interval '1 hour';
  if n >= 500 then
    raise exception 'Too many demo sessions right now. Try again in a few minutes.' using errcode = 'P0004';
  end if;
  insert into public.workspaces (id, name, kind, token_hash, expires_at, data)
  select v_id, d.name, 'sandbox', encode(extensions.digest(v_token, 'sha256'), 'hex'), now() + interval '14 days', '{}'::jsonb
    from public.workspaces d where d.id = '00000000-0000-4000-8000-000000000001';
  perform public.orgcue_copy_rows('00000000-0000-4000-8000-000000000001', v_id);
  return jsonb_build_object('id', v_id, 'token', v_token);
end;
$$;

create or replace function public.orgcue_reset_sandbox(p_ws uuid, p_token text)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v integer;
begin
  perform public.orgcue_access(p_ws, p_token, true);
  if (select kind from public.workspaces where id = p_ws) <> 'sandbox' then
    raise exception 'Only a demo session can be reset' using errcode = '42501';
  end if;
  perform public.orgcue_clear_rows(p_ws);
  perform public.orgcue_copy_rows('00000000-0000-4000-8000-000000000001', p_ws);
  update public.workspaces set version = version + 1, updated_at = now() where id = p_ws returning version into v;
  return v;
end;
$$;

-- a new team workspace for the signed-in user, copied from a workspace they can read (the demo, their sandbox or a team)
create or replace function public.orgcue_create_workspace(p_name text, p_from uuid, p_token text default null)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id uuid := gen_random_uuid();
begin
  if auth.uid() is null then
    raise exception 'Sign in first' using errcode = '42501';
  end if;
  if p_from is not null then
    perform public.orgcue_access(p_from, p_token, false);
  end if;
  insert into public.workspaces (id, name, kind, created_by, data) values (v_id, btrim(p_name), 'team', auth.uid(), '{}'::jsonb);
  insert into public.workspace_members (workspace_id, user_id, email, role)
  values (v_id, auth.uid(), (select email from auth.users where id = auth.uid()), 'admin');
  if p_from is not null then
    perform public.orgcue_copy_rows(p_from, v_id);
  end if;
  return v_id;
end;
$$;

-- soft references (declared, not enforced) that point at a missing row
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
  perform public.orgcue_access(p_ws, p_token, false);
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

revoke all on function public.orgcue_access(uuid, text, boolean), public.orgcue_columns(text), public.orgcue_copy_rows(uuid, uuid),
  public.orgcue_clear_rows(uuid) from public, anon, authenticated;
revoke all on function public.orgcue_load(uuid, text), public.orgcue_version(uuid, text), public.orgcue_apply(uuid, text, jsonb, integer),
  public.orgcue_new_sandbox(), public.orgcue_reset_sandbox(uuid, text), public.orgcue_create_workspace(text, uuid, text),
  public.orgcue_integrity(uuid, text) from public;
grant execute on function public.orgcue_load(uuid, text), public.orgcue_version(uuid, text), public.orgcue_apply(uuid, text, jsonb, integer),
  public.orgcue_new_sandbox(), public.orgcue_reset_sandbox(uuid, text), public.orgcue_integrity(uuid, text) to anon, authenticated;
grant execute on function public.orgcue_create_workspace(text, uuid, text) to authenticated;
