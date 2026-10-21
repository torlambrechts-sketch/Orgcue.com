-- Beta list: anyone on the public site can join; nobody can read the list through the API.
-- Read it in the Supabase dashboard (Table editor → beta_signups) or with the service role.

create table if not exists public.beta_signups (
  id uuid primary key default gen_random_uuid(),
  email text not null check (char_length(email) between 3 and 254 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  name text check (name is null or char_length(name) <= 120),
  company text check (company is null or char_length(company) <= 120),
  consent boolean not null default false,
  source text check (source is null or char_length(source) <= 40),
  created_at timestamptz not null default now()
);

create unique index if not exists beta_signups_email_key on public.beta_signups (lower(email));

alter table public.beta_signups enable row level security;

revoke all on public.beta_signups from anon, authenticated;
grant insert (email, name, company, consent, source) on public.beta_signups to anon, authenticated;

drop policy if exists "join the beta list" on public.beta_signups;
create policy "join the beta list" on public.beta_signups for insert to anon, authenticated with check (consent);
