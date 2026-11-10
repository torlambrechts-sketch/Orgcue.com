# Organisation structure and true cascading: SaaS founder's paper

Lens: product design and adoption. In both my collaboration companies, the org model decided whether customers got past week two. Basis: the brief, `docs/database.md`, the earlier panel papers, a grep of `public/project-portfolio.html` and vendor help pages (marked as not tested).

## Key recommendations

1. **Configurable level types, one tree, the customer's eight levels as a template.** Branches may skip levels and some types may nest (sub-departments). The default for a new workspace is Company › Department › Team. **Individual is not a node:** people are members of units, and personal goals hang off the person.
2. **A small data model: three tables and one column.** `org_level_types`, `org_units` (adjacency list, `parent_id`) and `org_unit_members`, plus an owning `unit_id` on `objectives`, `measures`, `okr_objectives` and `initiatives`. Tasks inherit from their initiative. No closure table or stored path in phase 1: a recursive query over a few hundred units costs nothing, and the page already loads the whole workspace.
3. **Migrate without rewriting references.** The 5 `units` and 13 `teams` become `org_units` **with their existing ids** ("Delivery", "Delivery/PMO"). Every `unit_id` and `team_id` in `unit_objectives`, `target_proposals`, `commitment_targets`, `pulse_scores` and `triage_queues` stays valid, and existing pages keep working.
4. **Zero to a full organisation in ten minutes.** Admin › Organisation offers a template picker, **paste an indented outline**, CSV with emails, drag to move with an impact preview, bulk edit, and archive instead of delete. HR sync comes later, as a **review queue**, never as silent overwrites.
5. **One unit switcher and one scope filter, defaulting to "my unit".** Each list offers *This unit*, *This unit and below* or *Everything I can see*. The unit page has three bands: **Asked of us**, **Ours** and **Below us**.
6. **Cascading is opt-in and shallow.** "Ask units to contribute" targets named child units, one or two levels down, and accepts "not relevant" as an answer.
   - Inherited items are shown, not copied.
   - Numbers roll up only when the measure says how.
   - Reuse catchball (`target_proposals`) and `kr_contributions`; do not build a third workflow.
7. **Access follows the tree in phase 2, with walls between portfolio companies.** It builds on the scoped loading already written for guests. Walls gate the PE launch.
8. **Demo: MosaicX stays the hero, with a thin holding layer above it** and one small second portfolio company, so the switcher, comparison and walls can be shown. The demo still opens on MosaicX.

## Reasoning per question

### 1. The ideal structure

**Fixed or configurable.** Configurable. Group, Corporation and Company mean different things in each firm, and most of our core buyers have three or four levels. Fixed levels would make a 400-person consultancy click through five empty layers.

**`org_level_types`:** name, plural, rank, `nestable`, `is_legal_entity`, icon.

- A child's rank must exceed its parent's, or equal it if the type is nestable.
- That allows skipped levels and sub-departments but blocks a Team above a Company.
- A deferred trigger enforces this and blocks cycles, because writes arrive through the generic `orgcue_apply`.

Cascade and Perdoo let units nest to any depth under a chosen parent. I found no typed levels in their help pages (not tested).

**`org_units` columns:**

- `parent_id`, `level_type_id`, `name`, `code`;
- `head_id` → people;
- `country_code`, `currency`;
- `legal_entity_id`;
- `is_boundary` (phase 2);
- `status`, `valid_from`, `valid_to`;
- `external_id` (HR key);
- `merged_into`.

**Matrix.** One primary tree, plus two cheap escape hatches:

- `org_unit_members` (unit, person, role head, deputy or member, `is_primary`, optional FTE share) lets a person sit in several teams.
- `country_code` makes "all of Germany across business lines" a filter, not a second hierarchy.

A true second tree waits for a paying customer who needs it.

**Legal versus management.** The management tree is primary, because strategy is run that way. A legal entity is a level type flagged `is_legal_entity`, or the `legal_entity_id` attribute where the two trees diverge. Statutory consolidation belongs in Board, Jedox or the ERP.

**The PE layer.** One workspace, with a holding node over portfolio companies, each a subtree. Comparability comes from a shared template and a **shared measure library** (one definition of EBITDA margin, revenue growth and NPS, with values per company), not from fixed levels. Perdoo documents a multi-company group structure in one account (article title and snippet seen, content not verified).

**Shared services.** Group Finance sits where it is managed. It reaches other units in two ways:

- owners from outside the unit (allowed, see 3);
- in phase 2, `org_unit_links` (from, to, kind `serves` or `dotted_line`), shown as "Serves: MosaicX UK, MosaicX Nordics".

**Change over time.** Never hard-delete:

- archive sets `valid_to`;
- merge sets `merged_into` and re-points items in one transaction, logged to `audit_log`;
- `commitment_targets` already freeze results per period, so history survives a reorganisation.

Scheduled reorganisations (draft, preview, apply on a date) are phase 2. An "as at" org view is later.

### 2. Configuration under admin

Settings already has Company settings, Workspace and sign-in, Import and Audit log. Add **Organisation** with five tabs.

- **Structure.**
  - The tree is on the left, with search, counts and coverage dots: grey means no objectives yet.
  - The detail panel is on the right: level, head, deputies, members, country, legal entity and status.
  - Drag to move. A preview says "Moving Training under Consulting moves 2 objectives, 3 initiatives and 14 tasks."
  - Multi-select to bulk edit level, head, parent or status.
- **Levels.** The level types and their switches.
- **People.** Members per unit: drag avatars or paste emails, with a list of "people in no unit".
- **Import.** Outline paste, CSV (unit, parent, level, head email, member emails), and later HR sync.
- **Changes.** History and pending HR changes.

**The ten minutes:**

| Minute | Step |
| --- | --- |
| 0–1 | Pick a template: Single company; Company with countries; Group of companies; Private equity portfolio (the customer's eight levels); or "Build from what I have", which converts existing units and teams. |
| 1–4 | Paste an outline from Excel or Notes. Indentation sets the parent, and level types are guessed by depth and corrected in one table. This beats any form. |
| 4–7 | Heads: autocomplete against people. Unknown names become pending invitations. |
| 7–10 | Members: paste "email, unit", or skip and ask "Which team are you in?" in the existing first-run welcome card. |

**HR sync** comes later, through a unified HRIS API or SCIM groups for Enterprise.

- HR-owned fields (name, parent, membership, external id) become read-only.
- OrgCue-owned fields (level type, links, strategy items) are never touched.
- Changes arrive as "14 changes from HR since Monday". Each is checked for impact, and the admin accepts them in bulk.

Some vendors lock HR-managed teams or revert local edits on the next sync (help pages, not tested). A review queue avoids both.

### 3. Ownership

- Every unit has one `head_id`. Deputies are member rows with role `deputy` and share the head's approval rights.
- Objectives, measures, OKRs and initiatives get a required `unit_id`, which defaults to the creator's primary unit, alongside the existing owner.
- A task's `unit_id` is null by default and inherits from its initiative. It is set only when another unit does the work, which is exactly the shared-services signal we want.
- **The owner need not be a member of the owning unit.** Matrix and shared services make a hard rule false on day one.
  - The picker suggests the head and members first.
  - An outsider triggers a soft note ("Jonas is in Technology, not Delivery"), not a block.
- `object_roles` and accept or decline stay as they are.

### 4. Cascade, inherit, align, create

| | Cascade down | Inherit | Align up | Create local |
| --- | --- | --- | --- | --- |
| Objectives | The parent asks named child units. This creates `target_proposals` (kind `align`). The child links or creates an objective, counter-proposes, or declines with a reason. | Parent objectives are shown read-only as context. Nothing is copied. | The child sets `parent_id`. The parent owner can reject the link. | `unit_id`, no parent. Allowed, and shown on coverage ("3 of Delivery's 5 objectives align"). |
| Measures and KRs | Ask for a share (`kr_contributions`). | The parent measure is shown, with an optional local target in `commitment_targets`. | Link to the parent measure with a roll-up rule. | Local measure. |
| Initiatives | Not cascaded: they are funded decisions. Parents request them through intake. | Shown where a child unit owns tasks. | They link to objectives (as today). | Normal. |
| Tasks | No. | No. | Through the initiative. | Normal. |

**Roll-up rules** live on the parent measure: `none` (the default), `sum`, `average`, `weighted` and `worst_of`.

- `sum` is offered only when all children share the measure's unit and currency and are flagged additive. No more KPI trees that add NPS to revenue.
- Weights are explicit, as `unit_objectives.weight` already is.
- **Status rolls up as worst-of plus a count** ("At risk: 2 of 6 contributors off track"). Green and red never average to amber.

**Where it stops.** Objectives and measures stop at Team. People get key results and tasks.

**"Individual strategy" means personal commitments:** the KRs and tasks I own, plus my contributions, shown as a "My goals" strip on My work. Development goals are HR territory (Lattice and Betterworks), so they are later, and only if customers ask.

### 5. Views

- **Switcher.** A breadcrumb in the top bar ("Aldmoor Capital › MosaicX Group › MosaicX UK › Delivery ▾") with search. It starts at the primary membership.
- **Scope filter.** The same three-way control on objectives, KPIs, initiatives, tasks, the review pack and dashboards (`dashboard_widgets` gains `unit_scope`).
- **Unit page.**
  - A header: head, deputies, members and parent.
  - **Asked of us**: requests with Accept, Propose and Not relevant buttons.
  - **Ours**: the unit's own items.
  - **Below us**: child tiles, exceptions first.
  - It is never empty: a new unit sees the parent's objectives and "Pick the ones Delivery contributes to". One click aligns.

First screens:

| Who | First screen |
| --- | --- |
| PE partner or group CEO | Portfolio companies as comparable tiles from the measure library, sorted by gap |
| Country or company manager | Their company page and the review pack, scoped to their subtree |
| Team lead | The team page: "Asked of us" first, then team OKRs and workload |
| Individual | My work with the "My goals" strip, never an org chart |

### 6. Access

- **Phase 1:** no change. Workspace roles stay as they are.
- **Phase 2:** `org_unit_grants` (member, unit, editor or viewer, `include_subtree`).
  - Heads and deputies edit their subtree automatically.
  - Inside one company everyone keeps read access, because hiding peers' goals kills alignment and adoption.
  - `is_boundary` units (portfolio companies) are walls. Members of one cannot load another, and holding-level grants see everything.
  - `orgcue_load` already filters guest rows. We extend that logic with a recursive CTE over `org_units` and the `unit_id` columns.

### 7. Migration

| Today | New |
| --- | --- |
| `units` (5) | `org_units`, level Department, same ids, under the MosaicX UK node; `lead` → `head_id` plus a membership |
| `teams` (13) | `org_units`, level Team, same ids, parent = `unit_id` |
| `unit_objectives`, `unit_measures` | Phase 1: read as the unit's objectives. Phase 2: merged into `objectives`, ending one more "same thing modelled twice". |
| `team_objectives` | Alignment rows |
| `okr_objectives.team` (text) | `unit_id` matched by name; misses listed for the admin |
| `initiatives` | Company root, plus a bulk-edit list "10 initiatives have no owning department". No silent guessing. |
| `people` | Memberships: by hand for the demo; import or first sign-in for customers |

In phase 1, a `dbCollection` adapter also writes the legacy `units` and `teams` rows, so `st-org`, `st-units`, the heat map and pulse keep working until they move.

**MosaicX demo (names illustrative; check they are not real firms):**

- Aldmoor Capital (PE holding)
  - MosaicX Group
    - MosaicX UK Ltd (Company, legal entity; head Dianne Miles)
      - Commercial (PR)
      - Delivery (ML)
      - Technology (JK)
      - People & Culture (DN)
      - Finance (LM)
      - Each department keeps its existing teams.
    - MosaicX Nordics AB (new and small). This gives "Win in two new markets" a home.
  - Fieldline (about 40 rows: 3 departments and a 6-measure scorecard from the shared library)

There is no Country level, which shows skipped levels.

### 8. Pitfalls

- **Deep cascades nobody maintains.** Avoid them with opt-in asks, a two-level default, "not relevant" as a valid answer, and inherit-by-reference instead of copies that go stale.
- **KPI trees that add up unrelated numbers.** Avoid them with `none` as the default roll-up and `sum` only for additive measures.
- **Org charts out of sync with HR.** Avoid them with the review queue, external ids and the "people in no unit" list.
- **Goals tools without a home in daily work struggle.** Microsoft retired Viva Goals on 31 December 2025 (Microsoft Learn). Our thread to tasks is the defence.

## Disagreements I expect

- **Strategy consultant and PE partner: "Fix the eight levels for comparability."** Comparability comes from the template and the measure library. Forcing eight levels on single-company buyers loses our core market.
- **Strategy consultant: "Catchball at every level."** That is the deep cascade nobody maintains. Deeper cascades can be a setting, but not the default.
- **PMO director: "Every task needs a unit, and capacity per unit."** Inheritance gives the same answer with no data entry. Unit capacity can come later from `role_people` plus memberships.
- **Market analyst: "Enterprise expects HRIS sync and SCIM now."** For Enterprise, yes, so it goes in Next. Paste and CSV close the first deal.
- **PE partner: "Walls on day one."** Walls gate the PE launch, not phase 1 for single-company customers.

## What to build first and what later

- **Phase 1:**
  - the three tables and `unit_id`;
  - migration with the same ids;
  - Admin › Organisation (templates, paste, CSV, drag, bulk edit, archive);
  - the switcher, the scope filter and the unit page;
  - cascades on `target_proposals` and `kr_contributions`;
  - the demo holding.
- **Phase 2:**
  - grants and walls;
  - merge and scheduled reorganisations;
  - `org_unit_links`;
  - one objectives table;
  - the portfolio comparison view;
  - the HR review queue.
- **Later:**
  - HRIS connectors and SCIM groups;
  - a second matrix tree;
  - as-at history;
  - development goals;
  - a stored path or closure table, if profiling asks for one.

## Summary of recommendations

- **Structure:** configurable levels with templates (the customer's eight as the PE template), with skipped and nested levels. People are members, not nodes.
- **Data model:** three tables plus an owning `unit_id`. Tasks inherit, and the tree is an adjacency list.
- **Migration:** keep the current ids so nothing breaks.
- **Admin:** ten minutes from template and outline paste to a full org. HR sync later, through a review queue.
- **Views:** one switcher, one scope filter and a unit page that is never empty.
- **Cascade:** opt-in and shallow, on the existing catchball. Explicit roll-ups and worst-of status. Individuals get commitments, not strategies.
- **Access:** tree-based access in phase 2, with walls before the PE pitch.
- **Demo:** MosaicX stays the hero under a small fictional holding.

Sources (help pages, not tested in the products): support.perdoo.com (sub-teams; multi-company group structure); help.cascade.app (organisational units); help.gtmhub.com (organisation chart); Leapsome, Yoodli and WeThrive help pages; learn.microsoft.com (Viva Goals retirement).
