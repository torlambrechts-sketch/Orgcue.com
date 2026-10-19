# Claude Code — kickoff prompt: Orgcue on Vercel + GitHub + Supabase

Paste everything below the line into Claude Code, run from an empty folder that also contains the unzipped `design_handoff_orgcue/`.

---

You are building **Orgcue**, a working web prototype. The full product is described in `design_handoff_orgcue/spec/Orgcue Product Spec.md`, and the visual reference is the HTML prototype in `design_handoff_orgcue/prototype/` (open `Orgcue.dc.html` with any static server; screenshots are in `design_handoff_orgcue/screenshots/`). Start with `design_handoff_orgcue/README.md`.

## Goal and posture
- Optimize for a **fast, clickable, deployed prototype**, not production hardening.
- **Security is out of scope for now.** No auth, no RLS, open Supabase policies, public anon key in the client, and no rate limits. Use a "View as" role switcher instead of login (spec §3 demo bar — keep it visible in this prototype).
- Prefer the fewest moving parts. When choosing between building something properly and faking it convincingly, **fake it** (AI pipeline steps, integrations, exports) unless I say otherwise.
- Keep everything in one repo and one Next.js app. No microservices.

## Stack (use exactly this unless you find a blocker — tell me first)
- **Next.js 15 (App Router) + TypeScript + React 19**, deployed on **Vercel**.
- **Supabase** (Postgres + Storage; Realtime optional) via `@supabase/supabase-js`. No Supabase Auth yet.
- **Tailwind CSS**, with tokens from the README's "Design tokens" section turned into CSS variables. Fonts: DM Sans + Playfair Display via `next/font/google`.
- **GitHub** repo `orgcue` with `main` deploying to Vercel production and PRs getting preview deploys.
- State: server data through Supabase, plus a small client store (Zustand) for UI state such as the role, phase, sidebar and view mode.
- Claude API (optional, phase 3): `@anthropic-ai/sdk` from a Next.js route handler, with the key in a Vercel env var.

## Step 1 — Assess (do this first and stop for my review)
1. Read the README, the full spec and `prototype/oc-data.js` (the seed data). Skim `prototype/oc-kit.js` for how the shared Board/List/Timeline view works (`K.views`) and how status colors map (`K.stc`).
2. Write `docs/ASSESSMENT.md` with:
   - a one-paragraph summary of the product in your own words
   - a screen inventory: route → spec section → prototype file → what's interactive
   - a list of what will be **real** (persisted in Supabase) versus **simulated** (hard-coded, timers, canned AI output) in this prototype — my default is in "Real vs simulated" below
   - risks, unknowns and anything in the spec you think should be cut for a prototype
   - a proposed data model (tables and columns) mapped from spec §4 and §25
3. Write `docs/PLAN.md`: milestones (see below) broken into tasks of about half a day each, with acceptance checks taken from spec §26.
4. **Stop and ask me to approve** ASSESSMENT.md and PLAN.md before writing app code.

## Real vs simulated (default — adjust in the assessment)
**Real (Supabase):**
- projects, members, questions, answers, input items (with versions), ideas, comments, votes, approvals
- decisions (options, chosen, rationale, pinned versions), spec versions + items
- actions (status, acceptance, checklist), milestones
- library items, settings (key/value), and an audit log (simple insert-only table; no hash chain yet)

**Simulated:**
- merge/cluster pipeline: "Close and reveal" switches the phase and loads the pre-seeded items
- smart-question skips and adaptive states (seeded rows with toggles that persist)
- simulated runs, instruction check, gates, generated files, flow map and segmentation (seeded JSON)
- integrations: cards with a connected flag only
- email/Slack/Teams sends (toast + audit row)
- evidence pack export (download a JSON dump of the project)

**Optional real AI (phase 3):** one route `/api/draft` that turns raw answers into an EARS requirement draft, or writes a decision-card summary, using Claude.

## Milestones
**M0 — Scaffold and deploy (same day)**
- Create the GitHub repo, the Next.js app, Tailwind tokens and fonts, and the Supabase project.
- `.env.local` with `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`; mirror both in Vercel.
- Connect Vercel to the repo and get a deployed "Hello Orgcue" on a public URL.
- `supabase/` folder with migrations (`supabase db push` or the SQL editor — tell me which you use) and `supabase/seed.sql` generated from `prototype/oc-data.js`.

**M1 — Shell and shared views**
- App shell per spec §5: demo bar (View as / Phase / Show all features), top bar, collapsible sidebar persisted in localStorage, and fluid main panel.
- **One** `<Views>` component (spec §7) with List / Board / Timeline, search, group-by and per-list view persistence. Every list in the app must use it: projects, templates, library, members, input items, ideas, actions, people and the audit log.
- Pages: Home, Projects, Templates, Library, Portfolio, all reading from Supabase.

**M2 — Project core**
- Project header, phase stepper and role-based tabs (§10.1).
- Overview, Members (with the send drawer), Input across all phases (§10.4, §14, §15, §16, §18.3), My input, and Brainstorm.
- The new-project wizard (§9) writes a real project with its sections and questions.

**M3 — Decide, spec, generate**
- Spec tab with Agree/Object, suggestions (Accept / Merge / Keep mine → creates a decision), recording DEC-03 with a rationale, the lock checklist, Lock v1.4.0, and framework coverage.
- Generate tab with seeded gates, linter, file explorer ("why this line"), changes, flow map, segmentation and not-in-any-file.

**M4 — Actions, settings, mobile**
- Actions (list/board/timeline, drawer, bulk bar, status cycling).
- Settings with draft + save bar and an audit row on save.
- Integrations grid.
- The contributor phone flow at `/phone` and the customer page at `/customer` (consent first).

**M5 — Polish**
- Walk through spec §26 end to end on the Vercel URL.
- Fix gaps and record a short `docs/DEMO.md` script.

## Data model starter (refine in the assessment)
Use `text` IDs that match the spec (`CI-0231`, `DEC-03`, `A-015`, `HC-007`, `LIB-HC-015`).

| Table | Columns |
|---|---|
| `orgs` | id, name, region |
| `people` | id, org_id, name, title, org_role, function_group, authority_areas, channel |
| `projects` | id, org_id, name, type, phase, owner_id, decider_id, template, target, deadline, start_date, end_date, color |
| `project_members` | project_id, person_id, project_role, status |
| `sections` | id, project_id, name, authority, restricted, position |
| `questions` | id, project_id, section_id, target_group, text, skipped_reason, skipped_source, ask_anyway |
| `answers` | id, project_id, question_id, person_id, text, strength |
| `input_items` | id, project_id, section, type, strength, group_name, author_id, text, original, relation, decision_id, approval_status, reject_reason |
| `item_versions` | item_id, version, text, note |
| `ideas` | id, project_id, section, text, outcome |
| `comments` | id, item_id, type, text, author_id, created_at |
| `votes` | item_id, person_id (composite PK) |
| `decisions` | id, project_id, title, options jsonb, chosen, rationale, pinned jsonb, status, decided_by, decided_at |
| `spec_versions` | id, project_id, version, locked, locked_by, locked_at, hash |
| `spec_items` | id, spec_version_id, kind, text, provenance, refs |
| `actions` | id, project_id, title, source, owner_id, acceptance, status, priority, due, milestone, tracked_in, checklist jsonb, blocked_by |
| `milestones` | id, project_id, name, date, owner_id, status |
| `library_items` | id, org_id, kind, text, owner, source, status, used_in, confirmed_at, next_review |
| `settings` | org_id, key, value jsonb |
| `audit_events` | id, org_id, at, who, what, object |
| `seed_artifacts` | project_id, key, data jsonb — for simulated runs, lint issues, files, lines, flow map, segmentation and customer themes |

Policies: enable RLS off (or `using (true)` for anon) on every table. No auth.

## Conventions
- Visuals follow the README tokens: Orgpuls cream/ink palette, saffron accent, full-colour status cells that always carry text, Playfair for headings and DM Sans for UI. Match the screenshots.
- Copy: use the exact strings from the prototype and spec (sentence case, no emoji, `·` separators).
- The view mode for each list goes in localStorage. Role and phase live in the client store, and the phase is also written to `projects.phase` for the demo project.
- Commit small and often. Open a PR per milestone so Vercel makes a preview, and post the preview URL when you finish each milestone.

## First message back to me
Reply with:
1. your questions (at most 5)
2. the path to `docs/ASSESSMENT.md` and `docs/PLAN.md`
3. the exact commands you'll run for GitHub, Supabase and Vercel setup, so I can do any steps that need my accounts (repo creation, `vercel link`, Supabase project keys)
