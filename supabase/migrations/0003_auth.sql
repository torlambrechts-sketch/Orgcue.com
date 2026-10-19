-- Real accounts: Supabase Auth (email + password) with row-level security.
-- Every signed-in user is a member of the shared Lumio Inc. demo workspace, so authenticated users may read and
-- write all app tables. Anonymous visitors can only submit the public customer answer page (spec §18.2).

-- 1. People rows for accounts.
alter table public.people add column if not exists user_id uuid unique references auth.users(id) on delete cascade;
alter table public.people add column if not exists email text;
alter table public.audit_events add column if not exists user_id uuid references auth.users(id) on delete set null;

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $fn$
begin
  insert into public.people (id, org_id, name, title, org_role, project_role, function_group, authority_areas, channel, user_id, email)
  values ('u-' || left(replace(new.id::text, '-', ''), 12), 'lumio',
          coalesce(nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''), split_part(new.email, '@', 1)),
          coalesce(new.raw_user_meta_data ->> 'title', ''), 'Member', '', '', '', 'Email', new.id, new.email)
  on conflict (user_id) do nothing;
  return new;
end;
$fn$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

-- 2. Row-level security on every app table.
do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security', t);
    execute format('drop policy if exists "workspace members" on public.%I', t);
    execute format('create policy "workspace members" on public.%I for all to authenticated using (true) with check (true)', t);
    execute format('revoke all on table public.%I from anon', t);
  end loop;
end $$;

-- The customer answer page needs no account: anonymous visitors may insert a response, and read nothing.
grant insert on table public.customer_responses to anon;
drop policy if exists "respondents submit answers" on public.customer_responses;
create policy "respondents submit answers" on public.customer_responses for insert to anon
  with check (project_id = 'it-helpdesk' and jsonb_typeof(answers) = 'object');

-- 3. Reset keeps the accounts' people rows, and only signed-in users may run it.
create or replace function public.reset_demo() returns void
language plpgsql security definer set search_path = public as $fn$
declare r record; cols text;
begin
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
