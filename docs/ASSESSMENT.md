# Orgcue — Assessment

Written from `design_handoff_orgcue/` (README, Product Spec v1.0, `prototype/oc-data.js`, `prototype/oc-kit.js`, the screen prototypes and the 21 screenshots). This is the kickoff's step 1 deliverable; `docs/PLAN.md` is the milestone plan.

## 1. Product summary

Orgcue is an intake-to-instructions tool for AI projects inside an organization. An owner frames a project (type, sections, questions, people, one named decider), then every member answers only their questions, privately and in about 12 minutes. When collection closes, all input is revealed at once, merged, clustered and flagged for gaps, duplicates, conflicts and injected instructions. Members agree, object, suggest wording, comment and upvote; a single decider settles each conflict with a written rationale and locks a versioned, hashed specification. From the locked spec Orgcue generates tool-specific instruction files (AGENTS.md, CLAUDE.md, Cursor rules, Copilot Studio packs, policy drafts, BPMN) where every line traces back to a person, a decision and a test, gated by checks that constraints are verbatim and nothing contradicts. After launch it tracks actions, drift in the generated targets, and scheduled reviews of shared constraints, and it closes the loop by telling each contributor what happened to their input. The demo org is Lumio Inc.; the worked project is "IT Helpdesk Agent v1", story date Thu Nov 12, 2026.

## 2. Screen inventory

| Route | Spec | Prototype file | What is interactive |
|---|---|---|---|
| `/home` | §8, §25.3 | OcPages | Next-step card (role × phase), CTAs navigate or toast, 7×14 heatmap, For you buttons, Getting started (owner, Show all off), "Your projects" shared views |
| `/projects` | §7, §25.2 | OcPages | Board · List · Timeline (persisted), search, CSV toast, row click → project, `＋ New project` opens wizard |
| `/templates` | §11 | OcPages | Shared views grouped by category; `Use` opens the wizard at Basics with the template applied; `+ Custom project`, `New template` |
| `/library` | §12 | OcPages | KPIs, shared views by kind; `Propose change` on LIB-HC-015 → Change pending + affected-projects banner, `Withdraw`; `Still true?` on Check-due facts |
| `/portfolio` | §13 | OcPages | KPIs, days-per-phase stacked bars, repeat questions (`Add the missing to the library`), where time is lost (actions). Hidden for contributors |
| modal | §9 | OcWizard | 6-step wizard: Start (scratch or 9 templates) · Basics (name, type chips, goal, output, frameworks, deadline/owner/decider) · Sections (checkbox grid, authority sign-off, custom section) · Questions (per-section rows, add/remove) · People (groups, toggles, external respondents) · Review. Continue validation, footer counts (`min(q, 8) × 2` minutes), `Create project` → real project |
| `/p/:id/overview` | §10.1–10.2 | OcProject | Header, phase stepper (demo: click to change phase), role tabs; next step, funnel, coverage, members grid, close-the-loop note (`Send to all members`), lock checklist, milestones, activity |
| `/p/:id/members` | §10.3, §18.1 | OcProject | Members shared views; `Nudge now`; send drawer (540px) with tokens, why-you per member, Email/Slack/Teams previews, `Send to 8 members` → Collect; external respondents card; reminder/digest/escalation cards |
| `/p/:id/input` | §10.4, §14–16, §18.3 | OcProject | Frame: smart question set (`Ask anyway` / `Skip again`), question editor, `Send`. Collect: `Close collection and reveal` with ~2 s progress, adaptive table (`Keep asking` / `Stop asking`). Review+: stats, customer evidence (`Create requirement` → REQ-025), gap cards, items with detail panel (versions, comments, upvote, Approve / Reject with reason, Send to decision) |
| `/p/:id/my-input` | §10.5 | OcProject | Contributor questions with inline editor (answer, strength, skip), private ideas (≤3), team input with vote-to-see-counts and comments, footprint, about panel, prefill facts |
| `/p/:id/brainstorm` | §10.7 | OcProject | Locked before reveal; after reveal shared views (Board = sticky-note clusters), `Promote to spec` / `Park` |
| `/p/:id/spec` | §10.8, §17, §19 | OcSpecGen | Version pill, `Compare with v1.3`, review banner, lock panel + `Lock v1.4.0` (decider, needs DEC-03 and DEC-07), simulated runs (`Re-run` 1.4 s), framework coverage tabs (`Add requirement` → REQ-024), document sections, Agree/Object (reason + alternative), T-01 diff (Accept / Merge / Keep mine → DEC-07), DEC-03 options + rationale + `Record decision`, superseded banner (Live) |
| `/p/:id/generate` | §10.9, §20 | OcSpecGen | Target picker, what the AI receives, 8 gates (`Fix` on HC-019), approve/generate (decider) or request approval, instruction check (`Fix`, `Apply safe fixes`, score), explorer tabs: Files (line select → why this line), Changes (cause chips), Flow map (chip filters), Segmentation, Not in any file; pilot comparison, 24 scenarios, trace matrix, evidence pack, MCP card; Live drift banner |
| `/p/:id/actions` | §10.10 | OcProject | Shared views; status cell cycles; row checkboxes → bulk bar (`Mark done`); drawer (460px) with Accept/Decline, checklist toggles, reminder rules, `Mark done`; ServiceNow-synced row read-only |
| `/settings/:section` | §21–22 | OcSettings | Sub-nav (filtered by role), typed rows, `Changed` badges, sticky save bar (`Discard` / `Save changes` → audit event), View only banner, People and Audit log shared views, Integrations grid (`Connect` / `Configure`) + MCP card, Billing |
| `/phone` | §10.6 | OcPhone | 6-screen contributor flow in a 390×844 bezel: invite, prefill (Correct / Needs a change / Out of date), question (textarea, strength, skip/next), follow-up, ideas (≤3), thanks. Answers persist |
| `/customer` | §18.2 | OcPhone | Branded page: consent checkbox gates `Start`, 4 questions (text + ≥50px choices), thanks, "Powered by Orgcue" |

Role-dependent tabs, the demo bar and visibility rules are as in README "Screens" and spec §2.3, §10.1.

## 3. Real vs simulated

**Real (persisted in Supabase, read on load, written on interaction)**

- orgs, people, projects (incl. `phase` for the demo project), project_members, sections, questions (`ask_anyway`, skip reason/source), answers (desktop and phone flows), input_items (+ approval status, reject reason), item_versions, ideas (private ideas and outcomes), comments, votes, reviews (Agree / Object with reason and alternative), decisions (chosen option, rationale, pins, status), spec_versions (locked, hash), spec_items (incl. REQ-024 / REQ-025 created from the UI), actions (status, acceptance, checklist), milestones, library_items (status: Change pending / Withdraw / Still true), settings (key/value draft → save), audit_events (insert-only), integrations (connected flag), adaptive_topics (state, saved minutes), project_state (small key/value jsonb per project for simulated flags, see below).
- The new-project wizard inserts a project, its sections and questions, and members.
- View mode per list and the sidebar collapse state stay in `localStorage` (as the README specifies).

**Simulated (seeded JSON or timers; no pipeline)**

- Merge/cluster: `Close collection and reveal` shows a ~2 s progress bar, flips `projects.phase` to Review and the pre-seeded items appear.
- Smart question set, adaptive states and follow-ups: seeded rows with toggles that persist.
- Simulated runs, gates, instruction check issues, generated files and lines, changes diff, flow map, segmentation, not-in-any-file, customer themes, scenarios, trace matrix: seeded rows in `seed_artifacts` (jsonb). Fix / Apply safe fixes / gate Fix / generation result write flags to `project_state`.
- Integrations: cards with a `connected` flag only; Connect toggles the flag and writes an audit row.
- Email / Slack / Teams sends, nudges, reminders: toast + audit row.
- Evidence pack export: downloads a JSON dump of the project's tables.
- Search, Person, Filter, Sort and Group by: live text search filters rows; the others toast ("options open here"), as in the prototype.
- AI drafting: not in M0–M4. Optional `/api/draft` with Claude in phase 3 (plan M6).

Deviations from the kickoff default: `reviews` (Agree/Object) and `adaptive_topics` get their own tables because the spec's §26 steps 4 and 8 depend on them; `integrations` is a table rather than settings keys so the grid can read a `connected` flag per card. `project_state` holds the remaining simulated flags (`gen`, `loopSent`, `t01`, `gateFix`, `lint`, `req024`, `req025`, `compare`) so each one does not need a column.

## 4. Risks, unknowns, suggested cuts

- **Scope is large for a prototype.** Six screen files (~630 KB of prototype logic) must be ported. The plan mitigates this by porting `oc-kit.js` as one typed block renderer (`lib/kit.ts` + `components/Blocks.tsx`) so each screen is a near-verbatim port of its `renderVals()` instead of a redesign.
- **No auth and an open anon key** (per kickoff). Every table has RLS off. Anyone with the URL can write. Fine for a demo; not for real data.
- **Single demo project is the "live" one.** The phase switcher writes `projects.phase` only for `it-helpdesk`; other projects keep seeded phases. Multiple viewers share one state (no per-user session), so two people clicking at once will see each other's changes.
- **Peer anonymity (P2) is enforced in the UI only**, not by the database.
- **Timeline today line is fixed at Nov 12, 2026** (story date), as the README asks.
- **Supabase region is eu-west-3** (the existing "Orgcue.com" project). The demo copy says "Data region: US". Cosmetic only.
- **Vercel deploy** is from this repo's branch via the Vercel GitHub integration if it is installed; otherwise a CLI deploy with the token the environment injects.
- Suggested cuts for v0: no Realtime subscriptions (page reloads see other users' writes); CSV is a toast; Settings → Billing is static; `Preview as member` and `Upload documents` are toasts; Customer page choice results chart is static text.

## 5. Data model (Supabase, public schema, RLS disabled)

Text IDs match the spec (`CI-0231`, `DEC-03`, `A-015`, `HC-007`, `LIB-HC-015`). `org_id` defaults to `lumio`.

| Table | Columns |
|---|---|
| `orgs` | id text pk, name, region |
| `people` | id text pk, org_id, name, title, org_role, project_role, function_group, authority_areas, channel |
| `projects` | id text pk, org_id, name, type, phase, owner_id, owner_name, decider_id, template, target, deadline, start_date, end_date, color, answered, conflicts, actions_count, next_step, created_at |
| `project_members` | project_id, person_id, project_role, status, pk(project_id, person_id) |
| `templates` | id text pk, org_id, category, name, type, frameworks, output, status, owner, used, description, is_new, updated |
| `sections` | id uuid pk, project_id, name, hint, authority bool, restricted bool, position |
| `questions` | id text, project_id, section, target_group, text, skipped_reason, skipped_source, ask_anyway bool, position, pk(project_id, id) |
| `answers` | id uuid pk, project_id, question_id, person_id, text, strength, skipped bool, created_at |
| `adaptive_topics` | id text, project_id, topic, state, evidence, did, saved int, pk(project_id, id) |
| `input_items` | id text pk, project_id, version int, section, type, strength, group_name, author_id, text, original, relation, decision_id, votes_seed int, comments_seed int, approval_status, reject_reason |
| `item_versions` | item_id, version text, text, note, pk(item_id, version) |
| `ideas` | id text pk, project_id, section, text, outcome, author_id, private bool, created_at |
| `comments` | id uuid pk, project_id, item_id, type, text, author_id, created_at |
| `votes` | item_id, person_id, pk |
| `reviews` | item_id, person_id, verdict, reason, alternative, pk(item_id, person_id) |
| `decisions` | id text pk, project_id, title, note, warn, done, options jsonb, chosen int, rationale, pinned, follow_up, status, decided_by, decided_at |
| `spec_versions` | id text pk, project_id, version, locked bool, locked_by, locked_at, hash |
| `spec_items` | id text pk, project_id, kind, text, refs, provenance, owner_id, review_date, position |
| `actions` | id text pk, project_id, title, source, owner_id, acceptance, status, priority, due date, milestone, tracked_in, checklist jsonb, blocked_by, description |
| `milestones` | id uuid pk, project_id, name, date, owner_name, status, position |
| `library_items` | id text pk, org_id, kind, text, owner, source, status, used int, confirmed_at, next_review, proposed_text |
| `settings` | org_id, key, value jsonb, pk(org_id, key) |
| `audit_events` | id bigserial pk, org_id, at timestamptz, who, what, object |
| `integrations` | id text pk, org_id, name, category, purpose, connected bool, detail |
| `external_segments` | id uuid pk, project_id, segment, channel, invited, answered, status |
| `customer_themes` | id uuid pk, project_id, theme, segments, n, quote, feeds, status |
| `customer_responses` | id uuid pk, project_id, answers jsonb, created_at |
| `seed_artifacts` | project_id, key, data jsonb, pk(project_id, key) — scenarios, lint, files, lines, changes, flow, segmentation, gates, not_in_file, framework coverage, prefill facts, smart skips |
| `project_state` | project_id, key, value jsonb, pk(project_id, key) — gen, loopSent, t01, gateFix, lint fixes, req024, req025, libPending, libAsked |

Migrations live in `supabase/migrations/` and are applied with the Supabase management API (MCP `apply_migration`); `supabase/seed.sql` is generated from `prototype/oc-data.js` by `scripts/gen-seed.mjs` and applied the same way. Both can also be pasted into the SQL editor.
