# Orgcue — Build plan

Milestones follow the kickoff. Tasks are about half a day each. Acceptance checks reference spec §26.

**Status (Oct 19, 2026):** M0–M5 are built and deployed at https://orgcue.vercel.app. `npm run test:e2e` walks spec §26 and checks the database: 33 of 33 checks pass. M6 (real AI drafting) is not started. Sign-up and log-in are built (README → Accounts). `supabase/migrations/0003_auth.sql` (accounts and row-level security) is applied; `0004_reset_keeps_accounts.sql` waits to be pasted into the SQL editor.

## M0 — Scaffold and deploy

| # | Task | Done when |
|---|---|---|
| 0.1 | Next.js 15 (App Router, TS, React 19, Tailwind v4) in the repo root; Orgpuls tokens as CSS variables in `globals.css`; DM Sans + Playfair Display via `next/font/google` | `npm run build` passes; `/` renders "Hello Orgcue" in the right fonts and colours |
| 0.2 | `src/lib/supabase.ts` client; `.env.local` with `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`; `.env.example` | Client reads a table from the Orgcue.com project |
| 0.3 | `supabase/migrations/0001_init.sql` (tables in ASSESSMENT §5, RLS off) applied via the management API | `list_tables` shows every table |
| 0.4 | `scripts/gen-seed.mjs` turns `prototype/oc-data.js` into `supabase/seed.sql`; apply it | Row counts match oc-data (9 people, 6 projects, 9 templates, 14 questions, 12 items, 7 ideas, 7 actions, 12 library rows …) |
| 0.5 | Vercel project linked to this GitHub repo, env vars mirrored, first deploy | Public URL serves the app |

## M1 — Shell and shared views

| # | Task | Done when |
|---|---|---|
| 1.1 | `lib/kit.ts`: port of `oc-kit.js` (status colours `stc`, pills, chips, cells, items, blocks, drawer/modal/bulk, timeline math, next-step matrix) | Type-checks; unit-free smoke in the Blocks gallery |
| 1.2 | `components/Blocks.tsx`: renders the block/item/cell shapes exactly like the prototype template (toolbar, head, tabs, banner, kpis, stepper, panel + 16 item kinds, table, board, timeline, lines, notes, flow) plus `Drawer`, `Modal`, `BulkBar`; design-system primitives `Button`, `Input`, `Select`, `Textarea`, `Switch`, `Mark` | Every block kind renders |
| 1.3 | `store/ui.ts` (Zustand): role, phase, showAll, navC, toast, wizard; per-list view mode via `localStorage['orgcue-view-<key>']` | §26.17: collapse sidebar, reload, still collapsed |
| 1.4 | `store/data.ts`: loads all tables for the org on first render into `D`; typed mutation helpers that write to Supabase and update `D` optimistically; audit helper | Network tab shows one batch of selects, writes land in Supabase |
| 1.5 | App shell: demo bar (dev flag `NEXT_PUBLIC_DEMO_BAR`), top bar, sidebar (240/72, 180 ms), main panel, toast, entry animation, `/phone` and `/customer` without the shell chrome | Matches screenshots 01–02 |
| 1.6 | `views()` shared template (Board · List · Timeline, search, group-by, per-list persistence) used by every list | Projects, Templates, Library switch views and persist |
| 1.7 | Home, Projects, Templates, Library, Portfolio from Supabase | §26.14: Propose change on LIB-HC-015 shows the 3 affected projects banner; Withdraw reverts |

## M2 — Project core

| # | Task | Done when |
|---|---|---|
| 2.1 | Project header, phase stepper, role tabs, contributor banner | Tabs per role per §10.1; Show all off hides Generate/Actions before Validate |
| 2.2 | Overview tab (next step, funnel, coverage, members, close-the-loop, checklist, milestones, activity) | `Send to all members` persists `loopSent` |
| 2.3 | Members tab with Nudge, send drawer, external respondents, info cards | `Send to 8 members` moves the project to Collect (§26.3) |
| 2.4 | Input tab, Frame: smart question set + editor | §26.2: 6 removed, Ask anyway restores one, minutes drop by 1.5 |
| 2.5 | Input tab, Collect: close and reveal, adaptive table | §26.4: Keep asking reopens a converged topic |
| 2.6 | Input tab, Review+: stats, customer evidence, gaps, items, detail panel, votes, comments, approve/reject | §26.5–6: counts after voting; Reject with Duplicate shows in the author's footprint; §26.15 Create requirement |
| 2.7 | My input tab and Brainstorm tab | Answers and private ideas persist; Promote / Park persist outcomes |
| 2.8 | New project wizard writing a real project | §26.1: Process + SIPOC + EARS creates Suppliers, Inputs, Outputs, Customers |

## M3 — Decide, spec, generate

| # | Task | Done when |
|---|---|---|
| 3.1 | Spec tab: document, provenance, Agree/Object, T-01 suggestion (Accept / Merge / Keep mine → DEC-07) | Object requires reason + alternative |
| 3.2 | Decisions: DEC-03 options, rationale, Record decision; compact rows; lock checklist; Lock v1.4.0 with hash; superseded banner | §26.8: scenario turns Pass, checklist updates, decider locks |
| 3.3 | Simulated runs and framework coverage | §26.7: conflicts link to DEC-03 and DEC-04; Add requirement creates REQ-024 |
| 3.4 | Generate tab: target picker, gates, approve/generate, instruction check | §26.9–10: 6 issues, safe fixes leave 2 high; all gates pass after Fix; PR #42 |
| 3.5 | Output explorer: Files (why this line), Changes, Flow map, Segmentation, Not in any file; pilot, scenarios, trace, evidence pack, MCP | §26.10–12 |

## M4 — Actions, settings, mobile

| # | Task | Done when |
|---|---|---|
| 4.1 | Actions tab: shared views, status cycling, bulk bar, drawer, synced read-only | §26.13 |
| 4.2 | Settings: sub-nav, typed rows, draft + save bar, audit row, View only, People and Audit log views | §26.16 |
| 4.3 | Integrations grid + MCP card | Connect flips the flag and logs an event |
| 4.4 | `/phone` contributor flow and `/customer` page | §26.3 and §26.15: consent gates Start; answers persist |

## M5 — Polish

| # | Task | Done when |
|---|---|---|
| 5.1 | Walk §26 steps 1–17 on the Vercel URL; fix gaps | Each step reproducible |
| 5.2 | `docs/DEMO.md` script; README with setup commands | Someone else can run the demo |

## M6 (optional) — Real AI

`/api/draft` route handler using `@anthropic-ai/sdk` (key in a Vercel env var) that drafts an EARS requirement from raw answers or a decision-card summary. Off by default; falls back to the canned text when the key is missing.
