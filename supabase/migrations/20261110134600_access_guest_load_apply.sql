-- OrgCue access, RM72: what a guest loads and what a guest may change.
--
-- What a guest sees is worked out from the data dictionary (public.orgcue_tables and its column references), so new
-- tables are covered without changing this file:
--   1. the initiatives shared with them (workspace_guest_scopes.initiative_ids);
--   2. every row that references a row already in scope, through a declared reference or an object reference such as
--      ref = 'task:I7-1' (columns named ref or *_ref; status_updates.target_id names an initiative), as long as each of
--      its enforced (owning) references also points into scope. Repeated until nothing new is found, so tasks, their
--      subtasks, assignees and followers, milestones and their evidence, comments with their threads, replies and
--      reactions, activity, status updates and RAID items all follow their initiative;
--   3. tables a guest never sees even when they point at a shared initiative (money, staffing, governance decisions,
--      planning and other strategy areas): see v_hidden in orgcue_guest_ids(); their child rows follow by rule 2;
--   4. notifications only when addressed to the guest;
--   5. the people referenced by the rows in scope, and the guest's own person;
--   6. configuration the pages need: the planning horizon, stages, perspectives, custom fields, and a few settings
--      (as-of date, company name, current period and quarter, workspace time zone and currency, date format).
-- Product-scope tables are served as to everyone; every other table is empty for a guest.
--
-- A guest with view rights changes nothing (orgcue_access refuses). A guest with contribute rights may, inside scope:
--   comment (comments, comment_threads, comment_replies, comment_reactions; their own comments and reactions only),
--   change the status of a task assigned to their person and tick its subtasks (no other column),
--   and record what that does: activity and activity feed entries in their name, following a task or initiative,
--   notifications about shared work, marking their own notifications read. Rows may be re-sorted.
-- Anything else in a change list makes orgcue_apply refuse the whole list. Other roles are unchanged.
-- The page mirrors these rules (access module: acGuestRows / acGuestAllowed) and its tests compare the two.

-- object reference kinds (the page's ref prefixes) and the table each names
create or replace function public.orgcue_ref_kinds()
returns table (kind text, tbl text)
language sql
immutable
set search_path = ''
as $$
  values ('init', 'initiatives'), ('task', 'tasks'), ('ms', 'initiative_milestones'), ('su', 'status_updates'),
         ('dec', 'decisions'), ('raid', 'raid_items'), ('act', 'actions'), ('req', 'requests'), ('kpi', 'measures'),
         ('obj', 'objectives'), ('kr', 'key_results'), ('risk', 'strategic_risks')
$$;

-- the rows a guest may see, as (table, id) in the transaction's temporary table pg_temp.orgcue_guest_ids
create or replace function public.orgcue_guest_ids(p_ws uuid, p_inits text[], p_person text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_cfg constant text[] := array['periods', 'stages', 'perspectives', 'custom_fields', 'custom_field_options'];
  v_hidden constant text[] := array['initiative_finance', 'finance_months', 'finance_month_capex', 'purchase_orders',
    'baselines', 'change_requests', 'benefits', 'initiative_role_demand', 'resource_requests', 'gate_status', 'gate_log',
    'decisions', 'requests', 'paused_initiatives', 'scenario_changes', 'import_runs', 'ambition_levers',
    'ogsm_strategy_initiatives', 'v2mom_methods', 'triage_queues'];
  t record;
  c jsonb;
  r text;
  conds text[];
  enf text[];
  n0 integer;
  n1 integer;
  pass integer := 0;
  v_rcpt boolean;
begin
  create temp table if not exists orgcue_guest_ids (t text not null, id text not null, primary key (t, id)) on commit drop;
  truncate pg_temp.orgcue_guest_ids;
  insert into pg_temp.orgcue_guest_ids (t, id)
  select 'initiatives', i.id from public.initiatives i where i.workspace_id = p_ws and i.id = any(coalesce(p_inits, '{}'));
  loop
    pass := pass + 1;
    select count(*) into n0 from pg_temp.orgcue_guest_ids;
    for t in select ot.name, ot.columns from public.orgcue_tables ot
              where ot.scope = 'workspace' and ot.name <> all (array['initiatives', 'people', 'settings'] || v_cfg || v_hidden)
              order by ot.sort loop
      conds := '{}';
      enf := '{}';
      v_rcpt := false;
      for c in select value from jsonb_array_elements(t.columns) loop
        r := c ->> 'ref';
        if c ->> 'name' = 'recipient_id' then
          v_rcpt := true;
        end if;
        if r is not null then
          if r = 'people' or r = any (v_cfg) then
            continue;
          end if;
          if coalesce((c ->> 'enforced')::boolean, false) then
            enf := enf || format('(x.%1$I is null or x.%1$I in (select g.id from pg_temp.orgcue_guest_ids g where g.t = %2$L))', c ->> 'name', r);
          end if;
          if r <> all (v_hidden) then
            conds := conds || format('x.%1$I in (select g.id from pg_temp.orgcue_guest_ids g where g.t = %2$L)', c ->> 'name', r);
          end if;
        elsif c ->> 'type' = 'text' and (c ->> 'name' = 'ref' or c ->> 'name' like '%\_ref') then
          conds := conds || format('x.%1$I in (select k.kind || '':'' || g.id from pg_temp.orgcue_guest_ids g join public.orgcue_ref_kinds() k on k.tbl = g.t)', c ->> 'name');
        elsif c ->> 'type' = 'text' and c ->> 'name' = 'target_id' then
          conds := conds || format('x.%1$I in (select g.id from pg_temp.orgcue_guest_ids g where g.t = ''initiatives'')', c ->> 'name');
        end if;
      end loop;
      if cardinality(conds) = 0 then
        continue;
      end if;
      execute format('insert into pg_temp.orgcue_guest_ids (t, id) select %1$L, x.id from public.%1$I x where x.workspace_id = $1 and (%2$s)%3$s%4$s on conflict do nothing',
                     t.name, array_to_string(conds, ' or '),
                     case when cardinality(enf) > 0 then ' and ' || array_to_string(enf, ' and ') else '' end,
                     case when v_rcpt then ' and x.recipient_id is not distinct from $2' else '' end)
        using p_ws, p_person;
    end loop;
    select count(*) into n1 from pg_temp.orgcue_guest_ids;
    exit when n1 = n0 or pass >= 25;
  end loop;
  -- the people the rows in scope name, and the guest's own person
  for t in select ot.name, ot.columns from public.orgcue_tables ot where ot.scope = 'workspace' order by ot.sort loop
    for c in select value from jsonb_array_elements(t.columns) loop
      if c ->> 'ref' = 'people' then
        execute format('insert into pg_temp.orgcue_guest_ids (t, id) select ''people'', x.%2$I from public.%1$I x
                         where x.workspace_id = $1 and x.%2$I is not null and x.id in (select g.id from pg_temp.orgcue_guest_ids g where g.t = %1$L)
                           and exists (select 1 from public.people p where p.workspace_id = $1 and p.id = x.%2$I)
                        on conflict do nothing', t.name, c ->> 'name')
          using p_ws;
      end if;
    end loop;
  end loop;
  insert into pg_temp.orgcue_guest_ids (t, id)
  select 'people', p.id from public.people p where p.workspace_id = p_ws and p.id = p_person
  on conflict do nothing;
end;
$$;

-- the settings rows a guest's pages need
create or replace function public.orgcue_guest_settings()
returns text[]
language sql
immutable
set search_path = ''
as $$
  select array['core.as_of', 'strategy.company', 'strategy.org_name', 'strategy.period', 'strategy.quarter',
               'strategy.now_quarter', 'projects.workspace', 'platform2.date_format']
$$;

-- all rows of a workspace (product-scope tables come from the product workspace), plus its version and the caller's
-- person; a guest gets only the rows in their scope (see the top of this file) and their scope.
-- (Body of 20261110100000_platform2_member_people.sql, plus the guest branch.)
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
  v_guest jsonb;
  g record;
begin
  v_role := public.orgcue_access(p_ws, p_token, false);
  if v_role = 'guest' then
    select s.initiative_ids, s.rights, s.person_id into g from public.orgcue_guest_scope(p_ws) s;
    perform public.orgcue_guest_ids(p_ws, g.initiative_ids, g.person_id);
    for t in select name, scope from public.orgcue_tables order by sort loop
      if t.scope = 'product' then
        execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%I x where workspace_id = $1', t.name)
          into rows using '00000000-0000-4000-8000-000000000002'::uuid;
      elsif t.name in ('periods', 'stages', 'perspectives', 'custom_fields', 'custom_field_options') then
        execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%I x where workspace_id = $1', t.name)
          into rows using p_ws;
      elsif t.name = 'settings' then
        execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%I x where workspace_id = $1 and x.id = any($2)', t.name)
          into rows using p_ws, public.orgcue_guest_settings();
      else
        execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%1$I x where workspace_id = $1 and x.id in (select g.id from pg_temp.orgcue_guest_ids g where g.t = %1$L)', t.name)
          into rows using p_ws;
      end if;
      res := res || jsonb_build_object(t.name, rows);
    end loop;
    v_guest := jsonb_build_object('initiatives', to_jsonb(coalesce(g.initiative_ids, '{}'::text[])), 'rights', coalesce(g.rights, 'view'));
  else
    for t in select name, scope from public.orgcue_tables order by sort loop
      execute format('select coalesce(jsonb_agg(to_jsonb(x) - ''workspace_id'' - ''updated_at'' order by x.sort nulls last, x.id), ''[]''::jsonb) from public.%I x where workspace_id = $1', t.name)
        into rows
        using case when t.scope = 'product' then '00000000-0000-4000-8000-000000000002'::uuid else p_ws end;
      res := res || jsonb_build_object(t.name, rows);
    end loop;
  end if;
  update public.workspaces
     set last_used_at = now(),
         expires_at = case when kind = 'sandbox' then greatest(expires_at, now() + interval '14 days') else expires_at end
   where id = p_ws
  returning * into w;
  if w.kind = 'team' then
    select m.person_id into v_person from public.workspace_members m where m.workspace_id = p_ws and m.user_id = auth.uid();
  end if;
  if v_guest is null then
    return jsonb_build_object('version', w.version, 'name', w.name, 'kind', w.kind, 'role', v_role, 'person', v_person, 'tables', res);
  end if;
  return jsonb_build_object('version', w.version, 'name', w.name, 'kind', w.kind, 'role', v_role, 'person', v_person, 'tables', res, 'guest', v_guest);
end;
$$;

-- refuses a change list a contributing guest may not make (see the top of this file); returns nothing when it is fine
create or replace function public.orgcue_guest_check(p_ws uuid, p_changes jsonb)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  g record;
  c jsonb;
  v_t text;
  r jsonb;
  v_id text;
  v_old jsonb;
  v_new jsonb;
  v_diff text[];
  v_pass integer;
  v_ref text;
  v_ok boolean;
  v_allowed constant text[] := array['comments', 'comment_threads', 'comment_replies', 'comment_reactions', 'tasks', 'subtasks',
    'activity', 'activity_feed', 'task_followers', 'initiative_followers', 'notifications'];
  v_deletable constant text[] := array['comments', 'comment_reactions', 'task_followers', 'initiative_followers', 'notifications'];
begin
  select s.initiative_ids, s.rights, s.person_id into g from public.orgcue_guest_scope(p_ws) s;
  if not found or g.rights <> 'contribute' then
    raise exception 'Guests with view access cannot change data' using errcode = '42501';
  end if;
  if g.person_id is null then
    raise exception 'Your account is not linked to a person yet. Ask an admin.' using errcode = '42501';
  end if;
  perform public.orgcue_guest_ids(p_ws, g.initiative_ids, g.person_id);
  -- comments first (pass 1), so threads, replies and reactions on a comment made in the same save find it in scope
  for v_pass in 1 .. 2 loop
    for c in select value from jsonb_array_elements(p_changes) loop
      v_t := c ->> 't';
      if (v_pass = 1) <> (v_t is not distinct from 'comments') then
        continue;
      end if;
      if v_t is null or v_t <> all (v_allowed) then
        raise exception 'Guests cannot change %', coalesce(v_t, 'this') using errcode = '42501';
      end if;
      if c ->> 'op' = 'delete' then
        if v_t <> all (v_deletable) then
          raise exception 'Guests cannot delete from %', v_t using errcode = '42501';
        end if;
        for v_id in select jsonb_array_elements_text(c -> 'ids') loop
          execute format('select to_jsonb(x) - ''workspace_id'' - ''updated_at'' from public.%I x where x.workspace_id = $1 and x.id = $2', v_t)
            into v_old using p_ws, v_id;
          if v_old is null then
            continue;
          end if;
          if not exists (select 1 from pg_temp.orgcue_guest_ids x where x.t = v_t and x.id = v_id)
             or coalesce(v_old ->> 'author_id', v_old ->> 'person_id', v_old ->> 'recipient_id', '') <> g.person_id then
            raise exception 'Guests can only delete their own % (%)', v_t, v_id using errcode = '42501';
          end if;
        end loop;
        continue;
      end if;
      if c ->> 'op' <> 'upsert' or jsonb_typeof(c -> 'rows') <> 'array' then
        raise exception 'Bad operation' using errcode = '22023';
      end if;
      for r in select value from jsonb_array_elements(c -> 'rows') loop
        v_id := r ->> 'id';
        execute format('select to_jsonb(x) - ''workspace_id'' - ''updated_at'' from public.%I x where x.workspace_id = $1 and x.id = $2', v_t)
          into v_old using p_ws, v_id;
        execute format('select to_jsonb(jsonb_populate_record(null::public.%I, $1)) - ''workspace_id'' - ''updated_at''', v_t)
          into v_new using r;
        if v_old is not null then
          if not exists (select 1 from pg_temp.orgcue_guest_ids x where x.t = v_t and x.id = v_id) then
            raise exception 'That is not shared with you (% %)', v_t, v_id using errcode = '42501';
          end if;
          select coalesce(array_agg(k), '{}') into v_diff
            from (select jsonb_object_keys(v_old || v_new) as k) kk
           where (v_old -> kk.k) is distinct from (v_new -> kk.k);
          if v_diff <@ array['sort'] then
            continue;
          end if;
        else
          v_diff := null;
        end if;
        v_ok := false;
        if v_t = 'tasks' then
          v_ok := v_old is not null and v_diff <@ array['status', 'sort']
                  and (v_old ->> 'owner_id' = g.person_id
                       or exists (select 1 from public.task_assignees a where a.workspace_id = p_ws and a.task_id = v_id and a.person_id = g.person_id));
        elsif v_t = 'subtasks' then
          v_ok := v_old is not null and v_diff <@ array['done', 'sort']
                  and exists (select 1 from public.tasks k where k.workspace_id = p_ws and k.id = v_old ->> 'task_id'
                                and (k.owner_id = g.person_id
                                     or exists (select 1 from public.task_assignees a where a.workspace_id = p_ws and a.task_id = k.id and a.person_id = g.person_id)));
        elsif v_t = 'comments' then
          v_ref := v_new ->> 'ref';
          v_ok := v_new ->> 'author_id' = g.person_id
                  and exists (select 1 from pg_temp.orgcue_guest_ids x join public.orgcue_ref_kinds() k on k.tbl = x.t where k.kind || ':' || x.id = v_ref)
                  and (v_old is null or (v_old ->> 'author_id' = g.person_id and v_old ->> 'ref' = v_ref));
          if v_ok then
            insert into pg_temp.orgcue_guest_ids (t, id) values ('comments', v_id) on conflict do nothing;
          end if;
        elsif v_t = 'comment_threads' then
          v_ok := (v_new ->> 'comment_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'comments')
                  and (v_new ->> 'resolved_by' is null or v_new ->> 'resolved_by' = g.person_id or v_new ->> 'resolved_by' = v_old ->> 'resolved_by')
                  and (v_new -> 'action_id') is not distinct from coalesce(v_old -> 'action_id', 'null'::jsonb)
                  and (v_new -> 'decision_id') is not distinct from coalesce(v_old -> 'decision_id', 'null'::jsonb);
        elsif v_t = 'comment_replies' then
          v_ok := v_old is null
                  and (v_new ->> 'comment_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'comments')
                  and (v_new ->> 'reply_to_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'comments');
        elsif v_t = 'comment_reactions' then
          v_ok := v_new ->> 'person_id' = g.person_id
                  and (v_new ->> 'comment_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'comments')
                  and (v_old is null or v_old ->> 'person_id' = g.person_id);
        elsif v_t in ('activity', 'activity_feed') then
          v_ok := v_old is null and v_new ->> 'actor_id' = g.person_id
                  and exists (select 1 from pg_temp.orgcue_guest_ids x join public.orgcue_ref_kinds() k on k.tbl = x.t where k.kind || ':' || x.id = v_new ->> 'ref');
        elsif v_t = 'task_followers' then
          v_ok := v_old is null and v_new ->> 'person_id' = g.person_id
                  and (v_new ->> 'task_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'tasks');
        elsif v_t = 'initiative_followers' then
          v_ok := v_old is null and v_new ->> 'person_id' = g.person_id
                  and (v_new ->> 'initiative_id') in (select x.id from pg_temp.orgcue_guest_ids x where x.t = 'initiatives');
        elsif v_t = 'notifications' then
          v_ok := (v_old is null
                   and exists (select 1 from pg_temp.orgcue_guest_ids x join public.orgcue_ref_kinds() k on k.tbl = x.t where k.kind || ':' || x.id = v_new ->> 'ref'))
               or (v_old is not null and v_old ->> 'recipient_id' = g.person_id and v_diff <@ array['read', 'sort']);
        end if;
        if not v_ok then
          raise exception 'Guests cannot make this change (% %)', v_t, v_id using errcode = '42501';
        end if;
      end loop;
    end loop;
  end loop;
end;
$$;

-- applies row changes: [{t, op:"upsert", rows:[…]} | {t, op:"delete", ids:[…]}], refusing if the version moved on.
-- (Body of 20261110090000_data_core.sql, plus the guest check.)
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
  v_role text;
begin
  v_role := public.orgcue_access(p_ws, p_token, true);
  select version into v from public.workspaces where id = p_ws for update;
  if p_version is not null and v <> p_version then
    return jsonb_build_object('conflict', true, 'version', v);
  end if;
  if jsonb_typeof(p_changes) <> 'array' or jsonb_array_length(p_changes) > 2000 then
    raise exception 'Bad change list' using errcode = '22023';
  end if;
  if v_role = 'guest' then
    perform public.orgcue_guest_check(p_ws, p_changes);
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

revoke all on function public.orgcue_ref_kinds(), public.orgcue_guest_ids(uuid, text[], text), public.orgcue_guest_settings(),
  public.orgcue_guest_check(uuid, jsonb) from public, anon, authenticated;
revoke all on function public.orgcue_load(uuid, text), public.orgcue_apply(uuid, text, jsonb, integer) from public;
grant execute on function public.orgcue_load(uuid, text), public.orgcue_apply(uuid, text, jsonb, integer) to anon, authenticated;
