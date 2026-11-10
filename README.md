# OrgCue

A fresh Next.js app (App Router, TypeScript, Tailwind CSS).

```bash
cp .env.example .env.local   # then paste the publishable key
npm install
npm run dev
```

Open http://localhost:3000.

## The MVP site

The whole site is one static page, `public/project-portfolio.html`, with every screen inside it
(dashboard, project plan, budgets, RAID log and so on, switched by the address hash, for example `/#budgets`).
`next.config.ts` rewrites `/` to that file. Edit the HTML file directly; it needs no build step of its own.

The **Strategy** section (compass icon, or `/#st-house`) holds 15 strategy pages built on one sample strategy:
strategy on a page, strategy review, strategy map, balanced scorecard, OKR alignment, OGSM, Hoshin X-matrix,
strategy canvas, business model canvas, SWOT and PESTLE, value driver tree, initiative roadmap, portfolio prioritisation,
strategy heat map and organisation alignment. They also appear first in the Templates gallery (`/#templates`).
The research behind them, covering 20 strategy applications, is in `docs/strategy-app-research.md`.

A **Purpose and value** group (also in the Strategy section) presents the company's ambition, purpose, values and value:
Ambition (north-star tracker), Purpose and values (Golden Circle and values as behaviours), Values in action
(value-tagged recognition and a values pulse heat map), Value creation (stakeholders, value bridge, value creation model)
and V2MOM. The research behind them is in `docs/purpose-ambition-values.md`.

**Measures and targets** (`/#st-kpis`) and the **Initiative portfolio** (`/#st-portfolio`) connect objectives to measures
with yearly targets, and measures to the initiatives expected to move them. Each initiative has its own page with tasks.
See `docs/measures-and-portfolio.md`.

The **Work** section (checklist icon, or `/#wk-my`) manages programmes, initiatives and tasks: My work and an inbox,
Portfolio control (health, budget forecast, baselines, stage gates), a page per programme with status updates,
Tasks as a list, board, timeline, calendar or workload, and Automation rules. Any task opens in a side panel with
subtasks, dependencies, comments with @mentions and followers. See `docs/work-management.md`.
Work also has **Requests** (`/#wk-intake`, scored demand intake) and **Decisions and actions** (`/#wk-decisions`), which feed
the strategy review. Measures calculate their status from progress against plan and keep a dated check-in history.

The **Product roadmap** (flag icon, or `/#roadmap`) shows what has shipped, what comes next with voting, how OrgCue covers
the features leading vendors offer, and the advisory panel's review. See `docs/product-review.md` and `docs/vendor-landscape.md`.

Later additions:
- shared workspaces with sign-in, roles, an audit log and import (Settings);
- monthly finance, gate criteria, change requests, benefits, capacity and scenarios;
- unit scorecards, strategic risks, a governance calendar and frozen board packs;
- one task list, custom fields, saved views and timesheets.

See `docs/release-notes.md`; the collaboration research is in `docs/collaboration-research.md`.

Everything a visitor adds or changes is saved in their own browser only; Help → Reset demo data restores the sample.

`npm run build` makes a production build and `npm run lint` runs ESLint.
Pushes to `claude/relaxed-goldberg-yjnnay` deploy to https://orgcue.vercel.app.

## Supabase

Shared workspaces use the tables in `supabase/migrations/` (row level security on every table). The static page reads the
public URL and publishable key from `/api/public-config`. Set the project's auth Site URL to the live domain so that
confirmation emails link to it.

The app talks to the Supabase project `qlzlnsjkacjqagvxlbvq` with its publishable key, which is safe in the browser.
Never put the secret or service-role key in a `NEXT_PUBLIC_` variable.

- `src/lib/supabase/client.ts`: client for Client Components.
- `src/lib/supabase/server.ts`: client for Server Components, Server Functions and Route Handlers. Create one per request.
- `src/proxy.ts`: refreshes the signed-in user's session cookie on each request.
- `/api/health`: returns `{"supabase":"ok"}` when the app can reach Supabase.

The same two variables are set in the Vercel project for production, preview and development.
