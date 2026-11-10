-- Data tables, generated from the table declarations in the page (node gen.js). Do not edit by hand.

create table public."audit_log" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "at" text,
  "who" text,
  "kind" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."audit_log" is 'Audit log: One recorded change: when (ISO time), who, kind and what; the latest 500 are kept';
alter table public."audit_log" enable row level security;
revoke all on public."audit_log" from anon, authenticated;

create table public."budget_caps" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "year" text,
  "cap" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."budget_caps" is 'Budget caps: Yearly budget cap of the live plan in £k (id = year)';
alter table public."budget_caps" enable row level security;
revoke all on public."budget_caps" from anon, authenticated;

create table public."import_runs" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "at" text,
  "who" text,
  "target" text,
  "source" text,
  "row_count" integer,
  "skipped" integer,
  "initiative_id" text,
  "task_ids" jsonb,
  "initiative_ids" jsonb,
  "measure_snapshots" jsonb,
  "summary" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."import_runs" is 'Imports: The last import, with what it added so it can be undone (measure_snapshots: values before the import)';
alter table public."import_runs" enable row level security;
revoke all on public."import_runs" from anon, authenticated;

create table public."initiative_role_demand" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "role_id" text,
  "fte" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_role_demand" is 'Demand by role: FTE an initiative needs from a role in every quarter while it runs (a row without role keeps an initiative whose demand was cleared)';
alter table public."initiative_role_demand" enable row level security;
revoke all on public."initiative_role_demand" from anon, authenticated;

create table public."paused_initiatives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "scenario_id" text,
  "paused_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."paused_initiatives" is 'Paused initiatives: An initiative an applied scenario left out of the live plan (id = initiative)';
alter table public."paused_initiatives" enable row level security;
revoke all on public."paused_initiatives" from anon, authenticated;

create table public."product_features" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "area" text,
  "feature" text,
  "class" text,
  "coverage" text,
  "go" text,
  "description" text,
  "vendors" text,
  "roadmap_item_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_features" is 'Feature coverage: A feature buyers expect (class T table stakes, E expected, D differentiator) and how far OrgCue covers it';
alter table public."product_features" enable row level security;
revoke all on public."product_features" from anon, authenticated;

create table public."product_import_samples" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "file_name" text,
  "content" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_import_samples" is 'Import samples: A sample CSV file offered on the import page (id = sample key)';
alter table public."product_import_samples" enable row level security;
revoke all on public."product_import_samples" from anon, authenticated;

create table public."product_panel_findings" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_panel_findings" is 'Panel findings: A point the review panel agreed on';
alter table public."product_panel_findings" enable row level security;
revoke all on public."product_panel_findings" from anon, authenticated;

create table public."product_panel_lists" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "kind" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_panel_lists" is 'Panel reviewer notes: One line a reviewer gave: kind good (strongest today) or gaps (biggest gaps)';
alter table public."product_panel_lists" enable row level security;
revoke all on public."product_panel_lists" from anon, authenticated;

create table public."product_panel_people" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "role" text,
  "color" text,
  "lens" text,
  "quote" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_panel_people" is 'Panel reviewers: A reviewer on the product panel (id = initials)';
alter table public."product_panel_people" enable row level security;
revoke all on public."product_panel_people" from anon, authenticated;

create table public."product_panel_picks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "item_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_panel_picks" is 'Panel picks: A roadmap item a reviewer wants built now';
alter table public."product_panel_picks" enable row level security;
revoke all on public."product_panel_picks" from anon, authenticated;

create table public."product_roadmap_areas" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "color" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_roadmap_areas" is 'Roadmap areas: A product area with its colour (id = area name)';
alter table public."product_roadmap_areas" enable row level security;
revoke all on public."product_roadmap_areas" from anon, authenticated;

create table public."product_roadmap_horizons" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "description" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_roadmap_horizons" is 'Roadmap horizons: A column of the product roadmap (done, now, next, later)';
alter table public."product_roadmap_horizons" enable row level security;
revoke all on public."product_roadmap_horizons" from anon, authenticated;

create table public."product_roadmap_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "area" text,
  "horizon" text,
  "status" text,
  "go" text,
  "votes" integer,
  "asked_by" jsonb,
  "refs" jsonb,
  "why" text,
  "what" text,
  "collab" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_roadmap_items" is 'Roadmap items: A product capability: shipped, building, planned or exploring';
alter table public."product_roadmap_items" enable row level security;
revoke all on public."product_roadmap_items" from anon, authenticated;

create table public."product_shipped_areas" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "icon" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_shipped_areas" is 'Shipped areas: A group of shipped capabilities';
alter table public."product_shipped_areas" enable row level security;
revoke all on public."product_shipped_areas" from anon, authenticated;

create table public."product_shipped_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "area_id" text,
  "name" text,
  "go" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_shipped_items" is 'Shipped capabilities: A shipped capability with the page that shows it';
alter table public."product_shipped_items" enable row level security;
revoke all on public."product_shipped_items" from anon, authenticated;

create table public."product_vendors" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "area" text,
  "known_for" text,
  "lesson" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."product_vendors" is 'Vendors: A vendor researched for the roadmap';
alter table public."product_vendors" enable row level security;
revoke all on public."product_vendors" from anon, authenticated;

create table public."roadmap_suggestions" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "area" text,
  "horizon" text,
  "status" text,
  "go" text,
  "votes" integer,
  "asked_by" jsonb,
  "refs" jsonb,
  "why" text,
  "what" text,
  "collab" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."roadmap_suggestions" is 'Roadmap suggestions: A feature someone in this workspace suggested for the product roadmap';
alter table public."roadmap_suggestions" enable row level security;
revoke all on public."roadmap_suggestions" from anon, authenticated;

create table public."roadmap_votes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "item_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."roadmap_votes" is 'Roadmap votes: A person''s vote for a roadmap item or suggestion (item_id is a product_roadmap_items or roadmap_suggestions id)';
alter table public."roadmap_votes" enable row level security;
revoke all on public."roadmap_votes" from anon, authenticated;

create table public."role_people" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "role_id" text,
  "share" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."role_people" is 'People''s roles: A person''s role for capacity planning and the share of their time that goes to portfolio work (id = person)';
alter table public."role_people" enable row level security;
revoke all on public."role_people" from anon, authenticated;

create table public."roles" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "extra_fte" numeric,
  "change_quarter" integer,
  "extra_fte_after" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."roles" is 'Roles: A role whose capacity is planned: FTE from the wider team on top of named people, which can change from a quarter (index into the planning horizon)';
alter table public."roles" enable row level security;
revoke all on public."roles" from anon, authenticated;

create table public."scenario_caps" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "scenario_id" text,
  "year" text,
  "cap" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."scenario_caps" is 'Scenario budget caps: Yearly budget cap in £k inside a scenario';
alter table public."scenario_caps" enable row level security;
revoke all on public."scenario_caps" from anon, authenticated;

create table public."scenario_changes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "scenario_id" text,
  "initiative_id" text,
  "leave_out" integer,
  "shift_quarters" integer,
  "cost" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."scenario_changes" is 'Scenario changes: How a scenario changes one initiative: left out (1) or kept in (0), quarters moved, budget in £k';
alter table public."scenario_changes" enable row level security;
revoke all on public."scenario_changes" from anon, authenticated;

create table public."scenarios" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "description" text,
  "created_by" text,
  "created_on" date,
  "applied_on" date,
  "applied_by" text,
  "applied_decision_id" text,
  "applied_changes" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."scenarios" is 'Scenarios: A what-if plan: changes on top of the live plan, and when it was last applied';
alter table public."scenarios" enable row level security;
revoke all on public."scenarios" from anon, authenticated;

create table public."actions" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "owner_id" text,
  "due_date" date,
  "status" text,
  "source" text,
  "created_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."actions" is 'Actions: A follow-up action, often from a decision';
alter table public."actions" enable row level security;
revoke all on public."actions" from anon, authenticated;

create table public."activity" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "ref" text,
  "actor_id" text,
  "happened_on" date,
  "what" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."activity" is 'Activity: A change made to any record; ref names it, for example task:I7-1';
alter table public."activity" enable row level security;
revoke all on public."activity" from anon, authenticated;

create table public."baselines" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "version" integer,
  "start_q" integer,
  "end_q" integer,
  "budget" numeric,
  "set_on" date,
  "reason" text,
  "set_by" text,
  "change_request_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."baselines" is 'Baselines: An approved version of an initiative''s dates and budget';
alter table public."baselines" enable row level security;
revoke all on public."baselines" from anon, authenticated;

create table public."benefit_values" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "benefit_id" text,
  "quarter" integer,
  "planned" numeric,
  "realised" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."benefit_values" is 'Benefit values: Planned and realised value of a benefit in one quarter';
alter table public."benefit_values" enable row level security;
revoke all on public."benefit_values" from anon, authenticated;

create table public."benefits" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "name" text,
  "kind" text,
  "owner_id" text,
  "measure_id" text,
  "unit" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."benefits" is 'Benefits: A benefit profile of an initiative';
alter table public."benefits" enable row level security;
revoke all on public."benefits" from anon, authenticated;

create table public."change_requests" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "requested_by" text,
  "requested_on" date,
  "changes" jsonb,
  "new_end_q" integer,
  "new_budget" numeric,
  "new_scope" text,
  "reason" text,
  "impact" text,
  "approver_id" text,
  "status" text,
  "old_end_q" integer,
  "old_budget" numeric,
  "old_scope" text,
  "decided_by" text,
  "decided_on" date,
  "decision_comment" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."change_requests" is 'Change requests: A request to change the end date, budget or scope of an initiative';
alter table public."change_requests" enable row level security;
revoke all on public."change_requests" from anon, authenticated;

create table public."comments" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "ref" text,
  "author_id" text,
  "posted_on" date,
  "body" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."comments" is 'Comments: A comment on any record; ref names it, for example task:I7-1 or su:SU2';
alter table public."comments" enable row level security;
revoke all on public."comments" from anon, authenticated;

create table public."decisions" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "forum" text,
  "about_ref" text,
  "proposed_by" text,
  "status" text,
  "from_gate" integer,
  "decided_by" text,
  "decided_on" date,
  "rationale" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."decisions" is 'Decisions: A decision from a steering group, review or stage gate';
alter table public."decisions" enable row level security;
revoke all on public."decisions" from anon, authenticated;

create table public."finance_months" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "month" integer,
  "budget" numeric,
  "actual" numeric,
  "forecast" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."finance_months" is 'Finance by month: Budget, actual and forecast of an initiative for one month (0 = the first month of the horizon), £k';
alter table public."finance_months" enable row level security;
revoke all on public."finance_months" from anon, authenticated;

create table public."gate_approvers" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "stage_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_approvers" is 'Gate approvers: A person who must approve leaving a stage';
alter table public."gate_approvers" enable row level security;
revoke all on public."gate_approvers" from anon, authenticated;

create table public."gate_checks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "gate_status_id" text,
  "criterion" text,
  "met" boolean,
  "explanation" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_checks" is 'Gate checks: A criterion ticked or explained for an initiative';
alter table public."gate_checks" enable row level security;
revoke all on public."gate_checks" from anon, authenticated;

create table public."gate_criteria" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "stage_id" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_criteria" is 'Gate criteria: A criterion to meet before leaving a stage';
alter table public."gate_criteria" enable row level security;
revoke all on public."gate_criteria" from anon, authenticated;

create table public."gate_log" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "to_stage" text,
  "decided_by" text,
  "decided_on" date,
  "comment" text,
  "votes" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_log" is 'Gate log: A move of an initiative through a stage gate';
alter table public."gate_log" enable row level security;
revoke all on public."gate_log" from anon, authenticated;

create table public."gate_status" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "stage" text,
  "last_rejected_on" date,
  "last_rejected_by" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_status" is 'Gate status: Where an initiative stands at the gate of its current stage';
alter table public."gate_status" enable row level security;
revoke all on public."gate_status" from anon, authenticated;

create table public."gate_votes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "gate_status_id" text,
  "voter_id" text,
  "decision" text,
  "comment" text,
  "voted_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."gate_votes" is 'Gate votes: An approver''s decision at a gate';
alter table public."gate_votes" enable row level security;
revoke all on public."gate_votes" from anon, authenticated;

create table public."initiative_dependencies" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "depends_on_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_dependencies" is 'Initiative dependencies: An initiative that must finish first';
alter table public."initiative_dependencies" enable row level security;
revoke all on public."initiative_dependencies" from anon, authenticated;

create table public."initiative_finance" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "capex_pct" numeric,
  "months" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_finance" is 'Initiative finance: Finance settings of an initiative; id is the initiative id';
alter table public."initiative_finance" enable row level security;
revoke all on public."initiative_finance" from anon, authenticated;

create table public."initiative_followers" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_followers" is 'Initiative followers: A person who follows an initiative';
alter table public."initiative_followers" enable row level security;
revoke all on public."initiative_followers" from anon, authenticated;

create table public."initiative_measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "measure_id" text,
  "impact" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_measures" is 'Expected impact: What an initiative is expected to add to a measure';
alter table public."initiative_measures" enable row level security;
revoke all on public."initiative_measures" from anon, authenticated;

create table public."initiative_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiative_objectives" is 'Initiative objectives: An objective an initiative supports';
alter table public."initiative_objectives" enable row level security;
revoke all on public."initiative_objectives" from anon, authenticated;

create table public."initiatives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "description" text,
  "perspective_id" text,
  "programme_id" text,
  "stage" text,
  "status" text,
  "owner_id" text,
  "start_q" integer,
  "end_q" integer,
  "baseline_start_q" integer,
  "baseline_end_q" integer,
  "budget" numeric,
  "spent" numeric,
  "forecast" numeric,
  "value" numeric,
  "effort" numeric,
  "risk" text,
  "project_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."initiatives" is 'Initiatives: A strategic initiative: dates as quarter indexes into the planning horizon, money in £k';
alter table public."initiatives" enable row level security;
revoke all on public."initiatives" from anon, authenticated;

create table public."milestones" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "quarter" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."milestones" is 'Milestones: A milestone quarter of an initiative';
alter table public."milestones" enable row level security;
revoke all on public."milestones" from anon, authenticated;

create table public."programmes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "lead_id" text,
  "color" text,
  "description" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."programmes" is 'Programmes: A group of initiatives with a lead and a colour';
alter table public."programmes" enable row level security;
revoke all on public."programmes" from anon, authenticated;

create table public."purchase_orders" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "ref" text,
  "description" text,
  "supplier" text,
  "amount" numeric,
  "raised_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."purchase_orders" is 'Purchase orders: Money committed to a supplier against an initiative budget, £k';
alter table public."purchase_orders" enable row level security;
revoke all on public."purchase_orders" from anon, authenticated;

create table public."request_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "request_id" text,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."request_objectives" is 'Request objectives: An objective a request supports';
alter table public."request_objectives" enable row level security;
revoke all on public."request_objectives" from anon, authenticated;

create table public."requests" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "sponsor_id" text,
  "submitted_on" date,
  "problem" text,
  "value" numeric,
  "effort" numeric,
  "cost" numeric,
  "risk" text,
  "status" text,
  "initiative_id" text,
  "decision_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."requests" is 'Requests: A new idea or request waiting to enter the portfolio';
alter table public."requests" enable row level security;
revoke all on public."requests" from anon, authenticated;

create table public."stages" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "in_flow" boolean,
  "gate_question" text,
  "has_gate" boolean,
  "gate_rule" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."stages" is 'Stages: A stage of the initiative life cycle and the gate to leave it';
alter table public."stages" enable row level security;
revoke all on public."stages" from anon, authenticated;

create table public."status_update_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "status_update_id" text,
  "kind" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."status_update_items" is 'Status update items: A highlight, blocker or next step of a status update';
alter table public."status_update_items" enable row level security;
revoke all on public."status_update_items" from anon, authenticated;

create table public."status_updates" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "target_id" text,
  "status" text,
  "author_id" text,
  "posted_on" date,
  "summary" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."status_updates" is 'Status updates: A status update on an initiative or a programme';
alter table public."status_updates" enable row level security;
revoke all on public."status_updates" from anon, authenticated;

create table public."subtasks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "name" text,
  "done" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."subtasks" is 'Subtasks: A checklist item of a task';
alter table public."subtasks" enable row level security;
revoke all on public."subtasks" from anon, authenticated;

create table public."task_assignees" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."task_assignees" is 'Task co-assignees: A person who works on a task with its owner';
alter table public."task_assignees" enable row level security;
revoke all on public."task_assignees" from anon, authenticated;

create table public."task_dependencies" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "depends_on_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."task_dependencies" is 'Task dependencies: A task that must be done before this one';
alter table public."task_dependencies" enable row level security;
revoke all on public."task_dependencies" from anon, authenticated;

create table public."task_field_values" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "field_id" text,
  "value" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."task_field_values" is 'Task custom field values: The value of a custom field on a task';
alter table public."task_field_values" enable row level security;
revoke all on public."task_field_values" from anon, authenticated;

create table public."task_followers" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."task_followers" is 'Task followers: A person who follows a task';
alter table public."task_followers" enable row level security;
revoke all on public."task_followers" from anon, authenticated;

create table public."tasks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "name" text,
  "owner_id" text,
  "status" text,
  "withdrawn" boolean,
  "priority" text,
  "phase" text,
  "start_date" date,
  "due_date" date,
  "due_quarter" text,
  "estimate_hours" numeric,
  "description" text,
  "plan_ref" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."tasks" is 'Tasks: A task of an initiative (linked project plans read these too)';
alter table public."tasks" enable row level security;
revoke all on public."tasks" from anon, authenticated;

create table public."checklist_checks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "item_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."checklist_checks" is 'Pre-launch checks done: A check ticked for a project.';
alter table public."checklist_checks" enable row level security;
revoke all on public."checklist_checks" from anon, authenticated;

create table public."checklist_groups" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."checklist_groups" is 'Pre-launch checklist groups: A group of pre-launch checks.';
alter table public."checklist_groups" enable row level security;
revoke all on public."checklist_groups" from anon, authenticated;

create table public."checklist_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "group_id" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."checklist_items" is 'Pre-launch checks: One check, id = its code (c1, c2...).';
alter table public."checklist_items" enable row level security;
revoke all on public."checklist_items" from anon, authenticated;

create table public."closure_steps" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."closure_steps" is 'Closure steps: The steps every project goes through to close, in order.';
alter table public."closure_steps" enable row level security;
revoke all on public."closure_steps" from anon, authenticated;

create table public."dashboard_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "kind" text,
  "due_bucket" text,
  "name" text,
  "subtask_count" integer,
  "status" text,
  "project_name" text,
  "priority" text,
  "due_label" text,
  "assignee_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."dashboard_items" is 'Dashboard tasks and actions: A task or action on the dashboard. kind: tasks or actions; due_bucket: today, week or overdue.';
alter table public."dashboard_items" enable row level security;
revoke all on public."dashboard_items" from anon, authenticated;

create table public."devices" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "location" text,
  "last_active" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."devices" is 'Devices: A device the user is signed in on.';
alter table public."devices" enable row level security;
revoke all on public."devices" from anon, authenticated;

create table public."documents" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "kind" text,
  "name" text,
  "ext" text,
  "size_label" text,
  "date_label" text,
  "color" text,
  "project_name" text,
  "url" text,
  "summary" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."documents" is 'Documents: A file, photo or link on the documents page. kind: file, photo or link; color holds the file colour or the photo''s gradient.';
alter table public."documents" enable row level security;
revoke all on public."documents" from anon, authenticated;

create table public."governance_groups" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "color" text,
  "purpose" text,
  "time_label" text,
  "recurrence" text,
  "project_name" text,
  "next_event" text,
  "details" text,
  "more_people" integer,
  "likes" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."governance_groups" is 'Governance groups: A recurring meeting or board with its next event.';
alter table public."governance_groups" enable row level security;
revoke all on public."governance_groups" from anon, authenticated;

create table public."governance_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "group_id" text,
  "kind" text,
  "label" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."governance_items" is 'Governance connected items: A task (t1, t2) or RAID item (t3) connected to a governance group.';
alter table public."governance_items" enable row level security;
revoke all on public."governance_items" from anon, authenticated;

create table public."governance_members" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "group_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."governance_members" is 'Governance members: A person in a governance group.';
alter table public."governance_members" enable row level security;
revoke all on public."governance_members" from anon, authenticated;

create table public."invoices" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "ref" text,
  "date_label" text,
  "status" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."invoices" is 'Invoices: A billing invoice.';
alter table public."invoices" enable row level security;
revoke all on public."invoices" from anon, authenticated;

create table public."people" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "role" text,
  "color" text,
  "team_order" integer,
  "directory_order" integer,
  "project_order" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."people" is 'People: A person in the workspace, id = initials. team_order: place in the resource pool (null = not in it); directory_order: place in the name directory used by strategy pages; project_order: place in the project people list. sort keeps the avatar colour order.';
alter table public."people" enable row level security;
revoke all on public."people" from anon, authenticated;

create table public."project_benefits" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "name" text,
  "type" text,
  "measure" text,
  "baseline" text,
  "target" text,
  "current" text,
  "progress" numeric,
  "status" text,
  "owner_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_benefits" is 'Project benefits: A benefit a project should deliver, with its measure and progress (%).';
alter table public."project_benefits" enable row level security;
revoke all on public."project_benefits" from anon, authenticated;

create table public."project_budget_lines" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "ref" text,
  "cost_type" text,
  "detail" text,
  "project_name" text,
  "classification" text,
  "spread" text,
  "status" text,
  "budget" numeric,
  "forecast" numeric,
  "spent" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_budget_lines" is 'Project budget lines: A cost line in a project budget (pounds).';
alter table public."project_budget_lines" enable row level security;
revoke all on public."project_budget_lines" from anon, authenticated;

create table public."project_closures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "steps_done" integer,
  "stage" text,
  "signed_off" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_closures" is 'Project closure: Closure progress of a project: steps done, stage (Delivering, Closing, Closed) and sign-off.';
alter table public."project_closures" enable row level security;
revoke all on public."project_closures" from anon, authenticated;

create table public."project_members" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_members" is 'Project team: A person shown on a project''s dashboard card.';
alter table public."project_members" enable row level security;
revoke all on public."project_members" from anon, authenticated;

create table public."project_scopes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "objective" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_scopes" is 'Project scope: The scope statement of a project (one per project).';
alter table public."project_scopes" enable row level security;
revoke all on public."project_scopes" from anon, authenticated;

create table public."project_task_assignees" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "task_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_task_assignees" is 'Plan task assignees: A person assigned to a plan task; the first is the main assignee.';
alter table public."project_task_assignees" enable row level security;
revoke all on public."project_task_assignees" from anon, authenticated;

create table public."project_tasks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "project_id" text,
  "ref" text,
  "name" text,
  "phase" text,
  "status" text,
  "priority" text,
  "timeline" text,
  "start_day" integer,
  "length_days" integer,
  "subtask_count" integer,
  "start_date" date,
  "due_date" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."project_tasks" is 'Project plan tasks: A task in the plan of a project that is not linked to an initiative (linked plans live in the initiative''s tasks). start_day and length_days count from 1 Jan 2024.';
alter table public."project_tasks" enable row level security;
revoke all on public."project_tasks" from anon, authenticated;

create table public."projects" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "title" text,
  "label" text,
  "owner_name" text,
  "due_label" text,
  "time_left" text,
  "ring" integer,
  "ring_color" text,
  "completion" integer,
  "tasks_done" integer,
  "tasks_total" integer,
  "more_people" integer,
  "status" text,
  "badge" text,
  "budget_k" numeric,
  "spent_k" numeric,
  "segments" jsonb,
  "card" boolean,
  "favourite" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."projects" is 'Projects: A project. name is the short name used in menus and plans; title, owner, dates, progress and budget feed the dashboard card (card = has a dashboard card).';
alter table public."projects" enable row level security;
revoke all on public."projects" from anon, authenticated;

create table public."raid_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "ref" text,
  "type" text,
  "title" text,
  "project_name" text,
  "owner_id" text,
  "impact" text,
  "status" text,
  "review_by" text,
  "initiative_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."raid_items" is 'RAID log: A risk, assumption, issue or dependency. initiative_id links it to the initiative it threatens.';
alter table public."raid_items" enable row level security;
revoke all on public."raid_items" from anon, authenticated;

create table public."resource_absences" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "starts_label" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."resource_absences" is 'Upcoming vacations: An upcoming absence of a person.';
alter table public."resource_absences" enable row level security;
revoke all on public."resource_absences" from anon, authenticated;

create table public."resource_workloads" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "monthly" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."resource_workloads" is 'Resource workload: A person''s workload per month (1 = full time, null = no data), months as in the setting projects.resource_months.';
alter table public."resource_workloads" enable row level security;
revoke all on public."resource_workloads" from anon, authenticated;

create table public."retro_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "retro_id" text,
  "col" text,
  "text" text,
  "votes" integer,
  "owner_id" text,
  "done" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."retro_items" is 'Retrospective notes and actions: col w = went well, i = to improve (with votes), a = action (with owner and done).';
alter table public."retro_items" enable row level security;
revoke all on public."retro_items" from anon, authenticated;

create table public."retro_participants" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "retro_id" text,
  "person_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."retro_participants" is 'Retrospective participants: A person who took part.';
alter table public."retro_participants" enable row level security;
revoke all on public."retro_participants" from anon, authenticated;

create table public."retrospectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "date_label" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."retrospectives" is 'Retrospectives: A retrospective meeting.';
alter table public."retrospectives" enable row level security;
revoke all on public."retrospectives" from anon, authenticated;

create table public."scope_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "scope_id" text,
  "kind" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."scope_items" is 'Scope items: An in-scope (inn) or out-of-scope (out) item.';
alter table public."scope_items" enable row level security;
revoke all on public."scope_items" from anon, authenticated;

create table public."spaces" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "initials" text,
  "color" text,
  "owned" boolean,
  "people_count" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."spaces" is 'Spaces: A workspace the user owns (owned) or is a member of.';
alter table public."spaces" enable row level security;
revoke all on public."spaces" from anon, authenticated;

create table public."value_distribution" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "value" numeric,
  "color" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."value_distribution" is 'Economic value distributed: How the value the company earns is shared (£M).';
alter table public."value_distribution" enable row level security;
revoke all on public."value_distribution" from anon, authenticated;

create table public."ambition_goals" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "objective_id" text,
  "target" numeric,
  "label" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ambition_goals" is 'Ambition goals: A goal of the long-term ambition; the first is the north star';
alter table public."ambition_goals" enable row level security;
revoke all on public."ambition_goals" from anon, authenticated;

create table public."ambition_levers" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "initiative_id" text,
  "added_value" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ambition_levers" is 'Ambition levers: Value an initiative adds to the north star by the end of the horizon';
alter table public."ambition_levers" enable row level security;
revoke all on public."ambition_levers" from anon, authenticated;

create table public."bmc_blocks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "icon" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."bmc_blocks" is 'Business model blocks: A business model canvas block; id = block key';
alter table public."bmc_blocks" enable row level security;
revoke all on public."bmc_blocks" from anon, authenticated;

create table public."bmc_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "block_id" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."bmc_items" is 'Business model items: A sticky note in a business model canvas block';
alter table public."bmc_items" enable row level security;
revoke all on public."bmc_items" from anon, authenticated;

create table public."board_packs" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "quarter" text,
  "version" integer,
  "frozen_on" date,
  "frozen_by" text,
  "pack_date" text,
  "note" text,
  "headlines" jsonb,
  "focus" jsonb,
  "tiles" jsonb,
  "objectives" jsonb,
  "measures" jsonb,
  "decisions" jsonb,
  "risks" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."board_packs" is 'Board packs: A frozen, read-only snapshot of a quarterly strategy review';
alter table public."board_packs" enable row level security;
revoke all on public."board_packs" from anon, authenticated;

create table public."canvas_curves" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "color" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."canvas_curves" is 'Canvas curves: A value curve (competitor or our offer) on the strategy canvas';
alter table public."canvas_curves" enable row level security;
revoke all on public."canvas_curves" from anon, authenticated;

create table public."canvas_errc_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "action" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."canvas_errc_items" is 'ERRC items: An eliminate, reduce, raise or create action';
alter table public."canvas_errc_items" enable row level security;
revoke all on public."canvas_errc_items" from anon, authenticated;

create table public."canvas_factors" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."canvas_factors" is 'Canvas factors: A competing factor on the strategy canvas';
alter table public."canvas_factors" enable row level security;
revoke all on public."canvas_factors" from anon, authenticated;

create table public."canvas_scores" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "curve_id" text,
  "factor_id" text,
  "score" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."canvas_scores" is 'Canvas scores: Offering level (0-10) of a curve on a factor';
alter table public."canvas_scores" enable row level security;
revoke all on public."canvas_scores" from anon, authenticated;

create table public."company_values" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "description" text,
  "champion" text,
  "color" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."company_values" is 'Company values: A company value; id = name';
alter table public."company_values" enable row level security;
revoke all on public."company_values" from anon, authenticated;

create table public."governance_cadence" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "review_workday" integer,
  "board_month" integer,
  "board_week" integer,
  "board_weekday" integer,
  "board_time" text,
  "monthly_workday" integer,
  "quarterly_workday" integer,
  "okr_weekday" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."governance_cadence" is 'Governance cadence: When reviews, board meetings and check-in deadlines fall (one row)';
alter table public."governance_cadence" enable row level security;
revoke all on public."governance_cadence" from anon, authenticated;

create table public."key_results" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "okr_objective_id" text,
  "name" text,
  "current" numeric,
  "target" numeric,
  "confidence" text,
  "checked_on" date,
  "note" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."key_results" is 'Key results: A key result with its latest check-in';
alter table public."key_results" enable row level security;
revoke all on public."key_results" from anon, authenticated;

create table public."kudos" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "from_person" text,
  "to_person" text,
  "value_name" text,
  "message" text,
  "when_label" text,
  "likes" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."kudos" is 'Recognition: A recognition of someone living a value';
alter table public."kudos" enable row level security;
revoke all on public."kudos" from anon, authenticated;

create table public."measure_checkins" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "measure_id" text,
  "period" text,
  "value" numeric,
  "status" text,
  "by_person" text,
  "checked_on" date,
  "comment" text,
  "owner_override" boolean,
  "targets_changed" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."measure_checkins" is 'Measure check-ins: A recorded value of a measure for a period, or a target change';
alter table public."measure_checkins" enable row level security;
revoke all on public."measure_checkins" from anon, authenticated;

create table public."measure_targets" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "measure_id" text,
  "year" integer,
  "target" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."measure_targets" is 'Measure targets: Year-end target of a measure';
alter table public."measure_targets" enable row level security;
revoke all on public."measure_targets" from anon, authenticated;

create table public."measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "objective_id" text,
  "name" text,
  "unit" text,
  "direction" integer,
  "baseline" numeric,
  "actual" numeric,
  "trend" jsonb,
  "status" text,
  "override" text,
  "owner" text,
  "source" text,
  "frequency" text,
  "is_primary" boolean,
  "comment" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."measures" is 'Measures: A company measure (KPI); headline measures read actual, trend and status from their objective';
alter table public."measures" enable row level security;
revoke all on public."measures" from anon, authenticated;

create table public."objective_links" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "from_objective_id" text,
  "to_objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."objective_links" is 'Cause and effect: A strategy-map arrow: the first objective drives the second';
alter table public."objective_links" enable row level security;
revoke all on public."objective_links" from anon, authenticated;

create table public."objective_unit_health" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "objective_id" text,
  "unit_id" text,
  "health" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."objective_unit_health" is 'Objective health by unit: Health score (0-100) of an objective in a unit, for the heat map';
alter table public."objective_unit_health" enable row level security;
revoke all on public."objective_unit_health" from anon, authenticated;

create table public."objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "perspective_id" text,
  "name" text,
  "owner" text,
  "measure_name" text,
  "baseline" numeric,
  "actual" numeric,
  "target" numeric,
  "unit" text,
  "status" text,
  "override" text,
  "trend" jsonb,
  "comment" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."objectives" is 'Objectives: A company objective with its headline measure values, trend of the last quarters and owner comment';
alter table public."objectives" enable row level security;
revoke all on public."objectives" from anon, authenticated;

create table public."ogsm_goals" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ogsm_goals" is 'OGSM goals: An objective used as an OGSM goal';
alter table public."ogsm_goals" enable row level security;
revoke all on public."ogsm_goals" from anon, authenticated;

create table public."ogsm_strategies" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "owner" text,
  "status" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ogsm_strategies" is 'OGSM strategies: An OGSM strategy';
alter table public."ogsm_strategies" enable row level security;
revoke all on public."ogsm_strategies" from anon, authenticated;

create table public."ogsm_strategy_initiatives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "strategy_id" text,
  "initiative_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ogsm_strategy_initiatives" is 'OGSM initiatives: An initiative delivering an OGSM strategy';
alter table public."ogsm_strategy_initiatives" enable row level security;
revoke all on public."ogsm_strategy_initiatives" from anon, authenticated;

create table public."ogsm_strategy_measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "strategy_id" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."ogsm_strategy_measures" is 'OGSM measures: A measure of an OGSM strategy';
alter table public."ogsm_strategy_measures" enable row level security;
revoke all on public."ogsm_strategy_measures" from anon, authenticated;

create table public."okr_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "parent_id" text,
  "objective_id" text,
  "team" text,
  "owner" text,
  "title" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."okr_objectives" is 'OKR objectives: A company OKR (no parent, linked to an objective) or a team OKR under it';
alter table public."okr_objectives" enable row level security;
revoke all on public."okr_objectives" from anon, authenticated;

create table public."period_locks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "period" text,
  "locked_by" text,
  "locked_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."period_locks" is 'Period locks: A month closed to new check-ins; id = period';
alter table public."period_locks" enable row level security;
revoke all on public."period_locks" from anon, authenticated;

create table public."periods" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "label" text,
  "year" integer,
  "quarter" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."periods" is 'Planning periods: One quarter of the planning horizon, in order';
alter table public."periods" enable row level security;
revoke all on public."periods" from anon, authenticated;

create table public."perspectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "theme" text,
  "color" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."perspectives" is 'Perspectives: A balanced-scorecard perspective (strategic pillar); id = its letter code';
alter table public."perspectives" enable row level security;
revoke all on public."perspectives" from anon, authenticated;

create table public."pestle_factors" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "factor" text,
  "text" text,
  "impact" integer,
  "likelihood" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."pestle_factors" is 'PESTLE factors: An outside force with its impact and likelihood';
alter table public."pestle_factors" enable row level security;
revoke all on public."pestle_factors" from anon, authenticated;

create table public."pulse_scores" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "survey_id" text,
  "value_name" text,
  "unit_id" text,
  "score" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."pulse_scores" is 'Pulse scores: Share of people in a unit who agree a value is lived';
alter table public."pulse_scores" enable row level security;
revoke all on public."pulse_scores" from anon, authenticated;

create table public."pulse_statements" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "value_name" text,
  "statement" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."pulse_statements" is 'Pulse statements: The survey statement for a value; id = value name';
alter table public."pulse_statements" enable row level security;
revoke all on public."pulse_statements" from anon, authenticated;

create table public."pulse_surveys" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "quarter" text,
  "response_rate" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."pulse_surveys" is 'Pulse surveys: A values pulse survey; id = quarter';
alter table public."pulse_surveys" enable row level security;
revoke all on public."pulse_surveys" from anon, authenticated;

create table public."review_focus" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."review_focus" is 'Review focus: A focus item for next quarter in the live review';
alter table public."review_focus" enable row level security;
revoke all on public."review_focus" from anon, authenticated;

create table public."review_headlines" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."review_headlines" is 'Review headlines: A headline of the live quarterly review';
alter table public."review_headlines" enable row level security;
revoke all on public."review_headlines" from anon, authenticated;

create table public."review_proposals" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "owner" text,
  "recommendation" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."review_proposals" is 'Review proposals: A proposal prepared for the steering group in the live review';
alter table public."review_proposals" enable row level security;
revoke all on public."review_proposals" from anon, authenticated;

create table public."risk_appetite" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "level" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."risk_appetite" is 'Risk appetite: Appetite level for a risk category; id = category';
alter table public."risk_appetite" enable row level security;
revoke all on public."risk_appetite" from anon, authenticated;

create table public."risk_appetite_levels" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "max_residual" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."risk_appetite_levels" is 'Risk appetite levels: Highest residual score an appetite level allows; id = level';
alter table public."risk_appetite_levels" enable row level security;
revoke all on public."risk_appetite_levels" from anon, authenticated;

create table public."risk_mitigations" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "risk_id" text,
  "title" text,
  "owner" text,
  "due" date,
  "done" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."risk_mitigations" is 'Risk mitigations: A mitigation action for a strategic risk';
alter table public."risk_mitigations" enable row level security;
revoke all on public."risk_mitigations" from anon, authenticated;

create table public."risk_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "risk_id" text,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."risk_objectives" is 'Risk objectives: An objective at stake for a strategic risk';
alter table public."risk_objectives" enable row level security;
revoke all on public."risk_objectives" from anon, authenticated;

create table public."risk_reviews" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "risk_id" text,
  "reviewed_on" date,
  "by_person" text,
  "residual_likelihood" integer,
  "residual_impact" integer,
  "trend" text,
  "comment" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."risk_reviews" is 'Risk reviews: A recorded review of a strategic risk';
alter table public."risk_reviews" enable row level security;
revoke all on public."risk_reviews" from anon, authenticated;

create table public."settings" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "key" text,
  "value" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."settings" is 'Settings: One workspace setting; id = key, prefixed by the owning domain (strategy.*, projects.*, ...)';
alter table public."settings" enable row level security;
revoke all on public."settings" from anon, authenticated;

create table public."stakeholder_measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "stakeholder_id" text,
  "name" text,
  "value" text,
  "change" text,
  "improving" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."stakeholder_measures" is 'Stakeholder measures: A measure of value for a stakeholder group';
alter table public."stakeholder_measures" enable row level security;
revoke all on public."stakeholder_measures" from anon, authenticated;

create table public."stakeholders" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "icon" text,
  "color" text,
  "headline" text,
  "story" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."stakeholders" is 'Stakeholders: A stakeholder group and the value created for it; id = name';
alter table public."stakeholders" enable row level security;
revoke all on public."stakeholders" from anon, authenticated;

create table public."strategic_risks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "category" text,
  "owner" text,
  "inherent_likelihood" integer,
  "inherent_impact" integer,
  "residual_likelihood" integer,
  "residual_impact" integer,
  "trend" text,
  "last_review" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."strategic_risks" is 'Strategic risks: A risk to the objectives, scored 1-5 before and after mitigation';
alter table public."strategic_risks" enable row level security;
revoke all on public."strategic_risks" from anon, authenticated;

create table public."swot_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "quadrant" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."swot_items" is 'SWOT items: A strength (S), weakness (W), opportunity (O) or threat (T)';
alter table public."swot_items" enable row level security;
revoke all on public."swot_items" from anon, authenticated;

create table public."team_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "team_id" text,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."team_objectives" is 'Team objectives: An objective a team owns work for';
alter table public."team_objectives" enable row level security;
revoke all on public."team_objectives" from anon, authenticated;

create table public."teams" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "unit_id" text,
  "name" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."teams" is 'Teams: A team inside a business unit';
alter table public."teams" enable row level security;
revoke all on public."teams" from anon, authenticated;

create table public."tows_strategies" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."tows_strategies" is 'TOWS strategies: A TOWS strategy; id = SO, WO, ST or WT';
alter table public."tows_strategies" enable row level security;
revoke all on public."tows_strategies" from anon, authenticated;

create table public."unit_measure_checkins" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "unit_measure_id" text,
  "period" text,
  "value" numeric,
  "status" text,
  "by_person" text,
  "checked_on" date,
  "comment" text,
  "owner_override" boolean,
  "targets_changed" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."unit_measure_checkins" is 'Unit measure check-ins: A recorded value of a unit measure, or a target change';
alter table public."unit_measure_checkins" enable row level security;
revoke all on public."unit_measure_checkins" from anon, authenticated;

create table public."unit_measure_targets" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "unit_measure_id" text,
  "year" integer,
  "target" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."unit_measure_targets" is 'Unit measure targets: Year-end target of a unit measure';
alter table public."unit_measure_targets" enable row level security;
revoke all on public."unit_measure_targets" from anon, authenticated;

create table public."unit_measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "unit_objective_id" text,
  "name" text,
  "unit" text,
  "direction" integer,
  "baseline" numeric,
  "actual" numeric,
  "frequency" text,
  "owner" text,
  "last_period" text,
  "trend" jsonb,
  "status" text,
  "override" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."unit_measures" is 'Unit measures: A measure on a unit scorecard';
alter table public."unit_measures" enable row level security;
revoke all on public."unit_measures" from anon, authenticated;

create table public."unit_objectives" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "unit_id" text,
  "name" text,
  "owner" text,
  "objective_id" text,
  "weight" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."unit_objectives" is 'Unit objectives: A business unit objective supporting a company objective with a weight';
alter table public."unit_objectives" enable row level security;
revoke all on public."unit_objectives" from anon, authenticated;

create table public."units" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "lead" text,
  "role" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."units" is 'Business units: A business unit (id = name) with its leader';
alter table public."units" enable row level security;
revoke all on public."units" from anon, authenticated;

create table public."v2mom_method_measures" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "method_id" text,
  "objective_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."v2mom_method_measures" is 'V2MOM measures: An objective measuring a V2MOM method';
alter table public."v2mom_method_measures" enable row level security;
revoke all on public."v2mom_method_measures" from anon, authenticated;

create table public."v2mom_methods" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "owner" text,
  "initiative_id" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."v2mom_methods" is 'V2MOM methods: A V2MOM method, in priority order';
alter table public."v2mom_methods" enable row level security;
revoke all on public."v2mom_methods" from anon, authenticated;

create table public."v2mom_obstacles" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "method_id" text,
  "done" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."v2mom_obstacles" is 'V2MOM obstacles: An obstacle, and the method it blocks';
alter table public."v2mom_obstacles" enable row level security;
revoke all on public."v2mom_obstacles" from anon, authenticated;

create table public."value_behaviours" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "value_id" text,
  "kind" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."value_behaviours" is 'Value behaviours: A behaviour we do (do) or don''t (dont) for a value';
alter table public."value_behaviours" enable row level security;
revoke all on public."value_behaviours" from anon, authenticated;

create table public."value_bridge_steps" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "bridge_id" text,
  "label" text,
  "value" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."value_bridge_steps" is 'Value bridge steps: A step that adds or removes value in a bridge';
alter table public."value_bridge_steps" enable row level security;
revoke all on public."value_bridge_steps" from anon, authenticated;

create table public."value_bridges" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "from_label" text,
  "from_value" numeric,
  "to_label" text,
  "to_value" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."value_bridges" is 'Value bridges: A value bridge (waterfall) between two totals';
alter table public."value_bridges" enable row level security;
revoke all on public."value_bridges" from anon, authenticated;

create table public."value_model_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "section" text,
  "name" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."value_model_items" is 'Value creation model: An input capital, business activity or output of the value creation model';
alter table public."value_model_items" enable row level security;
revoke all on public."value_model_items" from anon, authenticated;

create table public."vdt_nodes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "parent_id" text,
  "name" text,
  "value" numeric,
  "target" numeric,
  "unit" text,
  "operator" text,
  "lower_is_better" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."vdt_nodes" is 'Value driver tree: A node of the value driver tree; the root has no parent';
alter table public."vdt_nodes" enable row level security;
revoke all on public."vdt_nodes" from anon, authenticated;

create table public."vdt_notes" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "title" text,
  "text" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."vdt_notes" is 'Value driver notes: An insight card under the value driver tree';
alter table public."vdt_notes" enable row level security;
revoke all on public."vdt_notes" from anon, authenticated;

create table public."vdt_owners" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."vdt_owners" is 'Value driver owners: An owner of the value driver tree';
alter table public."vdt_owners" enable row level security;
revoke all on public."vdt_owners" from anon, authenticated;

create table public."xmatrix_bowling" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "targets" jsonb,
  "actuals" jsonb,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."xmatrix_bowling" is 'Bowling chart: Monthly targets and actuals of an X-matrix measure';
alter table public."xmatrix_bowling" enable row level security;
revoke all on public."xmatrix_bowling" from anon, authenticated;

create table public."xmatrix_items" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "quadrant" text,
  "name" text,
  "owner" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."xmatrix_items" is 'X-matrix items: A row of the Hoshin X-matrix: S breakthrough, W annual objective, N priority, E measure, R owner';
alter table public."xmatrix_items" enable row level security;
revoke all on public."xmatrix_items" from anon, authenticated;

create table public."xmatrix_links" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "from_item_id" text,
  "to_item_id" text,
  "strength" integer,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."xmatrix_links" is 'X-matrix correlations: A correlation between two X-matrix items (1 weak, 2 strong)';
alter table public."xmatrix_links" enable row level security;
revoke all on public."xmatrix_links" from anon, authenticated;

create table public."activity_feed" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "actor_id" text,
  "action" text,
  "ref" text,
  "title" text,
  "created_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."activity_feed" is 'Activity feed: One entry of the workspace activity feed: who did what, on which object (ref), newest first.';
alter table public."activity_feed" enable row level security;
revoke all on public."activity_feed" from anon, authenticated;

create table public."automation_rules" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "trigger_text" text,
  "action_text" text,
  "enabled" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."automation_rules" is 'Automation rules: A workspace automation rule and whether it is on. The behaviour of each rule id is built into the app.';
alter table public."automation_rules" enable row level security;
revoke all on public."automation_rules" from anon, authenticated;

create table public."custom_field_options" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "field_id" text,
  "label" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."custom_field_options" is 'Custom field options: One option of a single-select custom field, in order.';
alter table public."custom_field_options" enable row level security;
revoke all on public."custom_field_options" from anon, authenticated;

create table public."custom_fields" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "field_type" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."custom_fields" is 'Custom fields: A custom field every task in the workspace can have (text, number, single select, date or person), in display order.';
alter table public."custom_fields" enable row level security;
revoke all on public."custom_fields" from anon, authenticated;

create table public."notifications" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "recipient_id" text,
  "kind" text,
  "message" text,
  "ref" text,
  "created_on" date,
  "read" boolean,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."notifications" is 'Notifications: One item in a person''s inbox: a mention, an assignment, a request or a rule message. ref points at what it is about (task:I7-1, init:I2, go:wk-time).';
alter table public."notifications" enable row level security;
revoke all on public."notifications" from anon, authenticated;

create table public."rule_runs" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "rule_id" text,
  "ran_on" date,
  "message" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."rule_runs" is 'Rule runs: One run of an automation rule, newest first, with what it did.';
alter table public."rule_runs" enable row level security;
revoke all on public."rule_runs" from anon, authenticated;

create table public."saved_views" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "name" text,
  "owner_id" text,
  "shared" boolean,
  "view_type" text,
  "preset" text,
  "programme" text,
  "group_by" text,
  "search" text,
  "filters" jsonb,
  "created_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."saved_views" is 'Saved task views: A saved view of the Tasks page: view type, preset, programme, grouping, search and filters; personal or shared with the workspace.';
alter table public."saved_views" enable row level security;
revoke all on public."saved_views" from anon, authenticated;

create table public."timesheet_approvals" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "week_id" text,
  "actor_id" text,
  "acted_on" date,
  "action" text,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."timesheet_approvals" is 'Timesheet approval trail: One step in a timesheet week''s history: submitted, recalled, approved or returned (with the note).';
alter table public."timesheet_approvals" enable row level security;
revoke all on public."timesheet_approvals" from anon, authenticated;

create table public."timesheet_entries" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "week_id" text,
  "task_id" text,
  "listed" boolean,
  "hours_pos" integer,
  "mon" numeric,
  "tue" numeric,
  "wed" numeric,
  "thu" numeric,
  "fri" numeric,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."timesheet_entries" is 'Timesheet entries: One task row of a timesheet week with the hours logged Monday to Friday. listed: the task is a row of the week; hours null: no hours yet.';
alter table public."timesheet_entries" enable row level security;
revoke all on public."timesheet_entries" from anon, authenticated;

create table public."timesheet_weeks" (
  workspace_id uuid not null references public.workspaces (id) on delete cascade,
  id text not null,
  sort integer,
  "person_id" text,
  "week_start" date,
  "status" text,
  "decided_by" text,
  "note" text,
  "submitted_on" date,
  "decided_on" date,
  extra jsonb,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, id)
);
comment on table public."timesheet_weeks" is 'Timesheet weeks: One person''s timesheet for one week (Monday): draft, submitted, approved or returned. id is person|week.';
alter table public."timesheet_weeks" enable row level security;
revoke all on public."timesheet_weeks" from anon, authenticated;

-- parent-child links: enforced, cascading, checked at commit
alter table public."initiative_role_demand" add constraint "initiative_role_demand_role_id_fkey" foreign key (workspace_id, "role_id") references public."roles" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."product_panel_lists" add constraint "product_panel_lists_person_id_fkey" foreign key (workspace_id, "person_id") references public."product_panel_people" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."product_panel_picks" add constraint "product_panel_picks_person_id_fkey" foreign key (workspace_id, "person_id") references public."product_panel_people" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."product_shipped_items" add constraint "product_shipped_items_area_id_fkey" foreign key (workspace_id, "area_id") references public."product_shipped_areas" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."role_people" add constraint "role_people_role_id_fkey" foreign key (workspace_id, "role_id") references public."roles" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."scenario_caps" add constraint "scenario_caps_scenario_id_fkey" foreign key (workspace_id, "scenario_id") references public."scenarios" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."scenario_changes" add constraint "scenario_changes_scenario_id_fkey" foreign key (workspace_id, "scenario_id") references public."scenarios" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."baselines" add constraint "baselines_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."benefit_values" add constraint "benefit_values_benefit_id_fkey" foreign key (workspace_id, "benefit_id") references public."benefits" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."benefits" add constraint "benefits_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."change_requests" add constraint "change_requests_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."finance_months" add constraint "finance_months_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_approvers" add constraint "gate_approvers_stage_id_fkey" foreign key (workspace_id, "stage_id") references public."stages" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_checks" add constraint "gate_checks_gate_status_id_fkey" foreign key (workspace_id, "gate_status_id") references public."gate_status" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_criteria" add constraint "gate_criteria_stage_id_fkey" foreign key (workspace_id, "stage_id") references public."stages" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_log" add constraint "gate_log_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_status" add constraint "gate_status_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."gate_votes" add constraint "gate_votes_gate_status_id_fkey" foreign key (workspace_id, "gate_status_id") references public."gate_status" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."initiative_dependencies" add constraint "initiative_dependencies_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."initiative_finance" add constraint "initiative_finance_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."initiative_followers" add constraint "initiative_followers_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."initiative_measures" add constraint "initiative_measures_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."initiative_objectives" add constraint "initiative_objectives_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."milestones" add constraint "milestones_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."purchase_orders" add constraint "purchase_orders_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."request_objectives" add constraint "request_objectives_request_id_fkey" foreign key (workspace_id, "request_id") references public."requests" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."status_update_items" add constraint "status_update_items_status_update_id_fkey" foreign key (workspace_id, "status_update_id") references public."status_updates" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."subtasks" add constraint "subtasks_task_id_fkey" foreign key (workspace_id, "task_id") references public."tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."task_assignees" add constraint "task_assignees_task_id_fkey" foreign key (workspace_id, "task_id") references public."tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."task_dependencies" add constraint "task_dependencies_task_id_fkey" foreign key (workspace_id, "task_id") references public."tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."task_field_values" add constraint "task_field_values_task_id_fkey" foreign key (workspace_id, "task_id") references public."tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."task_followers" add constraint "task_followers_task_id_fkey" foreign key (workspace_id, "task_id") references public."tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."tasks" add constraint "tasks_initiative_id_fkey" foreign key (workspace_id, "initiative_id") references public."initiatives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."checklist_checks" add constraint "checklist_checks_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."checklist_checks" add constraint "checklist_checks_item_id_fkey" foreign key (workspace_id, "item_id") references public."checklist_items" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."checklist_items" add constraint "checklist_items_group_id_fkey" foreign key (workspace_id, "group_id") references public."checklist_groups" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."governance_items" add constraint "governance_items_group_id_fkey" foreign key (workspace_id, "group_id") references public."governance_groups" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."governance_members" add constraint "governance_members_group_id_fkey" foreign key (workspace_id, "group_id") references public."governance_groups" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_benefits" add constraint "project_benefits_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_closures" add constraint "project_closures_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_members" add constraint "project_members_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_scopes" add constraint "project_scopes_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_task_assignees" add constraint "project_task_assignees_task_id_fkey" foreign key (workspace_id, "task_id") references public."project_tasks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."project_tasks" add constraint "project_tasks_project_id_fkey" foreign key (workspace_id, "project_id") references public."projects" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."retro_items" add constraint "retro_items_retro_id_fkey" foreign key (workspace_id, "retro_id") references public."retrospectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."retro_participants" add constraint "retro_participants_retro_id_fkey" foreign key (workspace_id, "retro_id") references public."retrospectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."scope_items" add constraint "scope_items_scope_id_fkey" foreign key (workspace_id, "scope_id") references public."project_scopes" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."bmc_items" add constraint "bmc_items_block_id_fkey" foreign key (workspace_id, "block_id") references public."bmc_blocks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."canvas_scores" add constraint "canvas_scores_curve_id_fkey" foreign key (workspace_id, "curve_id") references public."canvas_curves" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."canvas_scores" add constraint "canvas_scores_factor_id_fkey" foreign key (workspace_id, "factor_id") references public."canvas_factors" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."key_results" add constraint "key_results_okr_objective_id_fkey" foreign key (workspace_id, "okr_objective_id") references public."okr_objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."measure_checkins" add constraint "measure_checkins_measure_id_fkey" foreign key (workspace_id, "measure_id") references public."measures" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."measure_targets" add constraint "measure_targets_measure_id_fkey" foreign key (workspace_id, "measure_id") references public."measures" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."objective_links" add constraint "objective_links_from_objective_id_fkey" foreign key (workspace_id, "from_objective_id") references public."objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."objective_links" add constraint "objective_links_to_objective_id_fkey" foreign key (workspace_id, "to_objective_id") references public."objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."objective_unit_health" add constraint "objective_unit_health_objective_id_fkey" foreign key (workspace_id, "objective_id") references public."objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."objective_unit_health" add constraint "objective_unit_health_unit_id_fkey" foreign key (workspace_id, "unit_id") references public."units" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."ogsm_strategy_initiatives" add constraint "ogsm_strategy_initiatives_strategy_id_fkey" foreign key (workspace_id, "strategy_id") references public."ogsm_strategies" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."ogsm_strategy_measures" add constraint "ogsm_strategy_measures_strategy_id_fkey" foreign key (workspace_id, "strategy_id") references public."ogsm_strategies" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."okr_objectives" add constraint "okr_objectives_parent_id_fkey" foreign key (workspace_id, "parent_id") references public."okr_objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."pulse_scores" add constraint "pulse_scores_survey_id_fkey" foreign key (workspace_id, "survey_id") references public."pulse_surveys" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."risk_mitigations" add constraint "risk_mitigations_risk_id_fkey" foreign key (workspace_id, "risk_id") references public."strategic_risks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."risk_objectives" add constraint "risk_objectives_risk_id_fkey" foreign key (workspace_id, "risk_id") references public."strategic_risks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."risk_reviews" add constraint "risk_reviews_risk_id_fkey" foreign key (workspace_id, "risk_id") references public."strategic_risks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."stakeholder_measures" add constraint "stakeholder_measures_stakeholder_id_fkey" foreign key (workspace_id, "stakeholder_id") references public."stakeholders" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."team_objectives" add constraint "team_objectives_team_id_fkey" foreign key (workspace_id, "team_id") references public."teams" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."teams" add constraint "teams_unit_id_fkey" foreign key (workspace_id, "unit_id") references public."units" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."unit_measure_checkins" add constraint "unit_measure_checkins_unit_measure_id_fkey" foreign key (workspace_id, "unit_measure_id") references public."unit_measures" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."unit_measure_targets" add constraint "unit_measure_targets_unit_measure_id_fkey" foreign key (workspace_id, "unit_measure_id") references public."unit_measures" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."unit_measures" add constraint "unit_measures_unit_objective_id_fkey" foreign key (workspace_id, "unit_objective_id") references public."unit_objectives" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."v2mom_method_measures" add constraint "v2mom_method_measures_method_id_fkey" foreign key (workspace_id, "method_id") references public."v2mom_methods" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."value_behaviours" add constraint "value_behaviours_value_id_fkey" foreign key (workspace_id, "value_id") references public."company_values" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."value_bridge_steps" add constraint "value_bridge_steps_bridge_id_fkey" foreign key (workspace_id, "bridge_id") references public."value_bridges" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."vdt_nodes" add constraint "vdt_nodes_parent_id_fkey" foreign key (workspace_id, "parent_id") references public."vdt_nodes" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."xmatrix_links" add constraint "xmatrix_links_from_item_id_fkey" foreign key (workspace_id, "from_item_id") references public."xmatrix_items" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."xmatrix_links" add constraint "xmatrix_links_to_item_id_fkey" foreign key (workspace_id, "to_item_id") references public."xmatrix_items" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."custom_field_options" add constraint "custom_field_options_field_id_fkey" foreign key (workspace_id, "field_id") references public."custom_fields" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."rule_runs" add constraint "rule_runs_rule_id_fkey" foreign key (workspace_id, "rule_id") references public."automation_rules" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."timesheet_approvals" add constraint "timesheet_approvals_week_id_fkey" foreign key (workspace_id, "week_id") references public."timesheet_weeks" (workspace_id, id) on delete cascade deferrable initially deferred;
alter table public."timesheet_entries" add constraint "timesheet_entries_week_id_fkey" foreign key (workspace_id, "week_id") references public."timesheet_weeks" (workspace_id, id) on delete cascade deferrable initially deferred;

-- every reference is indexed
create index "import_runs_initiative_id_idx" on public."import_runs" (workspace_id, "initiative_id");
create index "initiative_role_demand_initiative_id_idx" on public."initiative_role_demand" (workspace_id, "initiative_id");
create index "initiative_role_demand_role_id_idx" on public."initiative_role_demand" (workspace_id, "role_id");
create index "paused_initiatives_initiative_id_idx" on public."paused_initiatives" (workspace_id, "initiative_id");
create index "paused_initiatives_scenario_id_idx" on public."paused_initiatives" (workspace_id, "scenario_id");
create index "product_features_area_idx" on public."product_features" (workspace_id, "area");
create index "product_features_roadmap_item_id_idx" on public."product_features" (workspace_id, "roadmap_item_id");
create index "product_panel_lists_person_id_idx" on public."product_panel_lists" (workspace_id, "person_id");
create index "product_panel_picks_person_id_idx" on public."product_panel_picks" (workspace_id, "person_id");
create index "product_panel_picks_item_id_idx" on public."product_panel_picks" (workspace_id, "item_id");
create index "product_roadmap_items_area_idx" on public."product_roadmap_items" (workspace_id, "area");
create index "product_roadmap_items_horizon_idx" on public."product_roadmap_items" (workspace_id, "horizon");
create index "product_shipped_items_area_id_idx" on public."product_shipped_items" (workspace_id, "area_id");
create index "roadmap_suggestions_area_idx" on public."roadmap_suggestions" (workspace_id, "area");
create index "roadmap_suggestions_horizon_idx" on public."roadmap_suggestions" (workspace_id, "horizon");
create index "roadmap_votes_person_id_idx" on public."roadmap_votes" (workspace_id, "person_id");
create index "role_people_person_id_idx" on public."role_people" (workspace_id, "person_id");
create index "role_people_role_id_idx" on public."role_people" (workspace_id, "role_id");
create index "scenario_caps_scenario_id_idx" on public."scenario_caps" (workspace_id, "scenario_id");
create index "scenario_changes_scenario_id_idx" on public."scenario_changes" (workspace_id, "scenario_id");
create index "scenario_changes_initiative_id_idx" on public."scenario_changes" (workspace_id, "initiative_id");
create index "scenarios_created_by_idx" on public."scenarios" (workspace_id, "created_by");
create index "scenarios_applied_by_idx" on public."scenarios" (workspace_id, "applied_by");
create index "scenarios_applied_decision_id_idx" on public."scenarios" (workspace_id, "applied_decision_id");
create index "actions_owner_id_idx" on public."actions" (workspace_id, "owner_id");
create index "activity_actor_id_idx" on public."activity" (workspace_id, "actor_id");
create index "baselines_initiative_id_idx" on public."baselines" (workspace_id, "initiative_id");
create index "baselines_set_by_idx" on public."baselines" (workspace_id, "set_by");
create index "baselines_change_request_id_idx" on public."baselines" (workspace_id, "change_request_id");
create index "benefit_values_benefit_id_idx" on public."benefit_values" (workspace_id, "benefit_id");
create index "benefits_initiative_id_idx" on public."benefits" (workspace_id, "initiative_id");
create index "benefits_owner_id_idx" on public."benefits" (workspace_id, "owner_id");
create index "benefits_measure_id_idx" on public."benefits" (workspace_id, "measure_id");
create index "change_requests_initiative_id_idx" on public."change_requests" (workspace_id, "initiative_id");
create index "change_requests_requested_by_idx" on public."change_requests" (workspace_id, "requested_by");
create index "change_requests_approver_id_idx" on public."change_requests" (workspace_id, "approver_id");
create index "change_requests_decided_by_idx" on public."change_requests" (workspace_id, "decided_by");
create index "comments_author_id_idx" on public."comments" (workspace_id, "author_id");
create index "decisions_proposed_by_idx" on public."decisions" (workspace_id, "proposed_by");
create index "decisions_decided_by_idx" on public."decisions" (workspace_id, "decided_by");
create index "finance_months_initiative_id_idx" on public."finance_months" (workspace_id, "initiative_id");
create index "gate_approvers_stage_id_idx" on public."gate_approvers" (workspace_id, "stage_id");
create index "gate_approvers_person_id_idx" on public."gate_approvers" (workspace_id, "person_id");
create index "gate_checks_gate_status_id_idx" on public."gate_checks" (workspace_id, "gate_status_id");
create index "gate_criteria_stage_id_idx" on public."gate_criteria" (workspace_id, "stage_id");
create index "gate_log_initiative_id_idx" on public."gate_log" (workspace_id, "initiative_id");
create index "gate_log_to_stage_idx" on public."gate_log" (workspace_id, "to_stage");
create index "gate_log_decided_by_idx" on public."gate_log" (workspace_id, "decided_by");
create index "gate_status_initiative_id_idx" on public."gate_status" (workspace_id, "initiative_id");
create index "gate_status_stage_idx" on public."gate_status" (workspace_id, "stage");
create index "gate_votes_gate_status_id_idx" on public."gate_votes" (workspace_id, "gate_status_id");
create index "gate_votes_voter_id_idx" on public."gate_votes" (workspace_id, "voter_id");
create index "initiative_dependencies_initiative_id_idx" on public."initiative_dependencies" (workspace_id, "initiative_id");
create index "initiative_dependencies_depends_on_id_idx" on public."initiative_dependencies" (workspace_id, "depends_on_id");
create index "initiative_finance_initiative_id_idx" on public."initiative_finance" (workspace_id, "initiative_id");
create index "initiative_followers_initiative_id_idx" on public."initiative_followers" (workspace_id, "initiative_id");
create index "initiative_followers_person_id_idx" on public."initiative_followers" (workspace_id, "person_id");
create index "initiative_measures_initiative_id_idx" on public."initiative_measures" (workspace_id, "initiative_id");
create index "initiative_measures_measure_id_idx" on public."initiative_measures" (workspace_id, "measure_id");
create index "initiative_objectives_initiative_id_idx" on public."initiative_objectives" (workspace_id, "initiative_id");
create index "initiative_objectives_objective_id_idx" on public."initiative_objectives" (workspace_id, "objective_id");
create index "initiatives_perspective_id_idx" on public."initiatives" (workspace_id, "perspective_id");
create index "initiatives_programme_id_idx" on public."initiatives" (workspace_id, "programme_id");
create index "initiatives_stage_idx" on public."initiatives" (workspace_id, "stage");
create index "initiatives_owner_id_idx" on public."initiatives" (workspace_id, "owner_id");
create index "initiatives_project_id_idx" on public."initiatives" (workspace_id, "project_id");
create index "milestones_initiative_id_idx" on public."milestones" (workspace_id, "initiative_id");
create index "programmes_lead_id_idx" on public."programmes" (workspace_id, "lead_id");
create index "purchase_orders_initiative_id_idx" on public."purchase_orders" (workspace_id, "initiative_id");
create index "request_objectives_request_id_idx" on public."request_objectives" (workspace_id, "request_id");
create index "request_objectives_objective_id_idx" on public."request_objectives" (workspace_id, "objective_id");
create index "requests_sponsor_id_idx" on public."requests" (workspace_id, "sponsor_id");
create index "requests_initiative_id_idx" on public."requests" (workspace_id, "initiative_id");
create index "requests_decision_id_idx" on public."requests" (workspace_id, "decision_id");
create index "status_update_items_status_update_id_idx" on public."status_update_items" (workspace_id, "status_update_id");
create index "status_updates_author_id_idx" on public."status_updates" (workspace_id, "author_id");
create index "subtasks_task_id_idx" on public."subtasks" (workspace_id, "task_id");
create index "task_assignees_task_id_idx" on public."task_assignees" (workspace_id, "task_id");
create index "task_assignees_person_id_idx" on public."task_assignees" (workspace_id, "person_id");
create index "task_dependencies_task_id_idx" on public."task_dependencies" (workspace_id, "task_id");
create index "task_dependencies_depends_on_id_idx" on public."task_dependencies" (workspace_id, "depends_on_id");
create index "task_field_values_task_id_idx" on public."task_field_values" (workspace_id, "task_id");
create index "task_followers_task_id_idx" on public."task_followers" (workspace_id, "task_id");
create index "task_followers_person_id_idx" on public."task_followers" (workspace_id, "person_id");
create index "tasks_initiative_id_idx" on public."tasks" (workspace_id, "initiative_id");
create index "tasks_owner_id_idx" on public."tasks" (workspace_id, "owner_id");
create index "checklist_checks_project_id_idx" on public."checklist_checks" (workspace_id, "project_id");
create index "checklist_checks_item_id_idx" on public."checklist_checks" (workspace_id, "item_id");
create index "checklist_items_group_id_idx" on public."checklist_items" (workspace_id, "group_id");
create index "dashboard_items_assignee_id_idx" on public."dashboard_items" (workspace_id, "assignee_id");
create index "governance_items_group_id_idx" on public."governance_items" (workspace_id, "group_id");
create index "governance_members_group_id_idx" on public."governance_members" (workspace_id, "group_id");
create index "governance_members_person_id_idx" on public."governance_members" (workspace_id, "person_id");
create index "project_benefits_project_id_idx" on public."project_benefits" (workspace_id, "project_id");
create index "project_benefits_owner_id_idx" on public."project_benefits" (workspace_id, "owner_id");
create index "project_closures_project_id_idx" on public."project_closures" (workspace_id, "project_id");
create index "project_members_project_id_idx" on public."project_members" (workspace_id, "project_id");
create index "project_members_person_id_idx" on public."project_members" (workspace_id, "person_id");
create index "project_scopes_project_id_idx" on public."project_scopes" (workspace_id, "project_id");
create index "project_task_assignees_task_id_idx" on public."project_task_assignees" (workspace_id, "task_id");
create index "project_task_assignees_person_id_idx" on public."project_task_assignees" (workspace_id, "person_id");
create index "project_tasks_project_id_idx" on public."project_tasks" (workspace_id, "project_id");
create index "raid_items_owner_id_idx" on public."raid_items" (workspace_id, "owner_id");
create index "raid_items_initiative_id_idx" on public."raid_items" (workspace_id, "initiative_id");
create index "resource_absences_person_id_idx" on public."resource_absences" (workspace_id, "person_id");
create index "resource_workloads_person_id_idx" on public."resource_workloads" (workspace_id, "person_id");
create index "retro_items_retro_id_idx" on public."retro_items" (workspace_id, "retro_id");
create index "retro_items_owner_id_idx" on public."retro_items" (workspace_id, "owner_id");
create index "retro_participants_retro_id_idx" on public."retro_participants" (workspace_id, "retro_id");
create index "retro_participants_person_id_idx" on public."retro_participants" (workspace_id, "person_id");
create index "scope_items_scope_id_idx" on public."scope_items" (workspace_id, "scope_id");
create index "ambition_goals_objective_id_idx" on public."ambition_goals" (workspace_id, "objective_id");
create index "ambition_levers_initiative_id_idx" on public."ambition_levers" (workspace_id, "initiative_id");
create index "bmc_items_block_id_idx" on public."bmc_items" (workspace_id, "block_id");
create index "board_packs_frozen_by_idx" on public."board_packs" (workspace_id, "frozen_by");
create index "canvas_scores_curve_id_idx" on public."canvas_scores" (workspace_id, "curve_id");
create index "canvas_scores_factor_id_idx" on public."canvas_scores" (workspace_id, "factor_id");
create index "company_values_champion_idx" on public."company_values" (workspace_id, "champion");
create index "key_results_okr_objective_id_idx" on public."key_results" (workspace_id, "okr_objective_id");
create index "kudos_from_person_idx" on public."kudos" (workspace_id, "from_person");
create index "kudos_to_person_idx" on public."kudos" (workspace_id, "to_person");
create index "kudos_value_name_idx" on public."kudos" (workspace_id, "value_name");
create index "measure_checkins_measure_id_idx" on public."measure_checkins" (workspace_id, "measure_id");
create index "measure_checkins_by_person_idx" on public."measure_checkins" (workspace_id, "by_person");
create index "measure_targets_measure_id_idx" on public."measure_targets" (workspace_id, "measure_id");
create index "measures_objective_id_idx" on public."measures" (workspace_id, "objective_id");
create index "measures_owner_idx" on public."measures" (workspace_id, "owner");
create index "objective_links_from_objective_id_idx" on public."objective_links" (workspace_id, "from_objective_id");
create index "objective_links_to_objective_id_idx" on public."objective_links" (workspace_id, "to_objective_id");
create index "objective_unit_health_objective_id_idx" on public."objective_unit_health" (workspace_id, "objective_id");
create index "objective_unit_health_unit_id_idx" on public."objective_unit_health" (workspace_id, "unit_id");
create index "objectives_perspective_id_idx" on public."objectives" (workspace_id, "perspective_id");
create index "objectives_owner_idx" on public."objectives" (workspace_id, "owner");
create index "ogsm_goals_objective_id_idx" on public."ogsm_goals" (workspace_id, "objective_id");
create index "ogsm_strategies_owner_idx" on public."ogsm_strategies" (workspace_id, "owner");
create index "ogsm_strategy_initiatives_strategy_id_idx" on public."ogsm_strategy_initiatives" (workspace_id, "strategy_id");
create index "ogsm_strategy_initiatives_initiative_id_idx" on public."ogsm_strategy_initiatives" (workspace_id, "initiative_id");
create index "ogsm_strategy_measures_strategy_id_idx" on public."ogsm_strategy_measures" (workspace_id, "strategy_id");
create index "okr_objectives_parent_id_idx" on public."okr_objectives" (workspace_id, "parent_id");
create index "okr_objectives_objective_id_idx" on public."okr_objectives" (workspace_id, "objective_id");
create index "okr_objectives_owner_idx" on public."okr_objectives" (workspace_id, "owner");
create index "period_locks_locked_by_idx" on public."period_locks" (workspace_id, "locked_by");
create index "pulse_scores_survey_id_idx" on public."pulse_scores" (workspace_id, "survey_id");
create index "pulse_scores_value_name_idx" on public."pulse_scores" (workspace_id, "value_name");
create index "pulse_scores_unit_id_idx" on public."pulse_scores" (workspace_id, "unit_id");
create index "pulse_statements_value_name_idx" on public."pulse_statements" (workspace_id, "value_name");
create index "review_proposals_owner_idx" on public."review_proposals" (workspace_id, "owner");
create index "risk_mitigations_risk_id_idx" on public."risk_mitigations" (workspace_id, "risk_id");
create index "risk_mitigations_owner_idx" on public."risk_mitigations" (workspace_id, "owner");
create index "risk_objectives_risk_id_idx" on public."risk_objectives" (workspace_id, "risk_id");
create index "risk_objectives_objective_id_idx" on public."risk_objectives" (workspace_id, "objective_id");
create index "risk_reviews_risk_id_idx" on public."risk_reviews" (workspace_id, "risk_id");
create index "risk_reviews_by_person_idx" on public."risk_reviews" (workspace_id, "by_person");
create index "stakeholder_measures_stakeholder_id_idx" on public."stakeholder_measures" (workspace_id, "stakeholder_id");
create index "strategic_risks_owner_idx" on public."strategic_risks" (workspace_id, "owner");
create index "team_objectives_team_id_idx" on public."team_objectives" (workspace_id, "team_id");
create index "team_objectives_objective_id_idx" on public."team_objectives" (workspace_id, "objective_id");
create index "teams_unit_id_idx" on public."teams" (workspace_id, "unit_id");
create index "unit_measure_checkins_unit_measure_id_idx" on public."unit_measure_checkins" (workspace_id, "unit_measure_id");
create index "unit_measure_checkins_by_person_idx" on public."unit_measure_checkins" (workspace_id, "by_person");
create index "unit_measure_targets_unit_measure_id_idx" on public."unit_measure_targets" (workspace_id, "unit_measure_id");
create index "unit_measures_unit_objective_id_idx" on public."unit_measures" (workspace_id, "unit_objective_id");
create index "unit_measures_owner_idx" on public."unit_measures" (workspace_id, "owner");
create index "unit_objectives_unit_id_idx" on public."unit_objectives" (workspace_id, "unit_id");
create index "unit_objectives_owner_idx" on public."unit_objectives" (workspace_id, "owner");
create index "unit_objectives_objective_id_idx" on public."unit_objectives" (workspace_id, "objective_id");
create index "units_lead_idx" on public."units" (workspace_id, "lead");
create index "v2mom_method_measures_method_id_idx" on public."v2mom_method_measures" (workspace_id, "method_id");
create index "v2mom_method_measures_objective_id_idx" on public."v2mom_method_measures" (workspace_id, "objective_id");
create index "v2mom_methods_owner_idx" on public."v2mom_methods" (workspace_id, "owner");
create index "v2mom_methods_initiative_id_idx" on public."v2mom_methods" (workspace_id, "initiative_id");
create index "v2mom_obstacles_method_id_idx" on public."v2mom_obstacles" (workspace_id, "method_id");
create index "value_behaviours_value_id_idx" on public."value_behaviours" (workspace_id, "value_id");
create index "value_bridge_steps_bridge_id_idx" on public."value_bridge_steps" (workspace_id, "bridge_id");
create index "vdt_nodes_parent_id_idx" on public."vdt_nodes" (workspace_id, "parent_id");
create index "vdt_owners_person_idx" on public."vdt_owners" (workspace_id, "person");
create index "xmatrix_items_owner_idx" on public."xmatrix_items" (workspace_id, "owner");
create index "xmatrix_links_from_item_id_idx" on public."xmatrix_links" (workspace_id, "from_item_id");
create index "xmatrix_links_to_item_id_idx" on public."xmatrix_links" (workspace_id, "to_item_id");
create index "activity_feed_actor_id_idx" on public."activity_feed" (workspace_id, "actor_id");
create index "custom_field_options_field_id_idx" on public."custom_field_options" (workspace_id, "field_id");
create index "notifications_recipient_id_idx" on public."notifications" (workspace_id, "recipient_id");
create index "rule_runs_rule_id_idx" on public."rule_runs" (workspace_id, "rule_id");
create index "saved_views_owner_id_idx" on public."saved_views" (workspace_id, "owner_id");
create index "timesheet_approvals_week_id_idx" on public."timesheet_approvals" (workspace_id, "week_id");
create index "timesheet_approvals_actor_id_idx" on public."timesheet_approvals" (workspace_id, "actor_id");
create index "timesheet_entries_week_id_idx" on public."timesheet_entries" (workspace_id, "week_id");
create index "timesheet_entries_task_id_idx" on public."timesheet_entries" (workspace_id, "task_id");
create index "timesheet_weeks_person_id_idx" on public."timesheet_weeks" (workspace_id, "person_id");
create index "timesheet_weeks_decided_by_idx" on public."timesheet_weeks" (workspace_id, "decided_by");

-- data dictionary used by the access functions
delete from public.orgcue_tables;
insert into public.orgcue_tables (name, domain, scope, title, description, columns, sort) values
  ('audit_log', 'platform', 'workspace', 'Audit log', 'One recorded change: when (ISO time), who, kind and what; the latest 500 are kept', '[{"name":"at","type":"text","ref":null,"enforced":false},{"name":"who","type":"text","ref":null,"enforced":false},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 0),
  ('budget_caps', 'platform', 'workspace', 'Budget caps', 'Yearly budget cap of the live plan in £k (id = year)', '[{"name":"year","type":"text","ref":null,"enforced":false},{"name":"cap","type":"num","ref":null,"enforced":false}]'::jsonb, 1),
  ('import_runs', 'platform', 'workspace', 'Imports', 'The last import, with what it added so it can be undone (measure_snapshots: values before the import)', '[{"name":"at","type":"text","ref":null,"enforced":false},{"name":"who","type":"text","ref":null,"enforced":false},{"name":"target","type":"text","ref":null,"enforced":false},{"name":"source","type":"text","ref":null,"enforced":false},{"name":"row_count","type":"int","ref":null,"enforced":false},{"name":"skipped","type":"int","ref":null,"enforced":false},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"task_ids","type":"jsonb","ref":null,"enforced":false},{"name":"initiative_ids","type":"jsonb","ref":null,"enforced":false},{"name":"measure_snapshots","type":"jsonb","ref":null,"enforced":false},{"name":"summary","type":"text","ref":null,"enforced":false}]'::jsonb, 2),
  ('initiative_role_demand', 'platform', 'workspace', 'Demand by role', 'FTE an initiative needs from a role in every quarter while it runs (a row without role keeps an initiative whose demand was cleared)', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"role_id","type":"text","ref":"roles","enforced":true},{"name":"fte","type":"num","ref":null,"enforced":false}]'::jsonb, 3),
  ('paused_initiatives', 'platform', 'workspace', 'Paused initiatives', 'An initiative an applied scenario left out of the live plan (id = initiative)', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"scenario_id","type":"text","ref":"scenarios","enforced":false},{"name":"paused_on","type":"date","ref":null,"enforced":false}]'::jsonb, 4),
  ('product_features', 'platform', 'product', 'Feature coverage', 'A feature buyers expect (class T table stakes, E expected, D differentiator) and how far OrgCue covers it', '[{"name":"area","type":"text","ref":"product_roadmap_areas","enforced":false},{"name":"feature","type":"text","ref":null,"enforced":false},{"name":"class","type":"text","ref":null,"enforced":false},{"name":"coverage","type":"text","ref":null,"enforced":false},{"name":"go","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"vendors","type":"text","ref":null,"enforced":false},{"name":"roadmap_item_id","type":"text","ref":"product_roadmap_items","enforced":false}]'::jsonb, 5),
  ('product_import_samples', 'platform', 'product', 'Import samples', 'A sample CSV file offered on the import page (id = sample key)', '[{"name":"file_name","type":"text","ref":null,"enforced":false},{"name":"content","type":"text","ref":null,"enforced":false}]'::jsonb, 6),
  ('product_panel_findings', 'platform', 'product', 'Panel findings', 'A point the review panel agreed on', '[{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 7),
  ('product_panel_lists', 'platform', 'product', 'Panel reviewer notes', 'One line a reviewer gave: kind good (strongest today) or gaps (biggest gaps)', '[{"name":"person_id","type":"text","ref":"product_panel_people","enforced":true},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 8),
  ('product_panel_people', 'platform', 'product', 'Panel reviewers', 'A reviewer on the product panel (id = initials)', '[{"name":"role","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"lens","type":"text","ref":null,"enforced":false},{"name":"quote","type":"text","ref":null,"enforced":false}]'::jsonb, 9),
  ('product_panel_picks', 'platform', 'product', 'Panel picks', 'A roadmap item a reviewer wants built now', '[{"name":"person_id","type":"text","ref":"product_panel_people","enforced":true},{"name":"item_id","type":"text","ref":"product_roadmap_items","enforced":false}]'::jsonb, 10),
  ('product_roadmap_areas', 'platform', 'product', 'Roadmap areas', 'A product area with its colour (id = area name)', '[{"name":"color","type":"text","ref":null,"enforced":false}]'::jsonb, 11),
  ('product_roadmap_horizons', 'platform', 'product', 'Roadmap horizons', 'A column of the product roadmap (done, now, next, later)', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false}]'::jsonb, 12),
  ('product_roadmap_items', 'platform', 'product', 'Roadmap items', 'A product capability: shipped, building, planned or exploring', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"area","type":"text","ref":"product_roadmap_areas","enforced":false},{"name":"horizon","type":"text","ref":"product_roadmap_horizons","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"go","type":"text","ref":null,"enforced":false},{"name":"votes","type":"int","ref":null,"enforced":false},{"name":"asked_by","type":"jsonb","ref":null,"enforced":false},{"name":"refs","type":"jsonb","ref":null,"enforced":false},{"name":"why","type":"text","ref":null,"enforced":false},{"name":"what","type":"text","ref":null,"enforced":false},{"name":"collab","type":"int","ref":null,"enforced":false}]'::jsonb, 13),
  ('product_shipped_areas', 'platform', 'product', 'Shipped areas', 'A group of shipped capabilities', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"icon","type":"text","ref":null,"enforced":false}]'::jsonb, 14),
  ('product_shipped_items', 'platform', 'product', 'Shipped capabilities', 'A shipped capability with the page that shows it', '[{"name":"area_id","type":"text","ref":"product_shipped_areas","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"go","type":"text","ref":null,"enforced":false}]'::jsonb, 15),
  ('product_vendors', 'platform', 'product', 'Vendors', 'A vendor researched for the roadmap', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"area","type":"text","ref":null,"enforced":false},{"name":"known_for","type":"text","ref":null,"enforced":false},{"name":"lesson","type":"text","ref":null,"enforced":false}]'::jsonb, 16),
  ('roadmap_suggestions', 'platform', 'workspace', 'Roadmap suggestions', 'A feature someone in this workspace suggested for the product roadmap', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"area","type":"text","ref":"product_roadmap_areas","enforced":false},{"name":"horizon","type":"text","ref":"product_roadmap_horizons","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"go","type":"text","ref":null,"enforced":false},{"name":"votes","type":"int","ref":null,"enforced":false},{"name":"asked_by","type":"jsonb","ref":null,"enforced":false},{"name":"refs","type":"jsonb","ref":null,"enforced":false},{"name":"why","type":"text","ref":null,"enforced":false},{"name":"what","type":"text","ref":null,"enforced":false},{"name":"collab","type":"int","ref":null,"enforced":false}]'::jsonb, 17),
  ('roadmap_votes', 'platform', 'workspace', 'Roadmap votes', 'A person''s vote for a roadmap item or suggestion (item_id is a product_roadmap_items or roadmap_suggestions id)', '[{"name":"item_id","type":"text","ref":null,"enforced":false},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 18),
  ('role_people', 'platform', 'workspace', 'People''s roles', 'A person''s role for capacity planning and the share of their time that goes to portfolio work (id = person)', '[{"name":"person_id","type":"text","ref":"people","enforced":false},{"name":"role_id","type":"text","ref":"roles","enforced":true},{"name":"share","type":"num","ref":null,"enforced":false}]'::jsonb, 19),
  ('roles', 'platform', 'workspace', 'Roles', 'A role whose capacity is planned: FTE from the wider team on top of named people, which can change from a quarter (index into the planning horizon)', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"extra_fte","type":"num","ref":null,"enforced":false},{"name":"change_quarter","type":"int","ref":null,"enforced":false},{"name":"extra_fte_after","type":"num","ref":null,"enforced":false}]'::jsonb, 20),
  ('scenario_caps', 'platform', 'workspace', 'Scenario budget caps', 'Yearly budget cap in £k inside a scenario', '[{"name":"scenario_id","type":"text","ref":"scenarios","enforced":true},{"name":"year","type":"text","ref":null,"enforced":false},{"name":"cap","type":"num","ref":null,"enforced":false}]'::jsonb, 21),
  ('scenario_changes', 'platform', 'workspace', 'Scenario changes', 'How a scenario changes one initiative: left out (1) or kept in (0), quarters moved, budget in £k', '[{"name":"scenario_id","type":"text","ref":"scenarios","enforced":true},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"leave_out","type":"int","ref":null,"enforced":false},{"name":"shift_quarters","type":"int","ref":null,"enforced":false},{"name":"cost","type":"num","ref":null,"enforced":false}]'::jsonb, 22),
  ('scenarios', 'platform', 'workspace', 'Scenarios', 'A what-if plan: changes on top of the live plan, and when it was last applied', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"created_by","type":"text","ref":"people","enforced":false},{"name":"created_on","type":"date","ref":null,"enforced":false},{"name":"applied_on","type":"date","ref":null,"enforced":false},{"name":"applied_by","type":"text","ref":"people","enforced":false},{"name":"applied_decision_id","type":"text","ref":"decisions","enforced":false},{"name":"applied_changes","type":"int","ref":null,"enforced":false}]'::jsonb, 23),
  ('actions', 'portfolio', 'workspace', 'Actions', 'A follow-up action, often from a decision', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"due_date","type":"date","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"source","type":"text","ref":null,"enforced":false},{"name":"created_on","type":"date","ref":null,"enforced":false}]'::jsonb, 24),
  ('activity', 'portfolio', 'workspace', 'Activity', 'A change made to any record; ref names it, for example task:I7-1', '[{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"actor_id","type":"text","ref":"people","enforced":false},{"name":"happened_on","type":"date","ref":null,"enforced":false},{"name":"what","type":"text","ref":null,"enforced":false}]'::jsonb, 25),
  ('baselines', 'portfolio', 'workspace', 'Baselines', 'An approved version of an initiative''s dates and budget', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"version","type":"int","ref":null,"enforced":false},{"name":"start_q","type":"int","ref":null,"enforced":false},{"name":"end_q","type":"int","ref":null,"enforced":false},{"name":"budget","type":"num","ref":null,"enforced":false},{"name":"set_on","type":"date","ref":null,"enforced":false},{"name":"reason","type":"text","ref":null,"enforced":false},{"name":"set_by","type":"text","ref":"people","enforced":false},{"name":"change_request_id","type":"text","ref":"change_requests","enforced":false}]'::jsonb, 26),
  ('benefit_values', 'portfolio', 'workspace', 'Benefit values', 'Planned and realised value of a benefit in one quarter', '[{"name":"benefit_id","type":"text","ref":"benefits","enforced":true},{"name":"quarter","type":"int","ref":null,"enforced":false},{"name":"planned","type":"num","ref":null,"enforced":false},{"name":"realised","type":"num","ref":null,"enforced":false}]'::jsonb, 27),
  ('benefits', 'portfolio', 'workspace', 'Benefits', 'A benefit profile of an initiative', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"measure_id","type":"text","ref":"measures","enforced":false},{"name":"unit","type":"text","ref":null,"enforced":false}]'::jsonb, 28),
  ('change_requests', 'portfolio', 'workspace', 'Change requests', 'A request to change the end date, budget or scope of an initiative', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"requested_by","type":"text","ref":"people","enforced":false},{"name":"requested_on","type":"date","ref":null,"enforced":false},{"name":"changes","type":"jsonb","ref":null,"enforced":false},{"name":"new_end_q","type":"int","ref":null,"enforced":false},{"name":"new_budget","type":"num","ref":null,"enforced":false},{"name":"new_scope","type":"text","ref":null,"enforced":false},{"name":"reason","type":"text","ref":null,"enforced":false},{"name":"impact","type":"text","ref":null,"enforced":false},{"name":"approver_id","type":"text","ref":"people","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"old_end_q","type":"int","ref":null,"enforced":false},{"name":"old_budget","type":"num","ref":null,"enforced":false},{"name":"old_scope","type":"text","ref":null,"enforced":false},{"name":"decided_by","type":"text","ref":"people","enforced":false},{"name":"decided_on","type":"date","ref":null,"enforced":false},{"name":"decision_comment","type":"text","ref":null,"enforced":false}]'::jsonb, 29),
  ('comments', 'portfolio', 'workspace', 'Comments', 'A comment on any record; ref names it, for example task:I7-1 or su:SU2', '[{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"author_id","type":"text","ref":"people","enforced":false},{"name":"posted_on","type":"date","ref":null,"enforced":false},{"name":"body","type":"text","ref":null,"enforced":false}]'::jsonb, 30),
  ('decisions', 'portfolio', 'workspace', 'Decisions', 'A decision from a steering group, review or stage gate', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"forum","type":"text","ref":null,"enforced":false},{"name":"about_ref","type":"text","ref":null,"enforced":false},{"name":"proposed_by","type":"text","ref":"people","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"from_gate","type":"int","ref":null,"enforced":false},{"name":"decided_by","type":"text","ref":"people","enforced":false},{"name":"decided_on","type":"date","ref":null,"enforced":false},{"name":"rationale","type":"text","ref":null,"enforced":false}]'::jsonb, 31),
  ('finance_months', 'portfolio', 'workspace', 'Finance by month', 'Budget, actual and forecast of an initiative for one month (0 = the first month of the horizon), £k', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"month","type":"int","ref":null,"enforced":false},{"name":"budget","type":"num","ref":null,"enforced":false},{"name":"actual","type":"num","ref":null,"enforced":false},{"name":"forecast","type":"num","ref":null,"enforced":false}]'::jsonb, 32),
  ('gate_approvers', 'portfolio', 'workspace', 'Gate approvers', 'A person who must approve leaving a stage', '[{"name":"stage_id","type":"text","ref":"stages","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 33),
  ('gate_checks', 'portfolio', 'workspace', 'Gate checks', 'A criterion ticked or explained for an initiative', '[{"name":"gate_status_id","type":"text","ref":"gate_status","enforced":true},{"name":"criterion","type":"text","ref":null,"enforced":false},{"name":"met","type":"bool","ref":null,"enforced":false},{"name":"explanation","type":"text","ref":null,"enforced":false}]'::jsonb, 34),
  ('gate_criteria', 'portfolio', 'workspace', 'Gate criteria', 'A criterion to meet before leaving a stage', '[{"name":"stage_id","type":"text","ref":"stages","enforced":true},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 35),
  ('gate_log', 'portfolio', 'workspace', 'Gate log', 'A move of an initiative through a stage gate', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"to_stage","type":"text","ref":"stages","enforced":false},{"name":"decided_by","type":"text","ref":"people","enforced":false},{"name":"decided_on","type":"date","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false},{"name":"votes","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 36),
  ('gate_status', 'portfolio', 'workspace', 'Gate status', 'Where an initiative stands at the gate of its current stage', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"stage","type":"text","ref":"stages","enforced":false},{"name":"last_rejected_on","type":"date","ref":null,"enforced":false},{"name":"last_rejected_by","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 37),
  ('gate_votes', 'portfolio', 'workspace', 'Gate votes', 'An approver''s decision at a gate', '[{"name":"gate_status_id","type":"text","ref":"gate_status","enforced":true},{"name":"voter_id","type":"text","ref":"people","enforced":false},{"name":"decision","type":"text","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false},{"name":"voted_on","type":"date","ref":null,"enforced":false}]'::jsonb, 38),
  ('initiative_dependencies', 'portfolio', 'workspace', 'Initiative dependencies', 'An initiative that must finish first', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"depends_on_id","type":"text","ref":"initiatives","enforced":false}]'::jsonb, 39),
  ('initiative_finance', 'portfolio', 'workspace', 'Initiative finance', 'Finance settings of an initiative; id is the initiative id', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"capex_pct","type":"num","ref":null,"enforced":false},{"name":"months","type":"int","ref":null,"enforced":false}]'::jsonb, 40),
  ('initiative_followers', 'portfolio', 'workspace', 'Initiative followers', 'A person who follows an initiative', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 41),
  ('initiative_measures', 'portfolio', 'workspace', 'Expected impact', 'What an initiative is expected to add to a measure', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"measure_id","type":"text","ref":"measures","enforced":false},{"name":"impact","type":"num","ref":null,"enforced":false}]'::jsonb, 42),
  ('initiative_objectives', 'portfolio', 'workspace', 'Initiative objectives', 'An objective an initiative supports', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 43),
  ('initiatives', 'portfolio', 'workspace', 'Initiatives', 'A strategic initiative: dates as quarter indexes into the planning horizon, money in £k', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"perspective_id","type":"text","ref":"perspectives","enforced":false},{"name":"programme_id","type":"text","ref":"programmes","enforced":false},{"name":"stage","type":"text","ref":"stages","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"start_q","type":"int","ref":null,"enforced":false},{"name":"end_q","type":"int","ref":null,"enforced":false},{"name":"baseline_start_q","type":"int","ref":null,"enforced":false},{"name":"baseline_end_q","type":"int","ref":null,"enforced":false},{"name":"budget","type":"num","ref":null,"enforced":false},{"name":"spent","type":"num","ref":null,"enforced":false},{"name":"forecast","type":"num","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"effort","type":"num","ref":null,"enforced":false},{"name":"risk","type":"text","ref":null,"enforced":false},{"name":"project_id","type":"text","ref":"projects","enforced":false}]'::jsonb, 44),
  ('milestones', 'portfolio', 'workspace', 'Milestones', 'A milestone quarter of an initiative', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"quarter","type":"int","ref":null,"enforced":false}]'::jsonb, 45),
  ('programmes', 'portfolio', 'workspace', 'Programmes', 'A group of initiatives with a lead and a colour', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"lead_id","type":"text","ref":"people","enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false}]'::jsonb, 46),
  ('purchase_orders', 'portfolio', 'workspace', 'Purchase orders', 'Money committed to a supplier against an initiative budget, £k', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"supplier","type":"text","ref":null,"enforced":false},{"name":"amount","type":"num","ref":null,"enforced":false},{"name":"raised_on","type":"date","ref":null,"enforced":false}]'::jsonb, 47),
  ('request_objectives', 'portfolio', 'workspace', 'Request objectives', 'An objective a request supports', '[{"name":"request_id","type":"text","ref":"requests","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 48),
  ('requests', 'portfolio', 'workspace', 'Requests', 'A new idea or request waiting to enter the portfolio', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"sponsor_id","type":"text","ref":"people","enforced":false},{"name":"submitted_on","type":"date","ref":null,"enforced":false},{"name":"problem","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"effort","type":"num","ref":null,"enforced":false},{"name":"cost","type":"num","ref":null,"enforced":false},{"name":"risk","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"decision_id","type":"text","ref":"decisions","enforced":false}]'::jsonb, 49),
  ('stages', 'portfolio', 'workspace', 'Stages', 'A stage of the initiative life cycle and the gate to leave it', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"in_flow","type":"bool","ref":null,"enforced":false},{"name":"gate_question","type":"text","ref":null,"enforced":false},{"name":"has_gate","type":"bool","ref":null,"enforced":false},{"name":"gate_rule","type":"text","ref":null,"enforced":false}]'::jsonb, 50),
  ('status_update_items', 'portfolio', 'workspace', 'Status update items', 'A highlight, blocker or next step of a status update', '[{"name":"status_update_id","type":"text","ref":"status_updates","enforced":true},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 51),
  ('status_updates', 'portfolio', 'workspace', 'Status updates', 'A status update on an initiative or a programme', '[{"name":"target_id","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"author_id","type":"text","ref":"people","enforced":false},{"name":"posted_on","type":"date","ref":null,"enforced":false},{"name":"summary","type":"text","ref":null,"enforced":false}]'::jsonb, 52),
  ('subtasks', 'portfolio', 'workspace', 'Subtasks', 'A checklist item of a task', '[{"name":"task_id","type":"text","ref":"tasks","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"done","type":"bool","ref":null,"enforced":false}]'::jsonb, 53),
  ('task_assignees', 'portfolio', 'workspace', 'Task co-assignees', 'A person who works on a task with its owner', '[{"name":"task_id","type":"text","ref":"tasks","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 54),
  ('task_dependencies', 'portfolio', 'workspace', 'Task dependencies', 'A task that must be done before this one', '[{"name":"task_id","type":"text","ref":"tasks","enforced":true},{"name":"depends_on_id","type":"text","ref":"tasks","enforced":false}]'::jsonb, 55),
  ('task_field_values', 'portfolio', 'workspace', 'Task custom field values', 'The value of a custom field on a task', '[{"name":"task_id","type":"text","ref":"tasks","enforced":true},{"name":"field_id","type":"text","ref":null,"enforced":false},{"name":"value","type":"text","ref":null,"enforced":false}]'::jsonb, 56),
  ('task_followers', 'portfolio', 'workspace', 'Task followers', 'A person who follows a task', '[{"name":"task_id","type":"text","ref":"tasks","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 57),
  ('tasks', 'portfolio', 'workspace', 'Tasks', 'A task of an initiative (linked project plans read these too)', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"withdrawn","type":"bool","ref":null,"enforced":false},{"name":"priority","type":"text","ref":null,"enforced":false},{"name":"phase","type":"text","ref":null,"enforced":false},{"name":"start_date","type":"date","ref":null,"enforced":false},{"name":"due_date","type":"date","ref":null,"enforced":false},{"name":"due_quarter","type":"text","ref":null,"enforced":false},{"name":"estimate_hours","type":"num","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"plan_ref","type":"text","ref":null,"enforced":false}]'::jsonb, 58),
  ('checklist_checks', 'projects', 'workspace', 'Pre-launch checks done', 'A check ticked for a project.', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"item_id","type":"text","ref":"checklist_items","enforced":true}]'::jsonb, 59),
  ('checklist_groups', 'projects', 'workspace', 'Pre-launch checklist groups', 'A group of pre-launch checks.', '[{"name":"name","type":"text","ref":null,"enforced":false}]'::jsonb, 60),
  ('checklist_items', 'projects', 'workspace', 'Pre-launch checks', 'One check, id = its code (c1, c2...).', '[{"name":"group_id","type":"text","ref":"checklist_groups","enforced":true},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 61),
  ('closure_steps', 'projects', 'workspace', 'Closure steps', 'The steps every project goes through to close, in order.', '[{"name":"name","type":"text","ref":null,"enforced":false}]'::jsonb, 62),
  ('dashboard_items', 'projects', 'workspace', 'Dashboard tasks and actions', 'A task or action on the dashboard. kind: tasks or actions; due_bucket: today, week or overdue.', '[{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"due_bucket","type":"text","ref":null,"enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"subtask_count","type":"int","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"project_name","type":"text","ref":null,"enforced":false},{"name":"priority","type":"text","ref":null,"enforced":false},{"name":"due_label","type":"text","ref":null,"enforced":false},{"name":"assignee_id","type":"text","ref":"people","enforced":false}]'::jsonb, 63),
  ('devices', 'projects', 'workspace', 'Devices', 'A device the user is signed in on.', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"location","type":"text","ref":null,"enforced":false},{"name":"last_active","type":"text","ref":null,"enforced":false}]'::jsonb, 64),
  ('documents', 'projects', 'workspace', 'Documents', 'A file, photo or link on the documents page. kind: file, photo or link; color holds the file colour or the photo''s gradient.', '[{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"ext","type":"text","ref":null,"enforced":false},{"name":"size_label","type":"text","ref":null,"enforced":false},{"name":"date_label","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"project_name","type":"text","ref":null,"enforced":false},{"name":"url","type":"text","ref":null,"enforced":false},{"name":"summary","type":"text","ref":null,"enforced":false}]'::jsonb, 65),
  ('governance_groups', 'projects', 'workspace', 'Governance groups', 'A recurring meeting or board with its next event.', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"purpose","type":"text","ref":null,"enforced":false},{"name":"time_label","type":"text","ref":null,"enforced":false},{"name":"recurrence","type":"text","ref":null,"enforced":false},{"name":"project_name","type":"text","ref":null,"enforced":false},{"name":"next_event","type":"text","ref":null,"enforced":false},{"name":"details","type":"text","ref":null,"enforced":false},{"name":"more_people","type":"int","ref":null,"enforced":false},{"name":"likes","type":"int","ref":null,"enforced":false}]'::jsonb, 66),
  ('governance_items', 'projects', 'workspace', 'Governance connected items', 'A task (t1, t2) or RAID item (t3) connected to a governance group.', '[{"name":"group_id","type":"text","ref":"governance_groups","enforced":true},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"label","type":"text","ref":null,"enforced":false}]'::jsonb, 67),
  ('governance_members', 'projects', 'workspace', 'Governance members', 'A person in a governance group.', '[{"name":"group_id","type":"text","ref":"governance_groups","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 68),
  ('invoices', 'projects', 'workspace', 'Invoices', 'A billing invoice.', '[{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"date_label","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false}]'::jsonb, 69),
  ('people', 'projects', 'workspace', 'People', 'A person in the workspace, id = initials. team_order: place in the resource pool (null = not in it); directory_order: place in the name directory used by strategy pages; project_order: place in the project people list. sort keeps the avatar colour order.', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"role","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"team_order","type":"int","ref":null,"enforced":false},{"name":"directory_order","type":"int","ref":null,"enforced":false},{"name":"project_order","type":"int","ref":null,"enforced":false}]'::jsonb, 70),
  ('project_benefits', 'projects', 'workspace', 'Project benefits', 'A benefit a project should deliver, with its measure and progress (%).', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"type","type":"text","ref":null,"enforced":false},{"name":"measure","type":"text","ref":null,"enforced":false},{"name":"baseline","type":"text","ref":null,"enforced":false},{"name":"target","type":"text","ref":null,"enforced":false},{"name":"current","type":"text","ref":null,"enforced":false},{"name":"progress","type":"num","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false}]'::jsonb, 71),
  ('project_budget_lines', 'projects', 'workspace', 'Project budget lines', 'A cost line in a project budget (pounds).', '[{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"cost_type","type":"text","ref":null,"enforced":false},{"name":"detail","type":"text","ref":null,"enforced":false},{"name":"project_name","type":"text","ref":null,"enforced":false},{"name":"classification","type":"text","ref":null,"enforced":false},{"name":"spread","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"budget","type":"num","ref":null,"enforced":false},{"name":"forecast","type":"num","ref":null,"enforced":false},{"name":"spent","type":"num","ref":null,"enforced":false}]'::jsonb, 72),
  ('project_closures', 'projects', 'workspace', 'Project closure', 'Closure progress of a project: steps done, stage (Delivering, Closing, Closed) and sign-off.', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"steps_done","type":"int","ref":null,"enforced":false},{"name":"stage","type":"text","ref":null,"enforced":false},{"name":"signed_off","type":"text","ref":null,"enforced":false}]'::jsonb, 73),
  ('project_members', 'projects', 'workspace', 'Project team', 'A person shown on a project''s dashboard card.', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 74),
  ('project_scopes', 'projects', 'workspace', 'Project scope', 'The scope statement of a project (one per project).', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"objective","type":"text","ref":null,"enforced":false}]'::jsonb, 75),
  ('project_task_assignees', 'projects', 'workspace', 'Plan task assignees', 'A person assigned to a plan task; the first is the main assignee.', '[{"name":"task_id","type":"text","ref":"project_tasks","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 76),
  ('project_tasks', 'projects', 'workspace', 'Project plan tasks', 'A task in the plan of a project that is not linked to an initiative (linked plans live in the initiative''s tasks). start_day and length_days count from 1 Jan 2024.', '[{"name":"project_id","type":"text","ref":"projects","enforced":true},{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"phase","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"priority","type":"text","ref":null,"enforced":false},{"name":"timeline","type":"text","ref":null,"enforced":false},{"name":"start_day","type":"int","ref":null,"enforced":false},{"name":"length_days","type":"int","ref":null,"enforced":false},{"name":"subtask_count","type":"int","ref":null,"enforced":false},{"name":"start_date","type":"date","ref":null,"enforced":false},{"name":"due_date","type":"date","ref":null,"enforced":false}]'::jsonb, 77),
  ('projects', 'projects', 'workspace', 'Projects', 'A project. name is the short name used in menus and plans; title, owner, dates, progress and budget feed the dashboard card (card = has a dashboard card).', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"title","type":"text","ref":null,"enforced":false},{"name":"label","type":"text","ref":null,"enforced":false},{"name":"owner_name","type":"text","ref":null,"enforced":false},{"name":"due_label","type":"text","ref":null,"enforced":false},{"name":"time_left","type":"text","ref":null,"enforced":false},{"name":"ring","type":"int","ref":null,"enforced":false},{"name":"ring_color","type":"text","ref":null,"enforced":false},{"name":"completion","type":"int","ref":null,"enforced":false},{"name":"tasks_done","type":"int","ref":null,"enforced":false},{"name":"tasks_total","type":"int","ref":null,"enforced":false},{"name":"more_people","type":"int","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"badge","type":"text","ref":null,"enforced":false},{"name":"budget_k","type":"num","ref":null,"enforced":false},{"name":"spent_k","type":"num","ref":null,"enforced":false},{"name":"segments","type":"jsonb","ref":null,"enforced":false},{"name":"card","type":"bool","ref":null,"enforced":false},{"name":"favourite","type":"bool","ref":null,"enforced":false}]'::jsonb, 78),
  ('raid_items', 'projects', 'workspace', 'RAID log', 'A risk, assumption, issue or dependency. initiative_id links it to the initiative it threatens.', '[{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"type","type":"text","ref":null,"enforced":false},{"name":"title","type":"text","ref":null,"enforced":false},{"name":"project_name","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"impact","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"review_by","type":"text","ref":null,"enforced":false},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false}]'::jsonb, 79),
  ('resource_absences', 'projects', 'workspace', 'Upcoming vacations', 'An upcoming absence of a person.', '[{"name":"person_id","type":"text","ref":"people","enforced":false},{"name":"starts_label","type":"text","ref":null,"enforced":false}]'::jsonb, 80),
  ('resource_workloads', 'projects', 'workspace', 'Resource workload', 'A person''s workload per month (1 = full time, null = no data), months as in the setting projects.resource_months.', '[{"name":"person_id","type":"text","ref":"people","enforced":false},{"name":"monthly","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 81),
  ('retro_items', 'projects', 'workspace', 'Retrospective notes and actions', 'col w = went well, i = to improve (with votes), a = action (with owner and done).', '[{"name":"retro_id","type":"text","ref":"retrospectives","enforced":true},{"name":"col","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false},{"name":"votes","type":"int","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"done","type":"bool","ref":null,"enforced":false}]'::jsonb, 82),
  ('retro_participants', 'projects', 'workspace', 'Retrospective participants', 'A person who took part.', '[{"name":"retro_id","type":"text","ref":"retrospectives","enforced":true},{"name":"person_id","type":"text","ref":"people","enforced":false}]'::jsonb, 83),
  ('retrospectives', 'projects', 'workspace', 'Retrospectives', 'A retrospective meeting.', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"date_label","type":"text","ref":null,"enforced":false}]'::jsonb, 84),
  ('scope_items', 'projects', 'workspace', 'Scope items', 'An in-scope (inn) or out-of-scope (out) item.', '[{"name":"scope_id","type":"text","ref":"project_scopes","enforced":true},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 85),
  ('spaces', 'projects', 'workspace', 'Spaces', 'A workspace the user owns (owned) or is a member of.', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"initials","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"owned","type":"bool","ref":null,"enforced":false},{"name":"people_count","type":"int","ref":null,"enforced":false}]'::jsonb, 86),
  ('value_distribution', 'projects', 'workspace', 'Economic value distributed', 'How the value the company earns is shared (£M).', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false}]'::jsonb, 87),
  ('ambition_goals', 'strategy', 'workspace', 'Ambition goals', 'A goal of the long-term ambition; the first is the north star', '[{"name":"objective_id","type":"text","ref":"objectives","enforced":false},{"name":"target","type":"num","ref":null,"enforced":false},{"name":"label","type":"text","ref":null,"enforced":false}]'::jsonb, 88),
  ('ambition_levers', 'strategy', 'workspace', 'Ambition levers', 'Value an initiative adds to the north star by the end of the horizon', '[{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false},{"name":"added_value","type":"num","ref":null,"enforced":false}]'::jsonb, 89),
  ('bmc_blocks', 'strategy', 'workspace', 'Business model blocks', 'A business model canvas block; id = block key', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"icon","type":"text","ref":null,"enforced":false}]'::jsonb, 90),
  ('bmc_items', 'strategy', 'workspace', 'Business model items', 'A sticky note in a business model canvas block', '[{"name":"block_id","type":"text","ref":"bmc_blocks","enforced":true},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 91),
  ('board_packs', 'strategy', 'workspace', 'Board packs', 'A frozen, read-only snapshot of a quarterly strategy review', '[{"name":"quarter","type":"text","ref":null,"enforced":false},{"name":"version","type":"int","ref":null,"enforced":false},{"name":"frozen_on","type":"date","ref":null,"enforced":false},{"name":"frozen_by","type":"text","ref":"people","enforced":false},{"name":"pack_date","type":"text","ref":null,"enforced":false},{"name":"note","type":"text","ref":null,"enforced":false},{"name":"headlines","type":"jsonb","ref":null,"enforced":false},{"name":"focus","type":"jsonb","ref":null,"enforced":false},{"name":"tiles","type":"jsonb","ref":null,"enforced":false},{"name":"objectives","type":"jsonb","ref":null,"enforced":false},{"name":"measures","type":"jsonb","ref":null,"enforced":false},{"name":"decisions","type":"jsonb","ref":null,"enforced":false},{"name":"risks","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 92),
  ('canvas_curves', 'strategy', 'workspace', 'Canvas curves', 'A value curve (competitor or our offer) on the strategy canvas', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false}]'::jsonb, 93),
  ('canvas_errc_items', 'strategy', 'workspace', 'ERRC items', 'An eliminate, reduce, raise or create action', '[{"name":"action","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 94),
  ('canvas_factors', 'strategy', 'workspace', 'Canvas factors', 'A competing factor on the strategy canvas', '[{"name":"name","type":"text","ref":null,"enforced":false}]'::jsonb, 95),
  ('canvas_scores', 'strategy', 'workspace', 'Canvas scores', 'Offering level (0-10) of a curve on a factor', '[{"name":"curve_id","type":"text","ref":"canvas_curves","enforced":true},{"name":"factor_id","type":"text","ref":"canvas_factors","enforced":true},{"name":"score","type":"num","ref":null,"enforced":false}]'::jsonb, 96),
  ('company_values', 'strategy', 'workspace', 'Company values', 'A company value; id = name', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"description","type":"text","ref":null,"enforced":false},{"name":"champion","type":"text","ref":"people","enforced":false},{"name":"color","type":"text","ref":null,"enforced":false}]'::jsonb, 97),
  ('governance_cadence', 'strategy', 'workspace', 'Governance cadence', 'When reviews, board meetings and check-in deadlines fall (one row)', '[{"name":"review_workday","type":"int","ref":null,"enforced":false},{"name":"board_month","type":"int","ref":null,"enforced":false},{"name":"board_week","type":"int","ref":null,"enforced":false},{"name":"board_weekday","type":"int","ref":null,"enforced":false},{"name":"board_time","type":"text","ref":null,"enforced":false},{"name":"monthly_workday","type":"int","ref":null,"enforced":false},{"name":"quarterly_workday","type":"int","ref":null,"enforced":false},{"name":"okr_weekday","type":"int","ref":null,"enforced":false}]'::jsonb, 98),
  ('key_results', 'strategy', 'workspace', 'Key results', 'A key result with its latest check-in', '[{"name":"okr_objective_id","type":"text","ref":"okr_objectives","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"current","type":"num","ref":null,"enforced":false},{"name":"target","type":"num","ref":null,"enforced":false},{"name":"confidence","type":"text","ref":null,"enforced":false},{"name":"checked_on","type":"date","ref":null,"enforced":false},{"name":"note","type":"text","ref":null,"enforced":false}]'::jsonb, 99),
  ('kudos', 'strategy', 'workspace', 'Recognition', 'A recognition of someone living a value', '[{"name":"from_person","type":"text","ref":"people","enforced":false},{"name":"to_person","type":"text","ref":"people","enforced":false},{"name":"value_name","type":"text","ref":"company_values","enforced":false},{"name":"message","type":"text","ref":null,"enforced":false},{"name":"when_label","type":"text","ref":null,"enforced":false},{"name":"likes","type":"int","ref":null,"enforced":false}]'::jsonb, 100),
  ('measure_checkins', 'strategy', 'workspace', 'Measure check-ins', 'A recorded value of a measure for a period, or a target change', '[{"name":"measure_id","type":"text","ref":"measures","enforced":true},{"name":"period","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"by_person","type":"text","ref":"people","enforced":false},{"name":"checked_on","type":"date","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false},{"name":"owner_override","type":"bool","ref":null,"enforced":false},{"name":"targets_changed","type":"int","ref":null,"enforced":false}]'::jsonb, 101),
  ('measure_targets', 'strategy', 'workspace', 'Measure targets', 'Year-end target of a measure', '[{"name":"measure_id","type":"text","ref":"measures","enforced":true},{"name":"year","type":"int","ref":null,"enforced":false},{"name":"target","type":"num","ref":null,"enforced":false}]'::jsonb, 102),
  ('measures', 'strategy', 'workspace', 'Measures', 'A company measure (KPI); headline measures read actual, trend and status from their objective', '[{"name":"objective_id","type":"text","ref":"objectives","enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"unit","type":"text","ref":null,"enforced":false},{"name":"direction","type":"int","ref":null,"enforced":false},{"name":"baseline","type":"num","ref":null,"enforced":false},{"name":"actual","type":"num","ref":null,"enforced":false},{"name":"trend","type":"jsonb","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"override","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"source","type":"text","ref":null,"enforced":false},{"name":"frequency","type":"text","ref":null,"enforced":false},{"name":"is_primary","type":"bool","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false}]'::jsonb, 103),
  ('objective_links', 'strategy', 'workspace', 'Cause and effect', 'A strategy-map arrow: the first objective drives the second', '[{"name":"from_objective_id","type":"text","ref":"objectives","enforced":true},{"name":"to_objective_id","type":"text","ref":"objectives","enforced":true}]'::jsonb, 104),
  ('objective_unit_health', 'strategy', 'workspace', 'Objective health by unit', 'Health score (0-100) of an objective in a unit, for the heat map', '[{"name":"objective_id","type":"text","ref":"objectives","enforced":true},{"name":"unit_id","type":"text","ref":"units","enforced":true},{"name":"health","type":"int","ref":null,"enforced":false}]'::jsonb, 105),
  ('objectives', 'strategy', 'workspace', 'Objectives', 'A company objective with its headline measure values, trend of the last quarters and owner comment', '[{"name":"perspective_id","type":"text","ref":"perspectives","enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"measure_name","type":"text","ref":null,"enforced":false},{"name":"baseline","type":"num","ref":null,"enforced":false},{"name":"actual","type":"num","ref":null,"enforced":false},{"name":"target","type":"num","ref":null,"enforced":false},{"name":"unit","type":"text","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"override","type":"text","ref":null,"enforced":false},{"name":"trend","type":"jsonb","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false}]'::jsonb, 106),
  ('ogsm_goals', 'strategy', 'workspace', 'OGSM goals', 'An objective used as an OGSM goal', '[{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 107),
  ('ogsm_strategies', 'strategy', 'workspace', 'OGSM strategies', 'An OGSM strategy', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"status","type":"text","ref":null,"enforced":false}]'::jsonb, 108),
  ('ogsm_strategy_initiatives', 'strategy', 'workspace', 'OGSM initiatives', 'An initiative delivering an OGSM strategy', '[{"name":"strategy_id","type":"text","ref":"ogsm_strategies","enforced":true},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false}]'::jsonb, 109),
  ('ogsm_strategy_measures', 'strategy', 'workspace', 'OGSM measures', 'A measure of an OGSM strategy', '[{"name":"strategy_id","type":"text","ref":"ogsm_strategies","enforced":true},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 110),
  ('okr_objectives', 'strategy', 'workspace', 'OKR objectives', 'A company OKR (no parent, linked to an objective) or a team OKR under it', '[{"name":"parent_id","type":"text","ref":"okr_objectives","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false},{"name":"team","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"title","type":"text","ref":null,"enforced":false}]'::jsonb, 111),
  ('period_locks', 'strategy', 'workspace', 'Period locks', 'A month closed to new check-ins; id = period', '[{"name":"period","type":"text","ref":null,"enforced":false},{"name":"locked_by","type":"text","ref":"people","enforced":false},{"name":"locked_on","type":"date","ref":null,"enforced":false}]'::jsonb, 112),
  ('periods', 'strategy', 'workspace', 'Planning periods', 'One quarter of the planning horizon, in order', '[{"name":"label","type":"text","ref":null,"enforced":false},{"name":"year","type":"int","ref":null,"enforced":false},{"name":"quarter","type":"int","ref":null,"enforced":false}]'::jsonb, 113),
  ('perspectives', 'strategy', 'workspace', 'Perspectives', 'A balanced-scorecard perspective (strategic pillar); id = its letter code', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"theme","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false}]'::jsonb, 114),
  ('pestle_factors', 'strategy', 'workspace', 'PESTLE factors', 'An outside force with its impact and likelihood', '[{"name":"factor","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false},{"name":"impact","type":"int","ref":null,"enforced":false},{"name":"likelihood","type":"text","ref":null,"enforced":false}]'::jsonb, 115),
  ('pulse_scores', 'strategy', 'workspace', 'Pulse scores', 'Share of people in a unit who agree a value is lived', '[{"name":"survey_id","type":"text","ref":"pulse_surveys","enforced":true},{"name":"value_name","type":"text","ref":"company_values","enforced":false},{"name":"unit_id","type":"text","ref":"units","enforced":false},{"name":"score","type":"num","ref":null,"enforced":false}]'::jsonb, 116),
  ('pulse_statements', 'strategy', 'workspace', 'Pulse statements', 'The survey statement for a value; id = value name', '[{"name":"value_name","type":"text","ref":"company_values","enforced":false},{"name":"statement","type":"text","ref":null,"enforced":false}]'::jsonb, 117),
  ('pulse_surveys', 'strategy', 'workspace', 'Pulse surveys', 'A values pulse survey; id = quarter', '[{"name":"quarter","type":"text","ref":null,"enforced":false},{"name":"response_rate","type":"num","ref":null,"enforced":false}]'::jsonb, 118),
  ('review_focus', 'strategy', 'workspace', 'Review focus', 'A focus item for next quarter in the live review', '[{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 119),
  ('review_headlines', 'strategy', 'workspace', 'Review headlines', 'A headline of the live quarterly review', '[{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 120),
  ('review_proposals', 'strategy', 'workspace', 'Review proposals', 'A proposal prepared for the steering group in the live review', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"recommendation","type":"text","ref":null,"enforced":false}]'::jsonb, 121),
  ('risk_appetite', 'strategy', 'workspace', 'Risk appetite', 'Appetite level for a risk category; id = category', '[{"name":"level","type":"text","ref":null,"enforced":false}]'::jsonb, 122),
  ('risk_appetite_levels', 'strategy', 'workspace', 'Risk appetite levels', 'Highest residual score an appetite level allows; id = level', '[{"name":"max_residual","type":"int","ref":null,"enforced":false}]'::jsonb, 123),
  ('risk_mitigations', 'strategy', 'workspace', 'Risk mitigations', 'A mitigation action for a strategic risk', '[{"name":"risk_id","type":"text","ref":"strategic_risks","enforced":true},{"name":"title","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"due","type":"date","ref":null,"enforced":false},{"name":"done","type":"bool","ref":null,"enforced":false}]'::jsonb, 124),
  ('risk_objectives', 'strategy', 'workspace', 'Risk objectives', 'An objective at stake for a strategic risk', '[{"name":"risk_id","type":"text","ref":"strategic_risks","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 125),
  ('risk_reviews', 'strategy', 'workspace', 'Risk reviews', 'A recorded review of a strategic risk', '[{"name":"risk_id","type":"text","ref":"strategic_risks","enforced":true},{"name":"reviewed_on","type":"date","ref":null,"enforced":false},{"name":"by_person","type":"text","ref":"people","enforced":false},{"name":"residual_likelihood","type":"int","ref":null,"enforced":false},{"name":"residual_impact","type":"int","ref":null,"enforced":false},{"name":"trend","type":"text","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false}]'::jsonb, 126),
  ('settings', 'strategy', 'workspace', 'Settings', 'One workspace setting; id = key, prefixed by the owning domain (strategy.*, projects.*, ...)', '[{"name":"key","type":"text","ref":null,"enforced":false},{"name":"value","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 127),
  ('stakeholder_measures', 'strategy', 'workspace', 'Stakeholder measures', 'A measure of value for a stakeholder group', '[{"name":"stakeholder_id","type":"text","ref":"stakeholders","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"value","type":"text","ref":null,"enforced":false},{"name":"change","type":"text","ref":null,"enforced":false},{"name":"improving","type":"int","ref":null,"enforced":false}]'::jsonb, 128),
  ('stakeholders', 'strategy', 'workspace', 'Stakeholders', 'A stakeholder group and the value created for it; id = name', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"icon","type":"text","ref":null,"enforced":false},{"name":"color","type":"text","ref":null,"enforced":false},{"name":"headline","type":"text","ref":null,"enforced":false},{"name":"story","type":"text","ref":null,"enforced":false}]'::jsonb, 129),
  ('strategic_risks', 'strategy', 'workspace', 'Strategic risks', 'A risk to the objectives, scored 1-5 before and after mitigation', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"category","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"inherent_likelihood","type":"int","ref":null,"enforced":false},{"name":"inherent_impact","type":"int","ref":null,"enforced":false},{"name":"residual_likelihood","type":"int","ref":null,"enforced":false},{"name":"residual_impact","type":"int","ref":null,"enforced":false},{"name":"trend","type":"text","ref":null,"enforced":false},{"name":"last_review","type":"date","ref":null,"enforced":false}]'::jsonb, 130),
  ('swot_items', 'strategy', 'workspace', 'SWOT items', 'A strength (S), weakness (W), opportunity (O) or threat (T)', '[{"name":"quadrant","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 131),
  ('team_objectives', 'strategy', 'workspace', 'Team objectives', 'An objective a team owns work for', '[{"name":"team_id","type":"text","ref":"teams","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 132),
  ('teams', 'strategy', 'workspace', 'Teams', 'A team inside a business unit', '[{"name":"unit_id","type":"text","ref":"units","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false}]'::jsonb, 133),
  ('tows_strategies', 'strategy', 'workspace', 'TOWS strategies', 'A TOWS strategy; id = SO, WO, ST or WT', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 134),
  ('unit_measure_checkins', 'strategy', 'workspace', 'Unit measure check-ins', 'A recorded value of a unit measure, or a target change', '[{"name":"unit_measure_id","type":"text","ref":"unit_measures","enforced":true},{"name":"period","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"by_person","type":"text","ref":"people","enforced":false},{"name":"checked_on","type":"date","ref":null,"enforced":false},{"name":"comment","type":"text","ref":null,"enforced":false},{"name":"owner_override","type":"bool","ref":null,"enforced":false},{"name":"targets_changed","type":"int","ref":null,"enforced":false}]'::jsonb, 135),
  ('unit_measure_targets', 'strategy', 'workspace', 'Unit measure targets', 'Year-end target of a unit measure', '[{"name":"unit_measure_id","type":"text","ref":"unit_measures","enforced":true},{"name":"year","type":"int","ref":null,"enforced":false},{"name":"target","type":"num","ref":null,"enforced":false}]'::jsonb, 136),
  ('unit_measures', 'strategy', 'workspace', 'Unit measures', 'A measure on a unit scorecard', '[{"name":"unit_objective_id","type":"text","ref":"unit_objectives","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"unit","type":"text","ref":null,"enforced":false},{"name":"direction","type":"int","ref":null,"enforced":false},{"name":"baseline","type":"num","ref":null,"enforced":false},{"name":"actual","type":"num","ref":null,"enforced":false},{"name":"frequency","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"last_period","type":"text","ref":null,"enforced":false},{"name":"trend","type":"jsonb","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"override","type":"text","ref":null,"enforced":false}]'::jsonb, 137),
  ('unit_objectives', 'strategy', 'workspace', 'Unit objectives', 'A business unit objective supporting a company objective with a weight', '[{"name":"unit_id","type":"text","ref":"units","enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"objective_id","type":"text","ref":"objectives","enforced":false},{"name":"weight","type":"num","ref":null,"enforced":false}]'::jsonb, 138),
  ('units', 'strategy', 'workspace', 'Business units', 'A business unit (id = name) with its leader', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"lead","type":"text","ref":"people","enforced":false},{"name":"role","type":"text","ref":null,"enforced":false}]'::jsonb, 139),
  ('v2mom_method_measures', 'strategy', 'workspace', 'V2MOM measures', 'An objective measuring a V2MOM method', '[{"name":"method_id","type":"text","ref":"v2mom_methods","enforced":true},{"name":"objective_id","type":"text","ref":"objectives","enforced":false}]'::jsonb, 140),
  ('v2mom_methods', 'strategy', 'workspace', 'V2MOM methods', 'A V2MOM method, in priority order', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false},{"name":"initiative_id","type":"text","ref":"initiatives","enforced":false}]'::jsonb, 141),
  ('v2mom_obstacles', 'strategy', 'workspace', 'V2MOM obstacles', 'An obstacle, and the method it blocks', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"method_id","type":"text","ref":"v2mom_methods","enforced":false},{"name":"done","type":"bool","ref":null,"enforced":false}]'::jsonb, 142),
  ('value_behaviours', 'strategy', 'workspace', 'Value behaviours', 'A behaviour we do (do) or don''t (dont) for a value', '[{"name":"value_id","type":"text","ref":"company_values","enforced":true},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 143),
  ('value_bridge_steps', 'strategy', 'workspace', 'Value bridge steps', 'A step that adds or removes value in a bridge', '[{"name":"bridge_id","type":"text","ref":"value_bridges","enforced":true},{"name":"label","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false}]'::jsonb, 144),
  ('value_bridges', 'strategy', 'workspace', 'Value bridges', 'A value bridge (waterfall) between two totals', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"from_label","type":"text","ref":null,"enforced":false},{"name":"from_value","type":"num","ref":null,"enforced":false},{"name":"to_label","type":"text","ref":null,"enforced":false},{"name":"to_value","type":"num","ref":null,"enforced":false}]'::jsonb, 145),
  ('value_model_items', 'strategy', 'workspace', 'Value creation model', 'An input capital, business activity or output of the value creation model', '[{"name":"section","type":"text","ref":null,"enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 146),
  ('vdt_nodes', 'strategy', 'workspace', 'Value driver tree', 'A node of the value driver tree; the root has no parent', '[{"name":"parent_id","type":"text","ref":"vdt_nodes","enforced":true},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"value","type":"num","ref":null,"enforced":false},{"name":"target","type":"num","ref":null,"enforced":false},{"name":"unit","type":"text","ref":null,"enforced":false},{"name":"operator","type":"text","ref":null,"enforced":false},{"name":"lower_is_better","type":"int","ref":null,"enforced":false}]'::jsonb, 147),
  ('vdt_notes', 'strategy', 'workspace', 'Value driver notes', 'An insight card under the value driver tree', '[{"name":"title","type":"text","ref":null,"enforced":false},{"name":"text","type":"text","ref":null,"enforced":false}]'::jsonb, 148),
  ('vdt_owners', 'strategy', 'workspace', 'Value driver owners', 'An owner of the value driver tree', '[{"name":"person","type":"text","ref":"people","enforced":false}]'::jsonb, 149),
  ('xmatrix_bowling', 'strategy', 'workspace', 'Bowling chart', 'Monthly targets and actuals of an X-matrix measure', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"targets","type":"jsonb","ref":null,"enforced":false},{"name":"actuals","type":"jsonb","ref":null,"enforced":false}]'::jsonb, 150),
  ('xmatrix_items', 'strategy', 'workspace', 'X-matrix items', 'A row of the Hoshin X-matrix: S breakthrough, W annual objective, N priority, E measure, R owner', '[{"name":"quadrant","type":"text","ref":null,"enforced":false},{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner","type":"text","ref":"people","enforced":false}]'::jsonb, 151),
  ('xmatrix_links', 'strategy', 'workspace', 'X-matrix correlations', 'A correlation between two X-matrix items (1 weak, 2 strong)', '[{"name":"from_item_id","type":"text","ref":"xmatrix_items","enforced":true},{"name":"to_item_id","type":"text","ref":"xmatrix_items","enforced":true},{"name":"strength","type":"int","ref":null,"enforced":false}]'::jsonb, 152),
  ('activity_feed', 'work', 'workspace', 'Activity feed', 'One entry of the workspace activity feed: who did what, on which object (ref), newest first.', '[{"name":"actor_id","type":"text","ref":"people","enforced":false},{"name":"action","type":"text","ref":null,"enforced":false},{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"title","type":"text","ref":null,"enforced":false},{"name":"created_on","type":"date","ref":null,"enforced":false}]'::jsonb, 153),
  ('automation_rules', 'work', 'workspace', 'Automation rules', 'A workspace automation rule and whether it is on. The behaviour of each rule id is built into the app.', '[{"name":"trigger_text","type":"text","ref":null,"enforced":false},{"name":"action_text","type":"text","ref":null,"enforced":false},{"name":"enabled","type":"bool","ref":null,"enforced":false}]'::jsonb, 154),
  ('custom_field_options', 'work', 'workspace', 'Custom field options', 'One option of a single-select custom field, in order.', '[{"name":"field_id","type":"text","ref":"custom_fields","enforced":true},{"name":"label","type":"text","ref":null,"enforced":false}]'::jsonb, 155),
  ('custom_fields', 'work', 'workspace', 'Custom fields', 'A custom field every task in the workspace can have (text, number, single select, date or person), in display order.', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"field_type","type":"text","ref":null,"enforced":false}]'::jsonb, 156),
  ('notifications', 'work', 'workspace', 'Notifications', 'One item in a person''s inbox: a mention, an assignment, a request or a rule message. ref points at what it is about (task:I7-1, init:I2, go:wk-time).', '[{"name":"recipient_id","type":"text","ref":"people","enforced":false},{"name":"kind","type":"text","ref":null,"enforced":false},{"name":"message","type":"text","ref":null,"enforced":false},{"name":"ref","type":"text","ref":null,"enforced":false},{"name":"created_on","type":"date","ref":null,"enforced":false},{"name":"read","type":"bool","ref":null,"enforced":false}]'::jsonb, 157),
  ('rule_runs', 'work', 'workspace', 'Rule runs', 'One run of an automation rule, newest first, with what it did.', '[{"name":"rule_id","type":"text","ref":"automation_rules","enforced":true},{"name":"ran_on","type":"date","ref":null,"enforced":false},{"name":"message","type":"text","ref":null,"enforced":false}]'::jsonb, 158),
  ('saved_views', 'work', 'workspace', 'Saved task views', 'A saved view of the Tasks page: view type, preset, programme, grouping, search and filters; personal or shared with the workspace.', '[{"name":"name","type":"text","ref":null,"enforced":false},{"name":"owner_id","type":"text","ref":"people","enforced":false},{"name":"shared","type":"bool","ref":null,"enforced":false},{"name":"view_type","type":"text","ref":null,"enforced":false},{"name":"preset","type":"text","ref":null,"enforced":false},{"name":"programme","type":"text","ref":null,"enforced":false},{"name":"group_by","type":"text","ref":null,"enforced":false},{"name":"search","type":"text","ref":null,"enforced":false},{"name":"filters","type":"jsonb","ref":null,"enforced":false},{"name":"created_on","type":"date","ref":null,"enforced":false}]'::jsonb, 159),
  ('timesheet_approvals', 'work', 'workspace', 'Timesheet approval trail', 'One step in a timesheet week''s history: submitted, recalled, approved or returned (with the note).', '[{"name":"week_id","type":"text","ref":"timesheet_weeks","enforced":true},{"name":"actor_id","type":"text","ref":"people","enforced":false},{"name":"acted_on","type":"date","ref":null,"enforced":false},{"name":"action","type":"text","ref":null,"enforced":false}]'::jsonb, 160),
  ('timesheet_entries', 'work', 'workspace', 'Timesheet entries', 'One task row of a timesheet week with the hours logged Monday to Friday. listed: the task is a row of the week; hours null: no hours yet.', '[{"name":"week_id","type":"text","ref":"timesheet_weeks","enforced":true},{"name":"task_id","type":"text","ref":"tasks","enforced":false},{"name":"listed","type":"bool","ref":null,"enforced":false},{"name":"hours_pos","type":"int","ref":null,"enforced":false},{"name":"mon","type":"num","ref":null,"enforced":false},{"name":"tue","type":"num","ref":null,"enforced":false},{"name":"wed","type":"num","ref":null,"enforced":false},{"name":"thu","type":"num","ref":null,"enforced":false},{"name":"fri","type":"num","ref":null,"enforced":false}]'::jsonb, 161),
  ('timesheet_weeks', 'work', 'workspace', 'Timesheet weeks', 'One person''s timesheet for one week (Monday): draft, submitted, approved or returned. id is person|week.', '[{"name":"person_id","type":"text","ref":"people","enforced":false},{"name":"week_start","type":"date","ref":null,"enforced":false},{"name":"status","type":"text","ref":null,"enforced":false},{"name":"decided_by","type":"text","ref":"people","enforced":false},{"name":"note","type":"text","ref":null,"enforced":false},{"name":"submitted_on","type":"date","ref":null,"enforced":false},{"name":"decided_on","type":"date","ref":null,"enforced":false}]'::jsonb, 162);
