-- demo_seed holds the Lumio Inc. demo rows (loaded by `node scripts/gen-seed.mjs --push`).
-- reset_demo() truncates every app table and replays demo_seed, so the demo can be reset from the app.
create table if not exists public.demo_seed (pos int primary key, tbl text not null, rows jsonb not null);
alter table public.demo_seed disable row level security;
grant all on table public.demo_seed to anon, authenticated;

create or replace function public.reset_demo() returns void
language plpgsql security definer set search_path = public as $fn$
declare r record; cols text;
begin
  truncate table project_state, seed_artifacts, customer_responses, customer_themes, external_segments, integrations,
    audit_events, settings, library_items, milestones, actions, spec_items, spec_versions, decisions, reviews, votes,
    comments, ideas, item_versions, input_items, adaptive_topics, answers, questions, sections, templates,
    project_members, projects, people, orgs restart identity cascade;
  for r in select * from demo_seed order by pos loop
    select string_agg(quote_ident(k), ', ') into cols from jsonb_object_keys(r.rows -> 0) as k;
    execute format('insert into %I (%s) select %s from jsonb_populate_recordset(null::%I, $1)', r.tbl, cols, cols, r.tbl) using r.rows;
  end loop;
end;
$fn$;
grant execute on function public.reset_demo() to anon, authenticated;
