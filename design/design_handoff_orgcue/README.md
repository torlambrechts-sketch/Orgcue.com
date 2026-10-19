# Handoff: Orgcue — intake, decision and generation app

## Overview
Orgcue collects knowledge from the right people in an organization, settles conflicts through one named decider, locks a traceable specification, and generates instructions for AI tools (AGENTS.md, CLAUDE.md, Cursor rules, Copilot Studio, Agentforce, policy drafts, BPMN). After launch it tracks actions, drift and constraint reviews.

The **product and behavior source of truth is `spec/Orgcue Product Spec.md`** (v1.0, 26 sections). This README covers how the prototype implements it, the visual system it uses, and where the two differ. Where they conflict, the product spec wins on behavior and this README wins on visuals.

## About the design files
The files in `prototype/` are **design references built in HTML**. They show the intended look, flows and behavior. They are not production code to copy. The task is to **recreate them in the target codebase's environment** (the spec's §24 build order assumes a React-style web app with auth, orgs and an API), using its established patterns. If no codebase exists yet, pick a modern React stack (e.g. Next.js + TypeScript) and implement there.

To run the prototype, serve `prototype/` from any static server and open `Orgcue.dc.html`. The dark strip at the top is the **demo control bar** (View as / Phase / Show all features). It is a dev tool (spec §3) and **must not ship to production**. Put it behind a dev flag.

## Fidelity
**High-fidelity** for layout, copy, states and interactions. Colors, type, radii and spacing come from the bound **Orgpuls** design system (see Design tokens). This intentionally replaces the spec's §6 "Status grid" palette (Figtree, #0B6FE0 blue, monday-style cells). If the target product will use the spec's §6 palette instead, keep every layout, behavior and status mapping from here and swap the token table only. Status semantics are identical in both.

## App shell (spec §5)
- **Demo bar** (dev only): ink background #191510, 12.5px text. Segmented "View as" (Owner / Decider / Contributor / Org admin) and "Phase" (6 phases). Selected = saffron #F5C64A with ink text. "Show all features" switch. Links to Phone flow and Customer page.
- **Top bar**: 32px ink square logo with "O" (Playfair 17/600), "Orgcue" (Playfair 20/600), org name (13px, #5F5849). Centered search, max 420px, 38px field. 36px round "?" button. "＋ New project" primary button (owner and admin only). 34px initials avatar.
- **Sidebar**: 240px expanded / 72px collapsed, 180ms ease-in-out width transition. The collapsed state persists in `localStorage['orgcue-navC']`. Nav items: Home ⌂, Projects ▦, Templates ❐, Library ▤, Portfolio ▥ (hidden for contributors), Settings ≡. Each glyph sits in a 26px tile, saffron when current and #F2EAD6 at rest. The active row is #FBEBBE and 700 weight. Collapsed rows are 52px wide with a 10px label underneath. A "Projects" list follows (14px color square + name + phase). The footer reads "Name · Data region: US".
- **Main panel**: margin 0 8px 8px 0, 1px #E8DFC9 border, radius 14, background #FFFDF6, padding 22px 28px, fluid with no max-width. Wide tables keep a min-width and scroll horizontally inside their card.
- **Toast**: bottom-center, ink background, cream text, radius 12, 2.6s.
- **Entry animation** on every screen root: opacity 0→1 with a 6px rise, .25s ease. Honors `prefers-reduced-motion`.

## Shared view template — Board / List / Timeline (spec §7)
One implementation (`K.views` in `oc-kit.js`) is used by **every list**: Home "Your projects", Projects, Templates, Library, project Members, Input items, Brainstorm ideas, Actions, Settings → People and the Settings → Audit log. Build it as one component.
- **Header**: h1 (Playfair 28/600), a one-line subtitle, and on the right a segmented Board · List · Timeline control (track #F2EAD6, selected = ink fill with cream text, radius 9) plus a CSV button. The view choice persists per list in `localStorage['orgcue-view-<key>']`.
- **Toolbar**: hairline top and bottom. Primary buttons, then ◯ Search (200px, filters rows live), ◐ Person, ⊽ Filter, ⇅ Sort, ▤ Group by: <field>.
- **List**: groups stacked 30px apart. Group header: ⌄, title in the group color (17/600), "N items". Table: 6px color bar on the left (top-left radius 8), header labels 13px #5F5849, 1px #E8DFC9 grid lines, rows min 42px. Add row: half-opacity color bar, "＋ Add <noun>", and on the right a 180×20 status distribution bar.
- **Cell kinds**: name (bold + subline), text, mono, **status** (full-color cell, always carries text), avatar (28px ink circle, initials), button, chip, checkbox, progress bar.
- **Board**: `grid-auto-flow: column; grid-auto-columns: minmax(260px, 1fr)`. Column: 10px color dot, title 14.5/700, count bubble, tinted background rgba(25,21,16,.05), radius 16. Card: tag pill + mono ID, title 16/600, optional description, avatar + person + role, optional "! warning" pill (#6B240C background, white text), footer split left and right above a hairline.
- **Timeline**: 280px label column, month ticks, 22px rounded bars from start to end colored by status, due-date dots (14px), milestone diamonds (14px rotated square; amber when at risk), a 2px #6B240C **today** line (Nov 12, 2026), and a footnote saying what the bar spans.
- Brainstorm's Board view renders the clustered sticky notes (§10.7) instead of columns.

## Screens
Every screen exists in `prototype/`. Routes are hash routes.

| Route | Screen | Spec | File |
|---|---|---|---|
| #/home | Home: greeting, next-step card (role × phase matrix §25.3), 7×14 input heatmap, For you, Getting started (owner, Show all off), Your projects (shared views) | §8 | OcPages |
| #/projects · #/templates · #/library · #/portfolio | Shared views; Library KPIs, Propose change / Withdraw on LIB-HC-015, Still true?; Portfolio KPIs, days per phase, repeat questions, where time is lost | §11–13 | OcPages |
| modal | New project wizard: Start · Basics · Sections · Questions · People · Review; framework sections added and removed; minutes = min(q, 8) × 2 | §9 | OcWizard |
| #/p/:id/overview | Header, phase stepper, role tabs; next step, funnel, coverage, members, close-the-loop (Validate+, owner), lock checklist, milestones, activity | §10.1–10.2 | OcProject |
| #/p/:id/members | Members (shared views) with Nudge now, send drawer (540px, tokens, why-you per member, Email/Slack/Teams preview), external respondents card | §10.3, §18.1 | OcProject |
| #/p/:id/input | Frame: smart question set with Ask anyway / Skip again + question editor. Collect: close and reveal with progress, adaptive questions. Review+: stats, customer evidence (Create requirement → REQ-025), gap cards, Input items (shared views) with a detail drawer (versions, comments, upvotes, approve/reject with reasons) | §10.4, §14–16, §18.3 | OcProject |
| #/p/:id/my-input | Contributor: questions with an inline editor, private ideas (≤3), team input with vote-to-see-counts, footprint, about panel with prefill facts | §10.5 | OcProject |
| #/p/:id/brainstorm | Locked before reveal; afterwards ideas (shared views; Board = sticky-note clusters), Promote / Park | §10.7 | OcProject |
| #/p/:id/spec | Version pill, Compare with v1.3, review banner, lock panel (decider only), simulated runs (20, Re-run 1.4s), framework coverage (NIST / ISO / AI Act, Add requirement → REQ-024), document sections, Agree/Object (reason + alternative required), T-01 suggestion diff (Accept / Merge / Keep mine → DEC-07), DEC-03 options with advisory points and Record decision, superseded banner (Live) | §10.8, §17, §19 | OcSpecGen |
| #/p/:id/generate | Target picker, what the AI receives, 8 gates (Fix on HC-019), approve and generate (decider) or request approval, instruction check with Apply safe fixes, output explorer (Files with "why this line", Changes with cause chips, Flow map, Segmentation, Not in any file), pilot comparison, 24 scenarios, trace matrix, evidence pack, MCP; Live drift banner | §10.9, §20 | OcSpecGen |
| #/p/:id/actions | Actions (shared views); status cell cycles; bulk bar; drawer (460px) with Accept/Decline, checklist, reminder rules; ServiceNow-synced actions are read-only | §10.10 | OcProject |
| #/settings/:section | Sub-nav, typed rows (toggle, segmented, select, number, text, range, Locked), draft + sticky save bar, audit event on save, View only for non-admins, contributors see only Profile and Notifications; People and the Audit log use shared views; Integrations grouped by category + MCP card | §21–22 | OcSettings |
| #/phone · #/customer | Contributor phone flow (6 screens, 390×844, 7px ink bezel, ≥44px targets); branded customer page (consent gates Start, 4 questions, ≥50px choices, "Powered by Orgcue") | §10.6, §18.2 | OcPhone |

**Role-dependent tabs** (§10.1): Owner and Decider see Overview · Members · Input · Brainstorm · Spec · Generate · Actions. Contributor sees Overview · My input · Brainstorm · Spec (+ Actions from Validate). Admin sees Overview · Members · Spec · Actions. With Show all features off, Generate and Actions are hidden before Validate. Peers see function groups, never names (§2.3). Restricted sections show "⊡ Restricted section · Visible to owner, decider, security".

## Interactions & state
The prototype keeps one shared store (`OCK.S` in `oc-kit.js`), which maps cleanly to server state plus a client cache:
- `role`, `phase`, `all` (demo only) · `navC` (sidebar)
- Collection: `skip{}` (smart set), `adapt`, `kept{}` (adaptive), `ans{}`, `myIdeas[]`
- Review: `votes{}`, `coms{itemId: [{type, text}]}`, `appr{itemId: {st, reason}}`, `agree{}`, `t01`, `promoted{}`
- Decide: `dec03`, `dec03r` (rationale), `dec07`, `locked`
- Generate: `gateFix`, `lint{L1…L6}`, `gen`
- Live: `loopSent`, `act{id: {status, accept}}`, `cl{}` (checklists)
- Org: `libPending`, `libAsked{}`, `req024`, `req025`, `saved{}` + `audit[]` (settings), `conn{}` (integrations), `wiz` (wizard)

Key transitions, all from the spec:
- Send (Frame) → Collect.
- Close and reveal → about 2s progress → Review.
- Record DEC-03 (needs an option and a rationale) → "Password reset at 8am" scenario passes and the lock checklist updates.
- Lock v1.4.0 needs DEC-03 and DEC-07 settled, is decider only, and writes a hash.
- The generate gates must all pass; then Approve diff (decider) → progress → "✓ Pull request #42".
- Apply safe fixes leaves the 2 high-severity issues; the score is 100 minus the weighted open issues (High 15, Medium 6, Low 3).
- Actions: clicking a status cell cycles To do → Working on it → Blocked → Done.
- Settings: changes show a "Changed" badge and the "N unsaved changes · Discard · Save changes" bar.

## Design tokens (Orgpuls)
**Colors**
- Canvas #FCF6E9 · surface #FFFDF6 · ink #191510 · body #3A342A · muted #5F5849 · faint #8A8272
- Hairline #E8DFC9 · rule/dashed #C4BCA8 · track #F2EAD6
- Accent (one primary per screen, current state) #F5C64A · selected fill #FBEBBE · band #F5DC96 · amber bar #E0A21F · caution #8A6A00 · caution deep #5C4600
- Mint #CFE7E4 · link/done #2F5D2A · green deep #20431C · green bar #5C9A55 · sage #9DB8B3 · pulse #E4EEEC
- Peach #FBD5C4 · rust bar #D4633A · danger deep #6B240C · decision tint #E7DAF2 · ink 5 % rgba(25,21,16,.05) · ink 8 % rgba(25,21,16,.08)

**Status cells (full color, always with text)**
- Done / Pass / Published / Confirmed / Connected: #2F5D2A on white
- Working on it / In progress / Partial / Check due: #F5C64A on ink
- Blocked / Overdue / Fail / Conflict / Gap / High: #6B240C on white
- To do / Draft / Not sent / Low: #F2EAD6 on ink
- Owner pending / Decide / Requested / Deferred: #E7DAF2 on ink
- Review / Pending review: #CFE7E4 on #20431C
- Validate: #9DB8B3 on ink

**Typography**
- Playfair Display 500–700 for h1 (28/1.2), panel titles (19/600), KPI figures (32), sticky notes (15.5) and phone questions (25).
- DM Sans 400–700 for all UI. Root size 14px; half-pixel sizes are deliberate (11.5, 12.5, 13.5, 14.5).
- Eyebrows 11px uppercase, tracking .11em. Table heads 10.5px, tracking .09em.
- Mono (ui-monospace, Menlo) for IDs, files and code.

**Radius**: 6 focus/ID chips · 8 table · 9–10 segmented and nav · 12–13 rows · 14 main panel and phone options · 16 board column · 18 panels · 20 cards · 22 modal · 999 pills.

**Spacing**: block gap 16; panel padding 18/20; list rows 10/12; card grids gap 10–13.

**Borders, shadows and focus**
- Borders: 1px hairline on every surface; 1.5px ink on the strong (next-step / lock) panel; 2px ink on selected cards; dashed amber on gap cards.
- Shadows only on floating layers: menu 0 18px 40px −24px rgba(25,21,16,.45); drawer and modal 0 34px 80px rgba(25,21,16,.3). The scrim is 42 % ink.
- Focus: 3px ink outline with a 2px offset.
- No hover color changes on buttons or cards. Links turn #1E3D1A and underline.

**Glyphs (no emoji)**: ✓ ✕ ! ▲ ⌄ « » → ◯ ◐ ⊽ ⇅ ▤ ⊡ ◆ ＋ ×

## Assets
- No images. Fonts and components come from the Orgpuls design system bundle in `prototype/_ds/`; use your codebase's equivalent.
- Demo data is in `prototype/oc-data.js` and matches spec §25 (Lumio Inc., IT Helpdesk Agent v1, story date Thu Nov 12, 2026). Use it for seeds and tests.

## Acceptance
Use spec §26 (17-step end-to-end demo). Each step can be performed in the prototype with the demo bar.

## Screenshots
`screenshots/` holds 21 captures at viewport size: they show the top of each screen; scroll the prototype for the rest. Each name says the screen and the role or phase: 01-home, 02-projects-list, 03-projects-board, 04-projects-timeline, 05-library, 06-portfolio, 07-new-project-wizard, 08-project-overview, 09-project-members, 10-input-frame-smart-questions, 11-input-collect-adaptive, 12-input-review-items, 13-brainstorm, 14-spec-decider, 15-generate, 16-actions, 17-my-input-contributor, 18-settings-integrations, 19-settings-questions-library, 20-phone-contributor-flow, 21-customer-page.

## Files
- `spec/Orgcue Product Spec.md`: full product and build specification
- `spec/Orgcue prototype notes.md`: file map and visual-system note
- `prototype/Orgcue.dc.html`: entry (shell + router)
- `prototype/OcPages.dc.html`, `OcProject.dc.html`, `OcSpecGen.dc.html`, `OcWizard.dc.html`, `OcSettings.dc.html`, `OcPhone.dc.html`: screens
- `prototype/oc-kit.js`: store, status colors, block builders, the shared Board/List/Timeline template (`K.views`)
- `prototype/oc-data.js`: seed data
- `prototype/support.js`, `prototype/_ds/`: prototype runtime and design-system bundle (reference only)
