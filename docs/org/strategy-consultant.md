# Organisation structure and true cascading: strategy consultant and PE operating partner view

*Strategy consultant and PE operating partner, OrgCue advisory panel, November 2026. Demo facts come from `supabase/migrations/20261110090200_demo_data.sql`; vendor facts from web search summaries.*

## Key recommendations

1. **Build one org tree, not eight fixed tables.** Use a single `org_units` table with a parent, a configurable level type and dates. Ship the customer's eight levels as a template. Depth can vary by branch, so empty levels are skipped and never filled with placeholder units. "Individual" is not a level: people are members of units.
2. **Make the portfolio company a hard boundary.** One flag, `is_boundary`, marks the unit where data separation starts. Comparability across companies comes from a shared KPI dictionary and a common calendar. It never comes from shared objectives. Design for exit: a divested company must leave with its own data.
3. **Give every measure a definition from a common KPI dictionary.** A new `metric_definitions` table sets name, formula, unit, direction and how the measure may roll up. Measures are scoped instances of a definition. This removes today's duplicates, such as "Qualified Nordic pipeline" (K15 and UM4) and utilisation (K14 and UM7). It is also how a PE house compares EBITDA margin across five companies.
4. **Use one objective model with four explicit origins.** Merge `objectives` and `unit_objectives` into one table with `org_unit_id`, `parent_id`, `weight` and `origin` (cascaded, aligned, inherited or local). Catchball (`target_proposals`) becomes the only way to accept a cascaded item.
5. **Stop the strategy cascade at two levels below the unit that sets it, and at the team at the latest.** Hoshin works as breakthrough objectives, then annual objectives, then improvement priorities. Below the team, people get work (initiatives and tasks) and, if wanted, private development goals. They do not get personal strategy that rolls up.
6. **No roll-up by default.** Each measure states its roll-up rule: sum, average, weighted, worst-of, latest or none. Sum is allowed only when the children share the same definition, unit and currency. Status rolls up as a weighted score, plus a "worst child" flag that is never hidden.
7. **Every item has an owning unit and an accountable person, and the person can sit outside the unit.** The unit holds the accountability. The person can change without moving the item.
8. **Build first:** the tree, the admin screen with CSV import, `org_unit_id` on objectives, measures and initiatives, the unit page, a global scope picker and the boundary rule for read access. Leave for later: subtree edit rights, the legal-entity tree, HR sync, dated reorganisation change sets and value-creation-plan templates.

## Reasoning per question

### 1. The ideal structure

**Configurable levels with a template.** A PE fund holding a Nordic roll-up, a UK carve-out and a US platform company will never have the same depth everywhere. Fixed levels force empty "Country" nodes into single-country companies, and those attract empty scorecards nobody maintains.

Proposed tables:
- `org_level_types`: name, plural, default order, `is_boundary`, `allows_people`.
- `org_units`: `parent_id`, `level_type_id`, name, code, `head_person_id`, `country_code`, `currency`, flags `is_boundary` and `is_shared_service`, `valid_from`, `valid_to` and `archived_on`.
- `org_unit_roles`: unit, person and role (head, deputy, controller or updater).
- `org_memberships`: person, unit, `is_primary`, share of time and dates.

**Matrix organisations.** Keep one primary management parent per unit. Add the other axis as a dimension rather than a second parent. `org_dimensions` holds, for example, "Business line", and `org_unit_dimensions` tags each unit with a value. A Nordic Commercial unit sits under Nordics and is tagged "Advisory". Reports can pivot by either axis. A person can be in several teams, with one primary team. Several parents per unit would make every roll-up ambiguous.

**Legal entity versus management structure.** These are two different trees, as in Workday, which separates the supervisory organisation from the legal company (Workday documentation, from search summaries). Strategy follows the management tree. The customer's "Corporation" is usually a legal entity, so in the template it is an optional level, not a required one. A light `legal_entities` table (name, registration, country, ownership %, linked units) comes in phase 2, mainly for PE consolidation.

**The PE layer.** The template is PE house › Fund (optional) › Portfolio company (boundary) › Country (optional) › Division or department › Team. The PE house does not run the companies, so their objectives need not align upwards to a PE "strategy". It needs three things:
- the same KPIs, defined the same way;
- a value-creation plan per company, with value levers, owners and an EBITDA bridge;
- a board pack per company on the same calendar.

PE monitoring vendors say inconsistent definitions are the usual point of failure, and they fix it with common templates (Allvue and others; vendor content, **unverified**).

**Shared services.** A shared service centre is an ordinary unit with `is_shared_service`, placed where it is managed, for example Group › Shared services › IT. Other units ask it to contribute through the existing `kr_contributions` pattern, extended to objectives. It does not appear under each customer unit.

**Change over time.** Units and memberships carry `valid_from` and `valid_to`. A reorganisation is a dated change set (`org_changes`). An admin drafts the moves and merges, previews which objectives, measures and initiatives change owning unit, and applies the set on an effective date. Check-ins store the `org_unit_id` they were recorded under, so a merge does not rewrite last year's results. An acquisition adds a boundary unit. A divestment archives it and exports its data.

### 2. Configuration under admin

The screen is **Settings › Organisation**, with four tabs:
- **Tree.** A tree on the left with drag and drop to move units. A panel on the right with name, level type, head, deputies, members, country, currency, flags, effective dates, and counts of owned objectives, measures and initiatives. Actions: Add child, Move, Merge into…, Archive. Archive is blocked while live items are still owned, and offers to reassign them.
- **Level types.** Rename, reorder and add types. Mark the boundary level.
- **Import.** Upload a CSV with a path column, for example `MosaicX/Nordics/Commercial/Sales`, plus head email. A second CSV lists people with email, primary unit path and manager email. Preview, validate and apply.
- **History.** Change sets with their effective dates.

**From zero to structure in 10 minutes:**
1. Pick a template: Single company, Group with countries, or PE portfolio.
2. Paste the unit paths.
3. Paste the people.
4. Confirm the suggested heads.
5. OrgCue lists the unplaced people and the units with no head as a short to-do.

HR sync comes later. It updates memberships and heads, while the strategy tree stays editable in OrgCue.

### 3. Ownership

- Every unit has one head (accountable) and optional deputies. Deputies receive approvals and reminders during cover.
- Every objective, measure, initiative and task gets `org_unit_id` and `owner`.
  - The default owner is the unit head.
  - The default unit for a new item is the creator's current scope.
- **The owner does not have to be a member of the unit.** The demo already shows why: UO4 "Keep key clients healthy" belongs to Commercial but is owned by Marta Lindqvist, the delivery chief. In PE, an operating partner often owns a value lever inside a portfolio company. OrgCue shows a soft warning ("Owner is not in Commercial") and never blocks.
- When an owner leaves, the item stays with the unit and goes to the head's "unowned" queue.

### 4. Cascade, inherit, align and create

| Object | Cascade down | Inherit | Align up | Create local |
| --- | --- | --- | --- | --- |
| **Objectives** | The parent proposes an objective to child units through catchball. The child accepts, counter-proposes or declines. On acceptance a child objective is created with `origin = cascaded`, a `parent_id` and a weight. | The child shows the parent's objectives read-only in an "Our context" band. No copy is made. | The child links its own objective to any objective in its ancestors (`origin = aligned`). The parent owner confirms. | `origin = local`, with no parent. This is allowed, and shown as unaligned in coverage reports. |
| **Measures and KRs** | The parent asks for a contribution to a measure. The child gets an instance of the same metric definition with its own target (`parent_measure_id`). | The PE house or group publishes dictionary metrics as "mandatory for every boundary unit". Each company gets an instance with a local target and reports the actual. This is how a value-creation plan lands. | A KR links to an existing measure instead of copying it. | Local measures may use a dictionary definition or a local one. |
| **Initiatives** | No. A parent cannot cascade an initiative. It can sponsor one and name contributing units. | No. | An initiative links to one or more objectives at any level in its own boundary. | Yes. The owning unit funds and governs it. |
| **Tasks** | No. | No. | Tasks belong to an initiative, or to a unit's operating backlog. | Yes. |

**Roll-up rules.** These live on `metric_definitions.rollup` and can be overridden per measure only by an admin:
- **Sum:** only when the definition, unit and currency are the same, for example revenue in £.
- **Weighted average:** for rates, weighted by an explicit denominator, for example utilisation weighted by available hours.
- **Average:** for scores such as NPS. Show it with the spread.
- **Worst-of** for compliance, **latest** for snapshots, and **none** by default.

Across boundary units, the PE view is a **league table, not a total**. The one exception is financials converted to the reporting currency, optionally at the fund's ownership share.

**Status roll-up.** The parent shows a weighted score of its children's calculated status. Next to it, a red marker names any child that is off track. A green average must not hide a red country.

**Where cascading stops.** Objectives go at most two levels below the setting unit. Company objectives cascade to departments, departments to teams, and teams use KRs and initiatives. If a group sets objectives, its companies take them as context and cascade within their own boundary. Deeper, the bottom tier becomes rewording nobody updates.

**Individual "strategy".** For a person this means:
- their work: assigned tasks and owned KRs;
- optionally, private development goals visible only to the person and their manager.

Personal objectives that roll up numerically create appraisal gaming. I would not offer them.

### 5. Views

A unit page (`/#org/<unit>`) has a header with the unit, its head and the breadcrumb, and three tabs:
- **Our plan:** own items, both cascaded-in and local, plus contributions asked of us. This is the default tab.
- **Context:** inherited parent objectives and mandatory metrics, read-only.
- **Below us:** the children's roll-up as a heat map, with objectives as rows and child units as columns. It reuses `objective_unit_health`.

A **global scope picker** in the top bar ("Viewing: MosaicX › Commercial ▾", with "include sub-units" ticked by default) filters every list page: initiatives, tasks, measures, risks and decisions.

What each person sees first:
- **PE operating partner:** a portfolio league table, with one row per company. Columns: VCP lever status, the dictionary KPIs against plan, cash, and the next board date.
- **Group CEO:** the group scorecard with the companies heat map and exceptions first.
- **Country manager:** the country unit page, Our plan tab, with overdue check-ins.
- **Team lead:** team KRs, the team's initiatives and the overdue list.
- **Individual:** My work (`wk-my`), with their KRs and tasks.

### 6. Access

Access comes in three phases:
1. **Boundary read separation.** Members are scoped to one or more boundary units. Viewers in company A cannot load company B. PE-level members see all boundary units. Implement it like guest scopes: a `member_scopes` table (member, `org_unit_id`, right), enforced in `orgcue_load` and `orgcue_apply`.
2. **Subtree edit rights.** A unit head and their deputies can edit within their subtree. Others can view and comment.
3. **Sensitive fields.** Finance and compensation-adjacent measures are restricted to named roles.

Phase 1 matters most commercially: no PE house will put two portfolio companies in one workspace without it.

### 7. Migration

Today's tables map as follows:

| Today | New model |
| --- | --- |
| Workspace company | Root unit "MosaicX" (level: Company, boundary) |
| `units` (5) | Department units. `lead` becomes the head. |
| `teams` (13) | Team units under each department |
| `objectives` (12) | Objectives on MosaicX, `origin = local` |
| `unit_objectives` (15) | Objectives on the departments, `origin = cascaded`, `parent_id` = the company objective, weight kept |
| `measures` and `unit_measures` | Measures with `org_unit_id`. Same-named pairs (K14/UM7, K15/UM4, K17/UM9) are linked to one metric definition. |
| `team_objectives` (17) | Alignment links from team to company objective |
| `okr_objectives.team` | `org_unit_id` of the team |
| `initiatives` | `org_unit_id` = the owner's department (I7 Nordics → Commercial) |
| `people` | Memberships for the five unit heads. The others go to an "unplaced" queue. |

**For the demo, add the PE layer.** Add a fictional holding, "Aldervale Capital", with one fund and two portfolio companies (check that the names are not in real use). The companies are MosaicX and a smaller, fictional software company, "Brightfield Software".
- Under MosaicX, add a UK and a Nordics country level for Commercial only. This shows variable depth and ties to I7 "Nordics market entry".
- Technology becomes a shared service.
- Seed a 6-metric PE dictionary: revenue, recurring revenue %, EBITDA margin, cash conversion, client retention and employee engagement.
- Seed a two-company league table and one value-creation plan per company.

## Disagreements I expect, and my answers

- **PMO director:** "Initiatives belong to programmes and portfolios that cut across the tree." Agreed: the programme stays a separate dimension. An initiative still needs one owning unit for funding and accountability, and contributing units are added as roles.
- **SaaS founder:** "Fixed levels ship faster," or "Put each portfolio company in its own workspace." On levels, a generic tree is no harder to build than eight fixed tables, and it is far cheaper than a migration later. On workspaces, separate workspaces make comparison and the shared dictionary a cross-tenant problem. One workspace with a hard boundary and a clean export on exit is better. I accept that the boundary must be enforced server-side, not in the page.
- **Market analyst:** "Buyers expect individual OKRs and HRIS sync." Perdoo's multi-company setup shows members only their own teams' goals plus the parent company's (search summary, **unverified**); I would match that. I would offer personal goals as opt-in and outside roll-ups, and HR sync in phase 2 with CSV import now.
- **The customer:** "We want all eight levels." They get them as the default template. A level is skipped where it adds no decision.

## Pitfalls

- **Deep cascades nobody maintains.** Enforce the two-level rule with a soft limit and a warning. Flag objectives with no check-in for two periods as stale.
- **KPI trees that add up unrelated numbers.** Roll-up defaults to none, sum needs a shared definition, and the PE view compares rather than adds.
- **Org charts out of sync with HR.** HR feeds people and heads; OrgCue owns the strategy units and reports the differences.

## Summary

Build one configurable tree, with the customer's eight levels as a template, and make the portfolio company a hard, exit-ready boundary. Compare companies through a shared KPI dictionary, not shared objectives. Use one objective model with explicit origins and catchball. Stop the cascade at the team, roll up nothing by default, and give every item an owning unit plus an accountable person. Ship the tree, admin import, the unit page, the scope picker and boundary access first.

*Sources (from search summaries): Workday organisation documentation (doc.workday.com); Perdoo support articles on nested groups and multi-company group structure (support.perdoo.com, which could not be fetched directly); Cascade's "Understanding the Cascade strategy model" (support.cascade.app); Allvue guidance on portfolio KPI templates (allvuesystems.com).*
