# Claude Design prompt: [Product] clickable prototype

Paste this whole file into Claude Design. Build a high-fidelity, clickable prototype of every surface described below, in seven design files that share one design system file. Wire the click-through flows at the end across files. Where something is not specified, choose the simplest option that fits the principles and keep it consistent everywhere.

---

## 1. Product, users and goal

**Product.** [Product] is the intake and decision layer for AI work. A team that wants an AI agent, policy or playbook built asks its experts targeted questions by role. The app turns their answers into context items, finds duplicates and conflicts, and sends real conflicts to a named decider. It compiles an approved, versioned, traceable brief and exports it as AI instructions to the platform the customer uses. A light project management module tracks the follow-up actions from decisions, with optional sync to Jira or ServiceNow.

**Users.** Leadership and cross-functional teams in English-speaking mid-market and enterprise firms (250–5,000 employees), mainly in the US and UK. Contributors know nothing about AI and never see a prompt.

**Prototype goal.** Show a design partner or buyer the full loop in five minutes: create a brief, invite the team, answer on a phone, settle a conflict, lock the brief, export it to Copilot Studio, validate the result, and track the follow-up actions to done.

**Hard rules for the whole prototype**

- English only. UI copy, sample data and dates in US English; currency in USD.
- Use "[Product]" as the placeholder wordmark and name everywhere.
- Never use these words in the UI: survey, questionnaire, respondent, assessment, prompt engineering, magic, AI-powered. Use: brief, intake round, contributor, context item, decision card, constraint, export, action, milestone.
- Strictly multi-person. No single-user mode.
- No screen rates or evaluates individual people. No per-person scores, vote tallies, edit counts or task completion rates, anywhere, including project management.
- Data region is chosen per organization: EU or US. Show it in onboarding, org settings and the footer of every brief.

---

## 2. Design direction

It must look like a system of record for decisions, not a form builder: calm, dense, precise, with the decision always one click away.

**Design system.** If a Metrand design file is attached, use it as the core look with its own accent color and wordmark. Otherwise build the design system from the tokens below as file 0.

**Principles**

1. Show the outcome first. Every brief screen leads with status, open decisions, open actions and export state.
2. Provenance everywhere. Every context item, constraint, instruction and action shows where it came from (role, round, decision ID); hover shows the original.
3. Conflicts are visible and named. One strong conflict color, used for nothing else.
4. Progressive disclosure. Contributors see one question at a time. Owners see slot summaries, then items, then raw answers.
5. Two densities. Owner, decider and admin screens are desktop-first and dense. Contributor screens are mobile-first, large type, one thumb.
6. Quiet chrome. Flat surfaces, thin borders, no gradients, 1px elevation only on cards and menus.

**Tokens**

| Token | Light | Dark | Use |
| --- | --- | --- | --- |
| Surface | #FFFFFF | #111315 | Page background |
| Surface-2 | #F6F7F8 | #1A1D20 | Cards, side panels |
| Border | #E3E5E8 | #2A2E33 | Dividers, inputs |
| Text | #14171A | #ECEEF0 | Body text |
| Text-muted | #5F6670 | #9AA1AA | Labels, metadata |
| Accent | #2F5BEA | #6E8BFF | Primary actions, links, selection |
| Decision | #7A3FE0 | #A98BFF | Decision cards, decider actions |
| Conflict | #D64545 | #FF7A7A | Unresolved conflicts only |
| Success | #1F8A5B | #4CC38A | Gates passed, resolved, exported, done |
| Warning | #B7791F | #E5B567 | Gaps, due soon, overdue, re-attestation due |

**Type.** Inter (or the design system font): 28/36 page titles, 20/28 section titles, 15/22 body, 13/18 metadata, 12/16 table headers in small caps. Tabular numbers for counts and dates.

**Layout.** Desktop 1440px: 240px left navigation, content max 1200px, 24px gutters, 8px grid. Mobile 390px: single column, 16px side gutters, bottom action bar.

**Core components** (in file 0): status pill, role chip, function-group chip, constraint chip with ID (C-12), context item card with provenance footer, relation badge (duplicate, refines, conflicts), typed comment (Objection, Clarification, Evidence), tracked-change suggestion, decision card, coverage meter, round timeline, channel badge (email, Slack, Teams, link), export target tile, gate checklist row, version diff, audit row, action row, action card (board), action detail drawer, milestone marker, due-date chip (on track, due soon, overdue), status select, owner picker with acceptance state, checklist, empty state, toast, confirm dialog.

---

## 3. Roles and permissions

Roles are per brief, except the three admin roles. One person can hold several roles; the header shows the active role with a switcher.

| Role | Can do | Never sees |
| --- | --- | --- |
| Contributor | Answer own questions; in round 2 agree, object, comment, suggest changes, allocate points; see own footprint; work actions assigned to them | Others' answers in round 1; restricted slots |
| Authority contributor | Everything a contributor can, plus confirm or reject hard constraints in their slot | Restricted slots they don't own |
| Brief owner | Frame, choose template, map roles, distribute, see all items, send targeted questions, request export, manage the brief's actions and milestones | Restricted slots they don't own |
| Decider | Settle decision cards with rationale, assign decision owners, lock versions, approve export diffs, approve milestone completion | — |
| Consultee | Comment on consult-step slots and record a consultation outcome (policy templates) | Unrelated slots |
| Viewer | Read locked versions, the decision log and action status | Raw answers |
| Org admin | Members, SSO, data region, retention, model providers, integrations, billing, templates, audit export | Answer content in restricted slots unless also a brief role |
| Template author | Edit output schemas, question banks, role maps, synthesis rules, renderers and default action templates | Customer briefs |
| Platform admin | Tenants, plans, marketplace, model and prompt versions, golden-set runs, incidents | Customer answer content, ever |

Show permissions visibly: lock icons on restricted slots, a "Blind round" banner during round 1, and "Visible to: owner, decider, security" on restricted items. Any role held by fewer than three contributors shows as its function group (e.g. "Legal and risk"), never as a title that identifies one person.

---

## 4. Sitemap and design files

| File | Screens | Primary device |
| --- | --- | --- |
| 0. Design system | Tokens, type, components, icons, light and dark | — |
| 1. Marketing and onboarding | Landing page, pricing, sign-in, workspace setup | Desktop and mobile |
| 2. Owner workspace | Home, brief list, template gallery, new-brief wizard, synthesis workspace, gaps | Desktop |
| 3. Distribution | Invite builder, channels and digests, schedule and reminders, tracking, targeted follow-up, re-attestation | Desktop |
| 4. Contributor | Invite landing, intake, follow-ups, done, round 2 review, footprint, suggestions inbox, close-the-loop note, my actions | Mobile, with desktop variants |
| 5. Decide, brief and export | Decision queue, decision card, locked brief, version history, compile and export, validation, live briefs, evidence pack | Desktop |
| 6. Actions (project management) | Actions list, board, plan timeline, my actions, action detail, milestones, weekly digest, sync settings | Desktop, with mobile variants for my actions and action detail |
| 7. Admin and platform admin | Org context library, members, security and data, integrations, template builder, audit log, billing; platform tenants, marketplace, model and prompt versions, golden-set runs, system health | Desktop |

**Owner and admin navigation** (left rail): Home, Briefs, Decisions, Actions, Templates, Org context, Exports, Audit log, Settings. Workspace switcher at the top; data region (EU or US) at the bottom.

**Contributor navigation**: none for intake. Contributors arrive through an invite link and see only their task, with a progress bar and one "Continue" action. Contributors with assigned actions also get a minimal "My actions" page (4.12).

---

## 5. Screens

Each screen has an ID so flows and comments can point at it.

### File 1: Marketing and onboarding

**1.1 Landing page.** Hero: "Get your team aligned before the AI builds it." Subline: "[Product] turns what your experts know into an approved brief any AI tool can execute." Primary CTA "Book a demo", secondary "See how it works". Below: a four-step strip (Ask the right people → Settle the conflicts → Export to your AI → Track it to done), an animated preview of a decision card, integration logos as neutral tiles (Copilot Studio, Agentforce, ServiceNow, Claude, ChatGPT, Slack, Teams, Jira), a trust strip (EU or US data region, SSO, tamper-evident audit log, no training on your data), three use-case cards (AI agents, AI-use and HR policies, team playbooks), footer.

**1.2 Pricing.** Three tiers: Team, Business, Enterprise. Annual organization subscription sized by live briefs; contributors always free and unlimited; actions and project management included in every tier. Enterprise adds SSO, audit export and a dedicated instance. Add-on row: template packs. FAQ accordion.

**1.3 Sign-in.** Email magic link, Google, Microsoft, SSO.

**1.4 Workspace setup (4 steps, stepper on top).** Step 1: organization name, size, industry. Step 2: data region (EU or US) as two large tiles with "can't be changed later". Step 3: connect channels (Slack, Teams, email domain) and, optionally, export targets and work tools (Jira, ServiceNow, Planner, Asana), each Connect or Skip; copy under work tools: "No work tool? [Product] tracks actions for you." Step 4: pick a first template, "IT helpdesk agent" preselected.

### File 2: Owner workspace

**2.1 Home.** Four counters: Active briefs, Decisions waiting on you, Actions due this week, Re-attestations due. Main: "Needs your attention", mixing decision cards, gaps, overdue contributors, actions due or overdue, actions waiting for owner acceptance and constraints due for review, each with one action button. Right column: round timeline of the active brief, next milestone, recent exports.

**2.2 Briefs list.** Table: name, template, owner, decider, stage (Framing, Intake, Review, Deciding, Locked, Exported, Live), contributors done, open conflicts (conflict color), open actions, next milestone with date, export target icon. Filters by stage, template, owner; saved views.

**2.3 Template gallery.** Cards by category: AI agents (IT helpdesk, HR helpdesk, customer service, sales assistant), Policies (AI-use, HR, information security), Playbooks (onboarding, incident response). Each card: description, roles, question count, minutes per contributor, export targets, default milestones, "Preview", "Use template". "Marketplace" tab with publisher badges.

**2.4 New brief wizard (round 0, Frame).** Left: six steps; right: live preview of the brief outline.

1. Goal: name, purpose, deliverable type, audience.
2. Export target: pick the platform; preview of the output format.
3. People: owner, decider, role map table (role, person, authority slots, consult step yes or no). Add by name or email, or import from a Slack or Teams channel.
4. Documents: drag-and-drop of policies, SOPs, tickets, with "prefill the draft from these" and a parsing state.
5. Questions: per role, the 5–8 questions each person gets, editable, with minutes per role; restricted slots with a lock.
6. Schedule and plan: round windows on a timeline (R1 intake, R2 review, R3 decide, R4 validate), deadline, reminder cadence, plus the brief's milestones prefilled from the template (e.g. Brief locked, Exported, Pilot live, Go-live, First re-attestation), each with a date and an owner. Button: "Continue to distribution".

**2.5 Synthesis workspace.** Three panes. Left: the brief's slots (Objective, Scope, Hard constraints, Escalation rules, Data the agent may use, Tone, Examples, Acceptance criteria, Open questions), each with a coverage meter and a dot per authority role. Middle: context items in the selected slot as cards with type (fact, constraint, risk, idea), strength (must-have, nice-to-have, idea), relation badges and provenance footer. Right: item detail with original answer, version history, merge history and actions (Edit wording, Split, Mark restricted, Send to decision, Create action). Top bar: "Pipeline last run 2 min ago", counts of items, merges, conflicts, a "Gaps" button.

**2.6 Gaps panel.** Thin or missing slots, failed coverage rules, and flagged items: person-directed judgments returned to writers, and text that reads like instructions to the AI ("possible injected instruction", with the quote and Ignore or Keep as data). Each gap: "Send targeted question" (to 3.5) or "Create action".

### File 3: Distribution

**3.1 Invite builder.** Contributor table: name, role, channel (email, Slack, Teams, copy link), estimated minutes, status. Bulk: change channel, resend, remove. Right panel: invite message with merge fields ({first_name}, {role}, {brief_name}, {minutes}, {deadline}, {owner_name}), a required purpose statement ("why we're asking you"), and a note on blind round 1 and who sees answers.

**3.2 Channel previews.** Side by side: email, Slack card with "Start (12 min)", Teams adaptive card; sender is the brief owner. Fourth preview: the one-per-round digest in Slack or Teams ("3 suggestions on your items, 2 conflicts need your view, 1 action due Friday") with Accept, Keep mine, Comment, Mark done buttons that work without logging in. Never one notification per reply.

**3.3 Schedule and reminders.** Round timeline with dates. Reminder rules as rows ("2 days before close if not started", "on close day if not finished", "stop after 3 reminders"). Quiet hours. Toggle: escalate to owner when an authority contributor hasn't answered.

**3.4 Tracking.** Funnel: Sent → Opened → Started → Finished, with counts and a list per stage. Rows: last activity, channel, reminders sent, "Nudge now". Missing authority roles in warning color: "Slot at risk: Security has no answers yet".

**3.5 Targeted follow-up.** One question to one role, prefilled ("Security: what verification is required before a password reset?"), channel, due date. Shows in tracking as "follow-up".

**3.6 Re-attestation run.** For live briefs, asks each constraint owner to confirm constraints. Card: "C-07: The agent never asks for or accepts a password", buttons Still true or Needs change. "Needs change" creates an action for the brief owner.

### File 4: Contributor (mobile first, 390px; desktop variant 640px column)

**4.1 Invite landing.** Owner photo and name, brief name, purpose statement, "About 12 minutes", deadline, three reassurances: your answers stay private in round 1; you'll see how your input was used; this is about the work, not about people. Button "Start".

**4.2 Prefilled reaction.** "Here's what we already know from existing documents." Draft points with Correct, Needs a change, Out of date; "Needs a change" opens a field.

**4.3 Question card.** One question in large type, helper line, free-text field with voice input and attachment, then one plain choice: Must-have, Nice-to-have, Just an idea. Progress "4 of 7", Back and Continue. Variants for each pattern: non-negotiables, pre-mortem, exceptions, history, good and bad examples, definition of done, boundaries. Own answers are editable until round 1 closes.

**4.4 Follow-up.** After a vague answer: "You mentioned 'secure'. Which check must happen before a reset?" Small text "1 of 3 follow-ups this round". Skip always visible.

**4.5 About the work, not people.** If an answer names and judges a colleague, an inline notice asks to restate it as a fact about the process, with "Edit answer". No one else ever sees the original.

**4.6 Done.** "Thanks, Sam. Here's what happens next": round timeline, date of round 2.

**4.7 Round 2 review.** The merged brief by section, in two steps.

- Step 1, your view first: each item shows Agree or Object only; comments, counts and others' positions stay hidden until the contributor has responded. Objections need a reason and an alternative.
- Step 2, others' views: comments revealed; the contributor may revise; revised positions are marked "changed after seeing others".
- Comments are typed (Objection, Clarification, Evidence), at most two per person per item, attached to the item, never to a person.
- "Suggest a change" opens suggestion mode on someone else's item as a tracked change. No direct edits.
- Points: 100-point sliders across contested items (always sum to 100), plus "Nominate" on up to two non-contested items. Totals hidden until the round closes; banner: "Points are revealed for everyone when the round closes. They inform the decider; they don't decide." No downvotes, no sorting by votes.
- Supporters as role chips (function groups where a role has fewer than three people).
- Conflicts as highlighted cards with both positions side by side.
- Authority contributors: "Confirm hard constraints", Confirm or Reject per constraint ID. Constraints never get points.

**4.8 Footprint.** Private list of everything the contributor said, tagged Used, Merged with others, Changed by your accepted suggestion, Sent to a decision, or Not used (with reason). Original wording beside current version. Link to the locked brief once approved.

**4.9 Consult step** (consultees, policy templates). Slots needing consultation, proposed wording, comment thread, "Record consultation outcome" (Agreed, Agreed with changes, Not agreed, with notes).

**4.10 Suggestions on my items.** Inbox for authors: current wording, proposed wording as a tracked change, suggester's role chip, reason. Accept, Merge (edit both into one) or Keep mine. Microcopy: "Your original is saved. Declining a suggestion is normal. If the suggester still disagrees, both versions go to the decider." Keep mine plus a standing objection creates a decision card.

**4.11 Close-the-loop note.** Sent to every contributor at round 4, including those whose objection lost, by email and Slack or Teams. One row per item they raised: "You raised: no hardware orders without approval. Decided: $250 limit, because finance needs spend data first. Owner: Finance business partner, due December 15. Status: In progress. We'll tell you when it ships or slips." Status per item only.

**4.12 My actions (mobile).** For anyone with assigned actions, including contributors with no other role. List grouped Overdue, Due this week, Later, Done. Each row: title, brief, due-date chip, status. Tap opens 6.5 as a full-screen sheet. Swipe right: Mark done; swipe left: Update status. A pending request at the top: "Daniel Reyes asked you to own: Pull hardware spend data for Q1, due December 15" with Accept or Decline (with a reason).

### File 5: Decide, brief and export

**5.1 Decision queue.** For the decider: cards sorted by impact with title, slot, conflict type (contradiction, priority, scope, factual, terminology), supporters per side, age.

**5.2 Decision card.** Title ("Password resets through chat"). Two or three options as columns, each with supporters (role chips), evidence quotes, consequences and the constraints it touches by ID. Round-2 points as a small bar per option, labeled "advisory". "Low support, high stakes" badge when an option with few points carries a hard constraint or authority objection. Pinned-inputs strip: the exact item versions the decider sees ("Item 41 v2"). Actions: Choose option, Write a new option, Defer as open question, Ask for a short meeting. Required: rationale. Then a "Follow-up actions" block: add one or more actions (title, owner, due date, priority), each sent to its owner for acceptance; per action, choose "Track in [Product]" (default) or "Track in Jira" or "Track in ServiceNow" when connected. After saving, the card becomes a decision record: D-04, decided by, date, rationale, pinned versions, actions with status. If a pinned item changes later: banner "Decided on superseded input" with Review.

**5.3 Locked brief.** Document view, version pill (v1.2, Locked), owner and decider, data region footer. Hard constraints with IDs, owners and review dates. Hover any sentence for its source items. Side tabs: Decisions, Open questions, Actions, Comments, History.

**5.4 Version history.** Versions with who locked them and why; side-by-side diff; the decisions that caused each change.

**5.5 Compile and export.** Target tiles (Copilot Studio, Microsoft Employee Self-Service agent, Agentforce, ServiceNow, Claude project, ChatGPT GPT, Markdown files). Preview in the target's format; hard constraints marked as inserted verbatim. Gate checklist: all hard constraints present by ID, every required slot covered by its authority role, every instruction traced to items, no unreviewed injection flags, length within budget. Failing gate shows Fix (to 2.6). Decider approves an export diff, then Export, success state and link. On success, the milestone "Exported" completes automatically.

**5.6 Validation (round 4).** Scenarios from real past tickets: scenario, expected behavior, AI output, contributor verdict (Respects my constraints, Violates C-12). Pilot comparison: team brief vs the owner's solo draft, constraint violations each, pass threshold line. Violations offer "Reopen brief" or "Create action".

**5.7 Live briefs and re-attestation.** Briefs in production: export target, last export, constraints due for review, open actions, drift alerts ("Policy changed since export"). Each row: Run re-attestation (to 3.6).

**5.8 Evidence pack.** One-click export per brief version: every input with provenance, versions and suggestions, objections, authority confirmations, decider rationale, pinned versions, actions with their history, the exported AI instructions, and the audit-log hash chain. Cover page and contents preview; PDF and JSON.

### File 6: Actions (light project management)

Purpose: every decision, gap, validation finding and re-attestation ends in an owned, dated action that is tracked to done, for customers with or without Jira or ServiceNow. It is deliberately light: no Gantt charts, no dependencies beyond "blocked by", no time tracking, no story points, no sprints.

**Action model (show these fields in 6.5 and use them consistently):**

| Field | Values and rules |
| --- | --- |
| ID | A-001, sequential per workspace |
| Title | Required, under 80 characters, starts with a verb |
| Description | Optional rich text |
| Brief | Required link to one brief |
| Source | Decision (D-04), gap, validation finding, re-attestation, milestone, or manual; shown as a chip that links back |
| Owner | One person, required. Owner must accept: states Requested, Accepted, Declined (with reason). Until accepted, the action shows "Owner pending" |
| Collaborators | Optional people who get updates |
| Due date | Required. Chip states: on track, due in 3 days or less (warning), overdue (warning, bold) |
| Status | To do, In progress, Blocked (requires a reason and optional "blocked by" another action), Done, Canceled (requires a reason) |
| Priority | High, Normal, Low |
| Milestone | Optional link to one brief milestone |
| Checklist | Optional sub-steps with checkboxes; progress shown as "2 of 4" |
| Links and files | URLs and attachments |
| Updates | Timestamped comments and status changes; every change logged to the audit log |
| Tracked in | [Product] (default), or Jira or ServiceNow when connected. External actions are read-only here, showing the ticket ID, status mapped back, and "Open in Jira" |
| Completion | "Mark done" asks for an optional completion note; the decider can require evidence (a note or link) for actions from decisions |

**Milestone model:** name, date, owner, brief, status (Upcoming, At risk, Done, Missed), linked actions. Some milestones complete automatically: Brief locked (on lock), Exported (on export), Validated (when R4 passes). Others are completed by their owner, and the decider approves completion for Go-live.

**6.1 Actions list.** Default view for owners and deciders. Table: ID, title, brief, source chip, owner (with pending or accepted state), due-date chip, status, priority, milestone, tracked in. Group by brief (default), status, owner or milestone. Filters: my actions, overdue, due this week, blocked, owner pending, source type, tracked in. Bulk: change due date, reassign (triggers a new acceptance request), set status, move to milestone. Top right: "New action". Inline quick-add row at the bottom of each group. Summary bar per brief: "7 open · 2 overdue · 1 blocked · 12 done", counts at brief level only.

**6.2 Board.** Kanban with columns To do, In progress, Blocked, Done (Canceled hidden behind a toggle). Cards: title, brief chip, owner avatar with acceptance state, due-date chip, checklist progress, source chip. Drag between columns; dropping into Blocked opens a "Why is it blocked?" field. Swimlanes optional by brief.

**6.3 Plan (light timeline).** Per brief, a month-scale timeline: the four rounds as bands, milestones as diamonds on their dates, and actions as dots on their due dates in the row of their milestone ("No milestone" row at the bottom). Today line. Hover shows details; click opens 6.5. Drag a milestone or action dot to change its date (confirm dialog when it moves past the brief deadline). Milestones at risk show in warning color when a linked action is overdue or blocked.

**6.4 My actions (desktop).** The signed-in person's actions across briefs, grouped Overdue, Due this week, Later, Done (last 14 days), with ownership requests at the top (Accept or Decline). Same as 4.12 on mobile.

**6.5 Action detail drawer.** Opens from the right over any list (full-screen sheet on mobile). Header: ID, title (editable), status select, priority, due-date chip, Mark done. Body: owner with acceptance state and "Reassign", collaborators, brief and milestone links, source chip (e.g. "From decision D-04: Hardware orders without approval", which opens the decision record), description, checklist, links and files, "Tracked in" with "Move to Jira" when connected. Updates feed at the bottom with a comment box. Footer: created by, created date, "Visible to the brief's owner, decider and the people on this action".

**6.6 Milestones.** Per brief, a list of milestones: name, date, owner, status, linked actions with progress ("3 of 5 done"), and "Approve completion" for the decider on Go-live. "Add milestone" opens a small form. Template defaults are editable.

**6.7 Weekly digest and reminders.** Preview of the Monday digest by email and Slack or Teams for each person: their overdue actions, actions due this week, ownership requests, and milestones this week on their briefs, each with Mark done or Open. Reminder rules (in brief settings): 3 days before due, on the due date, then every 3 days while overdue, stop after 3; escalate to the brief owner when an action is 7 days overdue or blocked for 5 days. Quiet hours respected.

**6.8 Sync settings.** Per workspace: connect Jira, ServiceNow, Planner or Asana. Field mapping (owner, due date, status, priority) with status mapping (e.g. Jira "In Progress" → In progress). Choose default "Track in" per brief template. When nothing is connected, the screen says "Actions are tracked in [Product]" and offers CSV export and an iCal feed of due dates.

**Project management rules**

- Every action has exactly one owner who accepted it; reassigning restarts acceptance.
- Status is visible to everyone on the brief, at action level. No per-person completion rates, leaderboards or workload charts.
- Actions from decisions keep a permanent link to the decision record, and the close-the-loop note (4.11) shows their status.
- Done and Canceled are reversible but logged. Nothing is deleted; canceled actions keep their reason.

### File 7: Admin and platform admin

**7.1 Org context library.** Tabs: Constraints, Glossary, Standards, Decisions. Constraints table: ID, statement, owner, slot, briefs using it, review date, status (Current, Due, Changed). Changing a constraint shows affected live briefs and offers "Create actions for affected briefs".

**7.2 Members and roles.** People with org role (Org admin, Template author, Member), SSO status, last active, briefs involved. Invite, deactivate, transfer ownership (including open actions, which go back to acceptance). Groups synced from Entra ID or Okta.

**7.3 Security and data.** Data region (read-only, with date chosen); SSO and SCIM; retention (raw answers for a chosen period, locked briefs and action history indefinitely); model providers with in-region, zero-retention endpoints and a model choice per pipeline step (atomize, relate, render); restricted-slot defaults; audit export (CSV or SIEM webhook).

**7.4 Integrations.** Three groups with status, connected-by and Test: channels (Slack, Teams, email domain), export targets (Copilot Studio, Employee Self-Service agent, Agentforce, ServiceNow, Claude, ChatGPT, Markdown, webhook), work tools (Jira, ServiceNow, Planner, Asana; links to 6.8).

**7.5 Template builder.** Data-not-code editor in five tabs:

1. Output schema: ordered slots with type, required flag, length budget, authority role, restricted flag, consult step.
2. Question bank: questions per slot and role, answer type, follow-up triggers (missing number, system name, example or reason), prefill source, contributor preview.
3. Synthesis rules: per slot, merge rule, conflict rule (auto, vote, decider), authority roles.
4. Renderers: one per export target, live preview against sample data, version number.
5. Plan defaults: default milestones (name, offset in days from brief start, owner role) and default actions created at given moments (e.g. "after export: schedule pilot review, owner: brief owner, due +14 days").

Top actions: Save draft, Test with sample answers, Publish version, Submit to marketplace.

**7.6 Audit log.** Tamper-evident, append-only, "Chain verified" badge: who did what, when, on which brief, item, decision or action; suggestions with outcomes; points (attributed here, anonymous to peers); action status changes and reassignments; exports with diffs; permission changes; re-attestations. Rows link to objects. Button: Export evidence pack (to 5.8).

**7.7 Billing.** Plan, live briefs against the limit, template packs, invoices, chart of live briefs per month. Copy: contributors are free and unlimited; actions are included.

**7.8 Platform: Tenants.** Organizations with plan, region, live briefs, active contributors, health score, last incident. Tenant detail shows configuration and usage only, never answer content, and says so.

**7.9 Platform: Marketplace.** Template submissions with review status, publisher, version, installs, ratings; approve, request changes, unpublish.

**7.10 Platform: Model and prompt versions.** Each pipeline step (atomize, relate, merge, decision-card draft, render) with current model and prompt version, rollout percentage, rollback.

**7.11 Platform: Golden-set runs.** Seeded-conflict test results per change: conflicts caught, false merges, constraints dropped, pass or fail against thresholds. Release blocked when a run fails.

**7.12 Platform: System health.** Queue depth and latency per pipeline stage, failed jobs with retry, export and sync success rates per target, incidents.

---

## 6. Sample data (use on every screen)

Organization: Lumio Inc., a 1,200-person software company in Austin, Texas, on the US data region. Lumio has no Jira; its IT team uses ServiceNow. Most actions are tracked in [Product]; two are tracked in ServiceNow.

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

**Progress:** 7 of 8 finished round 1; Tom Becker opened the invite but hasn't started. 64 context items, 21 merged duplicates, 4 open conflicts.

**Decision cards**

1. D-03 Password resets through chat. Service desk: reset after one verification question. Security: MFA push before any reset. Points (revealed after R2): service desk 35, security 65.
2. D-04 Hardware orders without approval. Service desk $500, finance $250. Decided by Daniel Reyes: $250, revisit in Q2 with spend data.
3. D-05 Personal devices. Split; deferred as an open question.
4. D-06 After-hours escalation. On-call within 15 minutes, or a ticket for the morning shift.
5. D-07 Tone guidance. Grace suggested a softer tone on Sam's item; Sam chose Keep mine, so both versions went to the decider.

**Suggestions:** Sam suggested rewording Priya's item 41 to "Agent must verify identity with an MFA push before any account change"; Priya accepted, creating item 41 v2, which D-03 pins.

**Hard constraints:** C-07 The agent never asks for or accepts a password (owner Priya Shah, review March 1, 2027). C-12 Suspected security incidents escalate to on-call within 15 minutes (Priya Shah). C-15 No hardware order above $250 without manager approval (Lena Ortiz). C-19 The agent never reads or summarizes HR records (Mei Lin).

**Milestones (IT Helpdesk Agent v1):** Brief locked, November 14 (auto). Exported to Copilot Studio, November 18 (auto). Pilot live with IT team, December 1 (owner Kari Nordmann). Go-live company-wide, January 12, 2027 (owner Kari Nordmann, decider approves). First re-attestation, March 1, 2027 (owner Priya Shah).

**Actions**

| ID | Title | Source | Owner | Due | Status | Tracked in |
| --- | --- | --- | --- | --- | --- | --- |
| A-014 | Pull hardware spend data for Q1 | D-04 | Lena Ortiz (accepted) | Dec 15, 2026 | In progress, checklist 1 of 3 | [Product] |
| A-015 | Configure MFA push for chat-initiated resets | D-03 | Priya Shah (accepted) | Nov 28, 2026 | To do | ServiceNow CHG0031207 |
| A-016 | Write on-call escalation runbook for the agent | D-06 | Sam Okafor (requested) | Nov 21, 2026 | Owner pending | [Product] |
| A-017 | Add personal-device question to the FAQ as out of scope | D-05 | Kari Nordmann (accepted) | Nov 10, 2026 | Overdue | [Product] |
| A-018 | Brief Tom Becker on the escalation constraints | Gap | Kari Nordmann (accepted) | Nov 7, 2026 | Done | [Product] |
| A-019 | Remove HR-record lookup from the agent's data sources | Validation finding (violates C-19) | Mei Lin (accepted) | Nov 25, 2026 | Blocked: waiting on A-015 | [Product] |
| A-020 | Book pilot review with service desk | Milestone: Pilot live | Kari Nordmann (accepted) | Dec 3, 2026 | To do | [Product] |
| A-021 | Update asset system approval threshold to $250 | D-04 | Sam Okafor (accepted) | Nov 30, 2026 | In progress | ServiceNow TASK0088412 |

**Validation:** 24 scenarios from last quarter's tickets. Team brief: 2 violations; Kari's solo draft: 9; pass threshold: at most 4.

**Other briefs:** "AI Acceptable Use Policy 2027" (Intake, 9 of 14 finished, 3 open actions), "Customer Support Agent Tier 1" (Live, exported to Agentforce, 3 constraints due for review, 1 overdue action), "HR Helpdesk Agent" (Framing).

---

## 7. Click-through flows

1. **Five-minute demo:** 2.1 → 2.3 → 2.4 → 3.1 → 3.2 Slack preview → 4.1–4.6 on mobile → 2.5 → 5.2 D-03 → 5.3 → 5.5 export to Copilot Studio → 5.6 → 6.3 Plan showing milestones and actions.
2. **Gap to follow-up:** 2.5 → 2.6 (security slot thin) → 3.5 targeted question → 3.4 shows the follow-up.
3. **Round 2:** invite → 4.7 step 1 → step 2 with a revised position → points with hidden totals → confirm C-07 → 4.8.
4. **Suggestion to decision:** 4.7 suggest a change on Sam's tone item → 3.2 digest → 4.10 Keep mine → D-07 in 5.1 with both versions.
5. **Failed gate:** 5.5 "C-19 missing from output" → Fix → 5.5 all green → decider approves the diff.
6. **Decision to action:** 5.2 D-04 recorded → add action A-014 for Lena → 4.12 Lena accepts on mobile → 6.5 she ticks a checklist item and sets In progress → 4.11 close-the-loop note shows "In progress".
7. **Owner declines:** 6.4 Sam declines A-016 with a reason → 2.1 shows it to Kari → Kari reassigns in 6.5 → new acceptance request.
8. **Blocked and at risk:** 6.2 drag A-019 to Blocked, reason "waiting on A-015" → 6.3 milestone Pilot live turns At risk → 6.7 digest escalates to Kari.
9. **ServiceNow-tracked action:** 6.1 A-015 shows "Tracked in ServiceNow", read-only → status syncs to In progress → 6.8 shows the mapping.
10. **Superseded input:** item 41 amended after R3 → 5.2 "Decided on superseded input" → Review → reconfirmed.
11. **Re-attestation:** 5.7 → 3.6 → "Needs change" → action created → new version in 5.4 with diff.
12. **Audit:** 7.6 "Chain verified" → Export evidence pack → 5.8.
13. **Admin setup:** 1.4 (US region, skip work tools) → 7.4 → 7.5 Plan defaults tab → Publish version.
14. **Platform admin:** 7.10 prompt rollout → 7.11 golden-set run fails → release blocked.

---

## 8. States to draw

- Empty states for Home, Briefs, Decisions, Actions, Org context and Exports, each with one first action. Actions empty state: "Decisions turn into actions here. Settle a decision card to create the first one."
- Pipeline running after round 1 closes ("Reading 64 answers… labeling relations…").
- Blind round 1 locked view.
- Round 2 before and after responding; points hidden, then revealed for everyone at close.
- Restricted slot without access: locked card, "Visible to owner, decider, security".
- Suggestion accepted, merged and declined, from both sides.
- Action owner pending, accepted, declined with reason, reassigned.
- Action due soon, overdue, blocked, done with completion note, canceled with reason.
- Milestone upcoming, at risk, done, missed.
- External action sync failed (ServiceNow unreachable) with retry.
- Decision on superseded input.
- Deadline passed with missing contributors; round extended.
- Export failed (target unreachable) with retry.
- Contributor link expired; wrong-person link.
- Decision deferred to open question, rendered in the brief.

---

## 9. Copy rules

- Plain, short sentences; sentence case on buttons ("Record decision", "Mark done").
- Speak about the work: "What must be true no matter what?", not "Provide constraints".
- Show time cost on every contributor action.
- Action titles start with a verb.
- Never: survey, questionnaire, respondent, assessment, prompt engineering, magic, AI-powered.

## 10. Accessibility

WCAG 2.1 AA: 4.5:1 text contrast in light and dark, visible focus rings, full keyboard support on desktop (including board drag alternatives: "Move to…" menu), 44px touch targets on mobile, and color never the only signal (conflicts carry an icon and the word "Conflict"; overdue carries the word "Overdue").

## 11. Handoff to Claude Code

- Name components exactly as in the design system list, so they map one to one.
- Keep everything a template defines (slots, questions, roles, rules, renderers, plan defaults) as data shown by generic components, never hard-coded screens.
- Annotate each screen with its route and the roles that can open it, e.g. /briefs/:id/decisions/:cardId, /actions, /actions/board, /briefs/:id/plan, /me/actions, /actions/:actionId.
- Include the action and milestone field tables above as the data contract for the Actions module.
- Export a short spec per file listing components, states and sample data used.
