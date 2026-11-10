# Database design

Every record in OrgCue lives in the database. The page holds no sample data: at start it loads the workspace's rows, rebuilds the app's data from them, and from then on sends only the rows that change. The sample company, MosaicX, is demo data stored in the database like any customer's data.

There are 163 tables, all generated from one set of declarations in the app:
- 151 tables hold workspace data;
- 12 hold OrgCue's own product content (the roadmap, feature coverage, vendors and the advisory panel review).

The schema has 80 enforced parent-child keys and 190 indexed references. The demo company has 2,482 rows.

## Workspaces

Each data row has a `workspace_id`. A workspace has a kind:

| Kind | What it is | Who reaches it |
| --- | --- | --- |
| `demo` | The demo company, MosaicX. It is the source for new demo sessions and team workspaces. | Read-only, for everyone |
| `sandbox` | A visitor's private copy of the demo. It lasts 14 days after the last visit, and Help › Reset demo data restores it. | Only the browser holding its secret token; only a hash of the token is stored |
| `team` | A shared workspace with members and roles (admin, editor, contributor, viewer). It is created by a signed-in user as a copy of their demo session or of another workspace. | Members, through `workspace_members` |
| `product` | OrgCue's product content. | Read-only, for everyone |

Opening the site without an account starts a demo session. Signing in and creating a shared workspace copies the current data into a team workspace. Switching back returns to the demo session.

## How the app talks to the database

Clients never read or write data tables directly. Row level security is on and table privileges are revoked. All access goes through functions that check access first:

| Function | Does |
| --- | --- |
| `orgcue_new_sandbox()` | Creates a demo session from the demo company and returns its id and token. Expired sessions are removed, and new sessions are capped per hour. |
| `orgcue_load(ws, token)` | Returns every row of the workspace, plus the product content, the version and your role. |
| `orgcue_apply(ws, token, changes, version)` | Applies row upserts and deletes in one transaction. If someone else saved first, it refuses with a conflict, so the app reloads and tells you. Viewers cannot save. |
| `orgcue_version(ws, token)` | Returns the current version, so the app can check for other people's changes on focus and every 20 seconds. |
| `orgcue_reset_sandbox(ws, token)` | Restores a demo session to the demo company. |
| `orgcue_create_workspace(name, from, token)` | Creates a team workspace for the signed-in user, copying a workspace they can read. |
| `orgcue_integrity(ws, token)` | Reports soft references that point at a missing row. |

`orgcue_tables` is the data dictionary: every data table with its domain, scope, description and columns. The functions use it to decide which tables exist.

## Table conventions

- **Common columns.** Every data table has `workspace_id`, `id` (text, unique in the workspace), `sort` (list order), typed columns, `extra` (jsonb, for rare leftover properties) and `updated_at`. The primary key is (`workspace_id`, `id`).
- **Enforced keys.** When a child cannot exist without its parent (a key result and its OKR, a subtask and its task, a benefit value and its benefit), the foreign key is enforced, cascades on delete, and is checked when the transaction commits.
- **Soft references.** Other references, such as owners pointing to `people` or links between independent records, are indexed and checked by `orgcue_integrity`, but not enforced.
- **Text from other people.** Text loaded from the database cannot inject markup: the app turns angle brackets into look-alike characters before showing anything.

## Where the design comes from

The declarations are in the page: `dbTable(…)` gives a table with typed columns and references, and `dbCollection(…)` turns the app's data into rows and back.

`scripts/db/gen.js` turns the declarations into SQL:

```bash
node scripts/db/gen.js public/project-portfolio.html /tmp/out   # writes 02_data_tables.sql, tables.json and erd.md
```

The migrations in `supabase/migrations/`:

| File | Contents |
| --- | --- |
| `20261109223850_workspaces.sql` | Workspaces, members, invites and roles |
| `20261110090000_data_core.sql` | Workspace kinds, the data dictionary and the access functions |
| `20261110090100_data_tables.sql` | The 163 generated data tables, keys and indexes |
| `20261110090200_demo_data.sql` | The demo company and the product content |

The relationship diagrams for each domain are in `docs/database-erd.md`.

## Tables

The "Demo rows" column counts the rows the demo company has.

### Strategy (65 tables)

| Table | What a row is | Columns | Demo rows |
| --- | --- | --- | --- |
| `ambition_goals` | A goal of the long-term ambition; the first is the north star | objective_id → objectives, target, label | 3 |
| `ambition_levers` | Value an initiative adds to the north star by the end of the horizon | initiative_id → initiatives, added_value | 5 |
| `bmc_blocks` | A business model canvas block; id = block key | title, icon | 9 |
| `bmc_items` | A sticky note in a business model canvas block | block_id → bmc_blocks (cascade), text | 34 |
| `board_packs` | A frozen, read-only snapshot of a quarterly strategy review | quarter, version, frozen_on, frozen_by → people, pack_date, note, headlines, focus, tiles, objectives, measures, decisions, risks | 1 |
| `canvas_curves` | A value curve (competitor or our offer) on the strategy canvas | name, color | 3 |
| `canvas_errc_items` | An eliminate, reduce, raise or create action | action, text | 8 |
| `canvas_factors` | A competing factor on the strategy canvas | name | 8 |
| `canvas_scores` | Offering level (0-10) of a curve on a factor | curve_id → canvas_curves (cascade), factor_id → canvas_factors (cascade), score | 24 |
| `company_values` | A company value; id = name | name, description, champion → people, color | 4 |
| `governance_cadence` | When reviews, board meetings and check-in deadlines fall (one row) | review_workday, board_month, board_week, board_weekday, board_time, monthly_workday, quarterly_workday, okr_weekday | 1 |
| `key_results` | A key result with its latest check-in | okr_objective_id → okr_objectives (cascade), name, current, target, confidence, checked_on, note | 21 |
| `kudos` | A recognition of someone living a value | from_person → people, to_person → people, value_name → company_values, message, when_label, likes | 8 |
| `measure_checkins` | A recorded value of a measure for a period, or a target change | measure_id → measures (cascade), period, value, status, by_person → people, checked_on, comment, owner_override, targets_changed | 18 |
| `measure_targets` | Year-end target of a measure | measure_id → measures (cascade), year, target | 54 |
| `measures` | A company measure (KPI); headline measures read actual, trend and status from their objective | objective_id → objectives, name, unit, direction, baseline, actual, trend, status, override, owner → people, source, frequency, is_primary, comment | 18 |
| `objective_links` | A strategy-map arrow: the first objective drives the second | from_objective_id → objectives (cascade), to_objective_id → objectives (cascade) | 14 |
| `objective_unit_health` | Health score (0-100) of an objective in a unit, for the heat map | objective_id → objectives (cascade), unit_id → units (cascade), health | 33 |
| `objectives` | A company objective with its headline measure values, trend of the last quarters and owner comment | perspective_id → perspectives, name, owner → people, measure_name, baseline, actual, target, unit, status, override, trend, comment | 12 |
| `ogsm_goals` | An objective used as an OGSM goal | objective_id → objectives | 3 |
| `ogsm_strategies` | An OGSM strategy | name, owner → people, status | 5 |
| `ogsm_strategy_initiatives` | An initiative delivering an OGSM strategy | strategy_id → ogsm_strategies (cascade), initiative_id → initiatives | 9 |
| `ogsm_strategy_measures` | A measure of an OGSM strategy | strategy_id → ogsm_strategies (cascade), text | 10 |
| `okr_objectives` | A company OKR (no parent, linked to an objective) or a team OKR under it | parent_id → okr_objectives (cascade), objective_id → objectives, team, owner → people, title | 10 |
| `period_locks` | A month closed to new check-ins; id = period | period, locked_by → people, locked_on | 2 |
| `periods` | One quarter of the planning horizon, in order | label, year, quarter | 12 |
| `perspectives` | A balanced-scorecard perspective (strategic pillar); id = its letter code | name, theme, color | 4 |
| `pestle_factors` | An outside force with its impact and likelihood | factor, text, impact, likelihood | 6 |
| `pulse_scores` | Share of people in a unit who agree a value is lived | survey_id → pulse_surveys (cascade), value_name → company_values, unit_id → units, score | 40 |
| `pulse_statements` | The survey statement for a value; id = value name | value_name → company_values, statement | 4 |
| `pulse_surveys` | A values pulse survey; id = quarter | quarter, response_rate | 2 |
| `review_focus` | A focus item for next quarter in the live review | text | 3 |
| `review_headlines` | A headline of the live quarterly review | text | 3 |
| `review_proposals` | A proposal prepared for the steering group in the live review | title, owner → people, recommendation | 3 |
| `risk_appetite` | Appetite level for a risk category; id = category | level | 5 |
| `risk_appetite_levels` | Highest residual score an appetite level allows; id = level | max_residual | 4 |
| `risk_mitigations` | A mitigation action for a strategic risk | risk_id → strategic_risks (cascade), title, owner → people, due, done | 13 |
| `risk_objectives` | An objective at stake for a strategic risk | risk_id → strategic_risks (cascade), objective_id → objectives | 15 |
| `risk_reviews` | A recorded review of a strategic risk | risk_id → strategic_risks (cascade), reviewed_on, by_person → people, residual_likelihood, residual_impact, trend, comment | 0 |
| `settings` | One workspace setting; id = key, prefixed by the owning domain (strategy.*, projects.*, ...) | key, value | 28 |
| `stakeholder_measures` | A measure of value for a stakeholder group | stakeholder_id → stakeholders (cascade), name, value, change, improving | 12 |
| `stakeholders` | A stakeholder group and the value created for it; id = name | name, icon, color, headline, story | 4 |
| `strategic_risks` | A risk to the objectives, scored 1-5 before and after mitigation | name, category, owner → people, inherent_likelihood, inherent_impact, residual_likelihood, residual_impact, trend, last_review | 9 |
| `swot_items` | A strength (S), weakness (W), opportunity (O) or threat (T) | quadrant, text | 16 |
| `team_objectives` | An objective a team owns work for | team_id → teams (cascade), objective_id → objectives | 17 |
| `teams` | A team inside a business unit | unit_id → units (cascade), name | 13 |
| `tows_strategies` | A TOWS strategy; id = SO, WO, ST or WT | title, text | 4 |
| `unit_measure_checkins` | A recorded value of a unit measure, or a target change | unit_measure_id → unit_measures (cascade), period, value, status, by_person → people, checked_on, comment, owner_override, targets_changed | 19 |
| `unit_measure_targets` | Year-end target of a unit measure | unit_measure_id → unit_measures (cascade), year, target | 57 |
| `unit_measures` | A measure on a unit scorecard | unit_objective_id → unit_objectives (cascade), name, unit, direction, baseline, actual, frequency, owner → people, last_period, trend, status, override | 19 |
| `unit_objectives` | A business unit objective supporting a company objective with a weight | unit_id → units, name, owner → people, objective_id → objectives, weight | 15 |
| `units` | A business unit (id = name) with its leader | name, lead → people, role | 5 |
| `v2mom_method_measures` | An objective measuring a V2MOM method | method_id → v2mom_methods (cascade), objective_id → objectives | 10 |
| `v2mom_methods` | A V2MOM method, in priority order | title, owner → people, initiative_id → initiatives | 5 |
| `v2mom_obstacles` | An obstacle, and the method it blocks | title, method_id → v2mom_methods, done | 5 |
| `value_behaviours` | A behaviour we do (do) or don't (dont) for a value | value_id → company_values (cascade), kind, text | 16 |
| `value_bridge_steps` | A step that adds or removes value in a bridge | bridge_id → value_bridges (cascade), label, value | 12 |
| `value_bridges` | A value bridge (waterfall) between two totals | title, from_label, from_value, to_label, to_value | 2 |
| `value_model_items` | An input capital, business activity or output of the value creation model | section, name, text | 13 |
| `vdt_nodes` | A node of the value driver tree; the root has no parent | parent_id → vdt_nodes (cascade), name, value, target, unit, operator, lower_is_better | 11 |
| `vdt_notes` | An insight card under the value driver tree | title, text | 2 |
| `vdt_owners` | An owner of the value driver tree | person → people | 3 |
| `xmatrix_bowling` | Monthly targets and actuals of an X-matrix measure | name, targets, actuals | 5 |
| `xmatrix_items` | A row of the Hoshin X-matrix: S breakthrough, W annual objective, N priority, E measure, R owner | quadrant, name, owner → people | 22 |
| `xmatrix_links` | A correlation between two X-matrix items (1 weak, 2 strong) | from_item_id → xmatrix_items (cascade), to_item_id → xmatrix_items (cascade), strength | 43 |

### Portfolio and programmes (35 tables)

| Table | What a row is | Columns | Demo rows |
| --- | --- | --- | --- |
| `actions` | A follow-up action, often from a decision | title, owner_id → people, due_date, status, source, created_on | 4 |
| `activity` | A change made to any record; ref names it, for example task:I7-1 | ref, actor_id → people, happened_on, what | 85 |
| `baselines` | An approved version of an initiative's dates and budget | initiative_id → initiatives (cascade), version, start_q, end_q, budget, set_on, reason, set_by → people, change_request_id → change_requests | 11 |
| `benefit_values` | Planned and realised value of a benefit in one quarter | benefit_id → benefits (cascade), quarter, planned, realised | 105 |
| `benefits` | A benefit profile of an initiative | initiative_id → initiatives (cascade), name, kind, owner_id → people, measure_id → measures, unit | 13 |
| `change_requests` | A request to change the end date, budget or scope of an initiative | initiative_id → initiatives (cascade), requested_by → people, requested_on, changes, new_end_q, new_budget, new_scope, reason, impact, approver_id → people, status, old_end_q, old_budget, old_scope, decided_by → people, decided_on, decision_comment | 3 |
| `comments` | A comment on any record; ref names it, for example task:I7-1 or su:SU2 | ref, author_id → people, posted_on, body | 5 |
| `decisions` | A decision from a steering group, review or stage gate | title, forum, about_ref, proposed_by → people, status, from_gate, decided_by → people, decided_on, rationale | 7 |
| `finance_months` | Budget, actual and forecast of an initiative for one month (0 = the first month of the horizon), £k | initiative_id → initiatives (cascade), month, budget, actual, forecast | 141 |
| `gate_approvers` | A person who must approve leaving a stage | stage_id → stages (cascade), person_id → people | 8 |
| `gate_checks` | A criterion ticked or explained for an initiative | gate_status_id → gate_status (cascade), criterion, met, explanation | 18 |
| `gate_criteria` | A criterion to meet before leaving a stage | stage_id → stages (cascade), text | 17 |
| `gate_log` | A move of an initiative through a stage gate | initiative_id → initiatives (cascade), to_stage → stages, decided_by → people, decided_on, comment, votes | 0 |
| `gate_status` | Where an initiative stands at the gate of its current stage | initiative_id → initiatives (cascade), stage → stages, last_rejected_on, last_rejected_by | 7 |
| `gate_votes` | An approver's decision at a gate | gate_status_id → gate_status (cascade), voter_id → people, decision, comment, voted_on | 2 |
| `initiative_dependencies` | An initiative that must finish first | initiative_id → initiatives (cascade), depends_on_id → initiatives | 4 |
| `initiative_finance` | Finance settings of an initiative; id is the initiative id | initiative_id → initiatives (cascade), capex_pct, months | 10 |
| `initiative_followers` | A person who follows an initiative | initiative_id → initiatives (cascade), person_id → people | 0 |
| `initiative_measures` | What an initiative is expected to add to a measure | initiative_id → initiatives (cascade), measure_id → measures, impact | 30 |
| `initiative_objectives` | An objective an initiative supports | initiative_id → initiatives (cascade), objective_id → objectives | 23 |
| `initiatives` | A strategic initiative: dates as quarter indexes into the planning horizon, money in £k | name, description, perspective_id → perspectives, programme_id → programmes, stage → stages, status, owner_id → people, start_q, end_q, baseline_start_q, baseline_end_q, budget, spent, forecast, value, effort, risk, project_id → projects | 10 |
| `milestones` | A milestone quarter of an initiative | initiative_id → initiatives (cascade), quarter | 16 |
| `programmes` | A group of initiatives with a lead and a colour | name, lead_id → people, color, description | 4 |
| `purchase_orders` | Money committed to a supplier against an initiative budget, £k | initiative_id → initiatives (cascade), ref, description, supplier, amount, raised_on | 11 |
| `request_objectives` | An objective a request supports | request_id → requests (cascade), objective_id → objectives | 8 |
| `requests` | A new idea or request waiting to enter the portfolio | name, sponsor_id → people, submitted_on, problem, value, effort, cost, risk, status, initiative_id → initiatives, decision_id → decisions | 5 |
| `stages` | A stage of the initiative life cycle and the gate to leave it | name, in_flow, gate_question, has_gate, gate_rule | 5 |
| `status_update_items` | A highlight, blocker or next step of a status update | status_update_id → status_updates (cascade), kind, text | 23 |
| `status_updates` | A status update on an initiative or a programme | target_id, status, author_id → people, posted_on, summary | 8 |
| `subtasks` | A checklist item of a task | task_id → tasks (cascade), name, done | 44 |
| `task_assignees` | A person who works on a task with its owner | task_id → tasks (cascade), person_id → people | 13 |
| `task_dependencies` | A task that must be done before this one | task_id → tasks (cascade), depends_on_id → tasks | 11 |
| `task_field_values` | The value of a custom field on a task | task_id → tasks (cascade), field_id, value | 170 |
| `task_followers` | A person who follows a task | task_id → tasks (cascade), person_id → people | 66 |
| `tasks` | A task of an initiative (linked project plans read these too) | initiative_id → initiatives (cascade), name, owner_id → people, status, withdrawn, priority, phase, start_date, due_date, due_quarter, estimate_hours, description, plan_ref | 85 |

### Work (10 tables)

| Table | What a row is | Columns | Demo rows |
| --- | --- | --- | --- |
| `activity_feed` | One entry of the workspace activity feed: who did what, on which object (ref), newest first. | actor_id → people, action, ref, title, created_on | 6 |
| `automation_rules` | A workspace automation rule and whether it is on. The behaviour of each rule id is built into the app. | trigger_text, action_text, enabled | 6 |
| `custom_field_options` | One option of a single-select custom field, in order. | field_id → custom_fields (cascade), label | 4 |
| `custom_fields` | A custom field every task in the workspace can have (text, number, single select, date or person), in display order. | name, field_type | 2 |
| `notifications` | One item in a person's inbox: a mention, an assignment, a request or a rule message. ref points at what it is about (task:I7-1, init:I2, go:wk-time). | recipient_id → people, kind, message, ref, created_on, read | 4 |
| `rule_runs` | One run of an automation rule, newest first, with what it did. | rule_id → automation_rules (cascade), ran_on, message | 3 |
| `saved_views` | A saved view of the Tasks page: view type, preset, programme, grouping, search and filters; personal or shared with the workspace. | name, owner_id → people, shared, view_type, preset, programme, group_by, search, filters, created_on | 2 |
| `timesheet_approvals` | One step in a timesheet week's history: submitted, recalled, approved or returned (with the note). | week_id → timesheet_weeks (cascade), actor_id → people, acted_on, action | 15 |
| `timesheet_entries` | One task row of a timesheet week with the hours logged Monday to Friday. listed: the task is a row of the week; hours null: no hours yet. | week_id → timesheet_weeks (cascade), task_id → tasks, listed, hours_pos, mon, tue, wed, thu, fri | 20 |
| `timesheet_weeks` | One person's timesheet for one week (Monday): draft, submitted, approved or returned. id is person/week. | person_id → people, week_start, status, decided_by → people, note, submitted_on, decided_on | 10 |

### Projects (29 tables)

| Table | What a row is | Columns | Demo rows |
| --- | --- | --- | --- |
| `checklist_checks` | A check ticked for a project. | project_id → projects (cascade), item_id → checklist_items (cascade) | 20 |
| `checklist_groups` | A group of pre-launch checks. | name | 3 |
| `checklist_items` | One check, id = its code (c1, c2...). | group_id → checklist_groups (cascade), text | 10 |
| `closure_steps` | The steps every project goes through to close, in order. | name | 6 |
| `dashboard_items` | A task or action on the dashboard. kind: tasks or actions; due_bucket: today, week or overdue. | kind, due_bucket, name, subtask_count, status, project_name, priority, due_label, assignee_id → people | 16 |
| `devices` | A device the user is signed in on. | name, location, last_active | 3 |
| `documents` | A file, photo or link on the documents page. kind: file, photo or link; color holds the file colour or the photo's gradient. | kind, name, ext, size_label, date_label, color, project_name, url, summary | 8 |
| `governance_groups` | A recurring meeting or board with its next event. | title, color, purpose, time_label, recurrence, project_name, next_event, details, more_people, likes | 4 |
| `governance_items` | A task (t1, t2) or RAID item (t3) connected to a governance group. | group_id → governance_groups (cascade), kind, label | 10 |
| `governance_members` | A person in a governance group. | group_id → governance_groups (cascade), person_id → people | 10 |
| `invoices` | A billing invoice. | ref, date_label, status | 2 |
| `people` | A person in the workspace, id = initials. team_order: place in the resource pool (null = not in it); directory_order: place in the name directory used by strategy pages; project_order: place in the project people list. sort keeps the avatar colour order. | name, role, color, team_order, directory_order, project_order | 19 |
| `project_benefits` | A benefit a project should deliver, with its measure and progress (%). | project_id → projects (cascade), name, type, measure, baseline, target, current, progress, status, owner_id → people | 6 |
| `project_budget_lines` | A cost line in a project budget (pounds). | ref, cost_type, detail, project_name, classification, spread, status, budget, forecast, spent | 7 |
| `project_closures` | Closure progress of a project: steps done, stage (Delivering, Closing, Closed) and sign-off. | project_id → projects (cascade), steps_done, stage, signed_off | 5 |
| `project_members` | A person shown on a project's dashboard card. | project_id → projects (cascade), person_id → people | 15 |
| `project_scopes` | The scope statement of a project (one per project). | project_id → projects (cascade), objective | 5 |
| `project_task_assignees` | A person assigned to a plan task; the first is the main assignee. | task_id → project_tasks (cascade), person_id → people | 9 |
| `project_tasks` | A task in the plan of a project that is not linked to an initiative (linked plans live in the initiative's tasks). start_day and length_days count from 1 Jan 2024. | project_id → projects (cascade), ref, name, phase, status, priority, timeline, start_day, length_days, subtask_count, start_date, due_date | 6 |
| `projects` | A project. name is the short name used in menus and plans; title, owner, dates, progress and budget feed the dashboard card (card = has a dashboard card). | name, title, label, owner_name, due_label, time_left, ring, ring_color, completion, tasks_done, tasks_total, more_people, status, badge, budget_k, spent_k, segments, card, favourite | 5 |
| `raid_items` | A risk, assumption, issue or dependency. initiative_id links it to the initiative it threatens. | ref, type, title, project_name, owner_id → people, impact, status, review_by, initiative_id → initiatives | 9 |
| `resource_absences` | An upcoming absence of a person. | person_id → people, starts_label | 5 |
| `resource_workloads` | A person's workload per month (1 = full time, null = no data), months as in the setting projects.resource_months. | person_id → people, monthly | 10 |
| `retro_items` | col w = went well, i = to improve (with votes), a = action (with owner and done). | retro_id → retrospectives (cascade), col, text, votes, owner_id → people, done | 17 |
| `retro_participants` | A person who took part. | retro_id → retrospectives (cascade), person_id → people | 6 |
| `retrospectives` | A retrospective meeting. | title, date_label | 2 |
| `scope_items` | An in-scope (inn) or out-of-scope (out) item. | scope_id → project_scopes (cascade), kind, text | 23 |
| `spaces` | A workspace the user owns (owned) or is a member of. | name, initials, color, owned, people_count | 14 |
| `value_distribution` | How the value the company earns is shared (£M). | name, value, color | 6 |

### Platform, planning and product content (24 tables)

| Table | What a row is | Columns | Demo rows |
| --- | --- | --- | --- |
| `audit_log` | One recorded change: when (ISO time), who, kind and what; the latest 500 are kept | at, who, kind, text | 0 |
| `budget_caps` | Yearly budget cap of the live plan in £k (id = year) | year, cap | 3 |
| `import_runs` | The last import, with what it added so it can be undone (measure_snapshots: values before the import) | at, who, target, source, row_count, skipped, initiative_id → initiatives, task_ids, initiative_ids, measure_snapshots, summary | 0 |
| `initiative_role_demand` | FTE an initiative needs from a role in every quarter while it runs (a row without role keeps an initiative whose demand was cleared) | initiative_id → initiatives, role_id → roles (cascade), fte | 37 |
| `paused_initiatives` | An initiative an applied scenario left out of the live plan (id = initiative) | initiative_id → initiatives, scenario_id → scenarios, paused_on | 0 |
| `product_features` (product) | A feature buyers expect (class T table stakes, E expected, D differentiator) and how far OrgCue covers it | area → product_roadmap_areas, feature, class, coverage, go, description, vendors, roadmap_item_id → product_roadmap_items | 65 |
| `product_import_samples` (product) | A sample CSV file offered on the import page (id = sample key) | file_name, content | 4 |
| `product_panel_findings` (product) | A point the review panel agreed on | text | 5 |
| `product_panel_lists` (product) | One line a reviewer gave: kind good (strongest today) or gaps (biggest gaps) | person_id → product_panel_people (cascade), kind, text | 30 |
| `product_panel_people` (product) | A reviewer on the product panel (id = initials) | role, color, lens, quote | 4 |
| `product_panel_picks` (product) | A roadmap item a reviewer wants built now | person_id → product_panel_people (cascade), item_id → product_roadmap_items | 12 |
| `product_roadmap_areas` (product) | A product area with its colour (id = area name) | color | 8 |
| `product_roadmap_horizons` (product) | A column of the product roadmap (done, now, next, later) | name, description | 4 |
| `product_roadmap_items` (product) | A product capability: shipped, building, planned or exploring | title, area → product_roadmap_areas, horizon → product_roadmap_horizons, status, go, votes, asked_by, refs, why, what, collab | 66 |
| `product_shipped_areas` (product) | A group of shipped capabilities | name, icon | 8 |
| `product_shipped_items` (product) | A shipped capability with the page that shows it | area_id → product_shipped_areas (cascade), name, go | 66 |
| `product_vendors` (product) | A vendor researched for the roadmap | name, area, known_for, lesson | 33 |
| `roadmap_suggestions` | A feature someone in this workspace suggested for the product roadmap | title, area → product_roadmap_areas, horizon → product_roadmap_horizons, status, go, votes, asked_by, refs, why, what, collab | 0 |
| `roadmap_votes` | A person's vote for a roadmap item or suggestion (item_id is a product_roadmap_items or roadmap_suggestions id) | item_id, person_id → people | 0 |
| `role_people` | A person's role for capacity planning and the share of their time that goes to portfolio work (id = person) | person_id → people, role_id → roles (cascade), share | 15 |
| `roles` | A role whose capacity is planned: FTE from the wider team on top of named people, which can change from a quarter (index into the planning horizon) | name, extra_fte, change_quarter, extra_fte_after | 8 |
| `scenario_caps` | Yearly budget cap in £k inside a scenario | scenario_id → scenarios (cascade), year, cap | 6 |
| `scenario_changes` | How a scenario changes one initiative: left out (1) or kept in (0), quarters moved, budget in £k | scenario_id → scenarios (cascade), initiative_id → initiatives, leave_out, shift_quarters, cost | 3 |
| `scenarios` | A what-if plan: changes on top of the live plan, and when it was last applied | name, description, created_by → people, created_on, applied_on, applied_by → people, applied_decision_id → decisions, applied_changes | 2 |
