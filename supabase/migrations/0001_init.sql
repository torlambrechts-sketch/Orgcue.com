-- Orgcue prototype schema. No auth, RLS off on every table (prototype posture, see docs/ASSESSMENT.md).
-- Text IDs match the spec (CI-0231, DEC-03, A-015, HC-007, LIB-HC-015).

create table if not exists orgs (
  id text primary key,
  name text not null,
  region text not null default 'US'
);

create table if not exists people (
  id text primary key,
  org_id text not null default 'lumio' references orgs(id),
  name text not null,
  title text not null default '',
  org_role text not null default 'Member',
  project_role text not null default '',
  function_group text not null default '',
  authority_areas text not null default '',
  channel text not null default ''
);

create table if not exists projects (
  id text primary key,
  org_id text not null default 'lumio' references orgs(id),
  name text not null,
  type text not null default 'AI agent',
  phase text not null default 'Frame',
  owner_id text references people(id),
  owner_name text not null default '',
  decider_id text references people(id),
  template text not null default '',
  target text not null default '',
  deadline text not null default '',
  start_date date,
  end_date date,
  color text not null default 'var(--op-ink)',
  answered text not null default '—',
  conflicts int not null default 0,
  actions_count int not null default 0,
  next_step text not null default '',
  goal text not null default '',
  frameworks text[] not null default '{}',
  groups text[] not null default '{}',
  external jsonb,
  created_at timestamptz not null default now()
);

create table if not exists project_members (
  project_id text not null references projects(id) on delete cascade,
  person_id text not null references people(id),
  project_role text not null default 'Contributor',
  status text not null default 'Not sent',
  position int not null default 0,
  primary key (project_id, person_id)
);

create table if not exists templates (
  id text primary key,
  org_id text not null default 'lumio' references orgs(id),
  category text not null,
  name text not null,
  type text not null,
  frameworks text not null default '',
  output text not null default '',
  status text not null default 'Draft',
  owner text not null default '',
  used int not null default 0,
  description text not null default '',
  is_new boolean not null default false,
  updated date
);

create table if not exists sections (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  name text not null,
  hint text not null default '',
  authority boolean not null default false,
  restricted boolean not null default false,
  position int not null default 0
);

create table if not exists questions (
  id text not null,
  project_id text not null references projects(id) on delete cascade,
  section text not null,
  target_group text not null default 'All members',
  text text not null,
  skipped_reason text not null default '',
  skipped_source text not null default '',
  ask_anyway boolean not null default false,
  position int not null default 0,
  primary key (project_id, id)
);

create table if not exists answers (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  question_id text not null,
  person_id text not null references people(id),
  text text not null default '',
  strength text not null default 'Must-have',
  skipped boolean not null default false,
  created_at timestamptz not null default now(),
  unique (project_id, question_id, person_id)
);

create table if not exists adaptive_topics (
  id text not null,
  project_id text not null references projects(id) on delete cascade,
  topic text not null,
  state text not null default 'Open',
  evidence text not null default '',
  did text not null default '',
  saved int not null default 0,
  position int not null default 0,
  primary key (project_id, id)
);

create table if not exists input_items (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  version int not null default 1,
  section text not null,
  type text not null default 'Fact',
  strength text not null default 'Must-have',
  group_name text not null default '',
  author_id text references people(id),
  text text not null,
  original text not null default '',
  relation text not null default '',
  decision_id text not null default '',
  votes_seed int not null default 0,
  comments_seed int not null default 0,
  approval_status text not null default 'Pending review',
  reject_reason text not null default '',
  position int not null default 0
);

create table if not exists item_versions (
  item_id text not null references input_items(id) on delete cascade,
  version text not null,
  text text not null,
  note text not null default '',
  primary key (item_id, version)
);

create table if not exists ideas (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  section text not null default '',
  text text not null,
  outcome text not null default '',
  author_id text references people(id),
  private boolean not null default false,
  position int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists comments (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  item_id text not null,
  type text not null default 'Clarification',
  text text not null,
  author_id text references people(id),
  created_at timestamptz not null default now()
);

create table if not exists votes (
  item_id text not null,
  person_id text not null references people(id),
  primary key (item_id, person_id)
);

create table if not exists reviews (
  item_id text not null,
  person_id text not null references people(id),
  verdict text not null,
  reason text not null default '',
  alternative text not null default '',
  created_at timestamptz not null default now(),
  primary key (item_id, person_id)
);

create table if not exists decisions (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  title text not null,
  note text not null default '',
  warn text not null default '',
  done text not null default '',
  options jsonb not null default '[]',
  chosen int,
  rationale text not null default '',
  pinned text not null default '',
  follow_up text not null default '',
  status text not null default 'Open',
  decided_by text not null default '',
  decided_at timestamptz,
  position int not null default 0
);

create table if not exists spec_versions (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  version text not null,
  locked boolean not null default false,
  locked_by text not null default '',
  locked_at timestamptz,
  hash text not null default ''
);

create table if not exists spec_items (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  kind text not null,
  text text not null,
  refs text not null default '',
  provenance text not null default '',
  owner_id text references people(id),
  review_date text not null default '',
  position int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists actions (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  title text not null,
  source text not null default '',
  owner_id text references people(id),
  acceptance text not null default 'Requested',
  status text not null default 'To do',
  priority text not null default 'Normal',
  due date,
  milestone text not null default '',
  tracked_in text not null default 'Orgcue',
  checklist jsonb not null default '[]',
  blocked_by text not null default '',
  description text not null default '',
  decline_reason text not null default '',
  position int not null default 0
);

create table if not exists milestones (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  name text not null,
  date date,
  owner_name text not null default '',
  status text not null default 'Planned',
  position int not null default 0
);

create table if not exists library_items (
  id text primary key,
  org_id text not null default 'lumio' references orgs(id),
  kind text not null,
  text text not null,
  owner text not null default '',
  source text not null default '',
  status text not null default 'Confirmed',
  used int not null default 0,
  confirmed_at date,
  next_review date,
  proposed_text text not null default '',
  position int not null default 0
);

create table if not exists settings (
  org_id text not null default 'lumio' references orgs(id),
  key text not null,
  value jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (org_id, key)
);

create table if not exists audit_events (
  id bigserial primary key,
  org_id text not null default 'lumio' references orgs(id),
  at timestamptz not null default now(),
  who text not null default '',
  what text not null,
  object text not null default ''
);

create table if not exists integrations (
  id text primary key,
  org_id text not null default 'lumio' references orgs(id),
  name text not null,
  category text not null,
  purpose text not null default '',
  connected boolean not null default false,
  detail text not null default '',
  position int not null default 0
);

create table if not exists external_segments (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  segment text not null,
  channel text not null default '',
  invited int not null default 0,
  answered int not null default 0,
  status text not null default 'Not sent',
  position int not null default 0
);

create table if not exists customer_themes (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  theme text not null,
  segments text not null default '',
  n int not null default 0,
  quote text not null default '',
  feeds text not null default '—',
  status text not null default 'New',
  position int not null default 0
);

create table if not exists customer_responses (
  id uuid primary key default gen_random_uuid(),
  project_id text not null references projects(id) on delete cascade,
  answers jsonb not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists seed_artifacts (
  project_id text not null references projects(id) on delete cascade,
  key text not null,
  data jsonb not null,
  primary key (project_id, key)
);

create table if not exists project_state (
  project_id text not null references projects(id) on delete cascade,
  key text not null,
  value jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (project_id, key)
);

-- Prototype posture: open access for the anon key.
do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I disable row level security', t);
    execute format('grant all on table public.%I to anon, authenticated', t);
  end loop;
end $$;
grant usage, select on all sequences in schema public to anon, authenticated;
