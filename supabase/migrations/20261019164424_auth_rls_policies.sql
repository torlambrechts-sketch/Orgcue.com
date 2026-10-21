-- Real accounts, part 2 of 4: row-level security on every app table. Signed-in users read and write everything;
-- anonymous visitors can only submit the public customer answer page (spec §18.2), and read nothing.
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

do $$
begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'customer_responses' and policyname = 'respondents submit answers') then
    create policy "respondents submit answers" on public.customer_responses for insert to anon
      with check (project_id = 'it-helpdesk' and jsonb_typeof(answers) = 'object');
  end if;
end $$;
