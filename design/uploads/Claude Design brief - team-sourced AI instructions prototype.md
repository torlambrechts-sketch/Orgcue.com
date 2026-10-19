# Claude Design brief — team-sourced AI instructions prototype

Oct 18, 2026 · @Tor

## Product and prototype goal

Paste everything below this section into Claude Design, one section at a time or whole. It describes a clickable, high-fidelity prototype of every surface: marketing, onboarding, owner workspace, distribution, contributor intake, decisions, export, validation, org admin and platform admin.

**Product.** \[Product\] is the intake and decision layer for AI work. A team that wants an AI agent, policy or spec built asks its experts targeted questions by role. The app turns their answers into context items, finds duplicates and conflicts, and sends real conflicts to a named decider. It then compiles an approved, versioned, traceable brief and exports it as AI instructions to the platform the customer uses.

**Users.** Leadership and cross-functional teams in English-speaking mid-market and enterprise firms (250–5,000 employees), mainly in the US and UK. Contributors know nothing about AI and never see a prompt.

**Prototype goal.** Show a design partner or buyer the full loop in five minutes: create a brief, invite the team, answer on a phone, settle a conflict, lock the brief, export it to Copilot Studio, and validate the result.

**Hard rules for the whole prototype**

- English only. UI copy, sample data and dates in US English; currency in USD.
- Use "\[Product\]" as the placeholder wordmark and name everywhere.
- Never use the words survey, questionnaire, respondent, assessment or prompt engineering in the UI. Use brief, intake round, contributor, context item, decision card, constraint and export.
- Strictly multi-person. No single-user mode, and no screen that rates or evaluates individual people.
- Data region is chosen per organization: EU or US. Show it in onboarding, org settings and the footer of every brief.

## Design direction

It must look like a system of record for decisions, not a form builder: calm, dense, precise, with the decision always one click away.

**Design system.** If this ships as a Metrand edition, attach the Metrand design file and use it as the core look, with its own accent color and wordmark. Otherwise build a design system with the tokens below and keep it in a separate design file.

**Principles**

1. **Show the outcome first.** Every brief screen leads with its status, its open decisions and its export state, not with the questions.
2. **Provenance everywhere.** Every context item, constraint and exported instruction shows who said it and in which round; hover to see the original answer.
3. **Conflicts are visible and named.** Use one strong conflict color for unresolved conflicts; nothing else uses it.
4. **Progressive disclosure.** Contributors see one question at a time. Owners see slot summaries first, then items, then raw answers.
5. **Two densities.** Owner, decider and admin screens are desktop-first and information-dense. Contributor screens are mobile-first, large type, one thumb.
6. **Quiet chrome.** Flat surfaces, thin borders, no gradients or shadows beyond a 1px elevation on cards and menus.

**Tokens**

| Token | Light | Dark | Use |
| --- | --- | --- | --- |
| Surface | #FFFFFF | #111315 | Page background |
| Surface-2 | #F6F7F8 | #1A1D20 | Cards, side panels |
| Border | #E3E5E8 | #2A2E33 | Dividers, inputs |
| Text | #14171A | #ECEEF0 | Body text |
| Text-muted | #5F6670 | #9AA1AA | Labels, metadata |
| Accent | #2F5BEA | #6E8BFF | Primary actions, links, selected states |
| Decision | #7A3FE0 | #A98BFF | Decision cards and decider actions |
| Conflict | #D64545 | #FF7A7A | Unresolved conflicts only |
| Success | #1F8A5B | #4CC38A | Gates passed, resolved, exported |
| Warning | #B7791F | #E5B567 | Gaps, reminders due, re-attestation due |

**Type.** Inter (or the design system's font): 28/36 page titles, 20/28 section titles, 15/22 body, 13/18 metadata, 12/16 table headers in small caps. Use tabular numbers for counts and dates.

**Layout.** Desktop at 1440px: 240px left navigation, content max 1200px, 24px gutters, 8px spacing grid. Mobile at 390px: single column, 16px side gutters, bottom action bar.

**Core components** (keep them in the design system file): status pill, role chip, constraint chip with ID (e.g. C-12), context item card with provenance footer, relation badge (duplicate, refines, conflicts), decision card, coverage meter per slot, round timeline, channel badge (email, Slack, Teams, link), export target tile, gate checklist row, version diff, audit row, empty state, toast and confirm dialog.

## Roles and permissions

Roles are per brief, except the three admin roles. One person can hold several roles; the UI shows the active role in the header and lets them switch.

| Role | Who | Can do | Never sees |
| --- | --- | --- | --- |
| Contributor | Domain expert invited to a brief | Answer their own questions, react to the merged brief in round 2, see their own footprint | Other contributors' answers in round 1; restricted slots |
| Authority contributor | Contributor flagged as owner of a slot (e.g. security, legal, finance) | Everything a contributor can, plus confirm or reject hard constraints in their slot | Restricted slots they don't own |
| Brief owner | Person accountable for the brief | Frame the brief, pick the template, map roles, distribute, see all items, send targeted questions, request export | Nothing hidden, except restricted slots they don't own |
| Decider | Named approver of the brief | Settle decision cards with rationale, lock versions, approve export diffs | — |
| Consultee | Employee representative or works council member, where a template requires it | Comment on consult-step slots and record a consultation outcome | Unrelated slots |
| Viewer | Stakeholder kept informed | Read locked versions and the decision log | Raw answers |
| Org admin | Customer IT or AI program lead | Members, SSO, data region, retention, model providers, integrations, billing, templates, audit export | Answer content in restricted slots, unless also a role in that brief |
| Template author | Customer or partner who builds templates | Edit output schemas, question banks, role maps, synthesis rules and renderers | Customer briefs |
| Platform admin | \[Product\] staff | Tenants, plans, template marketplace, model and prompt versions, golden-set test runs, incidents | Customer answer content, ever |

Show permissions visibly: lock icons on restricted slots, a "blind round" banner during round 1, and "visible to: owner, decider, security" metadata on each restricted item.

## Sitemap and design files

Split the prototype into seven design files that share one design system file. Link them so the click-through flows in the last section run across files.

| File | Screens | Primary device |
| --- | --- | --- |
| 0. Design system | Tokens, type, components, icons, light and dark | — |
| 1. Marketing and onboarding | Landing page, pricing, sign-in, workspace setup | Desktop and mobile |
| 2. Owner workspace | Home, brief list, template gallery, new-brief wizard, synthesis workspace, coverage and gaps | Desktop |
| 3. Distribution | Invite builder, channels, schedule and reminders, tracking, message previews | Desktop |
| 4. Contributor | Invite landing, intake, follow-ups, done, round 2 review, footprint | Mobile, with desktop variants |
| 5. Decide, brief and export | Decision cards, locked brief, version history, compile and export, gates, validation, re-attestation | Desktop |
| 6. Admin | Org context library, org admin settings, template builder, audit log, billing | Desktop |
| 7. Platform admin | Tenants, marketplace, model and prompt versions, golden-set runs, system health | Desktop |

**Owner and admin navigation** (left rail): Home, Briefs, Decisions, Templates, Org context, Exports, Audit log, Settings. Show a workspace switcher at the top and the data region (EU or US) at the bottom.

**Contributor navigation**: none. Contributors arrive through an invite link and see only their task, with a progress bar and a single "Continue" action.

## Screens: marketing, onboarding, home and new brief

Each screen has an ID so flows and comments can point at it.

### File 1 — Marketing and onboarding

**1.1 Landing page.** Hero: "Get your team aligned before the AI builds it." Subline: "\[Product\] turns what your experts know into an approved brief any AI tool can execute." Primary CTA "Book a demo", secondary "See how it works". Below: a three-step strip (Ask the right people → Settle the conflicts → Export to your AI), an animated preview of a decision card, integration logos as neutral tiles (Copilot Studio, Agentforce, ServiceNow, Claude, ChatGPT, Slack, Teams), a trust strip (EU or US data region, SSO, audit log, no training on your data), three use-case cards (AI agents, AI-use and HR policies, team playbooks), and a footer.

**1.2 Pricing.** Three tiers as cards: Team, Business, Enterprise. Annual organization subscription sized by live briefs; contributors are always free and unlimited. Enterprise adds SSO, audit export and a dedicated instance. Add-on row: template packs. FAQ accordion.

**1.3 Sign-in.** Email magic link, Google, Microsoft, SSO button.

**1.4 Workspace setup (4 steps, stepper on top).** Step 1: organization name, size, industry. Step 2: data region (EU or US) as two large tiles with a "can't be changed later" note. Step 3: connect channels (Slack, Teams, email domain) and export targets (Copilot Studio, Agentforce, ServiceNow, Claude, ChatGPT, Markdown download), each as a tile with Connect / Skip. Step 4: pick a first template, with "IT helpdesk agent" preselected.

### File 2 — Owner workspace (part 1)

**2.1 Home.** Top: greeting and three counters (Active briefs, Decisions waiting on you, Re-attestations due). Main: "Needs your attention" list mixing decision cards, gaps, overdue contributors and constraints due for review, each with one action button. Right column: round timeline of the active brief and recent exports.

**2.2 Briefs list.** Table: brief name, template, owner, decider, stage (Framing, Intake, Review, Deciding, Locked, Exported, Live), progress bar of contributors done, open conflicts count in conflict color, next deadline, export target icon. Filters by stage, template and owner; saved views.

**2.3 Template gallery.** Cards grouped by category: AI agents (IT helpdesk, HR helpdesk, customer service, sales assistant), Policies (AI-use policy, HR policy, information security policy), Playbooks (onboarding, incident response). Each card: description, roles involved, number of questions, typical time per contributor, export targets, "Preview" and "Use template". A "Marketplace" tab shows partner-built templates with publisher badges.

**2.4 New brief wizard (round 0, Frame).** Left: six steps; right: live preview of the brief outline filling in.

1. **Goal:** name, what the brief is for, deliverable type, audience.
2. **Export target:** pick the platform; show what the output will look like for it.
3. **People:** owner, decider, and a role map table (role, person, authority slots, consult step yes/no). Add people by name or email, or import from a Slack or Teams channel.
4. **Documents:** drag-and-drop upload of existing policies, SOPs and tickets, with a "prefill the draft from these" toggle and a parsing progress state.
5. **Questions:** per role, a preview of the 5–8 questions each person will get, editable, with estimated minutes per role. Show restricted slots with a lock icon.
6. **Schedule:** round windows on a timeline (R1 intake, R2 review, R3 decide, R4 validate), deadline, reminder cadence. Final button: "Continue to distribution".

## Screens: distribution

Distribution gets each contributor their own questions through the channel they already use, then chases gently until the round closes.

### File 3 — Distribution

**3.1 Invite builder.** Table of contributors: name, role, channel (email, Slack, Teams, or copy link), language fixed to English, estimated minutes, status. Bulk actions: change channel, resend, remove. Right panel: the invite message with merge fields ({first\_name}, {role}, {brief\_name}, {minutes}, {deadline}, {owner\_name}), a purpose statement the owner must fill ("why we're asking you"), and a note on blind round 1 and who will see answers.

**3.2 Channel previews.** Three side-by-side previews of the same invite: email, Slack message card with a "Start (12 min)" button, and Teams adaptive card. Show sender as the brief owner, not the product.

**3.3 Schedule and reminders.** Round timeline with start and close dates per round. Reminder rules as rows: "2 days before close if not started", "on close day if not finished", "stop after 3 reminders". Quiet hours setting. Toggle: escalate to owner when an authority contributor hasn't answered.

**3.4 Tracking.** Funnel for the round: Sent → Opened → Started → Finished, with counts and a list per stage. Per-contributor rows show last activity, channel, reminders sent, and a "nudge now" button. Highlight missing authority roles in warning color with "Slot at risk: Security has no answers yet".

**3.5 Targeted follow-up.** When a gate fails or a slot is thin, the owner sends one question to one role. Composer prefilled by the system ("Security: what verification is required before a password reset?"), channel picker, due date. These show in tracking as "follow-up" rows.

**3.6 Re-attestation run.** For live briefs, a scheduled distribution that asks each constraint owner to confirm or update their constraints. Each email or card shows the constraint (e.g. "C-12: The agent never asks for a password"), with buttons Still true / Needs change.

## Screens: contributor intake and round 2

The contributor experience must feel like a short conversation with a sharp colleague: 10–15 minutes, one question at a time, no AI vocabulary. Design at 390px first, with a desktop variant at 1440px centred in a 640px column.

### File 4 — Contributor

**4.1 Invite landing.** Owner's photo and name, brief name, the owner's purpose statement, "About 12 minutes", deadline, and three reassurance lines: your answers stay private in round 1; you'll see how your input was used; this is about the work, not about people. Button: "Start".

**4.2 Prefilled reaction.** "Here's what we already know from existing documents." A short draft section with three choices per point: Correct, Needs a change, Out of date. "Needs a change" opens a text field.

**4.3 Question card.** One question in large type, a helper line in muted text, a free-text field with voice input and attachment buttons. Below the answer, one plain choice: Must-have, Nice-to-have, Just an idea. Progress bar on top ("4 of 7"), Back and Continue at the bottom. Show variants for each question pattern: non-negotiables, pre-mortem, exceptions, history, good and bad examples, definition of done, boundaries.

**4.4 Follow-up.** After a vague answer, a lighter card slides in: "You mentioned 'secure'. Which check must happen before a reset?" Small text: "1 of 3 follow-ups this round". Skip is always visible.

**4.5 About the work, not people.** If an answer names and judges a colleague, an inline notice asks the contributor to restate it as a fact about the process, with an "Edit answer" button. No one else ever sees the original.

**4.6 Done.** "Thanks, Sam. Here's what happens next": timeline of the rounds, date of round 2, and "You'll get a link when the merged brief is ready."

**4.7 Round 2 review.** The merged brief by section. Each item shows supporters as role chips (not names, unless the contributor wrote it) and actions Agree, Object, Comment. Conflicts appear as highlighted cards with both positions side by side and "Which matters more to you?". A 100-point allocation widget for contested items, with sliders that always sum to 100. Authority contributors see "Confirm hard constraints" with Confirm / Reject per constraint ID.

**4.8 Footprint.** Private to the contributor: a list of everything they said, each tagged Used, Merged with others, Sent to a decision, or Not used (with the reason). Link to the locked brief once it's approved.

**4.9 Consult step** (for consultees, policy templates only). Slots that need consultation, each with the proposed wording, a comment thread and "Record consultation outcome" (Agreed, Agreed with changes, Not agreed, with notes).

## Screens: synthesis, decisions, brief, export and validation

These are the screens that sell the product. Make them the most polished in the prototype.

### File 2 — Owner workspace (part 2)

**2.5 Synthesis workspace.** Three panes. Left: the brief's slots (Objective, Scope, Hard constraints, Escalation rules, Data the agent may use, Tone, Examples, Acceptance criteria, Open questions), each with a coverage meter and a role-coverage dot per authority role. Middle: context items in the selected slot as cards, with type label (fact, constraint, risk, idea), strength (must-have, nice-to-have, idea), relation badges (duplicate of, refines, conflicts with) and a provenance footer (role, round, quote on hover). Right: the item's detail with the original answer, merge history and actions (Edit wording, Split, Mark as restricted, Send to decision). Top bar: "Pipeline last run 2 min ago", counts of items, merges and conflicts, and a "Gaps" button.

**2.6 Gaps panel.** List of thin or missing slots, failed coverage rules and flagged items: person-directed judgments returned to writers, and text that reads like instructions to the AI ("possible injected instruction", with the quote and Ignore / Keep as data). Each gap has "Send targeted question" (links to 3.5).

### File 5 — Decide, brief and export

**5.1 Decision queue.** For the decider: cards sorted by impact, each with title, slot, conflict type (contradiction, priority, scope, factual, terminology), number of supporters per side, and age.

**5.2 Decision card.** Title ("Password resets through chat"). Two to three options as columns, each with its supporters as role chips, evidence quotes, consequences and the constraints it touches by ID. Round-2 point allocation shown as a small bar per option. Actions: Choose option, Write a new option, Defer as open question, Ask for a short meeting. A required rationale field, then "Record decision". After saving, the card shows as a decision record: D-04, decided by, date, rationale, superseded items.

**5.3 Locked brief.** Document view of the canonical brief with version pill (v1.2, Locked), owner and decider, data region footer. Hard constraints listed with IDs and owners and review dates. Hovering any sentence shows its source items. Side panel tabs: Decisions, Open questions, Comments, History.

**5.4 Version history.** List of versions with who locked them and why; a side-by-side diff with added, removed and changed lines, and the decisions that caused each change.

**5.5 Compile and export.** Choose a target tile (Copilot Studio, Microsoft Employee Self-Service agent, Agentforce, ServiceNow, Claude project, ChatGPT GPT, Markdown files). Preview the compiled output in the target's format, with hard constraints marked as inserted verbatim. Gate checklist above the preview: all hard constraints present by ID, every required slot covered by its authority role, every instruction traced to items, no unreviewed injection flags, length within budget. A failing gate shows Fix (links to 2.6). Final step: the decider approves an export diff against the last export, then "Export" with a success state and the target's link.

**5.6 Validation (round 4).** Test scenarios generated from real past tickets in a table: scenario, expected behavior, AI output, contributor verdict (Respects my constraints / Violates C-12). A pilot comparison card: team brief versus the owner's solo draft, constraint violations for each, with the pass threshold line. Violations offer "Reopen brief".

**5.7 Live briefs and re-attestation.** Briefs in production with their export target, last export date, constraints due for review, and drift alerts ("Policy changed since export"). Each row has Run re-attestation (links to 3.6).

## Screens: org context and admin

Admin screens are where buyers check trust and control. Keep them plain, complete and scannable.

### File 6 — Admin

**6.1 Org context library.** Tabs: Constraints, Glossary, Standards, Decisions. Constraints table: ID, statement, owner, slot, briefs using it, review date, status (Current, Due, Changed). Changing a constraint shows which live briefs it affects. New briefs pull from this library, so the wizard shows "12 constraints reused".

**6.2 Members and roles.** Table of people with org role (Org admin, Template author, Member), SSO status, last active and briefs involved. Invite, deactivate, transfer ownership. Groups synced from Entra ID or Okta.

**6.3 Security and data.**

- Data region (EU or US), shown read-only with the date chosen.
- SSO and SCIM settings.
- Retention: raw answers kept for a chosen period, locked briefs kept indefinitely.
- Model providers with in-region, zero-retention endpoints and a per-step model choice (atomize, relate, render).
- Restricted-slot policy defaults.
- Audit export (CSV or SIEM webhook).

**6.4 Integrations.** Channels (Slack, Teams, email domain verification) and export targets (Copilot Studio, Employee Self-Service agent, Agentforce, ServiceNow, Claude, ChatGPT, Markdown, webhook), each with status, connected-by and a Test button.

**6.5 Template builder.** The data-not-code editor, in four tabs:

1. **Output schema:** ordered slots with type, required flag, length budget, authority role, restricted flag and consult step.
2. **Question bank:** questions per slot and role, answer type, follow-up triggers (missing number, system name, example or reason), prefill source, preview as a contributor sees it.
3. **Synthesis rules:** per slot, merge rule, conflict rule (auto, vote, decider) and authority roles.
4. **Renderers:** one per export target, with a live preview against sample data and a version number.

Top actions: Save draft, Test with sample answers, Publish version, Submit to marketplace.

**6.6 Audit log.** Filterable stream: who did what, when, on which brief, item or decision; exports with their diffs; permission changes; re-attestations. Every row links to the object.

**6.7 Billing.** Plan, live-brief count against the plan limit, template packs owned, invoices, and a usage chart of live briefs per month. Copy makes clear that contributors are free and unlimited.

### File 7 — Platform admin (internal)

**7.1 Tenants.** Organizations with plan, region, live briefs, active contributors, health score and last incident. Tenant detail shows configuration and usage only, never answer content, and says so.

**7.2 Marketplace.** Template submissions queue with review status, publisher, version, installs and ratings; approve, request changes, unpublish.

**7.3 Model and prompt versions.** Each pipeline step (atomize, relate, merge, decision-card draft, render) with its current model and prompt version, rollout percentage and rollback button.

**7.4 Golden-set runs.** Results of the seeded-conflict test set per model or prompt change: conflicts caught, false merges, constraints dropped, pass or fail against thresholds. Release is blocked when a run fails.

**7.5 System health.** Queue depth and job latency per pipeline stage, failed jobs with retry, export success rate per target, and incidents.

## Sample data

Use one scenario on every screen, so the click-through reads as a single story. The organization is Lumio Inc., a 1,200-person software company in Austin, Texas, on the US data region.

**Brief:** "IT Helpdesk Agent v1", template IT helpdesk agent, export target Copilot Studio (Microsoft Employee Self-Service agent). Stage: Deciding. Deadline: November 14, 2026.

| Person | Brief role | Authority slots |
| --- | --- | --- |
| Kari Nordmann, IT Service Manager | Brief owner | — |
| Daniel Reyes, CIO | Decider | — |
| Priya Shah, Security Lead | Authority contributor | Hard constraints, Data the agent may use (restricted) |
| Sam Okafor, Service Desk Lead | Contributor | Escalation rules, Examples |
| Lena Ortiz, Finance Business Partner | Authority contributor | Spending limits |
| Mei Lin, Data Protection Officer | Authority contributor | Personal data |
| Tom Becker, Legal Counsel | Contributor | — |
| Grace Kim, Employee Experience Lead | Contributor | Tone |

**Progress:** 7 of 8 contributors finished round 1; Tom Becker opened the invite but hasn't started. 64 context items, 21 merged duplicates, 4 open conflicts.

**Conflicts (decision cards)**

1. **D-03 Password resets through chat.** Service desk: reset after one verification question, to cut wait times. Security: require MFA push before any reset. Points: service desk side 35, security side 65.
2. **D-04 Hardware orders without approval.** Service desk wants a $500 limit; finance wants $250. Decided by Daniel Reyes: $250, revisit in Q2 with spend data.
3. **D-05 Personal devices.** Whether the agent answers questions about personal phones on the corporate network. Contributors split; deferred as an open question.
4. **D-06 After-hours escalation.** Escalate security incidents to on-call within 15 minutes, or open a ticket for the morning shift.

**Hard constraints (selection)**

- C-07: The agent never asks for or accepts a password. Owner: Priya Shah. Review: March 1, 2027.
- C-12: Suspected security incidents escalate to on-call within 15 minutes. Owner: Priya Shah.
- C-15: No hardware order above $250 without manager approval. Owner: Lena Ortiz.
- C-19: The agent never reads or summarizes HR records. Owner: Mei Lin.

**Validation:** 24 scenarios from last quarter's tickets. Team brief: 2 constraint violations; Kari's solo draft: 9; pass threshold: at most 4.

**Other briefs in the list:** "AI Acceptable Use Policy 2027" (Intake, 9 of 14 finished), "Customer Support Agent Tier 1" (Live, exported to Agentforce, 3 constraints due for review), "HR Helpdesk Agent" (Framing).

## Flows, states, copy and handoff

Wire these flows as clickable prototypes across the design files; they are what a demo walks through.

### Click-through flows

1. **Five-minute demo:** 2.1 Home → 2.3 Template gallery → 2.4 Wizard → 3.1 Invite builder → 3.2 Slack preview → 4.1–4.6 Contributor on mobile → 2.5 Synthesis → 5.2 Decision card D-03 → 5.3 Locked brief → 5.5 Export to Copilot Studio → 5.6 Validation.
2. **Gap to follow-up:** 2.5 → 2.6 Gaps (security slot thin) → 3.5 Targeted question → 3.4 Tracking shows the follow-up.
3. **Round 2:** invite email → 4.7 Review with a conflict card and point allocation → authority confirmation of C-07 → 4.8 Footprint.
4. **Failed gate:** 5.5 shows "C-19 missing from output" → Fix → back to 5.5, all gates green → decider approves the export diff.
5. **Re-attestation:** 5.7 Live briefs → Run re-attestation → 3.6 constraint card → "Needs change" → new version in 5.4 with diff.
6. **Admin setup:** 1.4 Workspace setup (US region) → 6.4 Integrations → 6.5 Template builder → Publish version.
7. **Platform admin:** 7.3 Prompt version rollout → 7.4 Golden-set run fails → release blocked.

### States to draw

- Empty states for Home, Briefs, Decisions, Org context and Exports, each with one clear first action.
- Loading: the pipeline running after round 1 closes ("Reading 64 answers… labeling relations…").
- Blind round 1 locked view for contributors who try to see others' answers.
- Restricted slot as seen by someone without access: locked card with "Visible to owner, decider, security".
- Deadline passed with missing contributors; round extended.
- Export failed (target unreachable) with retry.
- Contributor link expired, and wrong-person link.
- Decision deferred to open question, rendered in the brief.

### Copy rules

- Plain, short sentences; sentence case for buttons ("Record decision", not "Record Decision").
- Speak about the work: "What must be true no matter what?" not "Provide constraints".
- Show time cost on every contributor action.
- Never: survey, questionnaire, respondent, assessment, prompt engineering, magic, AI-powered.

### Accessibility

Meet WCAG 2.1 AA: 4.5:1 text contrast in light and dark, visible focus rings, full keyboard support on desktop, 44px touch targets on mobile, and color never the only signal (conflicts also carry an icon and the word "Conflict").

### Handoff to Claude Code

- Name components exactly as in the design system list in Design direction, so they map one to one.
- Keep everything a template defines (slots, questions, roles, rules, renderers) as data shown by generic components, never hard-coded screens, in line with the data-not-code pattern.
- Annotate each screen with its route (e.g. /briefs/:id/decisions/:cardId) and the role that can open it.
- Export a short spec per file listing components, states and sample data used.
