# Orgcue

A working web prototype of Orgcue: collect what an organization knows, settle conflicts through one named decider, lock a traceable spec, and generate instructions for AI tools. The product spec and the visual reference are in [`design/`](design/BUNDLE_README.md).

- **Live:** https://orgcue.vercel.app
- **Demo script:** [`docs/DEMO.md`](docs/DEMO.md) (spec §26, end to end)
- **Assessment and plan:** [`docs/ASSESSMENT.md`](docs/ASSESSMENT.md), [`docs/PLAN.md`](docs/PLAN.md)

Prototype posture: no auth, RLS off, public anon key. The dark "Demo controls" strip (View as / Phase / Show all features / Reset demo) is a dev tool, hidden when `NEXT_PUBLIC_DEMO_BAR=0`.

## Stack

Next.js 15 (App Router) · React 19 · TypeScript · Tailwind v4 · Zustand · Supabase (Postgres) · Vercel.

## Run locally

```bash
cp .env.example .env.local        # fill in the Supabase URL and anon key
npm install
npm run dev                       # http://localhost:3000
```

Variables already exported in your shell win over `.env.local` in Next.js. If your environment exports a different `NEXT_PUBLIC_SUPABASE_URL`, load the file first: `set -a; . ./.env.local; set +a; npm run dev`.

## Database

```bash
# 1. Schema: run supabase/migrations/*.sql in order (SQL editor or `supabase db push`).
# 2. Seed: load the Lumio Inc. demo (spec §25) and reset to it.
npm run seed                      # = node scripts/gen-seed.mjs --push
```

`scripts/gen-seed.mjs` reads `design/design_handoff_orgcue/prototype/oc-data.js`. It writes `supabase/seed.sql`, a standalone SQL-editor version. With `--push` it loads the rows into `demo_seed` and calls `reset_demo()`. The app's **Reset demo** link calls the same function.

## Tests

```bash
npm run test:smoke                # every route: page errors, failed requests, screenshots
npm run test:e2e                  # spec §26 walk-through in Chromium, checks the Supabase rows (resets the demo)
```

Both need a running app (`npm run build && npm start`) and a Chromium at `/opt/pw-browsers/chromium` (set `CHROMIUM_PATH` otherwise).

## How the code is organized

| Path | What it is |
|---|---|
| `src/screens/*.js` | Screen logic from the design files (`Oc*.dc.html`), kept as written. Each class turns the store and data into block descriptors. Edits are marked `ORGCUE:`. |
| `src/oc/kit.js` | Port of the prototype's `oc-kit.js`: status colours, block builders and the shared Board / List / Timeline template (`K.views`), on a Zustand store. |
| `src/oc/db.js` | Supabase layer. `load()` builds the data in the prototype's shape and hydrates the store. `persist()` writes the rows for every store change and logs audit events. |
| `src/components/Blocks.tsx` | Typed React renderer for the block descriptors. It mirrors the prototype template element for element. |
| `src/components/Shell.tsx` | Demo bar, top bar, collapsible sidebar, routing, toast. |
| `src/components/ds.tsx` | Orgpuls design-system primitives (Button, Input, Select, Textarea, Switch, Mark). |
| `supabase/` | Migrations and the generated seed. |
| `design/` | The Claude Design handoff bundle: spec, prototype, screenshots and design system. |
