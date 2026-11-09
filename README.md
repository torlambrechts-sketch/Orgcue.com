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

`npm run build` makes a production build and `npm run lint` runs ESLint.
Pushes to `claude/relaxed-goldberg-yjnnay` deploy to https://orgcue.vercel.app.

## Supabase

The app talks to the Supabase project `qlzlnsjkacjqagvxlbvq` with its publishable key, which is safe in the browser.
Never put the secret or service-role key in a `NEXT_PUBLIC_` variable.

- `src/lib/supabase/client.ts`: client for Client Components.
- `src/lib/supabase/server.ts`: client for Server Components, Server Functions and Route Handlers. Create one per request.
- `src/proxy.ts`: refreshes the signed-in user's session cookie on each request.
- `/api/health`: returns `{"supabase":"ok"}` when the app can reach Supabase.

The same two variables are set in the Vercel project for production, preview and development.
