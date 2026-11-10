# The organisation structure and true cascading: PMO director's paper

My lens is the group PMO, which must say every month, for any node of the organisation, what we are doing, who pays, who does the work and whether it is on track, across legal entities and reorganisations, without counting anything twice.

## Key recommendations

1. **Keep three hierarchies apart and link them.** The *organisation tree* (who we are), the *legal-entity view* (who books the cost) and the *portfolio tree* (portfolio → programme → initiative → task) are different trees; Planview and Clarity both keep work and organisation structures separate. A programme such as MosaicX "Digital core" crosses units, so it must not become an org node.
2. **Make level types configurable, with the customer's eight as the default template, and let depth vary by branch.** "Individual" is not a level: people are members of units, not nodes.
3. **Every initiative has exactly one owning unit, plus optional sponsoring, contributing and benefiting units.** Roll-ups count an item in full only in its owning unit's subtree; contributing units see it under "contributed to", with only their share of money and capacity.
4. **Give every tree object an owning unit and an accountable person, with a soft rule between them.** The owner should belong to the owning unit or an ancestor; a breach warns rather than blocks, unless the workspace makes it strict.
5. **Effective-dated reorganisations, not edits.** A move, merge, split or archive is a dated `org_changes` event, usually tied to a decision. A unit cannot be archived while it owns open items.
6. **Roll up by rule per number, never by habit.** Money is summed in one reporting currency. Status shows the spread of child statuses next to the owner's own call, never an average. KPIs roll up only when they share a definition and are declared additive.
7. **Access follows the tree, in two phases.** Phase 1: a global unit filter, plus edit rights for unit heads on their subtree. Phase 2: hard visibility boundaries at portfolio-company nodes, enforced in the database, for the PE case.
8. **Build the owning unit first, everywhere, before anything clever.** An `owning_unit_id` on every object and a scope picker in the top bar give most of the value. Cascade workflows, subtree access and HR sync come after.

## Reasoning per question

### 1. The ideal structure

**Levels.** Fixed levels break on the first real customer: MosaicX Delivery has three teams, a larger client has Delivery → UK Delivery → Consulting → Banking practice. Clarity caps an OBS at ten levels ([Broadcom KB](https://knowledge.broadcom.com/external/article/27094/how-many-obs-levels-can-be-created.html)). A level type is a label with behaviour, not a depth:
- `org_level_types`: name, sort, `is_legal_entity`, `can_own_budget`, `is_boundary_default`, icon. The default template is PE fund, Group, Country, Corporation, Company, Department, Team.
- `org_units`: `parent_id`, `level_type_id`, name, code, `head_id → people`, `legal_entity_id → org_units`, `is_boundary`, currency, `valid_from`, `valid_to`, status, `external_ref`.
- **Rule:** a child must sit lower in the template order than its parent, but it may skip levels. A Company can sit directly under the Group, and a Department can hold sub-departments of the same type.

**Matrix.** One management tree plus memberships, not two trees:
- `org_memberships`: `person_id`, `unit_id`, kind (`home`, `member`, `secondment`), `fte_pct`, `valid_from`, `valid_to`.
- **One home unit per person**, where their capacity lives; the line manager defaults to its head. Other memberships say where they also work.
- **Country × business line** is a *secondary dimension*: a unit carries a `country` tag and every view can pivot by it. Planview likewise gives each resource one primary structure and keeps other attributes in alternate structures (*unverified in detail*; from search summaries of their documentation).

**Legal entity versus management.** A management node points to its legal entity through `legal_entity_id`; legal entities are units flagged `is_legal_entity`, with no separate tree in phase 1. Money then carries both: the initiative is *managed* by Commercial and *booked* to MosaicX Nordics AB. Clarity's own KB admits its "Department OBS" and "financial department" are "essentially the same thing" ([KB 263440](https://knowledge.broadcom.com/external/article/263440/unable-to-updated-department-obs-on-an-i.html)); OrgCue should have one field per question.

**The PE layer.** A portfolio company is a *boundary* node (`is_boundary = true`). People below it cannot see siblings, and fund-level people see everything. Comparability comes from a shared *definition library*, not from adding companies together:
- the same stage model;
- the same KPI definitions (EBITDA margin, revenue per FTE, utilisation);
- the same value-creation-plan template.

**Shared services.** An ordinary unit, often at Group level, that appears as a *contributing* unit on others' initiatives. For charge-back, its `share_pct` in `initiative_units` puts the cost where the customer wants it.

**Change over time.** Workday groups related changes into a reorganisation event with one effective date, allowing one future-dated reorganisation per organisation ([Workday admin guide](https://doc.workday.com/admin-guide/en-us/manage-workday/organizations/manage-organization-concepts/dan1370796343360.html), via search summary). Copy the event, skip the restriction:
- `org_changes`: `effective_on`, kind (`create`, `move`, `merge`, `split`, `rename`, `archive`), `unit_id`, `to_parent_id`, `into_unit_id`, `decision_id → decisions`, status (`planned`, `applied`).
- A nightly job applies changes that are due; history reads `valid_from` and `valid_to`, so reports can run "as at" a date.

### 2. Configuration under admin

**Admin → Organisation** has four tabs:
- **Structure:** a tree; dragging a node asks "effective from?" (default today). The right panel shows and edits head, level type, legal entity, members and owned items.
- **Level types:** the template list with behaviour switches.
- **People:** a grid with home unit, other memberships, FTE % and line manager, with bulk edit.
- **Changes:** planned and applied reorganisations, each linked to its decision.

**Zero to structure in ten minutes:**
1. Pick a template: single company, group with countries, or PE fund with portfolio companies.
2. Upload a units CSV (`unit, parent, type, head_email, legal_entity`).
3. Upload a people CSV (`person_email, home_unit, fte, manager_email`), easily mapped from an HR export.
4. Review a diff of new, moved and unmatched rows.

Merge moves every owned item and membership to the target in one dated event. Archive is blocked while open items remain, and it offers "reassign all to…".

### 3. Ownership

- **Unit head and deputies.** `org_units.head_id` holds the accountable head. Deputies reuse `object_roles`, with `ref = unit:<id>` and `role = deputy`. A second mechanism is not needed.
- **Owned items.** Objectives, measures, initiatives, programmes and tasks each get `owning_unit_id` plus their existing owner person.
- **Initiatives also get** `initiative_units` (`initiative_id`, `unit_id`, role `sponsoring|contributing|benefiting`, `share_pct`). The owning unit stays a column, so "exactly one owner" is enforced by the schema.
- **Defaults.** A new item takes the creator's current scope; a task takes its owner's home unit, meaning the *performing* unit, which can differ from the initiative's.
- **Owner and unit.** The soft rule from recommendation 4: in a matrix, a group initiative's owner often sits in a sister unit.

### 4. Cascade, inherit, align and create

| Object | Cascade down | Inherit | Align up | Create local | Roll-up |
|---|---|---|---|---|---|
| Objectives | Parent asks named child units to contribute: a `target_proposals` row per child (existing catchball). | Children see parent objectives read-only, as "context". | Child objective gets `parent_objective_id` and a weight (today's `unit_objectives.objective_id` and `weight`). | Yes | Weighted score of aligned children, shown beside (never replacing) the parent's own measure. |
| Measures and KRs | Parent sets a target and asks for a child split. | Child may adopt the parent measure with a *local target*: same definition, own number. | Child KR "contributes to" parent KR. | Yes | Only when declared: `sum` (revenue, headcount), `weighted avg` (margin by revenue), `worst-of` (compliance), else `none`. |
| Initiatives | Parent spawns *child initiatives* owned by child units; the parent owns the whole. | No | Child initiative links to a parent initiative or programme, and to objectives (`initiative_objectives`). | Yes, the normal case. | Cost and benefit: sum over owned children. Status: distribution plus the owner's call. Dates: earliest start, latest finish. |
| Tasks | No. Tasks are *assigned*, not cascaded. | No | Task belongs to an initiative, as today. | Yes, unit "run" tasks with no initiative, later. | Counts and hours only. |

**Where cascading stops.**
- Objectives: three hops, for example Company → Department → Team. Deeper links are allowed but flagged.
- Initiatives: one level of child initiatives below a programme.
- Tasks: never.

**Status roll-up.** A parent shows "4 on track, 1 at risk, 1 off track" with a worst-of indicator. The owner's own status sits beside it. When the owner says green and two thirds of the children are red, the page says so.

**Individual strategy.** For a person it means work, not strategy:
- their tasks;
- KRs assigned to them;
- optionally personal development goals that are private to the person and their manager and excluded from every roll-up.

Appraisal scoring belongs in HR tools.

### 5. Views

**The unit page** has the tabs Scorecard, Portfolio, Work, People and Capacity. A scope switch at the top offers:
- **This unit:** owned items only;
- **With sub-units:** the subtree, the default;
- **Incl. contributions:** adds items this unit contributes to, marked with a "contributing" badge and showing only its share.

**The Portfolio tab** for a country is a table: initiative, role badge (Owner, Contributor, Sponsor), stage, RAG, budget, actual and forecast for this unit's share, and FTE requested from this unit.

**First screens.** Group CEO: group scorecard plus initiatives at risk across the group, sorted by money at risk. Country manager: their country page plus incoming contribution and resource requests. Team lead: work board, team KRs, capacity against demand. Individual: My work, as today.

**Filtering.** One global scope picker in the top bar sets the unit and subtree for every page: portfolio, finance, capacity, reviews. It is remembered per person. Every list gets an "Owning unit" column and filter.

### 6. Access

Clarity grants access by OBS unit with descendant or ancestor modes (from experience, *unverified for current versions*); ServiceNow added "Enterprise-Wide Deployment" partitions by department or business unit ([docs](https://www.servicenow.com/docs/r/it-business-management/explore-ewd.html)); Planview grants inherit down its structures. Access follows the tree.

- **Phase 1:**
  - `workspace_member_scopes` (`member_id`, `unit_id`, rights `view|edit|admin`, `include_descendants`);
  - edit rights on the subtree for unit heads;
  - the existing workspace role as the ceiling.
- **Phase 2:** boundary nodes enforced in `orgcue_load` and row-level security, the same way guests are scoped to initiatives today. A member below a boundary loads only rows whose owning unit is inside it, plus shared definitions.

### 7. Migration

- **Structure:** a new parent node MosaicX UK (Company, legal entity MosaicX Ltd), placed under the demo's group and fund nodes below; the five `units` become Department nodes keeping their ids, `lead` → `head_id`; the 13 `teams` become Team nodes keeping ids such as `Delivery/PMO`.
- **Scorecards:** `unit_objectives` become objectives with `owning_unit_id` and `parent_objective_id` (or stay behind a view until a later merge); `team_objectives` become alignment links.
- **People:** home unit set from `units.lead` for the five heads; for the others, proposed from `role_managers` and task history for an admin to confirm.
- **Initiatives:** owning unit proposed from the owner's unit, admin confirms: I4, I7 → Commercial; I1, I5, I6 → Delivery; I2, I8 → Technology; I3 → Technology/Security; I9 → Finance; I10 → People & Culture.
- **Contributing units:** derived from `initiative_role_demand`. For I7 Nordics market entry, Sales 2 FTE is Commercial's own work, while Consulting 2 FTE and PM 1 FTE make Delivery a contributing unit.
- **The demo's first matrix lesson:** I2 Educational platform is owned by Technology but sits in "People and skills", led by DN. People & Culture is its sponsoring unit.

**MosaicX demo.** Yes, add the PE layer:
- Mosaic Partners Fund II (fictional, PE fund) → MosaicX Group, which holds:
  - **MosaicX UK:** country and legal entity, containing today's five departments;
  - **MosaicX Nordics AB:** a planned `org_changes` create, effective Q1 2025 and tied to decision D-14. The I7 initiative literally creates a country.
- A second, small fictional portfolio company, for example "Corvane Engineering", with:
  - one scorecard on the shared KPI definitions;
  - three initiatives;
  - a boundary flag, so a demo user switching to a Corvane viewer sees MosaicX disappear.

### 8. Pitfalls

- **Deep cascades nobody maintains.** Cap the depth, flag objectives with no check-in for 60 days, and let a unit "adopt" a parent measure instead of copying it.
- **Adding unrelated numbers.** Never sum unless the measure says it is additive. Never average RAG.
- **Double counting**, the PMO classic: a £1.2M initiative shows as £1.2M in Commercial, £1.2M in Delivery and £2.4M at group. Shares solve it.
- **Org charts out of sync with HR.** Treat the HR system as the source for people and home units, and OrgCue as the source for ownership. Re-import as a diff. Never silently overwrite a move that was made in OrgCue.
- **Vendor lessons:**
  - **Clarity:** powerful OBS model, but in my experience it needs a full-time administrator.
  - **ServiceNow:** portfolios reportedly cannot nest ([community thread](https://www.servicenow.com/community/spm-forum/spm-nested-portfolios/td-p/3355274), not official), and record partitioning arrived only recently.
  - **Planview:** says portfolios "have no parents" (search summary of their documentation, *unverified*).
  - **Workday:** excellent effective dating, but it is HR's tree, not the portfolio's.

## Expected disagreements and my answers

- **Strategy consultant / PE operating partner: "Give me one comparable number per portfolio company, and cascade value-creation plans down to individuals."** Comparable, yes, through shared definitions and a fund-level comparison table, summed only when additive. Objectives can cascade far; initiatives one level; tasks not at all.
- **SaaS founder: "Separate workspaces per portfolio company are simpler. Defer access by subtree."** Separate workspaces kill the fund roll-up and duplicate configuration; boundaries in one workspace reuse the existing guest-scoping code. The hard boundary can wait for phase 2, but the owning-unit fields cannot: every month without them creates data to migrate later.
- **Market analyst: "OKR tools win on alignment UX. Leave budgets and capacity by unit to PPM suites."** The gap is that OKR tools have no money and PPM tools have no strategy. Unit, entity and share on money make OrgCue credible to a PMO buyer, as a light version of what Clarity needs consultants to set up.

## What to build first, and what later

- **Now:** `org_level_types`, `org_units`, `org_memberships`; the admin tree with CSV import; `owning_unit_id` on objectives, measures, programmes, initiatives and tasks; the global scope picker; the unit page; the migration and the PE demo.
- **Next:** `initiative_units` with roles and shares; unit and legal entity on `finance_months` and `budget_caps`; capacity by unit (`roles` and `resource_requests` routed to the supplying unit's head); `org_changes`; edit rights by subtree.
- **Later:** hard boundaries in row-level security; multi-currency per entity; HR sync; "as at" reports; a second full matrix tree, only if customers prove they need it.

## Summary

In short: three linked hierarchies (org, legal entity, portfolio); configurable levels with the customer's eight as default; one owning unit per item, with shared contributions carrying shares so nothing is counted twice; effective-dated reorganisations; roll-ups by declared rule; access by subtree in two phases; and the owning-unit fields plus a global scope picker built first.
