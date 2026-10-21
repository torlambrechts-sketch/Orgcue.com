# Orgcue: notes for Claude Code sessions

Read this first; README.md has the full picture. Handover state as of 21 Oct 2026.

## What this is
- Next.js 15 (App Router) · React 19 · TypeScript · Tailwind v4 · Zustand · Supabase · Vercel. Live: https://orgcue.vercel.app
- **Public site** (`/`, `/plan`, `/collect`, `/decide`, `/deliver`, `/platform`, `/beta`): the splash design in
  `design/splash-handoff/…/Splash/*.dc.html`. Pages in `src/components/splash/pages/` are **generated**: change the
  design file or `scripts/splash-to-tsx.py`, then `python3 -I scripts/splash-to-tsx.py`. Never edit them by hand.
  Nav, closing band and beta card are hand-written in `src/components/splash/SplashChrome.tsx`; `/beta` is `BetaPage.tsx`.
- **Signed-in app** (`/home`, `/projects`, `/p/…`, `/library`, …): port of the earlier prototype (`design/design_handoff_orgcue`),
  rendered by the catch-all `src/app/[...slug]`. Screens in `src/screens/*.js` stay as written (edits marked `ORGCUE:`).
- **Auth**: `/signup`, `/login`, `/forgot-password`, `/reset-password` (`src/components/auth/AuthUI.tsx`, splash look).
- **Beta list**: table `public.beta_signups`, insert-only for anon (consent required), unreadable through the API.

## Rules the owner has set
- No prices anywhere: pages, structured data or copy.
- Every call to action is "Become a beta user" (header → `/beta`, in-page → `#beta`). No "book a demo", no "open the app".
- Brand on the public site: **OrgCue**. Work only on branch `claude/relaxed-goldberg-yjnnay`; no pull requests unless asked.
- The owner does not want to run SQL by hand or spend CI minutes. Apply database changes yourself (below).
- Never put secrets, tokens or the test account's password in the repo or the chat.

## Fresh container setup
1. `.env.local` is gitignored, so recreate it. `NEXT_PUBLIC_SUPABASE_URL=https://qlzlnsjkacjqagvxlbvq.supabase.co`, and
   `NEXT_PUBLIC_SUPABASE_ANON_KEY` comes from the Supabase connector (`get_publishable_keys`, project `qlzlnsjkacjqagvxlbvq`).
   Add `NEXT_PUBLIC_DEMO_BAR=1`. `ORGCUE_TEST_EMAIL` / `ORGCUE_TEST_PASSWORD` stay empty unless the owner adds a test account.
2. This container exports a `NEXT_PUBLIC_SUPABASE_URL` for **another** project, so always build and run with
   `set -a; . ./.env.local; set +a; npm run build` (then `npm start`).
3. To stop a server: `ps aux | grep -E "next-server|next start" | grep -v grep | awk '{print $2}' | xargs -r kill`.

## Database (Supabase project "Orgcue.com", ref `qlzlnsjkacjqagvxlbvq`, eu-west-3)
- Migrations: `supabase/migrations/<version>_<name>.sql`; the names match the project's migration history.
- **Apply directly:** `node scripts/db.mjs status`, `node scripts/db.mjs migrate [--dry-run]`, `node scripts/db.mjs sql "…"`.
  These call the Management API over HTTPS; the proxy adds the `api.supabase.com` credential from the environment's
  Network secrets. 401 means the credential is missing or invalid; 403 means it belongs to an account without access to
  this project. Either way the owner has to fix it in the environment settings: a personal access token from the
  account that owns the project.
- The Supabase **connector** works for reads and additive DDL. Statements with DELETE/DROP/TRUNCATE come back
  `cancelled` (its confirmation dialog can't be shown here), whatever its permissions say. Don't work around that.
- Direct Postgres (5432/6543) is blocked from this container. `.github/workflows/supabase-migrations.yml` is a
  manual-only fallback (needs repo secret `SUPABASE_DB_URL`); don't add push triggers.
- `npm run seed` reloads the Lumio demo. It needs the test account, since only signed-in users may write.

## Deploy (Vercel project `orgcue`, production branch `claude/relaxed-goldberg-yjnnay`)
The Git hook often doesn't fire. After pushing, deploy the exact commit through the API (the proxy authenticates it):
```bash
curl -s -X POST "https://api.vercel.com/v13/deployments?teamId=team_GSymdcaopnxjetshSD6bP6MR" -H "Content-Type: application/json" \
  -d '{"name":"orgcue","project":"prj_95oB9tlrivwZRGfUStBhexxGtSxY","target":"production","gitSource":{"type":"github","repoId":1425685771,"ref":"claude/relaxed-goldberg-yjnnay","sha":"'"$(git rev-parse HEAD)"'"}}'
```
Then poll `GET https://api.vercel.com/v13/deployments/<id>?teamId=…` until `readyState` is `READY`, and check the live page.

## Checks before pushing
`npx tsc --noEmit` · `npm run lint` (0 errors; warnings are old) · build ·
`npm run test:auth` (public pages, beta form, auth flows; 29 checks) · `npm run test:smoke`. Chromium for Playwright is at
`/opt/pw-browsers/chromium`; Lighthouse: `CHROME_PATH=/opt/pw-browsers/chromium npx --yes lighthouse@12.8.2 <url>`.

## Open items (21 Oct 2026)
1. Run `node scripts/db.mjs migrate`: one pending migration, `20261021160000_remove_beta_test_row.sql`. It was blocked on
   the API credential (403 at handover).
2. Owner, in the Supabase dashboard: Auth → URL Configuration (Site URL `https://orgcue.vercel.app`, redirect URLs in
   README → Accounts), and custom SMTP or "Confirm email" off. Until then, confirmation emails only reach members of
   the Supabase org.
3. Not built, on offer: sign-up limited to invited beta addresses; an admin page for the beta list (view, delete, invite).
4. Accessibility on the home page is 96: the design dims the "Outlook sync" card to 60%. Kept on purpose; ask before changing it.
