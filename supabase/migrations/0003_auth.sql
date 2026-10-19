-- Real accounts: Supabase Auth (email + password) with row-level security.
-- Applied Oct 19, 2026 through the Supabase connector. Every signed-in user is a member of the shared Lumio Inc. demo workspace, so authenticated users may read and
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
create or replace trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();
-- Trigger functions are not an API: nobody calls it over /rest/v1/rpc.
revoke execute on function public.handle_new_user() from public, anon, authenticated;

-- 2. Row-level security on every app table.
do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security', t);
    if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = t and policyname = 'workspace members') then
      execute format('create policy "workspace members" on public.%I for all to authenticated using (true) with check (true)', t);
    end if;
  end loop;
end $$;

-- The customer answer page needs no account: anonymous visitors may insert a response, and read nothing.
-- With RLS on and no policy for anon, anonymous requests read and change nothing.
do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'customer_responses' and policyname = 'respondents submit answers') then
    create policy "respondents submit answers" on public.customer_responses for insert to anon
      with check (project_id = 'it-helpdesk' and jsonb_typeof(answers) = 'object');
  end if;
end $$;

-- 3. Only signed-in users may reset the demo.
revoke execute on function public.reset_demo() from public, anon;
grant execute on function public.reset_demo() to authenticated;
