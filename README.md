# Orgcue

A working web prototype of Orgcue: collect what an organization knows, settle conflicts through one named decider, lock a traceable spec, and generate instructions for AI tools. The product spec and the visual reference are in [`design/`](design/BUNDLE_README.md).

- **Live:** https://orgcue.vercel.app
- **Demo script:** [`docs/DEMO.md`](docs/DEMO.md) (spec §26, end to end)
- **Assessment and plan:** [`docs/ASSESSMENT.md`](docs/ASSESSMENT.md), [`docs/PLAN.md`](docs/PLAN.md)

Everyone signs in with an email and password (Supabase Auth). Every account joins the shared Lumio Inc. demo workspace. The customer answer page at `/customer` needs no account, as the spec requires. The dark "Demo controls" strip (View as / Phase / Show all features / Reset demo) is a dev tool, hidden when `NEXT_PUBLIC_DEMO_BAR=0`. View as changes the demo role you look through, not the account you are signed in with.

## Public site and SEO

| Route | What it is |
|---|---|
| `/` | Landing page (design/Marketing.dc.html 1.1): hero with the animated DEC-03 decision card, how it works, generation targets, trust strip, project types, principles, and the beta list. |
| `/pricing` | Plans (Team, Business, Enterprise) with what each includes and **no prices**, template packs, an FAQ (native `<details>`, readable without JavaScript) and the beta list. |

**Beta list.** Every "Become a beta user" button (header, hero, plan cards) jumps to the `#beta` form at the end of the page: work email, optional name and company, and a required consent box for beta and product-update emails. It posts straight to `public.beta_signups` (`supabase/migrations/0005_beta_signups.sql`, applied). Anonymous visitors may only insert, and only with consent; nobody can read the list through the API. A repeat address answers "You're already on the list". Read the list in the Supabase dashboard (Table editor → `beta_signups`), where `source` says which page it came from (`landing` or `plans`). Sign-up at `/signup` still works for the demo workspace but is no longer linked from the public pages.

Both are static, server-rendered pages: no Supabase call, and the middleware does not touch the session there. Search setup lives in `src/lib/site.ts` (`pageMeta()` gives every page its title, description, canonical URL, Open Graph and Twitter card) and the App Router files `robots.ts`, `sitemap.ts`, `manifest.ts`, `icon.svg`, `apple-icon.tsx` and `opengraph-image.tsx`. Landing and pricing carry schema.org JSON-LD (Organization, WebSite, SoftwareApplication; FAQPage, BreadcrumbList). No prices appear anywhere, in the pages or in the structured data. The signed-in app, the auth pages and the customer link are `noindex`, and `robots.txt` keeps crawlers out of the app routes. Lighthouse (mobile, simulated slow 4G): performance 97, accessibility, best practices and SEO 100 on both pages.

Set `NEXT_PUBLIC_SITE_URL` when the site moves to its own domain (default `https://orgcue.vercel.app`); canonical URLs, the sitemap and social cards follow it.

## Stack

Next.js 15 (App Router) · React 19 · TypeScript · Tailwind v4 · Zustand · Supabase (Postgres) · Vercel.

## Run locally

```bash
cp .env.example .env.local        # fill in the Supabase URL and anon key
npm install
npm run dev                       # http://localhost:3000
```

Variables already exported in your shell win over `.env.local` in Next.js. If your environment exports a different `NEXT_PUBLIC_SUPABASE_URL`, load the file first: `set -a; . ./.env.local; set +a; npm run dev`.

## Accounts

| Route | What it does |
|---|---|
| `/signup` | Name, work email, password (8+ characters). Sends a confirmation link, with "Send the link again". |
| `/login` | Email and password. Returns you to the page you asked for (`?next=`). Explains an unconfirmed email and lets you resend. |
| `/forgot-password` → `/reset-password` | Emails a reset link, then sets a new password. The answer is the same whether or not the account exists. |
| `/auth/callback` | Where the emailed links land (PKCE `code` or `token_hash`). |
| Account menu (top right) | The signed-in account, the demo role it views as, and **Log out**. |

`src/middleware.ts` refreshes the session cookie on app requests and sends signed-out visitors to `/login`. Public: `/`, `/pricing`, the auth pages, `/auth/*` and `/customer`.

**Supabase settings to make once** (Dashboard → Authentication):
1. **URL Configuration:** Site URL `https://orgcue.vercel.app`. Redirect URLs `https://orgcue.vercel.app/**`, `https://*-tor-lambrechts-s-projects.vercel.app/**` and `http://localhost:3000/**`. Without these, the links in confirmation and reset emails point at the default Site URL.
2. **Emails:** Supabase's built-in mailer only delivers to members of your Supabase organization and sends a few emails an hour. To let anyone sign up, add custom SMTP under **SMTP Settings** (for example Resend or Postmark). The other option is to turn off **Confirm email** under Providers → Email, which logs people in straight after sign-up.

## Database

```bash
# 1. Schema: run supabase/migrations/*.sql in order (SQL editor or `supabase db push`).
#    0003_auth.sql (applied) links accounts to people rows and turns on row-level security: signed-in users read and
#    write, anonymous visitors may only submit the customer page. `npm run seed` now needs the test account below.
#    0004_reset_keeps_accounts.sql (applied) makes Reset demo keep accounts' People entries and refuse anonymous calls.
#    0005_beta_signups.sql (applied) adds the beta list: insert-only for visitors, unreadable through the API.
# 2. Seed: load the Lumio Inc. demo (spec §25) and reset to it.
npm run seed                      # = node scripts/gen-seed.mjs --push
```

`scripts/gen-seed.mjs` reads `design/design_handoff_orgcue/prototype/oc-data.js`. It writes `supabase/seed.sql`, a standalone SQL-editor version. With `--push` it loads the rows into `demo_seed` and calls `reset_demo()`. The app's **Reset demo** link calls the same function.

## Tests

Put a confirmed account in `.env.local` as `ORGCUE_TEST_EMAIL` and `ORGCUE_TEST_PASSWORD` (see `.env.example`). The full suite signs in with it.

```bash
npm run test:smoke                # every route: page errors, failed requests, screenshots
npm run test:e2e                  # spec §26 walk-through in Chromium, checks the Supabase rows (resets the demo)
npm run test:auth                 # beta form, sign-up, log-in, reset and redirects; email and beta-list writes are intercepted
```

`tests/e2e/mock-auth.mjs` stands in for Supabase Auth with one fixed account and forwards data requests to the real project. Build with `NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321` and run the suites with `E2E_SUPABASE_URL=http://localhost:54321 ORGCUE_TEST_EMAIL=mock@orgcue.test ORGCUE_TEST_PASSWORD=mock-password-123`. That checks the signed-in app without a real account or email. It only worked before `0003_auth.sql`; now that the anon role reads nothing, use a real test account.

All suites need a running app (`npm run build && npm start`) and a Chromium at `/opt/pw-browsers/chromium` (set `CHROMIUM_PATH` otherwise).

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
