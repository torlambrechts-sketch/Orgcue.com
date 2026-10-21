# Orgcue

A working web prototype of Orgcue: collect what an organization knows, settle conflicts through one named decider, lock a traceable spec, and generate instructions for AI tools. The product spec and the visual reference are in [`design/`](design/BUNDLE_README.md).

- **Live:** https://orgcue.vercel.app
- **Demo script:** [`docs/DEMO.md`](docs/DEMO.md) (spec §26, end to end)
- **Assessment and plan:** [`docs/ASSESSMENT.md`](docs/ASSESSMENT.md), [`docs/PLAN.md`](docs/PLAN.md)

Everyone signs in with an email and password (Supabase Auth). Every account joins the shared Lumio Inc. demo workspace. The customer answer page at `/customer` needs no account, as the spec requires. The dark "Demo controls" strip (View as / Phase / Show all features / Reset demo) is a dev tool, hidden when `NEXT_PUBLIC_DEMO_BAR=0`. View as changes the demo role you look through, not the account you are signed in with.

## Public site and SEO

The public site is the splash design in [`design/splash-handoff/`](design/splash-handoff/ai-instructions-application-layouts/project/Splash) (Claude Design handoff, 21 October 2026). Seven static pages share one header and one closing band:

| Route | Design file | What it is |
|---|---|---|
| `/` | `Splash/Home.dc.html` | Hero with the Northwind CRM conflict mock-up, standards strip, feature grid, project and feature rules, seven gated phases, numbers. |
| `/plan` | `Splash/Plan.dc.html` | Phases 1–3: wizard, first draft with Claude, MVP vote. |
| `/collect` | `Splash/Collect.dc.html` | Phase 4: question bank, packages per person, sending and nudging. |
| `/decide` | `Splash/Decide.dc.html` | Phase 5: backlog with sources, conflicts side by side, margin comments. |
| `/deliver` | `Splash/Deliver.dc.html` | Phases 6–7: signed specification, handoff files, system prompt, revisions. |
| `/platform` | `Splash/Platform.dc.html` | AI models, integrations, security, where the product is today. |
| `/beta` | (not in the design; built in its language) | The private beta: what beta users get, the form, and the three steps from the list to an account. |

`scripts/splash-to-tsx.py` turns each design file into `src/components/splash/pages/*.tsx`, keeping every inline style. Hover, focus and press states go into `src/components/splash/splash-hover.css`. Run `python3 -I scripts/splash-to-tsx.py` again when the design changes; don't edit the generated pages by hand. The nav and the closing band are written by hand in `src/components/splash/SplashChrome.tsx`, with the fonts (Figtree, Instrument Serif) in `SplashShell.tsx`. Changes from the design:

- "Open the app" became **Become a beta user →** and opens `/beta`; a **Log in** link sits beside it. "Open the CRM example" in the home hero jumps to the beta form in the closing band, which every page has (`#beta`). The design's "Prototype · demo data · no sign-up" line now reads "Private beta · join the list, no account needed". Platform's closing band invites people to the beta instead of the demo.
- Links to the app prototypes (`App/*.dc.html`) are dropped. The footer has **Log in** in their place.
- On screens under 760px, the hero's floating cards are hidden and the app mock-up takes the full width. Without this they sat off-screen.
- The hero slides in without the design's fade from transparent, so the headline paints at once.
- Lists keep their bullets, and the page wrapper clips instead of hiding overflow, so the header stays sticky.

The old plans page is gone: `/pricing` redirects to `/`.

**Beta list.** The form asks for a work email, an optional name and company, and a required consent box for beta and product-update emails. It posts straight to `public.beta_signups` (`supabase/migrations/0005_beta_signups.sql`, applied). Anonymous visitors may only insert, and only with consent; nobody can read the list through the API. A repeat address answers "You're already on the list". Read the list in the Supabase dashboard (Table editor → `beta_signups`). `source` says which page it came from (`home`, `plan`, `collect`, `decide`, `deliver`, `platform`, `beta`).

**Sign-up and log-in.** `/signup`, `/login`, `/forgot-password` and `/reset-password` use the same look as the public site (`AuthFrame` in `src/components/auth/AuthUI.tsx`, inside `SplashShell`). Sign-up is for people invited to the beta, and links to `/beta` for everyone else; log-in links to both. Sign-up is not enforced against the list yet: anyone with the link can still create an account.

**Search.** `src/lib/site.ts` holds every public page's title and description (`SPLASH_PAGES`). `pageMeta()` gives each page its canonical URL, Open Graph and Twitter card. `robots.ts`, `sitemap.ts`, `manifest.ts`, `icon.svg` (the OrgCue mark), `apple-icon.tsx` and `opengraph-image.tsx` (plum card in Instrument Serif) follow from it. The home page carries Organization, WebSite and SoftwareApplication JSON-LD; the other pages carry a BreadcrumbList. The signed-in app, the auth pages and the customer link are `noindex`, and `robots.txt` keeps crawlers out of the app routes. Lighthouse (mobile, simulated slow 4G): performance 91–93, accessibility 96, best practices and SEO 100. Accessibility misses full marks on one design choice: the "Outlook sync" card is dimmed to 60% to show a feature left out of the MVP.

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

`src/middleware.ts` refreshes the session cookie on app requests and sends signed-out visitors to `/login`. Public: the seven splash pages, the auth pages, `/auth/*` and `/customer`.

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
| `design/` | The Claude Design handoff bundles: spec, app prototype, screenshots and design system; `design/splash-handoff/` holds the public site. |
| `src/components/splash/` | The public site: generated pages, nav and closing band, fonts and styles. |
