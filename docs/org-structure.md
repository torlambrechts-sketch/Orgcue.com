# Organisation structure and true cascading: panel discussion and design

November 2026. The customer asked for "a true cascading strategy, initiatives and goals", set and combined at company, country, department, team and personal level. They want the organisation structured under admin as PE company, Group, Country, Corporation, Company, Department, Team and Individual. Every item needs an owner, and each level must be able to cascade, inherit and create its own strategy, initiatives and tasks.

The standing advisory panel discussed the request:
- the strategy consultant, who for this topic also took the role of a private-equity operating partner;
- the PMO director;
- the SaaS founder;
- the market analyst, who researched 19 products.

Their papers are summarised below. The chair's decisions follow, then the design that is built.

## 1. Where the panel agreed

All four papers reached these conclusions independently.

1. **One tree whose levels each workspace can configure, not eight fixed levels.**
   - The customer's eight levels ship as the default "Investor group" template, alongside "Single company" and "Group with countries".
   - Depth may vary by branch: a level can be skipped, and some types (such as Department) can nest.
   - Fixed levels force empty "Country" nodes on single-country companies, and empty nodes attract scorecards nobody maintains.
   - None of the OKR tools the analyst checked uses fixed named levels. Only SAP SuccessFactors and Clarity have typed levels.
2. **"Individual" is not a node.**
   - People are members of units, with one primary unit and any number of matrix memberships, Workday-style.
   - A person's level shows their own goals, key results and tasks.
3. **Every item has an owning unit and an accountable person.**
   - The person does not have to belong to the unit: matrix leads and shared services are normal, so the app warns but never blocks.
   - The demo already has a case: Marta Lindqvist, the delivery chief, owns a Commercial objective.
4. **Align up is the default, cascade down is a request, inherit is a view, and local items are allowed.**
   - Copies drift and double-count, so inheriting never copies.
   - Cascading down reuses the existing catchball (`target_proposals`) instead of a new workflow, and "not relevant" is a valid answer.
5. **Nothing rolls up by habit.**
   - Each measure declares its roll-up rule, and "none" is the default.
   - Sums are refused when the units of measure differ.
   - Status shows worst-of and a count of children off track. Green and red never average to amber, and a red country is never hidden.
6. **The portfolio company is a hard boundary.**
   - Companies are compared through a shared KPI library, not added up.
   - People in one portfolio company cannot see another.
7. **The strategy cascade stops at Team.**
   - Below a team, people get key results and tasks.
   - Personal development goals belong to HR tools, or are private and never roll up.
8. **Migration keeps today's ids.**
   - The 5 business units and 13 teams become organisation units with the same ids, so the 20-odd tables that reference them stay valid.
9. **Admin gets from zero to a full organisation in ten minutes:** a template, then a pasted indented outline, then heads, then people from CSV.
   - Import creates missing parents. Profit.co fails when a parent does not exist.
   - Archiving never orphans children. Viva Goals turns them into stand-alone teams.
   - HR sync comes later, through a review queue that never overwrites silently.

## 2. Where the panel disagreed, and the chair's decision

| Question | Positions | Decision |
| --- | --- | --- |
| **Access between portfolio companies: now or later?** | Strategy consultant and analyst: phase 1, because no PE house puts two companies in one workspace without walls. PMO director and founder: phase 2. | **Phase 1, built in parallel.** The customer is a PE structure, and the demo shows two portfolio companies. The guest-scope code already filters loads and saves by row, so the boundary reuses it. Edit rights by subtree stay in phase 2. |
| **Can initiatives cascade?** | Strategy consultant: never, they are funded decisions. PMO director: one level of child initiatives. Analyst: a parent may ask a child unit to run a sub-initiative. Founder: request them through intake. | **One level, as a request.** A parent initiative can ask a child unit to run a child initiative, which the unit accepts or declines. The child is linked to its parent, and money is allocated, never double-counted. Contributing, sponsoring and benefiting units hold a share. The customer explicitly asked for initiatives to cascade. |
| **Can tasks cascade?** | All: no; tasks are assigned. | **Delegation, not cascade.** A task can be handed to another unit, whose head (or triage owner) assigns a person. The performing unit is recorded. Tasks otherwise inherit their unit from their initiative. |
| **Merge `objectives` and `unit_objectives` now?** | Strategy consultant: yes. Founder: phase 2. | **Phase 2.** In phase 1, `objectives` is the portfolio company's level. `unit_objectives` becomes the objective of *any* unit below it, gaining an origin and a parent that can be another unit objective. |
| **KPI library: phase 1?** | Strategy consultant, analyst and founder: yes, for PE comparison. PMO director: shared definitions. | **Phase 1:** `metric_definitions` with a roll-up rule, linked from measures, plus a portfolio comparison grid. |
| **Effective-dated reorganisations** | PMO director and analyst: dates in the schema now. Founder: simple tree first. | **The dates go in the schema now** (`valid_from`, `valid_to` on units and memberships). Moves, merges and archives are logged in `org_changes`. Scheduled future reorganisations are phase 2. |
| **Legal entity** | Strategy consultant: a separate tree later. Others: a flag. | **A flag** (`is_legal_entity`) on units and level types. A separate legal tree waits for a customer that needs one. |
| **How deep can objectives cascade?** | Two levels (strategy consultant), three (PMO director), to Team (all). | **A soft limit:** a warning beyond two levels below the unit that set the objective, and objectives stop at Team. |

## 3. The design

### 3.1 Data model (new tables are named `org_*`, because "team" already means a workspace kind and a table)

**`org_level_types`.** A configurable level.

| Column | Meaning |
| --- | --- |
| `name`, `plural` | Name of the level |
| `rank` | Order from top (1) to bottom |
| `nestable` | Whether a unit can sit under a unit of the same type |
| `is_boundary` | Default for new units of this type: a portfolio company |
| `is_legal_entity` | Default for new units of this type |
| `allows_objectives` | Whether units of this type hold objectives. Off for Individual-like levels and on by default |
| `icon` | Icon shown for the level |

The default template has seven level types. The Individual level is people as members:

| Level | Name | Plural | Rank | Flags |
| --- | --- | --- | --- | --- |
| `pe` | PE company | PE companies | 1 | |
| `group` | Group | Groups | 2 | |
| `country` | Country | Countries | 3 | |
| `corporation` | Corporation | Corporations | 4 | legal entity |
| `company` | Company | Companies | 5 | legal entity |
| `department` | Department | Departments | 6 | nestable |
| `team` | Team | Teams | 7 | |

**`org_units`.** The tree.

| Column | Meaning |
| --- | --- |
| `parent_id` → `org_units`, `level_type_id` → `org_level_types` | Place in the tree. The rule is checked in the app: a child's rank must be greater than its parent's, or equal when the type is nestable. Cycles are refused. |
| `name`, `code` | Name, and a short code |
| `head_id` → people | The unit's head |
| `country_code`, `currency` | Location and reporting currency |
| `is_boundary`, `is_legal_entity`, `is_shared_service` | Flags |
| `valid_from`, `valid_to`, `status` (active or archived), `merged_into` | Lifecycle |
| `external_id` | Key in an HR system |
| `description` | Free text |

Ids are text. The 5 existing business units keep their ids ("Delivery"), and so do the 13 teams ("Delivery/PMO").

**`org_memberships`.** People in units.

| Column | Meaning |
| --- | --- |
| `person_id` → people, `unit_id` → `org_units`! | Who belongs where |
| `kind` | primary or matrix. Each person has exactly one primary membership. |
| `role` | head, deputy or member |
| `fte_share` | Share of the person's time |
| `valid_from`, `valid_to` | Dates of the membership |

**`org_changes`.** A log of structure changes.

| Column | Meaning |
| --- | --- |
| `kind` | create, move, rename, merge, archive or restore |
| `unit_id`, `from_parent_id`, `to_parent_id`, `into_unit_id` | What changed |
| `effective_on`, `by_person`, `note` | When, who and why |
| `decision_id` → decisions | The decision behind it, if any |

**`metric_definitions`.** The shared KPI library.

| Column | Meaning |
| --- | --- |
| `name`, `description`, `formula` | What the KPI is |
| `unit`, `direction` | Unit of measure, and whether higher or lower is better |
| `rollup` | none, sum, average, weighted or worst_of |
| `additive` | Whether values may be summed |
| `scope_unit_id` → `org_units` | The level that publishes it, for example the PE company |

**Ownership columns.** Side tables keyed by the parent id, so existing tables keep their shape:

| Table | Columns | Meaning |
| --- | --- | --- |
| `org_item_units` | `ref`, `unit_id` → `org_units`, `role` (owner, sponsor, contributor, benefiting or performer), `share_pct`. Refs use the comment-thread kinds (`obj:`, `kpi:`, `kr:`, `init:`, `task:`), extended with `uobj:` (unit objective), `um:` (unit measure) and `okr:` (OKR objective). | The **owning unit** of every objective, unit objective, measure, KR, initiative and task, plus sponsoring, contributing and benefiting units with shares, and the performing unit of delegated tasks. Exactly one owner row per ref. |
| `org_item_links` | `ref`, `parent_ref`, `kind` (aligned, cascaded or adopted), `weight`, `status` (proposed, accepted, declined or not_relevant), `requested_by`, `requested_on`, `answered_on`, `reason` | Align-up and cascade links between items across units, for objectives, unit objectives, KRs, measures and initiatives. Today's `unit_objectives.objective_id` and weight stay as they are and are read as links. |
| `measure_rollups` | `ref`, `definition_id` → `metric_definitions`, `rollup`, `tolerance` | A measure's definition and roll-up rule |

### 3.2 Cascade, inherit, align, create

| Object | Create local | Align up | Cascade down | Inherit | Roll-up |
| --- | --- | --- | --- | --- | --- |
| **Objectives** (`objectives` at a portfolio company, `unit_objectives` at any unit below) | A new objective owned by the unit, with no parent. Allowed, and shown as "not aligned" in coverage. | Link to an objective of any ancestor unit, with a weight. The parent owner can reject the link. | The parent owner asks chosen child units, one or two levels down, through `target_proposals` (kind `cascade`). The child accepts (an aligned objective is created, with a proposed target), counter-proposes, declines with a reason, or answers "not relevant". | Ancestors' objectives show read-only in the unit's **Context** band. **Adopt** creates one aligned local objective with a local target. | Weighted score of aligned children, shown next to the parent's own measure. Status: worst-of with a count. |
| **Measures and KRs** | A local measure, optionally from the library | Contributes to a parent measure only when the definition or unit of measure matches | Ask for a contribution with a target split (`kr_contributions`, extended to units) | The parent's measure shows as context. Adopting it creates a measure from the same definition with a local target. | The measure's declared rule. Sums only when additive. Never across a portfolio-company boundary unless the measure comes from the library. |
| **Initiatives** | Normal: owning unit plus an owner person | Supports objectives at its own unit or above | A parent initiative asks a child unit to run a child initiative. When accepted, the child is linked and part of the parent's budget is allocated to it. One level per hop. | Shown in "Initiatives affecting us" where the unit sponsors, contributes or benefits | Money: summed over owned children, and contributors see only their share, so nothing is counted twice. Status: spread of children plus the owner's call. |
| **Tasks** | A task in an initiative; it takes the initiative's unit | Through its initiative | **Delegate** to another unit. That unit's head or triage owner assigns a person, and the performing unit is recorded. | No | Counts and hours |
| **Individuals** | Personal key results (`okr_objectives` owned by the person) and their tasks | KRs align to team objectives | Received through assignments and accepted requests | The person's page shows their units' objectives as context | No personal strategy roll-up |

**Where cascading stops.** The app warns when an objective is cascaded more than two levels below the unit that set it. Objectives stop at Team, and people get key results and tasks. A **stale check** flags cascaded items with no check-in for 60 days, and items aligned to archived parents.

### 3.3 Screens

- **Settings › Organisation** (admins), with five tabs:
  - **Structure:**
    - a tree with search, counts and coverage dots;
    - drag to move, with an impact preview ("moves 2 objectives, 3 initiatives, 14 tasks");
    - a detail panel: name, level, head, deputies, members, country, currency, flags, dates and owned items;
    - Add child, Move, Merge into…, Archive. Archive is blocked while the unit owns open items, and offers to reassign them.
  - **Levels:**
    - the level types;
    - templates (Investor group, Single company, Group with countries);
    - flags, and the rank rule.
  - **People:**
    - each person's primary unit, matrix memberships, role and FTE share;
    - the list of people in no unit;
    - bulk edit.
  - **Import:**
    - paste an indented outline (indentation sets the parent; the level is guessed by depth and corrected in a table);
    - units CSV (`unit, parent, level, head_email`) and people CSV (`email, primary_unit, other_units, role`);
    - missing parents are created;
    - a preview of the differences before applying.
  - **Changes:** the `org_changes` history.
- **Scope picker in the top bar.**
  - A breadcrumb ("Kestrelmoor Capital › MosaicX Group › United Kingdom › … › Delivery ▾") with search, and three choices:
    - this unit;
    - this unit and below (the default);
    - everything I can see.
  - It is remembered per person. It starts at "everything I can see", and the visibility scope in 3.4 limits that for people inside a portfolio company. "My unit" is one click away. (The panel proposed starting at the person's own unit. In the build that left most pages nearly empty for people in small teams, so the chair changed the default.)
  - Every list (objectives, measures, initiatives, tasks, finance, capacity, risks, reviews, dashboards) gets an owning-unit filter and column, and reads the scope.
- **Unit page (`org-unit`).**
  - A header: level, head, deputies, members and breadcrumb.
  - Then bands:
    - **Asked of us:** cascade requests, child-initiative requests and delegated tasks, with Accept, Propose, Decline and Not relevant.
    - **Ours:** the unit's own objectives, measures, initiatives and tasks, each labelled cascaded, aligned, adopted or local.
    - **Context:** inherited ancestor items, with Adopt.
    - **Below us:** child units as tiles, exceptions first, plus a heat map of objectives by child unit.
  - It is never empty. A new unit sees its parent's objectives and "Pick the ones you contribute to".
- **Person page (Individual).** Primary unit, memberships, key results, tasks, contributions and owned items.
- **Portfolio comparison** (at a PE company or group): companies as rows, library KPIs as columns, value against plan, sorted by gap. A league table, never a total.

**First screens.**

| Who | First screen |
| --- | --- |
| PE partner | Portfolio comparison |
| Group CEO | Group unit page, with exceptions first |
| Country or company manager | Their unit page, scoped to their subtree |
| Team lead | Team page, with "Asked of us" first |
| Individual | My work, with a "My goals" strip |

### 3.4 Access

**Phase 1 (this release).**
- A member can be given a **visibility scope**: one or more units, each including its subtree. They then see:
  - their subtree;
  - the context items of its ancestors;
  - product content and shared library definitions.
- **Units flagged `is_boundary` are walls.** A member scoped below one portfolio company cannot load or change another. Members with no scope, such as PE-level staff, see everything.
- This is enforced in `orgcue_load` and `orgcue_apply`, like guest scopes.

**Phase 2.**
- Edit rights by subtree: heads and deputies edit their own subtree, and others view and comment.
- Scheduled reorganisations, a separate legal-entity tree, merging the two objective tables, and HR sync through a review queue.

### 3.5 Migration and demo

**Mapping today's data.**

| Today | New model |
| --- | --- |
| `units` (5) | Department units with the same ids, under MosaicX UK Ltd. The leads become heads, with a membership. |
| `teams` (13) | Team units with the same ids |
| `objectives` (12) | Owned by MosaicX Group, the portfolio company |
| `unit_objectives` (15) | Owned by their department, linked to company objectives as today |
| `team_objectives` (17) | Alignment links |
| `okr_objectives.team` | The owning team unit |
| `initiatives` | An owning department, proposed from the owner's unit (I7 → Commercial and so on), with contributing units from role demand |

The legacy `units` and `teams` rows are kept in step by the organisation module, so pages that read them keep working.

**The demo becomes a PE structure.** All names are fictional:

- **Kestrelmoor Capital** (PE company)
  - **MosaicX Group** (Group; portfolio company boundary)
    - **United Kingdom** (Country)
      - **MosaicX Holdings Ltd** (Corporation, legal entity)
        - **MosaicX UK Ltd** (Company, legal entity)
          - Commercial, Delivery, Technology, People & Culture, Finance (Departments), each with its existing teams
    - **Nordics** (Country)
      - **MosaicX Nordics AB** (Company, legal entity; skips the Corporation level). This is the home of I7 "Nordics market entry".
  - **Tidewell Software** (Company; portfolio company boundary; skips Group, Country and Corporation)
    - A small 40-person software firm with three departments and a scorecard on the shared library.

Kestrelmoor publishes six library KPIs: revenue growth, recurring revenue share, EBITDA margin, cash conversion, client retention and employee engagement. Both companies report against them, so the comparison grid has data.

The 19 MosaicX people get primary memberships. Tidewell gets a few people of its own.

## 4. Build plan

| Step | Module | Builds |
| --- | --- | --- |
| A | `org` (prefix `og`) | The core:<ul><li>`org_level_types`, `org_units`, `org_memberships` and `org_changes`;</li><li>the shared `org_item_units` and `org_item_links`, with their API and the owning units of today's items;</li><li>Settings › Organisation with all five tabs and the templates;</li><li>the scope picker and scope API;</li><li>the unit page shell and the person page;</li><li>the migration, with legacy sync, and the demo tree and memberships.</li></ul>Other modules build on its API. |
| B1 | `cascade` (prefix `cs`) | Strategy:<ul><li>`metric_definitions` and `measure_rollups`;</li><li>owning units on objectives, unit objectives, measures and KRs;</li><li>align, cascade requests, context with adopt, and local items;</li><li>roll-up rules, the library, status worst-of and depth warnings;</li><li>the portfolio comparison;</li><li>strategy bands on unit and person pages;</li><li>the scope filter on strategy pages;</li><li>Tidewell's scorecard.</li></ul> |
| B2 | `orgwork` (prefix `ow`) | Portfolio and work:<ul><li>owning, sponsoring, contributing and benefiting units with shares;</li><li>child-initiative requests with budget allocation;</li><li>task delegation to units;</li><li>the scope filter on portfolio, finance, capacity, tasks and My work;</li><li>initiative and task bands on unit pages;</li><li>Tidewell's initiatives.</li></ul> |
| B3 | `orgaccess` (prefix `oa`) | Visibility scopes and portfolio-company walls:<ul><li>SQL in `orgcue_load` and `orgcue_apply`, tested on a local Postgres;</li><li>the member scope setting in Settings;</li><li>a memory-provider test hook.</li></ul> |

Step A comes first. B1, B2 and B3 then run in parallel on A's page.

## Sources
- The four panel papers. The market analyst's appendices compare 19 products, with sources.
- The vendor facts come from search results quoting help centres, and are marked as unverified where weak in the papers:
  - Workday supervisory and matrix organisations, and its reorganisation events;
  - SuccessFactors' two-level cascade limit;
  - Profit.co's propagation rules;
  - Viva Goals' archiving behaviour and its retirement on 31 December 2025;
  - Perdoo's multi-company groups;
  - Clarity's OBS levels;
  - ServiceNow's enterprise-wide deployment partitions.
