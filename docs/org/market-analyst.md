# Organisation structure and true cascading: the market analyst's paper

Author: market analyst, OrgCue advisory panel. Research date: 10 November 2026.

Method: web search only. Direct fetches of vendor help centres (help.workboard.com, support.perdoo.com) were blocked by the session's network policy, so every vendor fact comes from search results that quote help centres, knowledge-base articles, release notes and community forums. Facts marked **(unverified)** rest on a single weak source, a competitor's claim, a community post, or my own product knowledge that no search confirmed. The market synthesis, the vendor comparison table and the sources are in the appendices, which are outside the word count.

---

## Key recommendations

1. **One recursive tree with named level types, not eight fixed levels.** Every OKR and strategy tool I checked uses one self-nesting "team" or "department" object of any depth. Build `org_units` (id, parent_id, level_type_id, name, head_person_id) plus `org_level_types`, which each workspace can configure. Ship the customer's eight levels as the "Investor group" template and a three-level "Single company" template. Allow ragged depth: a branch may skip Country or nest sub-departments. **Individual is not a unit.** People attach to units through membership.
2. **One management tree, with matrix and legal views as secondary links.** Copy Workday's rule: each person has one primary unit and any number of matrix memberships. Legal entity should be a flag on a unit (`is_legal_entity`) in version 1, not a second tree.
3. **Every item carries an owning unit and an accountable person.** The alignment link sits on the item and is separate from the tree. Quantive, Perdoo, Asana and ServiceNow all keep the goal's parent pointer separate from the team tree. The tree drives suggestions, views and access, not parenthood.
4. **Make "align up" the default and treat "cascade down" as a request.** Build "cascade down" on today's catchball (`target_proposals`). "Inherit" is a view, never a copy. SuccessFactors and Profit.co show that push-cascades need review rules and depth limits. Pure top-down cascades are widely criticised and abandoned.
5. **No silent sums.** Each parent declares its roll-up method (none, weighted progress, sum or worst-of). Sums are allowed only when the units of measure match. At the portfolio-company boundary, the default is "compare", not "add".
6. **Access follows the subtree, in two phases.** Phase 1 adds unit filters and a hard boundary between portfolio companies. Phase 2 adds roles scoped to a subtree and inherited downwards.
7. **Admin gets a tree editor, CSV import with a parent column, and moves with effective dates.** Archiving must never orphan children. HR sync comes later. When it is on, HR owns the structure and OrgCue owns the goals.
8. **Add a PE holding with a second portfolio company to the demo.** The PE comparison view is a differentiator. Only specialist PE tools sell it today.

The evidence is summarised in Appendix A, with a per-vendor table in Appendix B and sources in Appendix C.

---

## Reasoning per question

### 1. The ideal structure

**Configurable levels, with the customer's eight as a template.** Fixed levels fail the first customer that has no Country or no Corporation. Anaplan shows the cost: balanced hierarchies need dummy levels that confuse users. The level type should carry behaviour flags, not drive code paths:
- `is_portfolio_company`: a separation boundary for access and roll-up;
- `is_legal_entity`;
- `is_country`: used for country filters;
- `allows_people`.

A default rule says which types may sit under which ("Department may sit under Company or Department"). It warns rather than blocks, because sub-departments are normal.

**Matrix.** Add `org_memberships`:
- `person_id`;
- `unit_id`;
- `kind`: primary, matrix or secondary;
- `role`: head, deputy or member;
- `valid_from` and `valid_to`.

Each person has one primary unit and any number of others. A country × business line matrix is modelled as a management tree plus matrix units, Workday-style. It is not two trees that both claim the same item.

**Legal versus management.** In the PE and mid-market segment, legal entities usually line up with the management levels Company and Corporation, so a flag is enough. A separate legal tree belongs to finance and HR suites and can come later, if ever.

**PE layer.** The portfolio company is a hard boundary. Units below it cannot see across it, and numbers do not add across it unless a measure comes from a shared library and is declared comparable. PE tools (Maestro, Shibumi) sell this cross-portfolio view on a standard KPI taxonomy.

**Shared services.** A shared-services unit sits where it belongs legally, for example under the Group. A "serves" link (phase 2) shows its initiatives on the pages of the units it supports.

**Change over time.** Put `valid_from` and `valid_to` on `org_units`, on the parent link and on memberships now, even before the UI uses them. Add an `org_changes` log that groups moves, merges and renames under one effective date, as Workday's reorganisation event does. History matters because last year's scorecards must still roll up the way they were.

### 2. Configuration under admin

Admin › Organisation has four parts:
1. **Tree editor.** Expand and collapse, drag to move, set the head and deputies per node, and merge (choose a survivor; items move with it).
2. **Level types.** Rename, reorder, set flags, and choose a template.
3. **Members.** Assign people to units and set the primary unit.
4. **Import.** Paste or upload a CSV with these columns: `unit, parent, level, head_email`, plus a people file `email, primary_unit, other_units`.

Import must auto-create missing parents and show a preview diff. Profit.co's "validation fails if the department doesn't exist" is the trap to avoid. Archiving keeps children attached and asks where open items go. It must not repeat Viva Goals, where archiving orphans sub-teams.

**From zero in 10 minutes:**
1. Pick a template.
2. Type or paste an indented list. Indentation sets the parent.
3. Assign heads from the people list.
4. Done.

HR sync (BambooHR, Personio, Workday) belongs in phase 3. When it is on, HR owns units and membership and OrgCue owns goals, because Betterworks overwrites manual edits.

### 3. Ownership

Every unit has a head (`head_person_id`) and optional deputies, stored as membership roles.

Add `owner_unit_id` to these tables, and replace `team_objectives` with it:
- `objectives`, `unit_objectives` and `okr_objectives`;
- `measures`, `initiatives` and `tasks`.

`owner` and `owner_id` stay as the accountable person, and `object_roles` stays for contributors and the rest.

The owner should normally be a member of the owning unit, but this is a warning, not a rule. Matrix leads and group functional heads often own items in units they do not belong to, and Workday's dotted-line model accepts this. The default: when you create an item on a unit's page, it is owned by that unit, and the owner defaults to its head.

### 4. Cascade, inherit and create

The market mostly ships "align up" and calls it cascading. That is honest and it works. Where vendors do ship a true push-cascade, they need guard rails: SuccessFactors limits depth and Profit.co uses review rules.

| Verb | Objectives and KRs | Measures | Initiatives | Tasks |
| --- | --- | --- | --- | --- |
| **Align up** | `parent_id` on the item points to a parent item, any level up, possibly across branches | Contributes to a parent measure only if the unit of measure matches | Supports one or more objectives (many-to-many, weighted) | Belongs to its initiative; no separate alignment |
| **Cascade down** | Parent owner sends a request to selected child units (`target_proposals`, kind = cascade). On accept, a draft child objective is created and aligned, with a proposed target. Default rule: review-required. | Same, with a split of the target (equal, weighted, or left to each child) | Parent initiative asks a child unit to run a sub-initiative (`parent_initiative_id`) | Not cascaded; assigned |
| **Inherit** | View only. A unit page shows ancestors' items in a "Context" band, read-only. "Adopt" turns one into an aligned local item with a local target. | Same | Shown as "Initiatives affecting this unit" when the unit is a stakeholder | Not inherited |
| **Create local** | `parent_id` is null; tagged "local" in coverage reports | Same | Same | Same |

**Roll-up rules** live on the parent, in `rollup_method`:
- `none` is the default for objectives;
- `weighted_progress` is the default for objective progress;
- `sum` requires the same unit of measure and is declared additive;
- `average`;
- `worst_of` is for status and risk.

Status rolls up worst-of with a tolerance: one red child out of five makes the parent amber, not red. The owner can override this, as `override` already does. Cancelled and withdrawn items are excluded.

**Where cascading stops:**
- Numbers: at the portfolio-company boundary, unless the measure comes from the shared library.
- Objectives: at Team. The individual level holds goals and work, not strategy.

"Individual strategy" should mean personal goals aligned to team goals plus the person's tasks. Development goals are HR's territory, and SuccessFactors itself does not cascade them. Personal goals should be private to the person and their line manager by default. This matches WorkBoard's "Management Can View" default for individual goals.

**Optional mandatory alignment.** A workspace setting can require objectives at or below a chosen level to have a parent. It is off by default. Quantive offers this only when the customer asks its customer success manager.

### 5. Views

A unit page has one header (head, members, level) and three tabs over the same lists:
- **Own:** the default tab.
- **Children:** a roll-up table, one row per child unit, showing coverage, status mix, target attainment and initiative spend.
- **Context:** inherited ancestor items.

A level switcher in the breadcrumb ("MosaicX › Delivery › Cloud Migration team") moves up and down. A global unit filter in the top bar ("Scope: Delivery and below") applies to every page: portfolio, tasks, RACI and cascade. It is remembered per user.

What each user sees first:
- **Group CEO or PE partner:** a portfolio-company comparison grid. Rows are companies, columns are shared KPIs and value-creation-plan initiatives.
- **Country manager:** their subtree's Children tab.
- **Team lead:** their team's Own tab.
- **Individual:** My work (goals, tasks and assignments) with a Context strip.

### 6. Access

**Phase 1** (with the tree):
- Workspace roles stay as they are.
- Add an optional `scope_unit_id` per member that limits what they can see to that subtree, plus the context items of its ancestors. This is Perdoo's model.
- A member scoped to one portfolio company cannot see a sibling company at all.
- PE-level members are unscoped.

**Phase 2:** unit-scoped roles (`unit_role_grants`: person, unit, role), inherited downwards as in Workday. A country manager is an editor on their subtree. Do not copy Oracle P6, where rights are not inherited by children: it forces admins to grant every node by hand.

**Phase 3:** HR-driven grants, where a unit's head automatically becomes an editor on it.

### 7. Migration

| Today | New model |
| --- | --- |
| Company | New root `org_units` row: MosaicX Ltd, level Company, flagged legal entity |
| `units` (id = name) | Child units at level Business unit. Keep a `legacy_unit_id` mapping, because many rows reference unit names. `lead` becomes `head_person_id`. |
| `teams` | Units at level Team, parent = their unit |
| `unit_objectives` | Kept, or folded into `objectives` with `owner_unit_id` and `parent_id` set to the company objective. Keep `weight` on the link. |
| `unit_measures` | Measures with `owner_unit_id` |
| `team_objectives` | Kept as alignment links. Seed one draft team objective per pair only if the panel wants team scorecards. |
| `people` | Memberships: heads from `units.lead`. Others are inferred from initiative and task ownership and flagged "please confirm". |
| `initiatives` | Get `owner_unit_id`, defaulting to the owner's primary unit. A coverage report shows the guesses. |

**Naming.** The database calls a shared workspace kind `team`, there is a `teams` table, and the customer wants a level called "Team". The new tables should be named `org_*` to avoid a fourth meaning.

**Demo.** Add "Northlight Partners Fund II" as the PE root, with two portfolio companies:
- MosaicX, the professional-services firm, with UK and Netherlands country units over its current business units;
- a small second company, such as a 40-person software firm with three departments.

Both share four library KPIs: revenue growth, EBITDA margin, cash conversion and employee engagement. The second company stays small.

### 8. Pitfalls

- **Deep cascades nobody maintains.** Betterworks says this itself. The fix is alignment by default, cascade only on request, and a stale-link report that lists parents with no check-ins in 60 days and children aligned to archived parents.
- **KPI trees that add unrelated numbers.** Asana's "203". The fix is to make roll-up methods explicit and refuse a sum when the units of measure differ.
- **Org charts out of sync with HR.** Viva Goals' structure cannot be reversed, Profit.co does not sync deletions, and Betterworks overwrites manual edits. The fix is one owner per field and an "unassigned people" queue after each import.
- **Matrix teams lost from the alignment view.** WorkBoard's working groups are left out of it. In OrgCue, matrix units should still appear in views, marked as matrix.

---

## Disagreements I expect, and my answers

**The strategy consultant (PE lens): "Fix the eight levels so portfolio companies are comparable."** Comparability comes from shared level types and a shared KPI library, not from identical depth. A buy-and-build platform company with no Country level is still comparable on EBITDA margin. Templates keep the defaults uniform.

**The PMO director: "Make the owning unit mandatory, and the owner must be a member, with strict edit rights per unit from day one."** I agree that the owning unit is mandatory for initiatives and objectives; migration fills it in. I disagree on strict membership, because it breaks matrix ownership. Subtree edit rights are phase 2. Phase 1's visibility scope and portfolio-company boundary cover the urgent PE confidentiality need.

**The SaaS founder: "Skip effective dating and matrix; ship a simple tree."** I agree on the UI, but not on the schema. `valid_from` and `valid_to` columns and a membership table cost little now and a great deal later. Ship the simple tree UI with them in place and add the history UI later.

**Someone will propose "inherit = copy the parent's objectives into each child".** Copies drift, double-count in roll-ups and multiply maintenance, which is the "deep cascade" failure. Inherit is a view. "Adopt" creates one aligned item on purpose.

---

## Summary of recommendations

- **Structure:** one ragged `org_units` tree with configurable level types; the customer's eight levels as a template; people as members, not units.
- **Matrix, legal and PE:** matrix memberships; legal entity and portfolio company as flags, the latter a hard boundary.
- **Ownership:** an owning unit and an accountable person on every item; alignment as a parent link, separate from the tree.
- **Cascade:** align-up by default, cascade-down as a catchball request, inherit as a view, local items allowed.
- **Roll-up:** declared methods, no sums across units of measure.
- **Access:** phased subtree access.
- **Admin:** tree editor, auto-creating import, effective-dated reorganisations.
- **Demo:** a PE holding with two portfolio companies.

---

## Appendix A: what the market does

| Question | What the market does |
| --- | --- |
| **Hierarchy model** | OKR tools use one recursive team tree: WorkBoard functional teams with parent teams, Perdoo teams and sub-teams, Quantive parent and child teams, Profit.co departments and sub-departments, and Viva Goals teams and sub-teams. Atlassian shipped Team Hierarchy in 2025 with one parent per team and at most 25 sub-teams. Cascade's model suggests four layers (Corporate, Business Units, Functional Departments, Teams) but builds them as linked "plans". Only SuccessFactors has typed objects (Legal Entity → Business Unit → Division → Department, effective-dated, with chained pick-lists). Only Clarity lets admins name OBS levels. Planview caps strategy hierarchies at 5 levels. |
| **Matrix** | WorkBoard keeps "dynamic teams" (working groups) out of the org alignment view. Workday gives each worker one supervisory org and many matrix orgs, and the supervisory manager keeps final authority. Cost-centre and company hierarchies sit alongside as separate trees. |
| **Goal attachment and alignment** | A goal is owned by a team and a person and points to a parent goal. Quantive suggests parents in three groups: team, parent team and top level. It can make alignment mandatory, but only when the customer asks its customer success manager. Perdoo lets an OKR align to any OKR. |
| **True push-cascade** | SuccessFactors pushes goals at most two levels down, times out above 40 generated goals, and works only within one goal-plan template. Profit.co has propagation rules per link: review-required (the default), lock-down and auto-cascade going down; silent, threshold (10% by default) and approval going up (vendor blog). i-nexus repeats the X-matrix and catchball at each level and cites a six-level customer deployment. |
| **Roll-up** | Asana averages percentages and sums numbers, and weights must total 100%. Cascade offers sum or average. ServiceNow offers weighted average. Profit.co lets each parent choose which sub-KRs count, has a decoupled mode, and excludes cancelled items. Atlassian Goals has no native hierarchical roll-up (community answer, **unverified**). monday rolls up only two levels (community post, **unverified**). |
| **Access by subtree** | Perdoo standard users see their own teams and sub-teams plus company goals. Cascade sets permissions per plan and shows a private parent as "Private plan". WorkBoard sets view permissions per OKR, and team OKRs are visible to the whole organisation by default. In Workday, role assignments are inherited down hierarchies. In Oracle P6 the opposite holds: rights on an OBS element do not pass to its children. |
| **Admin and import** | WorkBoard: only admins create functional teams; Workday sync makes the structure mirror Workday; OKR Excel import is Enterprise-only and goes through support. Viva Goals: team import by Excel, owner set by email; the structure "can't be reversed", and archiving a parent turns its sub-teams into independent teams. Profit.co: CSV import fails if a department does not already exist, while BambooHR sync auto-creates departments but does not carry deletions over. Betterworks: the HR feed overwrites manual edits. Atlassian: no public API to write the team hierarchy. |
| **Change over time** | Workday groups reorganisation actions into an event with one effective date, and allows only one future-dated reorganisation per org. SuccessFactors effective-dates units and their heads. I found no OKR tool with effective-dated org history (**unverified absence**). |
| **Complaints** | Rigid cascades for cross-functional work: a Profit.co claim about WorkBoard, **unverified**. Perdoo refuses to align one KR to several objectives because it "ruins the cascade" (review). Betterworks itself writes that many-layer cascades give "very little return". Asana sums unrelated numbers (200 tickets + 3 hires = 203). Atlassian has no combined goal-hierarchy view. Anaplan forces dummy levels to balance ragged hierarchies. |

---

## Appendix B: vendor comparison

| Product | Hierarchy model | Matrix / legal | Goal attaches to | Cascade semantics | Roll-up | Access by subtree | Admin and import | Known complaints |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| WorkBoard (incl. Quantive since May 2025) | Functional teams with parent teams, created by admins only | Dynamic teams (working groups) sit outside the org view; no legal model found | Team or individual | Parent alignment; full alignment report | Progress through alignment (detail **unverified**) | Per-OKR view permissions; team OKRs visible to the whole organisation by default | Workday sync mirrors structure; Excel OKR import is Enterprise-only, via support | Rigid for cross-functional teams (competitor claim, **unverified**) |
| Quantive Results | Parent and child teams; org chart built automatically | Not found | Team or person, with a Parent field | Align up; mandatory alignment via customer success manager | Through alignment | Per-session permissions by employee, team, role or account | Not found | Not found |
| Cascade | "Plans" linked parent and child; suggested four layers | Multi-location set-up needs planning (review) | Plan, owner and collaborators | Upward contribution across plans | Sum or average for metrics | Permissions per plan; private parent shown as "Private plan" | Not found | Hard to attach metrics to initiatives (review) |
| Perdoo | Teams and nested sub-teams; multi-company via nesting | Membership not inherited by the parent team | Team, a lead and contributors | Align to any OKR, optional | Aligned children push parent progress | Users see their own teams and sub-teams plus company goals | Admins create teams | Cannot align one KR to several objectives (review) |
| Profit.co | Departments and sub-departments; company → department → team → individual | Not found | Department, team or individual | Align up plus propagation rules (review, lock-down, auto) | Configurable, including decoupled; cancelled excluded | Team visibility and access list | CSV import blocks on a missing department; BambooHR sync auto-creates departments but does not delete | Not found |
| Viva Goals (retired 31 Dec 2025) | Teams and sub-teams | Not found | Team or owner | Parent OKR | Through alignment | Private teams only for Microsoft 365-connected teams | Excel team import, owner by email; structure cannot be reversed | Archiving a parent orphans its sub-teams |
| Betterworks | Departments mirrored from HR | Reporting lines from HR | Person or department | Company → team → individual | Bidirectional (patent) | Not found | HR feed overwrites manual edits | Many-layer cascades bring "little return" (vendor's own words) |
| i-nexus | Hoshin levels, configured per customer (six-level example) | Not found | X-matrix per level | Catchball at each level | Not found | Not found | Not found | Not found |
| Planview Portfolios | Configurable structures (strategy, work, resource, org-resource); strategy capped at 5 levels | Org-resource structure for roles | Strategy and outcome nodes | Work linked to strategy | Not found | Structure-based (**unverified**) | Admin defines levels | Milestones only at the lowest strategy level (community) |
| Broadcom Clarity | OBS with admin-named levels | Several OBS trees (**unverified**) | Investment linked to OBS unit | Not applicable | Portfolio and business-unit aggregation | OBS used for security (**unverified** for current version) | Admin OBS screens | Not found |
| ServiceNow SPM | Portfolio plans built on a "lens"; goals tied to any owning entity | Not found | Entity | Optional parent goal; "not aligned" cards | Weighted average; targets fed from cost and benefit plans | Plan-based (**unverified**) | Not found | Terminology changes between releases |
| Workday HCM | Supervisory, cost-centre, company and matrix orgs, each a separate hierarchy | One supervisory org and many matrix orgs; company = legal entity | Not applicable (goals module not researched) | Not applicable | Not applicable | Role assignments inherited through hierarchies | Reorganisation events with an effective date; one future-dated reorganisation per org | Not found |
| SAP SuccessFactors | Typed and effective-dated: Legal Entity, Business Unit, Division, Department | Matrix manager not researched | Person's goal plan | Push only; two levels down; one template | Not found | Role-based permissions | Effective-dated heads | Timeouts above 40 cascaded goals; recipient picker caps at 20 |
| Anaplan | Lists: composite (balanced) or ragged parent-child | Alternate hierarchies as separate lists | Not applicable | Not applicable | Native aggregation | Selective access per list (**unverified**) | Import | Dummy levels; input only at the leaf in ragged lists |
| Board | Entities; unbalanced hierarchies since v12 | Several relationships via extra parents | Not applicable | Not applicable | Native aggregation | Not found | Not found | Not found |
| Asana | Teams (divisions on enterprise plans) | Not found | Team, owner and parent goal | Align up | Average (%), sum (numbers); weights total 100%; up to 100 items | Public or private goals; team-level visibility disputed | Not found | Meaningless sums; no drag to re-parent |
| monday.com | Workspaces and boards; goals at company, team and individual level | Not found | Board | Connected boards | Two levels natively (**unverified**) | Board permissions | Not found | No native cascading (competitor claim) |
| ClickUp | Workspace → Space → Folder → List; goals in folders | Not found | Goal folder | Targets linked to tasks | Folder-level; numeric targets updated by hand | Not found | Not found | Cannot filter "my goals"; targets hidden |
| Atlassian | Team Hierarchy (one parent, at most 25 sub-teams); Focus over Jira Align | Not found | Team, owner and sub-goals | Sub-goals; Focus areas | No native hierarchical roll-up (community, **unverified**) | Edit rights on teams | No public API to write the hierarchy | No combined goal-hierarchy view |

## Appendix C: sources

- WorkBoard: [functional teams](https://help.workboard.com/en/articles/13341335-create-and-manage-functional-teams), [teams overview](https://help.workboard.com/en/articles/13341327-workboard-teams-overview), [OKR alignment](https://help.workboard.com/en/articles/13341186-view-and-publish-okr-alignment), [Excel import](https://help.workboard.com/en/articles/13341146-import-objectives-key-results-with-excel-template), [Workday integration](https://help.workboard.com/en/articles/13341407-workboard-workday-integration-automated-users-teams-management), [view permissions](https://help.workboard.com/en/articles/13341145-manage-okr-view-permissions), [Profit.co comparison (competitor)](https://www.profit.co/compare/okr/profit-co-vs-workboard)
- Quantive: [organisational chart](https://help.quantive.com/en/articles/3671571-organizational-chart), [aligning OKRs](https://help.quantive.com/en/articles/8794862-aligning-okrs), [mandatory alignment](https://help.quantive.com/en/articles/6737592-mandatory-alignment-of-okrs), [set permissions](https://help.quantive.com/en/articles/2278889-set-permissions)
- Cascade: [strategy model](https://support.cascade.app/understanding-the-cascade-strategy-model), [OKR software](https://www.cascade.app/solutions/okr-software?hsLang=en), [strategy frameworks](https://www.cascade.app/solutions/strategy-frameworks), [plan permissions](https://support.cascade.app/plan-permissions-), [access and permissions](https://support.cascade.app/access-and-permissions), [Capterra reviews](https://www.capterra.com/p/148008/Cascade-Strategy/reviews/)
- Perdoo: [multi-company group structure](https://support.perdoo.com/en/articles/12928854-multi-company-group-structure), [sub-teams](https://support.perdoo.com/en/articles/4396290-subteams), [aligning OKRs](https://support.perdoo.com/en/articles/5391069-aligning-okrs), [private OKRs](https://support.perdoo.com/en/articles/5040665-make-okrs-or-kpis-private), [G2 features](https://www.g2.com/products/perdoo/features)
- Profit.co: [OKR alignment tree](https://www.profit.co/blog/okr-university/okr-alignment/), [July 2026 release](https://www.profit.co/release-updates/july-2026/), [propagation rules](https://www.profit.co/blog/adaptive-planning/hierarchical-planning/plan-propagation-rules-controlling-what-changes-cascade-and-what-stays-local/), [parent department](https://profit.co/answers/general/settings-preferences/how-do-i-create-a-parent-department-for-an-existing-department), [import users](https://www.profit.co/answers/general/settings-preferences/how-do-i-import-users-in-profit-co/), [BambooHR](https://www.profit.co/integrations/okrs-for-bamboohr/), [team visibility](https://profit.co/answers/okrs/how-can-i-set-the-team-visibility-and-the-access-list)
- Viva Goals: [teams and sub-teams](https://learn.microsoft.com/en-us/viva/goals/create-and-edit-teams-and-subteams), [orgs and teams](https://learn.microsoft.com/en-sg/viva/goals/understand-orgs-and-teams), [edit permissions](https://learn.microsoft.com/en-us/viva/goals/edit-permissions), [OKR import](https://learn.microsoft.com/en-us/viva/goals/import-okrs-projects)
- Betterworks: [integrations](https://betterworks.com/integrations), [HRIS article](https://support.betterworks.com/hc/en-us/articles/217499506), [patents](https://patents.justia.com/assignee/betterworks-systems-inc)
- i-nexus: [X-matrix explained](https://blog.i-nexus.com/hoshin-kanri-x-matrix-explained), [aircraft case study](https://info.i-nexus.com/case-study/hoshin-kanri-aircraft)
- Planview: [primary structures](https://success.planview.com/Planview_Portfolios/Administration/Structures/10_Primary_Structures), [resource management set-up](https://success.planview.com/capabilities/Resource_Management/02Design_and_set_up), [community: multi-level programmes](https://community.planview.com/ask-the-community-67/how-do-you-structure-multi-level-programs-in-portfolios-802)
- Clarity and OBS: [Clarity OBS levels](https://ftpdocs.broadcom.com/cadocs/0/CA%20Clarity%20PPM%2012%201%200-ENU/Bookshelf_Files/HTML/Administration/422422.html), [Clarity organisational OBS](https://ftpdocs.broadcom.com/cadocs/0/CA%20Clarity%20PPM%2014%201%2000%20%20On%20Demand%20-ENU/Bookshelf_Files/HTML/pmoaccel/1812310.html), [Oracle P6 OBS security](https://docs.oracle.com/cd/F88968_01/client_help/en_US/obs_security.htm)
- ServiceNow: [portfolio plans](https://www.servicenow.com/docs/r/s8BPDWDEVTaN0SLuos4GTg/jxLp~RZUoLS8g3cxvmKgVw), [managing goals](https://www.servicenow.com/docs/r/4Pll~Vzr5Rr79UNYLnUdJw/zkb692BtGnRamV1vHYBlpw), [Goal Framework](https://www.servicenow.com/docs/r/cVzHwL~N5hQ70Ca9r7fiZg/nfOmuFPGs0C~L6pNrOM_9A)
- Workday: [organisations and hierarchies](https://doc.workday.com/workday-education/en-us/course-manuals/hcm-core-for-administrators/organizations-and-hierarchies.html), [matrix organisations](https://doc.workday.com/admin-guide/en-us/manage-workday/organizations/steps_set_up_matrix_organizations_business_process.html), [W&M sup orgs and cost centres](https://www.wm.edu/sites/workday/recent-activities/uhr-workday-tip-of-the-month-sup-orgs-cost-centers.php), [reorganisation concepts](https://doc.workday.com/admin-guide/en-us/manage-workday/organizations/manage-organization-concepts/dan1370796343360.html), [Alight reorganisation guide](https://alight.com/library/a-guide-for-workday-reorganizations)
- SAP SuccessFactors: [foundation objects](https://learning.sap.com/courses/sap-successfactors-employee-central-core-administration/introducing-foundation-objects), [associating foundation objects](https://learning.sap.com/courses/sap-successfactors-employee-central-core-administration/associating-foundation-objects), KBAs [3308727](https://userapps.support.sap.com/sap/support/knowledge/en/3308727), [3042997](https://userapps.support.sap.com/sap/support/knowledge/en/3042997), [2072032](https://userapps.support.sap.com/sap/support/knowledge/en/2072032), [3584863](https://userapps.support.sap.com/sap/support/knowledge/en/3584863), [2072675](https://userapps.support.sap.com/sap/support/knowledge/en/2072675)
- Anaplan: [composite vs ragged (Planual)](https://community.anaplan.com/kb/articles/71183-1-05-08-use-composite-lists-rather-than-ragged), [two approaches to ragged hierarchy](https://community.anaplan.com/discussion/154586/two-approaches-to-ragged-hierarchy)
- Board: [unbalanced hierarchies](https://help.board.com/docs/new-unbalanced-hierarchies-feature-for-entities), [multiple relationships](https://community.board.com/discussion/17383/how-to-make-multiple-relationships-coexist-in-the-same-hierarchy)
- Asana: [goal progress](https://help.asana.com/s/article/progress-status-and-connecting-work-to-goals), [weighted goals](https://help.asana.com/s/article/weighted-goals), [goals privacy](https://help.asana.com/s/article/goals-privacy-and-sharing), [forum: sub-goal sums](https://forum.asana.com/t/goal-subgoal-automatic-numeric-reporting-up-doesnt-count-subgoals/349686)
- monday.com: [community: multi-level hierarchy](https://community.monday.com/t/connecting-boards-in-a-multi-level-hierachy/121664), [OKR software blog](https://monday.com/blog/project-management/okr-software/)
- ClickUp: [hierarchy for goals](https://help.clickup.com/hc/en-us/articles/30806266190103-Organize-your-Hierarchy-for-goals-and-OKRs), [goals v2 feedback](https://feedback.clickup.com/feature-requests/p/goals-v2)
- Atlassian: [team hierarchy](https://support.atlassian.com/platform-experiences/docs/represent-your-organizations-hierarchy-with-teams/), [JRACLOUD-97860](https://jira.atlassian.com/browse/JRACLOUD-97860), [goal roll-up question](https://community.atlassian.com/forums/Jira-questions/Can-t-roll-up-progress-from-objectives-sub-goals-to-strategic/qaq-p/3187784), [Focus FAQ](https://praecipio.com/resources/faqs/atlassian-focus-faq)
- PE tools: [Maestro](https://go-maestro.com/platform), [Shibumi for private equity](https://shibumi.com/private-equity-shibumi/), [Accordion on operating partners](https://www.accordion.com/our-insights/knowledge/5-things-operating-partners-expect-from-your-cpm-epm/)
- Cascading criticism: [Mind the Product](https://www.mindtheproduct.com/cascading-okrs-more-trouble-than-its-worth/), [Allan Kelly](https://www.allankelly.net/archives/6377/the-difficulties-of-cascading-okrs/), [Tability](https://tability.io/okrs/cascading-vs-aligning-okrs)
