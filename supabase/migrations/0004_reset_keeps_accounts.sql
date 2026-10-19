-- NOT APPLIED YET: paste into the Supabase SQL editor. (The connector holds statements containing TRUNCATE for a
-- confirmation this cloud session cannot give.)
-- Reset the demo but keep the people rows of real accounts, and refuse to run without a signed-in user.
create or replace function public.reset_demo() returns void
language plpgsql security definer set search_path = public as $fn$
declare r record; cols text;
begin
  if auth.uid() is null then
    raise exception 'Only signed-in workspace members can reset the demo' using errcode = '42501';
  end if;
  create temp table _keep_people on commit drop as select * from people where user_id is not null;
  truncate table project_state, seed_artifacts, customer_responses, customer_themes, external_segments, integrations,
    audit_events, settings, library_items, milestones, actions, spec_items, spec_versions, decisions, reviews, votes,
    comments, ideas, item_versions, input_items, adaptive_topics, answers, questions, sections, templates,
    project_members, projects, people, orgs restart identity cascade;
  for r in select * from demo_seed order by pos loop
    select string_agg(quote_ident(k), ', ') into cols from jsonb_object_keys(r.rows -> 0) as k;
    execute format('insert into %I (%s) select %s from jsonb_populate_recordset(null::%I, $1)', r.tbl, cols, cols, r.tbl) using r.rows;
  end loop;
  insert into people select * from _keep_people on conflict (id) do nothing;
end;
$fn$;
revoke execute on function public.reset_demo() from public, anon;
grant execute on function public.reset_demo() to authenticated;
