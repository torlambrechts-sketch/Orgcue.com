# File 2 — Owner workspace · spec (v2, updated spec of Oct 19)

Entry: `Product Prototype.dc.html` (shell, routing, left rail incl. Actions, role switch, annotation strip) → `OwnerWorkspace.dc.html`. Data: `data.js` (`window.PD`). Story date: Thursday, Nov 12, 2026. Visual system: Orgpuls.

## Token mapping (spec → Orgpuls)
- Accent / primary / selected → `--op-ac`, `--op-sbg`, ink hairline · Link → `--op-link`
- Decision → `--op-viz5`, glyph ◆ · Conflict (unresolved only) → `--op-peach` + `--op-rustbar` border + ⇄ + word "Conflict"
- Success / done → `--op-mint` · Warning (gaps, due soon, overdue, at risk) → `--op-band` / `--op-amberbar` / `--op-caution`, always with the word
- Owner pending → `--op-pulse` + `--op-sage` · Milestone marker → 9px rotated square (diamond)

## Anonymity
Provenance shows function group + round (+ version), never a name: "Legal, risk and finance" (Security, Legal, Data protection, Finance) and "IT and people" (IT service, Service desk, Network, Employee experience). Constraint owners and action owners are named.

## Screens
| ID | Route | Opens for | States |
| --- | --- | --- | --- |
| 2.1 Home | /home | Brief owner, Decider, Viewer | Populated, Empty; persona Kari / Daniel |
| 2.2 Briefs | /briefs | Brief owner, Decider, Viewer, Org admin | Populated, Empty, No filter match |
| 2.3 Template gallery | /templates, /templates/marketplace | Any member | Library, Marketplace |
| 2.4 New brief wizard | /briefs/new/:step | Any member | Six steps; step 6 "Schedule and plan" with milestones |
| 2.5 Synthesis | /briefs/:id/synthesis | Brief owner, Decider | Populated, Pipeline running, Restricted slot locked |
| 2.6 Gaps | /briefs/:id/synthesis/gaps | Brief owner | Populated, No gaps, Resolved |

## What changed in v2
- 2.1: four counters (adds Actions due this week); attention list adds overdue action (A-017) and owner-pending action (A-016); Next milestone card
- 2.2: Open actions (with overdue) and Next milestone columns; "Overdue actions" saved view
- 2.3: default milestones on each card
- 2.4: step 6 adds five template milestones with date and owner (auto ones marked)
- 2.5: status band adds Open actions; brief tabs add Actions and Plan; item 41 v2 with Versions block (v1 struck through) and pin to D-03; D-07 tone conflict (suggestion vs Keep mine); Create action; provenance by function group; brief footer with US data region
- 2.6: gaps offer Create action; first gap is "Security slot is thin" → 3.5

## Pending links (later files)
/decisions/* (5.1–5.2) · /actions, /actions/:id, /me/actions, /briefs/:id/plan (6.x) · /briefs/:id/brief, /export, /validation (5.x) · /org-context, /audit, /settings (7.x)
