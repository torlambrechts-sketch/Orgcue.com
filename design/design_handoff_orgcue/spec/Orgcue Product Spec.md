# Orgcue — Product & Build Specification

Version 1.0 · Source prototype: `Grid Actions.dc.html`
Audience: Claude Code (implementation) or Claude Design (further design work)

---

## 0. How to use this document

- **Sections 1–4** are the product model: what Orgcue is, who uses it, how a project moves, and the core objects. Read these first; every screen depends on them.
- **Sections 5–7** are the app shell, the design system and the shared view template (Board / List / Timeline).
- **Sections 8–20** specify each screen and feature: purpose, layout, behavior, states, data and acceptance criteria.
- **Sections 21–24** cover settings, integrations, non-functional requirements and build order.
- The prototype uses a fictional company (**Lumio Inc.**) and one fully worked project (**IT Helpdesk Agent v1**). Use the demo data in §25 for seeds and tests.

Conventions: **MUST** = required for v1, **SHOULD** = expected, **MAY** = optional. IDs in `MONO` are stable and user-visible.

---

## 1. Product summary

**Orgcue** collects knowledge from the right people in an organization and turns it into a locked, traceable specification. From that spec it generates instructions for AI tools (AGENTS.md, CLAUDE.md, Cursor rules, Copilot Studio packs, Agentforce, policy drafts, BPMN). After launch it tracks actions, drift and constraint reviews.

**The problem.** AI projects fail on missing or conflicting input: security rules nobody asked for, finance limits discovered after launch, instructions nobody can explain. Gathering that input takes weeks of meetings.

**The promise.**
1. Ask each person only what they know, privately, in about 12 minutes.
2. Reveal everyone's input at the same moment, and surface duplicates, gaps and conflicts automatically.
3. Let one decider settle conflicts with a written rationale.
4. Lock the spec, then generate tool-specific files where every line traces back to a person, a decision and a test.
5. Close the loop: tell every contributor what happened to their input.

### Design principles (MUST hold everywhere)

| # | Principle | What it means in the product |
|---|-----------|------------------------------|
| P1 | Blind first | Answers and ideas stay private until collection closes, then everyone sees them at once. |
| P2 | Work, not people | Members are never scored or ranked. Peers see function groups, not names. Comments are about the input. |
| P3 | Constraints are sacred | Hard constraints are owned, confirmed, inserted verbatim, and can't be voted out. |
| P4 | Points ≠ truth | Upvotes and advisory points show how much people care, not who is right. The decider decides. |
| P5 | Everything traces | Every generated line links to a spec item, its input, its decision and its test. |
| P6 | Reversible automation | Any automatic skip, merge or stop can be seen and undone, and is logged. |
| P7 | Close the loop | Each contributor learns what happened to their input, including when they lost. |
| P8 | External input is evidence | Customers inform requirements, examples and tests, but never set constraints or vote on decisions. |

---

## 2. Roles

### 2.1 Project roles (per project)

| Role | Who (demo) | Can |
|------|-----------|-----|
| **Owner** | Kari Nordmann, IT Service Manager | Set up the project, send questions, nudge, close collection, promote ideas, create actions, generate drafts, send the close-the-loop note. |
| **Decider** | Daniel Reyes, CIO | Choose options for decisions, write rationale, defer, lock spec versions, approve generation and go-live, approve or reject input. |
| **Authority** | Priya Shah (Security), Lena Ortiz (Finance), Mei Lin (Legal) | Everything a Contributor can do, plus own hard constraints in their areas (confirm them and review them on schedule). |
| **Contributor** | Sam Okafor (Service desk), Grace Kim, Tom Becker | Answer questions, add up to 3 private ideas, Agree or Object, suggest wording, upvote and comment, accept or decline actions. |
| **External respondent** | Customers, contractors, partners | Answer a short question set by link. No account, no access to the project. |

### 2.2 Org roles (Settings → Members)

| Capability | Admin | Creator | Member | Guest |
|---|---|---|---|---|
| Create projects | ✓ | ✓ | — | — |
| Be a decider | ✓ | ✓ | ✓ | — |
| See who said what | ✓ | Own projects | Own projects | — |
| Export evidence packs | ✓ | ✓ | — | — |
| Edit templates | ✓ | ✓ | — | — |
| Manage the library | ✓ | ✓ | — | — |
| Connect integrations | ✓ | — | — | — |
| Answer questions | ✓ | ✓ | ✓ | ✓ |

### 2.3 Visibility rules (MUST)

- **Peers** see function groups ("Service desk"), never names. If a role is held by fewer than 3 people, show its function group instead.
- **Owner, decider and admin** see names. This is configurable in Settings → Security → "Who sees who said what".
- **Restricted sections** (for example "Data the AI may use") are visible only to the owner, the decider and the security role. Everyone else sees a placeholder: "⊡ Restricted section · Visible to owner, decider, security".
- **External respondents** never see other answers, internal names or project content.

---

## 3. Project lifecycle

Six phases. The current phase drives which tabs, panels and next steps appear.

| # | Phase | Goal | Exit condition |
|---|-------|------|----------------|
| 1 | **Frame** | Define the project, sections, questions, members and decider | Owner presses **Send** |
| 2 | **Collect** | Members answer blind, one question at a time | Owner presses **Close collection and reveal** (or the deadline passes) |
| 3 | **Review** | Revealed input is merged and clustered; members Agree or Object, suggest wording, comment and upvote | Review window closes |
| 4 | **Decide** | The decider settles conflicts (DEC-xx), then locks the version | Decider presses **Lock vN** |
| 5 | **Validate** | Generate for the target, run gates and scenarios, approve the diff, pilot | Validation within threshold, close-the-loop note sent |
| 6 | **Live** | Track actions, drift and constraint reviews | Ongoing |

**Phase stepper** (project header): six circles joined by lines. Past phases show a ✓ and "Done", the current phase is outlined and shows "Now", future phases are muted.

**Demo control bar** (prototype only, dark strip at the top): "View as" (Owner / Decider / Contributor / Org admin), "Phase" (the 6 phases) and "Show all features". This is a dev and demo tool and MUST NOT ship to production; it SHOULD exist behind a dev flag.

---

## 4. Core data model

```
Organization ─┬─ Users (org role, SSO status)
              ├─ Library ─┬─ SharedConstraint (LIB-HC-xxx)
              │           └─ KnownFact (LIB-F-xxx)
              ├─ Templates (category, sections, questions, frameworks, status)
              ├─ Integrations
              ├─ Settings (key/value, audited)
              └─ Projects ─┬─ Members (project role, function group, authority areas, channel)
                           ├─ ExternalSegments (segment, channel, invited, answered)
                           ├─ Sections (name, authority flag, restricted flag)
                           ├─ Questions (section, target group, follow-up triggers)
                           ├─ Answers (author, question, text, strength, version)
                           ├─ InputItems (CI-xxxx, versions, merges, relations)
                           ├─ Ideas (N-xx, cluster, outcome)
                           ├─ Comments (type, item, author)
                           ├─ Votes (item, user)
                           ├─ Approvals (item, status, reason)
                           ├─ SpecVersions (v1.4.0, hash, locked_by, locked_at)
                           │    └─ SpecItems (G-01, S-01, HC-007, REQ-020, T-01, D-01, ESC-01, EX-01, AC-020.1)
                           ├─ Decisions (DEC-xx, options, chosen, rationale, pinned input versions)
                           ├─ Generations (target, files, gates, diff, result)
                           │    └─ GeneratedLines (file, line no, text, source id, kind)
                           ├─ Scenarios / SimRuns (result per scenario)
                           ├─ Actions (A-0xx, owner, acceptance, status, due, checklist, source)
                           ├─ Milestones
                           └─ AuditEvents (append-only, hash-chained)
```

### 4.1 ID formats

| Prefix | Object | Example |
|---|---|---|
| `CI-` | Collected input item | `CI-0231 v2` |
| `N-` | Brainstorm idea | `N-03` |
| `G-` / `S-` / `T-` / `D-` / `ESC-` / `EX-` | Spec items: Goal / Scope / Tone / Data / Escalation / Example | `S-02` |
| `HC-` | Hard constraint (project) | `HC-007` |
| `LIB-HC-` / `LIB-F-` | Library constraint / fact | `LIB-HC-015` |
| `REQ-` | Requirement (EARS) | `REQ-020` |
| `AC-` | Acceptance criterion | `AC-020.1` |
| `DEC-` | Decision | `DEC-03` |
| `A-` | Action | `A-015` |
| `L` | Instruction-check issue | `L1` |
| `Q` / `QC` | Question / customer question set | `Q8`, `QC` |

### 4.2 Item types and strength

- **Types:** Fact, Constraint, Idea, Risk, Requirement, Example.
- **Strength** (set by the author): Must-have, Nice-to-have, Just an idea.
- **Relations:** Conflicts with, Duplicates (merged), Refines (new version), Possible injected instruction.

### 4.3 Versioning

- Input items are versioned (v1 → v2 when a suggestion is accepted). The history lists each version, who proposed it and who accepted it.
- Spec versions use semver (v1.3 → v1.4.0). Locking makes a version immutable and records its hash.
- A decision **pins** the input versions it was based on. If a pinned item is amended later, show the banner **"Decided on superseded input"** with a Review action.

---

## 5. App shell

### 5.1 Layout

```
┌───────────────────────────────────────────────────────────────┐
│ [Demo bar — dev only]                                         │
├───────────────────────────────────────────────────────────────┤
│ O Orgcue  Lumio Inc.        [Search everything] ? [+ New] KN  │ top bar (#ECEFF8)
├──────────┬────────────────────────────────────────────────────┤
│ Sidebar  │  Main panel (white, radius 14px, margin 0 8px 8px 0)│
│ 240px    │  padding 22px 28px; width 100% (fluid)             │
│ or 72px  │                                                    │
└──────────┴────────────────────────────────────────────────────┘
```

- The main panel MUST be fluid: no max-width, and content scales to the window. Wide tables keep a `min-width` and scroll horizontally inside their card.
- Toasts appear bottom-centre, dark (#14171A), and disappear after about 2.6 s.

### 5.2 Sidebar (collapsible)

**Expanded (240px):** a collapse button «, the nav items (icon + label), a "Projects" heading, and the project list (colored square + name + phase). The footer shows "User · Data region: US".

**Collapsed (72px, `overflow-x:hidden`):** an expand button », nav items as an icon with a 10px label underneath (52px wide button), a divider, project color squares (tooltip shows the name), and the user avatar at the bottom.

The collapsed state persists in `localStorage['orgcue-navC']`.

**Nav items and icons** (24×24 stroke icons, 1.8px stroke):

| Item | Icon | Visible to |
|---|---|---|
| Home | House | All |
| Projects | Board (4 tiles) | All |
| Templates | Stacked pages | All |
| Library | Open book | All |
| Portfolio | Bar chart | All except contributors |
| Settings | Sliders | All (sections filtered by role) |

The active item uses background `--side-act` (#CCE0FF) and text color #0B4FB3.

### 5.3 Top bar

Logo (blue rounded square with "O") + "Orgcue" + org name, a search field ("Search everything"), a help/notifications button, the primary **+ New project** button, and the user avatar.

---

## 6. Design system (Status grid theme)

### 6.1 Tokens

| Token | Value | Use |
|---|---|---|
| Font | **Figtree** 400/500/600/700 | All UI |
| Mono | ui-monospace, Menlo | IDs, files, code |
| `--app` | #ECEFF8 | Shell background, sidebar |
| `--main` / `--s1` | #FFFFFF | Main panel, cards |
| `--s2` | #F5F6F8 | Subtle fills, hover |
| `--bd` | #E1E4EB | Borders, grid lines |
| `--ink` | #323338 | Body text |
| `--mute` | #676879 | Secondary text |
| `--acc` / `--pri` | #0B6FE0 | Primary actions, focus, accents |
| `--dec` | #7A3FE0 | Decisions, decider actions |
| `--con` | #D64545 | Conflicts |
| `--suc` | #1F8A5B | Pass, confirmed |
| `--warn` | #B7791F | Warnings, gaps |
| `--track` | #E6E9EF | Bar tracks |
| `--idea-bg` | #FFE9B8 | Idea sticky notes |
| Radius | 4px controls · 8px cards · 14px main panel | |
| Section column title | 17px / 600 / #0B6FE0 | Board column headers |

### 6.2 Status cells (full-color, monday-style)

| Status | Background | Text |
|---|---|---|
| Done / Pass / Published / Confirmed | #0A8754 | #FFF |
| Working on it / In progress | #FDAB3D | #1F1F22 |
| Blocked / Overdue / Fail | #D53A50 | #FFF |
| To do / Draft / Not sent | #C4C7D0 | #22252B |
| Owner pending / Decide | #9B51D8 | #FFF |
| Review phase | #0B6FE0 | #FFF |
| Validate phase | #00A9A5 | #FFF |

Priority cells: High #2B2F6B, Normal #5C7CFA, Low #BFD3FB (dark text).

### 6.3 Generated-line source colors

Constraint #D53A50 · Spec item #0B6FE0 · Decision #9B51D8 · Example #E58A00 · Scaffolding #C4C7D0 · Hand edit #323338.

### 6.4 Change-cause colors (diffs)

Decision #9B51D8 · Conflict resolved #D53A50 · Idea promoted #E58A00 · Suggestion accepted #0B6FE0 · Constraint confirmed #8A1F2E · Hand edit #323338.

### 6.5 Rules

- Lay out sibling groups with flex or grid and `gap`. Never fixed heights on text boxes.
- Minimum hit target is 44px on mobile surfaces (contributor phone flow, customer page).
- Text contrast is at least 4.5:1. Never mute text with opacity on colored grounds.
- No emoji. Glyphs used are ✓ ✕ ! ▲ ⌄ « » → ◯ ◐ ⊽ ⇅ ▤ ⊡.

---

## 7. Shared view template — Board / List / Timeline

One template MUST be used for **Projects**, **Templates**, **Library** and the project **Actions** tab, so that all four behave identically.

### 7.1 Header

Title (h1), a one-line subtitle, and on the right a segmented control **Board · List · Timeline** plus a **CSV** button. The view choice is stored per page.

Optional KPI tiles and an optional warning banner sit under the header.

Toolbar: primary button(s) on the left, then `◯ Search  ◐ Person  ⊽ Filter  ⇅ Sort  ▤ Group by: <field>`.

### 7.2 List view (default for grid theme)

- **Groups** stack vertically with a 30px gap. Each group has:
  - A header: ⌄, the group title in the group color (17px/600), and a count ("3 items").
  - A column header row: a 6px color bar in the group color (top-left radius 8px), then column labels (13px, #676879), with 1px #E1E4EB grid lines.
  - Rows: minimum height 42px, white, hover #F5F6F8, and the 6px color bar on the left. Clicking a row opens the item.
  - An add row: a half-opacity color bar, "+ Add <noun>", and on the right a 180×20px **status distribution bar** for the group.
- **Cell kinds:** name (bold + optional subline), text, mono, **status** (full-color cell), avatar (28px initials circle), button.
- Wide tables keep a `min-width` and scroll horizontally.

### 7.3 Board view

Columns flow horizontally (`grid-auto-flow:column; grid-auto-columns:minmax(260px,1fr)`). Each column header has a color dot, the title and a count bubble.

Each card contains:
- a tag pill and an ID (mono) on the right
- a title (16/600)
- an optional description
- an avatar with person and role
- an optional red "! warning" pill
- a footer split left and right, above a top border

### 7.4 Timeline view

- A 280px label column, then a track with month ticks.
- Each row has a color dot and label, then a 22px rounded bar from start to end, showing its dates and status.
- A red vertical **today** line (2px #D53A50).
- A footnote explains what the bar spans.

### 7.5 Per-page configuration

| Page | Group by (List) | Board columns | Timeline bar | Columns (List) |
|---|---|---|---|---|
| **Projects** | Phase | Phase | Start → target date | Project · Type · Owner · Phase · Answered · Conflicts · Actions · Next milestone · Target |
| **Templates** | Category (AI agents, Software, Policies, Processes) | Status (Draft, In review, Published) | Last update → next review | Template · Status · Questions · Time · Who answers · Output · Used in · Owner · [Use] |
| **Library** | Kind (Shared constraints, Known facts) | Status (Confirmed, Fresh, Check due, Change pending) | Confirmed → next review | ID · Item · Owner · Source · Status · Used in · Next review · [Propose change / Still true?] |
| **Actions** (project tab) | Due window (Overdue and next two weeks, Before pilot live, Later, Done) | Status (To do, In progress, Blocked, Done) | Due date dots + milestones + phase bands | ☐ · Action · Owner · Status · Priority · Due · Timeline · Source · Tracked in |

**Actions list extras:**
- Clicking a status cell cycles To do → Working on it → Blocked → Done.
- Row checkboxes open a floating bulk bar: **N Actions selected · ✓ Mark done · → Move to · ⇩ Export CSV · ×**.

---

## 8. Home

- Greeting ("Good morning, Kari") and org/date.
- **Next step card:** one card with a title, a "why" line, a primary CTA and an optional secondary CTA. Its content depends on role × phase (matrix in §25.3).
- **Input received heatmap:** 7 days × 14 columns of activity, colored on a 4-step scale.
- **For you:** a list of items for this user, each with a kind label, text and an action button (Nudge, Review, Open, Decide, Accept, Read).
- **Getting started** checklist (owner, when "Show all features" is off): Project created · Questions reviewed · 3+ members sent · First input in · Spec generated.
- Project overview: cards by phase (other themes) or a grouped table (grid theme).

---

## 9. New project wizard (modal, 6 steps)

Modal 900×≤780px with a stepper: **Start · Basics · Sections · Questions · People · Review**.
- Back and Continue sit in the footer. The footer also shows "N sections · N questions · about N min per member".
- Continue is disabled until the step is valid. Clicking a completed step jumps back to it.

### 9.1 Start

Two options: **Start from scratch** (card), or pick a **template** (9 cards in a grid). Each template card shows its category, name, description and question count. "New" is shown on Process input.

### 9.2 Basics

- **Name** (required).
- **Type** chips: AI agent, Software, Policy, Process, Other. Changing type resets sections, questions and frameworks to that type's defaults.
- **Goal** textarea: "What should this project produce, and why?"
- **Output** chips depend on type:
  - AI agent: Copilot Studio, Agentforce, Claude project, ChatGPT GPT
  - Software: Claude Code, Cursor, Kiro, Codex
  - Policy: Policy draft · Word, PDF, Markdown
  - Process: BPMN 2.0 file, Process map, SOP draft, Markdown
- **Frameworks** (multi-select cards with "Fits type" badges). Each one adds sections:

| Framework | Fits | Adds sections |
|---|---|---|
| NIST AI RMF | AI agent, Software | Risk and impact, Roles and accountability, Monitoring after launch |
| ISO/IEC 42001 | AI agent, Software, Policy | Risk and impact, Roles and accountability, Monitoring after launch |
| EU AI Act | AI agent, Software, Policy | Risk classification, Transparency to users |
| ITIL 4 change | All but Policy | Change and release, Service impact |
| SIPOC + BPMN | Process | Suppliers, Inputs, Outputs, Customers |
| EARS requirements | All | (changes how requirements are written: WHEN … SHALL) |

  Unticking a framework removes the sections it added, unless the type's preset or another selected framework also needs them.
- **Deadline, Owner, Decider** inputs.

### 9.3 Sections

- A grid of every section in the library, plus custom sections. Each row has a checkbox, the name, a hint and a "· restricted" tag.
- When a section is selected, an **Authority sign-off** toggle appears (● Authority sign-off / ○ No sign-off).
- "Add a custom section" input with an **Add section** button.
- Type presets:
  - AI agent: Goal, Scope, Hard constraints, Requirements, Escalation rules, Data the AI may use, Tone, Examples, Acceptance criteria
  - Software: Goal, Scope, Hard constraints, Requirements, Data the AI may use, Examples, Acceptance criteria
  - Policy: Goal, Scope, Hard constraints, Controls and approvals, Examples, Acceptance criteria
  - Process (SIPOC): Goal, Suppliers, Inputs, Process steps, Outputs, Customers, Roles and handoffs, Exceptions, Systems and tools, Controls and approvals, Metrics, Pain points
  - Other: Goal, Scope, Requirements, Acceptance criteria

### 9.4 Questions

- For each selected section, a card with rows of **[target group select] [question input] [×]**, plus "+ Add question". Each section starts with seeded questions.
- An **Upload documents to prefill** button.
- When EARS is on, a banner explains that answers are drafted as "WHEN … THE SYSTEM SHALL …".

### 9.5 People

- Function-group chips (multi-select): All members, Contributors, Service desk, Security and risk, Finance, Legal and risk, People, IT, Engineering, Product, Operations, Process owner, Process performers.
- Toggles: Answer my own questions first · Prefill from documents · Allow private ideas · Save as a template for Lumio.
- **Include customers and other external respondents** toggle. When on, it shows segment chips (Enterprise customers, Pro plan customers, Free trial, Contractors, EU customers, New in last 90 days), channel chips (Email, In-app prompt, Support follow-up, Salesforce segment, QR code) and the note "Customer question set: 4 questions · about 3 minutes · consent shown first · personal details removed before analysis."

### 9.6 Review

A summary table: Name, Type, Started from, Produces, Deadline, Owner, Decider, Sections, Questions (with minutes), Frameworks, External respondents, Who answers.

**Create project** opens the new project on the Members tab in the Frame phase and shows a toast: "<name> created · N sections, N questions".

**Minutes estimate:** `min(questions, 8) × 2` per member (members only see their group's questions).

---

## 10. Project view

### 10.1 Header

Breadcrumb (Projects / IT Helpdesk Agent v1), title, type pill, phase pill, a meta line ("template · Target · Deadline"), owner and decider avatars, a settings button, the **phase stepper**, and the **tabs**.

**Tabs by role:**
- Owner and Decider: Overview · Members · Input · Brainstorm · Spec · Generate · Actions
- Contributor: Overview · My input · Brainstorm · Spec (+ Actions from Validate onward)
- Admin: Overview · Members · Spec · Actions

When "Show all features" is off, Generate and Actions are hidden before Validate.

Contributors get a banner above the tabs: "You have 1 thing to do: …".

### 10.2 Overview tab

- **Next step** card. Its color comes from the featured-card token.
- **Status:** a funnel (Sent → Opened → Started → Finished), plus open conflicts, open questions and an actions summary.
- **Coverage by section:** bars, with ● for authority sections and "· restricted" tags.
- **Members** grid with status pills (Done / In progress / Opened / Not started / Not sent). The caption reads "Status only. Nobody is scored."
- **Close-the-loop note** (Validate and later, owner only). An auto-drafted preview per member uses the pattern: "You raised … Decided … because … Owner … Status …". It ends with **Send to all members**, which becomes "✓ Sent to 8 members".
- **Checklist** for the current gate, for example "Before you lock v1.4.0".
- **Milestones** list (diamond marker, date, owner, status).
- **Activity** feed.

### 10.3 Members tab

- **Table:** Name + title · Role · Function group · Authority areas · Channel · Status cell · Last activity · **Nudge now**. "Targeted question sent" appears under a member's status when it applies.
- Actions: **Add by name or email · Import from Slack channel · Send / Send reminder**.
- **Send drawer** (right, 540px):
  - Message template with tokens `{first_name} {why_you} {minutes} {deadline} {owner_name}`.
  - A required "Why we're asking you" line per member.
  - Channel previews for Email, Slack and Teams.
  - A summary of the reminder rules, and **Send to 8 members**.
- **External respondents** card (§18.1).
- Info cards: Reminders (at most 2, worded differently, quiet hours 19:00–08:00), Digest (one per phase, with buttons), Escalation (the owner is told if an authority member hasn't answered 24h before the deadline).

### 10.4 Input tab — owner and decider

**Frame phase**
- **Smart question set** card (§14): the questions the system removed, with "Ask anyway".
- A question editor: a section list on the left (with question counts and restricted tags), and question cards on the right (target group, question, minutes, Edit / Add follow-up trigger / Preview as member).
- Buttons: **Upload documents · Prefill from these**, **Answer my own questions**.

**Collect phase**
- A card reading "Collection is open · N of 8 answered" with **Close collection and reveal**.
- While processing: "Reading 64 answers… Finding duplicates and conflicts" with a progress bar.
- **Adaptive questions** panel (§15).

**Review phase and later**
- A stats row: "Last processed 2 min ago · 64 items · 21 merges · 4 conflicts".
- **Customer evidence** card (§18.3).
- **Gap cards** (dashed amber border) with an action each:
  - Thin section → Send targeted question
  - Possible injected instruction → Keep as data
  - About a person → Create action
- Three columns:
  1. **Coverage by section** (mini bars).
  2. **Item list**. Each item card shows type pill, strength pill, ID and version, text, "role · Collect · section", a relation pill (for example "! Conflicts with CI-0250"), and a footer with **▲ upvotes · N comments · approval status pill**.
  3. **Detail panel** (sticky). It shows ID, version and section, the text, the original answer (italic, with role), and versions and merges. Below that come the actions (Edit wording · Split · Mark restricted · **Send to decision** · Create action) and the **Review** block (§16).

### 10.5 My input tab — contributor

Two columns.

**Left**
- **Your questions** list. Each row shows number, section tag, status pill, question, help text, and the saved answer with its strength. **Answer / Edit answer** opens an inline editor: textarea, strength chips (Must-have / Nice-to-have / Just an idea), Save answer, Skip · not my area, Cancel.
- In Frame the list is shown as a preview. In Review and later it is locked.
- **Answer on phone** shows the mobile flow (§10.6).
- **Your private ideas** (up to 3).
- **Team input** (Review and later): revealed items with **▲ Vote** (counts show only after you vote) and **N comments**. Comments expand inline with type chips and Post.
- **What happened to your input** (footprint). Each row reads "You said → outcome tag + why". Outcome tags: Sent to a decision, Used, Changed by your accepted suggestion, Not used.

**Right**
- About this project, including "Why you".
- Your role, areas, owner, decider, deadline and time needed.
- **Where we are:** a mini stepper and text for the current phase.
- **Here's what we already know** (Collect): prefill facts with Correct / Needs a change / Out of date.
- Promises: "Your answers stay private until everyone has answered. You'll see what happened to your input. This is about the work, not about people."

### 10.6 Contributor mobile flow (390px phone)

Six screens, all with hit targets of 44px or more:
1. **Invite:** who invited you, "Sam, we need what you know about escalations.", the reason, "6 questions · about 12 min", "Due Nov 14", the three promises, **Start**, "No account needed".
2. **Prefill:** "Here's what we already know." with 3 facts, each with Correct / Needs a change / Out of date.
3. **Question:** section and progress, question, help text, textarea, strength chips, **Skip · not my area / Next**.
4. **Follow-up:** "You mentioned 'secure'. Which check must happen before a reset?" (1 of 3 follow-ups).
5. **Ideas:** "Anything else we should consider?" Up to 3 private ideas on sticky notes.
6. **Thanks:** "You'll get one message when it's time to review."

### 10.7 Brainstorm tab

- **Before reveal:** "Your private ideas" (only you) and the message "Shared board is locked · Opens for everyone when collection closes."
- **After reveal:** the shared board, with the caption "Authors anonymous. Order randomized for you. No likes, no counts."
- Idea clusters are suggested and placed next to the spec section they relate to.
- Each sticky note (slightly rotated) shows ID, Anonymous, text, an outcome pill, and actions: Build on · Comment · **Promote to spec** · Park.
- Outcomes: Adopted → Spec vX · REQ-xxx / Declined · reason / Merged with N-xx / Sent to decision · DEC-xx / Parked · revisit after pilot.
- Promoting an idea creates a suggestion in the Spec tab.

### 10.8 Spec tab

**Header:** "Specification", a version pill (Draft / In review / Locked v1.4.0), **Compare with v1.3** (a diff toggle that highlights changed requirements) and **Export evidence pack**.

**Panels above the document**
- **Review banner** (contributor in Review): "Step 1: Agree or Object on the items chosen for your role. Comments appear after you give your own view."
- **Lock panel** (Decide): a checklist (No open conflicts, or each one deferred · All authority constraints confirmed 4 of 4 · Every requirement has acceptance criteria) and **Lock v1.4.0** (decider only, purple).
- **Simulated runs on this draft** (§17).
- **Framework coverage** (§19).

**Document sections**
- Goal, Scope, Hard constraints, Data the AI may use, Requirements, Tone, Decisions, Acceptance criteria.
- Every line shows an ID chip, the text and a provenance line, for example "From 5 people · 2 objections resolved · Decided by Daniel Reyes, Nov 12 · DEC-03".
- **Hard constraints:** owner and review date, plus "✓ Confirmed by <name>". Caption: "Constraints never get points and can't be voted out."
- **Requirements** use EARS: "WHEN … THE AGENT SHALL …" with `[HC-xxx]` references.
  - In Review, contributors get **Agree / Object** buttons. Object requires a reason and an alternative.
  - After giving their own view, the user sees peer comments: Clarification / Evidence.
- **Suggested change** (Tone T-01, Review): a strike/insert diff. The author chooses **Accept / Merge / Keep mine**. "Keep mine" creates a decision (DEC-07).
- **Decisions**
  - DEC-03 has an options grid. Each option shows supporters (groups), a quote, consequences and advisory points (35 / 65), plus a stacked bar with the caption "Points show how much people care, not whether something is right".
  - Decider actions: Choose, then a rationale (required), follow-up owner (who must accept) and due date → **Record decision**.
  - Other decider actions: Write a new option · Defer as open question · Ask for a short meeting.
  - DEC-07 (Choose Sam's / Grace's / Defer), DEC-06 (warning "Low support, high stakes"), DEC-04 and DEC-05 (deferred) are shown as compact rows.
- **Superseded banner** (Live): "! Decided on superseded input. CI-0231 was amended to v3 after lock. DEC-03 pins v2." with **Review**.

### 10.9 Generate tab

**Target picker:**
- Copilot Studio (connected)
- GitHub · Claude Code
- Agentforce
- Policy draft
- Markdown files

**What the AI receives**
- For a repository target: a file list with size bars for AGENTS.md, CLAUDE.md, .cursor/rules/constraints.mdc, spec/*.md, spec/decisions/DEC-03.md, tests/acceptance/*, .brief/brief.json and .brief/trace.json.
- For an instruction pack: Instructions, Hard constraints (verbatim), Topics, Knowledge sources and Escalation rules.

**Gates** (all must pass before approval):
1. Every hard constraint present by ID
2. Every constraint mapped to a check — HC-019 fails until **Fix** is pressed
3. Required sections covered by authority role
4. Every instruction traced to input
5. No contradictions
6. No unreviewed injection flags
7. Size within budget
8. No open conflicts (fails until locked)

**Approve and generate**
- The decider presses **Approve diff and open pull request** or **Approve diff and export to Copilot Studio**. Others see **Request approval from Daniel**.
- "Generate as draft only" is a fallback when gates fail.
- While running: "Claude Code · Agent running on brief/v1.4.0…". When done: "✓ Pull request #42 · 14 files changed · Generated from Spec v1.4.0".

**Instruction check** (§20.1).

**Generated output** (§20.2–20.6).

**After generation**
- Pilot comparison: violations for the team spec (2) vs. the owner's first draft (9), against a dashed threshold of 4.
- A grid of 24 scenarios (Pass/Fail chips, each linked to a constraint).
- A trace matrix: Item → Criterion → Test → Result → Source.
- Evidence pack (PDF · JSON).
- **MCP** endpoint card: `mcp.orgcue.com/lumio/it-helpdesk` (read-only; tools get_spec, get_requirement, list_constraints, report_failure).

**Live phase:** a drift banner ("Copilot Studio topic edited by hand · 2 changes proposed as input") and a "3 constraints due for review Mar 1" card with **Run review**.

### 10.10 Actions tab

Uses the shared template (§7) with Board, List and Timeline views.

**Action fields:** ID, title (starts with a verb), source (DEC-xx / Gap / Validation · HC-xxx / Milestone), owner, acceptance (Requested / Accepted / Declined), status, priority, milestone, due date, checklist, tracked in (Orgcue or an external tracker such as ServiceNow CHG0031207).

**Labels:** Overdue, Owner pending and Blocked override the plain status in the label.

**Drawer** (right, 460px):
- ID and priority, title, status / due / source pills.
- For synced actions: "Tracked in ServiceNow · read-only, status synced 4 min ago".
- Owner with acceptance pill and Reassign, milestone, tracked-in.
- **Accept / Decline with reason** when the owner is still pending.
- Description, checklist (toggleable unless synced), and the reminder rules ("3 days before due, on the due date, then every 3 days while overdue. Escalates to the owner after 7 days.").
- **Mark done**.

**Counts are project-level only** (P2).

---

## 11. Templates page

Uses the shared template (§7). Primary buttons: **+ Custom project** (opens the wizard from scratch) and **New template**. **Use** in a row opens the wizard at Basics with that template applied.

**Templates (9):**

| Category | Template | Default frameworks | Output |
|---|---|---|---|
| AI agents | IT helpdesk agent | NIST, EU AI Act, EARS | Copilot Studio · ServiceNow |
| AI agents | HR helpdesk agent | ″ | Copilot Studio |
| AI agents | Customer service agent | ″ | Agentforce · ServiceNow |
| AI agents | Sales assistant | ″ | Claude project · ChatGPT GPT |
| Software | Feature spec | EARS | Claude Code · Cursor · Kiro |
| Software | Internal tool | EARS | Claude Code · Codex |
| Policies | AI-use policy | ISO/IEC 42001 | Policy draft |
| Policies | Information security policy | ISO/IEC 42001 | Policy draft · Markdown |
| Processes | **Process input · SIPOC** | SIPOC + BPMN | BPMN 2.0 · Process map · SOP draft |

Question counts and minutes are computed from the type preset.

---

## 12. Library page (shared constraints + known facts)

Uses the shared template (§7).

- **KPIs:** 126 reuses across 5 projects · 31 h member time saved this quarter · 2 facts due for a "still true?" check.
- **Shared constraints (LIB-HC-xxx):** owned by an authority role and inherited by every project that uses the topic.
  - **Propose change** (for example LIB-HC-015: raise the limit to $400) sets the status to *Change pending* and shows a banner listing the affected projects, each of which gets a review prompt. Nothing changes until each owner confirms. **Withdraw** reverts it.
- **Known facts (LIB-F-xxx):** a source (person or document), a confirmed date, usage count and a freshness status.
  - Facts older than the freshness window (default 6 months) become *Check due*. **Still true?** asks the source.
- **How reuse works**
  - Frame: matching questions are removed or pre-filled (§14).
  - Collect: facts appear as prefill cards for members to confirm.
  - Finished projects suggest new library items, and an owner approves each one.

---

## 13. Portfolio page (not for contributors)

- **KPI tiles:** Median days, Frame to Live (23, −9 vs Q2) · Member minutes per project (74, −18 with library reuse) · Questions skipped automatically (31%, 212 questions · 318 min saved) · Conflicts per project (2.0) · Regenerations after lock (0.8, down from 2.1 since the linter).
- **Days per phase:** a stacked bar per project. Phase colors: Frame #C4C7D0, Collect #FDAB3D, Review #0B6FE0, Decide #9B51D8, Validate #0A8754. Each row also shows total days, member minutes, conflicts, % reused and regenerations.
- **Repeat questions:** questions asked in several projects, each marked "In library · LIB-xxx" or "Not in library", with **Add the missing to the library**.
- **Where time is lost:** insights with an action each, for example "Legal and risk answers 6 days after the deadline on average → Adjust template", "Regenerated 3× after lock → Run linter".
- Rule: show counts only, never individual performance (P2).

---

## 14. Smart question set (skip what's already answered)

**Where:** Input tab, Frame phase (owner).

Before sending, every question is checked against:
1. **Shared constraints:** "Covered by shared constraint · LIB-HC-015 · Lena Ortiz".
2. **Library facts:** "Answered in the library · LIB-F-005 · confirmed Nov 3".
3. **Uploaded documents:** "Found in an uploaded document · IT service catalogue · p. 4".
4. **Past projects:** "Answered in <project> · same group, 3 weeks ago".
5. **Duplicates** within the set.
6. **Low value:** "Low value in 3 past projects · Answers never reached a generated file".

**UI**
- Summary pill: "**N questions removed · N×1.5 min saved per member**".
- Chips: "4 constraints inherited", "5 facts pre-filled · members confirm instead of typing".
- A row per removed question: the question (struck through), reason, source, and **Ask anyway / Skip again**. This is reversible (P6).

**Acceptance criteria**
- The removed count and minutes saved update live.
- Every skip shows its source.
- Pressing Ask anyway puts the question back in the set.

---

## 15. Adaptive question management

**Where:** Input tab, Collect phase (owner).

**Rules** (configurable in Settings → Questions and library):
- **Converged:** stop asking a topic when at least *threshold* % agree (default 80%) with at least *min answers* (default 3).
- **Conflict:** send a follow-up only to the people in the conflict.
- **Thin:** send a targeted question to the missing role.
- **Open:** keep asking everyone.

**UI**
- An **Adaptive on/off** switch. When off, everyone gets every question.
- Summary: "N member-minutes saved so far · stops when 80% agree with 3+ answers".
- Table columns: Topic · State cell (Converged green / Conflict red / Thin amber / Open gray) · Evidence ("5 of 5 agree", "$500 vs $250") · What Orgcue did · action button (Keep asking / Stop asking / View follow-up / Send now).
- Footnote: "Every change is logged and reversible."

**Acceptance criteria**
- Keep asking on a converged topic changes its state to Open and removes its saved minutes.
- Follow-ups never reach people outside the conflict.

---

## 16. Comments, upvotes and approve/reject on input

**Where:** the Input tab (owner/decider item cards and detail panel) and the contributor Team input list.

### 16.1 Upvotes

- ▲ toggles your vote.
- **Contributors see counts only after voting.** This avoids herd effects; configurable to After voting / Always / Never.
- The owner and decider always see counts.
- Footnote: "Upvotes show interest, not truth. Constraints can't be voted out."

### 16.2 Comments

- Types: **Clarification**, **Evidence**, **Concern**, each with its own color.
- Placeholder text: "Comment on the input, not the person."
- Comments are attributed with name and role for the owner, decider and admin, and with role only for peers.

### 16.3 Approve / reject

- Owner and decider only, from Review onward.
- **Approve** → status *Approved*. The item goes into the spec draft.
- **Reject…** → pick a reason: Out of scope · Duplicate · Not feasible · Conflicts with a constraint. Status becomes *Rejected*. The author sees the reason in their footprint.
- The default status is *Pending review*.

### 16.4 Acceptance criteria

- Vote counts update immediately.
- New comments appear in both the detail panel and Team input.
- A rejected item shows its reason everywhere it appears.

---

## 17. Simulated runs during Review

**Where:** Spec tab, Review and Decide phases (not contributors).

- 20 scenarios drawn from last quarter's tickets, run against the **draft** spec.
- Result per scenario: **Pass**, **Fail** (constraint violated or undefined), **Conflict** (options give different answers; linked to the DEC), **Unclear** (an open question or a missing rule).
- Results update as decisions land. For example, "Password reset at 8am" changes from Conflict to Pass once DEC-03 is recorded.
- UI:
  - Summary "N of 20 pass on this draft", a stacked bar and a legend.
  - A grid of the cards that didn't pass, each with spec reference, status, title and note.
  - **Re-run** shows "Running 20 scenarios…" for about 1.4 s.
- Purpose: catch conflicts while people can still discuss them, not after lock.

---

## 18. External respondents (customers, partners, contractors)

### 18.1 Members tab — External respondents card

- Header: "External respondents", with a summary such as "86 of 240 answered · 36% response rate". Buttons: **Add segment · Copy link · QR · Preview as customer**.
- Guardrail chips: ✓ Consent shown first · ✓ Personal details removed · ✓ Text treated as data · Themes count from 10 responses · Shapes requirements, examples and tests · never constraints.
- Segments table: Segment · Channel · Invited · Answered · Response rate bar · Status (Not sent / Collecting / Closed).

### 18.2 Customer answer page (mobile, branded)

- Branded header (the customer's logo and name), progress bar, "Question N of 4". Footer: "Powered by Orgcue".
- **Intro:** "Help us build a better support assistant · 4 short questions · About 3 minutes · No account needed", plus a **consent checkbox**. Start is disabled until it is ticked.
- Questions:
  1. When you last needed help with your account, what happened? (text)
  2. How do you prefer to get help? (Chat / Email / Phone / Help article)
  3. How long is it OK to wait for a person? (Under 5 minutes / Under 1 hour / Same day / Next day)
  4. Would you trust a chat assistant to reset your password? (Yes / Only with extra checks / No)
- **Thanks:** "We will let you know what changed because of your answers."
- Choice buttons are at least 50px tall. Shown in the respondent's language.

### 18.3 Input tab — Customer evidence card

- Caption: "Evidence, not votes. Customer input informs requirements, examples and tests; members and the decider weigh it. Respondents who answer are not your whole customer base."
- Theme table: Theme + segments · Share (bar, % and count) · "In their words" quote · **Feeds** (spec reference) · Status (Supports / New / Used / Below sample) · Action.
  - **Create requirement** on a New theme drafts REQ-025, which goes to Review.
  - Themes below the minimum sample show "Needs 10+ responses".
- Result charts for the choice questions.
- The flow map shows "Customers · external" as its own highlighted group. The line explainer shows "From 53 customers" with no identities.

### 18.4 Rules (MUST)

- No account or login. A unique link or QR code, rate-limited.
- Consent comes before the first question. Personal details are removed before any AI processing. Injection handling is always on and can't be turned off.
- External input never creates constraints and never votes on decisions.
- Minimum sample size before a theme counts (default 10).
- Retention defaults to 6 months for raw answers. Themes and counts are kept longer.
- An optional "what changed because of you" note is sent when the change goes live.

---

## 19. Frameworks and coverage

**Where:** a Framework coverage card on the Spec tab (not contributors), with tabs **NIST AI RMF · ISO/IEC 42001 · EU AI Act**.

- Big % covered, a progress bar, and "N of N covered · N gaps · N partial".
- An export button per tab: Export NIST profile / ISO 42001 evidence / AI Act record.
- Table: Ref · Requirement · Covered by (spec items) · Status (Covered / Partial / Gap / Planned / N/A) · Action.
- **NIST:** GOVERN (roles, third-party risk — Gap: attach vendor terms), MAP (context, data risk, employee impact — Partial), MEASURE (testing, traceability), MANAGE (decisions, post-launch monitoring).
- **ISO/IEC 42001:** Clauses 4–10, 6.1.4 impact assessment (Gap → Add section), Annex A.6.
- **EU AI Act:** Art. 5, Art. 6/Annex III (not high-risk), Art. 50 transparency (Gap → **Add requirement** creates REQ-024 "say it is an AI"), Art. 4 AI literacy (Partial), Art. 26 (N/A).
- Many statuses depend on the phase. For example, MEASURE becomes Covered after lock.

---

## 20. Generated output explorer

### 20.1 Instruction check (linter)

Runs before generation.

- Quality score (100 minus weighted open issues) with a colored bar, and "N issues · N high".
- Issue table columns: Severity cell (High / Medium / Low) · Kind · Finding · Suggested fix · **Fix** (becomes ✓ Fixed).
- **Apply safe fixes** fixes everything except high-severity issues, which need a person.
- Demo issues:
  - L1 Conflict: ESC-01 vs HC-012 at 2am.
  - L2 Threshold: is $250.00 "above $250"?
  - L3 Vague: "expected wait time" has no unit.
  - L4 No test for REQ-021.
  - L5 Duplicate: HC-012 written twice.
  - L6 Vague: "plain words".
- Fixes save to draft v1.4.1.

### 20.2 Files view

Three panes:

1. **File tree:** name, size or budget, and "!" when a file has drift.
2. **File content**
   - Summary header: file name, "Spec v1.4.0 · generated Nov 18", a **Content / Changes v1.3 → v1.4** toggle, stat pills (budget, N sources, N people, N decisions), and "! 1 hand edit since generation".
   - A legend of source colors.
   - Lines: line number, 4px source-color bar, text and a source tag (HC-007, REQ-020…). Clicking a line selects it.
   - A footer note, for example "Showing the 35 lines that carry content · 83 more are scaffolding".
3. **Why this line is here**
   - With nothing selected: **Questions behind this file**, ranked by lines produced, each with a bar and "N lines · N answers".
   - With a line selected: ID chip and kind, version, title, spec text, **From input** (role · name, or "Name hidden" for peers, with the quote), **Decision** (ID, decider, rationale), **Checked by** (test name and Pass/Fail/Missing), **Appears in** (other files, clickable) and **Open in spec**.
   - Scaffolding lines: "Headings, links and file structure from the template and the target adapter. No spec source."
   - Hand edits: "Added in the target on Nov 21 (commit 3e1a7c2). Not in the spec, so the next generation would remove it." with **Propose as input / Keep as override**.

**CLAUDE.md** is a single line, `@AGENTS.md`, so both tools share one source.

### 20.3 Changes view (per file)

- A version diff with +/− lines (green or red background, strikethrough for removed lines). Each changed line carries a **cause chip**: Decision, Conflict resolved, Idea promoted, Suggestion accepted, Constraint confirmed or Hand edit.
- Summary: "+6 −3 lines · 2 decision · 1 conflict resolved · …".
- Files with no changes show "This file did not change between v1.3 and v1.4."

### 20.4 Flow map

- Four columns: **Questions → Answers by group → Spec items → Files**. Links are curves whose width reflects answers or lines (max 14px).
- Highlight by clicking a node, or with filter chips (Clear, groups, files). Unrelated nodes fade to 30% and unrelated links to 8%.
- Info bar: "N questions · N answers from N groups → N spec items → N files · N lines", with **Open file / Open in spec**.
- **Dead ends** have dashed red borders: questions with no output ("No output: Parked as idea N-12"), and spec items in no file.
- Fluid width (min 900px), with non-scaling strokes.
- Names stay at group level.

### 20.5 Segmentation view

- Always-loaded budget bar. Example: "AGENTS.md 118 + constraints.mdc 46 = 164 lines always loaded · target under 200".
- Table: Spec section → Goes to (clickable files) · Loading cell (Always / Always · verbatim / On demand / On trigger / Executed / Excluded / Not exported) · Why.
- Repository target rules:
  - Goal, Scope, Escalation, Tone and Data → AGENTS.md (always loaded).
  - Hard constraints → AGENTS.md, .cursor/rules/constraints.mdc and spec/constraints.md (verbatim).
  - Requirements → spec/requirements.md (on demand) plus a one-line summary in AGENTS.md.
  - Examples → spec/design.md.
  - Acceptance criteria → tests (executed).
  - Decisions → spec/decisions/.
  - Open questions and unpromoted ideas → excluded.
- Copilot Studio rules: Instructions, Hard constraints, Topics (on trigger), Knowledge sources and Escalation rules. Decisions are not exported; they stay in the evidence pack.
- Budgets come from Settings: AGENTS.md 150 lines, Cursor rules 200, Copilot 8,000 characters. Constraints are never summarized.

### 20.6 Not in any file

- **Excluded on purpose:** DEC-05 (open question), unpromoted ideas, CI-0277 (injected instruction).
- **Missing:** AC-021.1 has no test stub → **Add test stub**. REQ-024 was added after generation → **Regenerate**.
- **Questions that reached no file:** each with its answer count and why it wasn't used, and **Remove from template / Keep for v2**.

---

## 21. Settings

Left sub-nav and content on the right. Each row has a label, help text and a control (toggle, segmented, select, number with unit, text, or range). Rows can be **Locked** or show a **Changed** badge.

Changes collect in a draft and a sticky bar shows "N unsaved changes · Discard · Save changes". Saving writes an audit event.

Non-admins see org sections as "View only", with a banner: "Only org admins can change these settings. Ask Jordan Lee." Contributors see only Profile and Notifications.

| Section | Key settings (default) |
|---|---|
| **Profile** | Display name · Job title · Language · Time zone · Preferred channel (Slack) |
| **Notifications** | Digest (Per phase / Daily / Weekly) · Push only for mentions and objections (on) · Quiet hours (19:00–08:00) · Reminders before a deadline (2) · Escalate to the owner after (24 h) |
| **Organization** | Name (Lumio Inc.) · Email domain · Data region (US, **locked**) · Default language · Working days · Who may be decider (Leads and up) · Minimum members per project (3) · Default collection window (5 working days) |
| **Members and roles** | SCIM sync (on) · Allow guests (on) · Who can invite · **People table** (name, email, org role select, sign-in status, last active) · **Permission matrix** (§2.2) · Invite people · 48 of 60 seats |
| **Security and data** | SSO (Okta · SAML) · Require MFA (on) · Session length (12 h) · Who sees who said what (Owners and deciders) · Auto-restrict data/security sections (on) · Who can export (Owners and admins) · Keep raw answers (24 months) · Redact personal data (on) · Never train on our data (on, **locked**) · IP allowlist |
| **AI and generation** | Model provider (Anthropic Claude / Azure OpenAI / AWS Bedrock) · Process in data region only (on) · Budgets: AGENTS.md 150 lines, Cursor rules 200, Copilot 8,000 characters · Constraints verbatim (on, **locked**) · Flag injected instructions (on) · Instruction-check strictness (Standard) · High-severity issues (Block generation) · Simulated scenarios (20) · Validation threshold (4) |
| **Questions and library** | Skip answered questions (on) · Convergence threshold (80%, range 50–100) · Minimum answers (3) · Follow-ups only to conflict (on) · Max follow-ups per member (3) · Fact freshness (6 months) · Suggest library items (on) · Show upvote counts (After voting) · Who approves input (Owner and decider) |
| **External respondents** | Allow (on) · Who can invite (Owners and admins) · Branding (Your brand) · Language (Match respondent) · Consent line · Remove personal details (on, **locked**) · Treat external text as data (on, **locked**) · Retention (6 months) · Minimum responses per theme (10) · Can shape (Requirements, examples and tests) · Send "what changed" note (on) |
| **Integrations** | Card grid (§22) and an MCP server card |
| **Compliance and audit** | Frameworks on/off (NIST, ISO 42001, EU AI Act on · ITIL 4 off) · Evidence pack format (PDF and JSON) · Audit retention (7 years) · **Audit log** table (When, Who, What, Object), "✓ Chain verified · append-only", Export evidence pack |
| **Billing** | Plan (Business, annual) · Seats 48/60 · Usage (projects, generations, simulated runs) · Next invoice · Add seats · Download invoices · Change billing contact |

---

## 22. Integrations

| Category | Integration | Purpose | Demo state |
|---|---|---|---|
| Channels | Slack, Microsoft Teams, Email | Questions, digests and nudges with action buttons | Connected |
| Trackers | ServiceNow | Actions as change requests (read-only sync) | Not connected |
| Trackers | Jira | Actions as issues | Not connected |
| Trackers | PagerDuty | On-call data for escalation rules | Connected |
| AI targets | GitHub | Pull requests with generated files | Connected |
| AI targets | Copilot Studio | Instruction pack export | Connected |
| AI targets | Agentforce | Instruction pack export | Not connected |
| Documents | SharePoint / Google Drive | Documents for prefill | Connected / Not |
| CRM | Salesforce / HubSpot / Zendesk | Customer segments; ask after a ticket closes | Connected / Not / Not |
| API | **MCP server** | Read-only spec access for AI tools | `mcp.orgcue.com/lumio` |

Each card shows its name, status pill, purpose and category, with **Connect** (primary) or **Configure**. Admin only.

---

## 23. Non-functional requirements

- **Security:** SSO (SAML/OIDC) and SCIM, MFA through the identity provider, role-based access per §2, restricted sections, IP allowlist, and an audit log that is append-only and hash-chained.
- **Privacy:** data residency per org region, no model training on customer data (contractual), personal details removed before AI processing, configurable retention, and per-item restriction.
- **AI safety:** all collected text is treated as data. Injection detection flags items (for example CI-0277) and keeps them out of instructions. Constraints are copied verbatim, and gates block generation.
- **Traceability:** every generated line stores `{file, line, source_id, kind, spec_version}`. `.brief/trace.json` is emitted with each generation.
- **Accessibility:** WCAG 2.2 AA, visible keyboard focus (2px #4C7DFF), hit targets of 44px or more on mobile, and color never used as the only signal (status cells always carry text).
- **Performance:** first meaningful paint under 1.5 s. Merging 64 answers takes about 60 s and shows progress. A simulated run of 20 scenarios takes under 30 s.
- **Internationalization:** questions and the customer page are shown in the respondent's language; dates follow the user's time zone.
- **Notifications:** at most 2 reminders per deadline, worded differently, quiet hours respected, one digest per phase.

---

## 24. Suggested build order

1. **Foundations:** auth, orgs, users, roles, app shell, collapsible sidebar, design tokens, shared Board/List/Timeline template.
2. **Projects core:** wizard (scratch + templates + frameworks), sections and questions, members and send drawer, phases, stepper.
3. **Collection:** contributor My input (desktop and mobile), blind storage, reveal, merge and cluster, gaps, item detail.
4. **Review:** Agree/Object, suggestions (Accept/Merge/Keep mine), comments, upvotes, approve/reject, brainstorm board.
5. **Decide and lock:** decisions with options and rationale, pinned versions, lock gate, superseded detection.
6. **Generate:** target adapters (AGENTS.md / CLAUDE.md / Cursor / Copilot Studio), gates, instruction check, file explorer, trace, segmentation, diff, flow map, not-in-any-file.
7. **Validate and live:** scenarios and pilot comparison, actions (board/list/timeline, drawer, bulk), close-the-loop note, drift, constraint reviews, MCP.
8. **Org efficiency:** library (facts and shared constraints, change propagation), smart question set, adaptive questions, simulated runs during Review, portfolio.
9. **Compliance:** framework coverage (NIST / ISO 42001 / EU AI Act), evidence pack export, audit log.
10. **External respondents:** segments, branded mobile form, customer evidence, CRM integrations.
11. **Settings and integrations** (full), billing.

---

## 25. Demo data (seed)

### 25.1 Organization and people (Lumio Inc., US region)

| ID | Name | Title | Org role | Project role (IT Helpdesk) | Group | Authority | Channel |
|---|---|---|---|---|---|---|---|
| kari | Kari Nordmann | IT Service Manager | Creator | Owner | IT service | — | Slack |
| daniel | Daniel Reyes | CIO | Member | Decider | Leadership | — | Teams |
| priya | Priya Shah | Security Lead | Member | Authority | Security and risk | Hard constraints · Data (restricted) | Slack |
| sam | Sam Okafor | Service Desk Lead | Member | Contributor | Service desk | Escalation rules · Examples | Slack |
| lena | Lena Ortiz | Finance Business Partner | Member | Authority | Finance | Spending limits | Email |
| mei | Mei Lin | Data Protection Officer | Member | Authority | Legal and risk | Personal data | Teams |
| tom | Tom Becker | Legal Counsel | Guest | Contributor | Legal and risk | — | Email |
| grace | Grace Kim | Employee Experience Lead | Creator | Contributor | People | Tone | Slack |
| jordan | Jordan Lee | Org admin | Admin | — | — | — | — |

### 25.2 Projects

| Project | Type | Phase | Owner | Answered | Conflicts | Actions | Next milestone | Target |
|---|---|---|---|---|---|---|---|---|
| IT Helpdesk Agent v1 | AI agent | (demo phase) | Kari Nordmann | 7 of 8 | 4 | 7 | Spec locked · Nov 14 | Copilot Studio |
| Expense Approval Service | Software | Validate | Raj Patel | 7 of 7 | 0 | 3 | Pilot · Dec 8 | GitHub · Claude Code |
| AI Acceptable Use Policy 2027 | Policy | Collect | Kari Nordmann | 9 of 14 | 0 | 0 | Collection closes · Nov 20 | Policy draft |
| Customer Support Agent Tier 1 | AI agent | Live | Grace Kim | 10 of 10 | 0 | 1 | Constraint review · Nov 30 | Agentforce |
| HR Helpdesk Agent | AI agent | Frame | Kari Nordmann | — | 0 | 0 | Send · Nov 24 | Copilot Studio |
| Customer Refund Agent | Sample (read-only) | Live | Sample | 6 of 6 | 0 | 0 | Done | Agentforce |

### 25.3 Next-step matrix (role × phase)

| | Frame | Collect | Review | Decide | Validate | Live |
|---|---|---|---|---|---|---|
| **Owner** | Send questions to 8 members | 4 of 8 haven't answered → Nudge / Close and reveal | 3 ideas ready to promote | 2 decisions waiting on Daniel / Spec ready to lock | Send close-the-loop note / Track actions | 3 constraints due for review |
| **Decider** | Nothing waiting yet | Answer your 3 questions | Decisions arrive when Review closes | Settle DEC-03 and DEC-07, then lock | Approve the generation diff / Validation back | Approve go-live Jan 12 |
| **Contributor** | Nothing to do yet | Answer 6 questions · 12 min | Agree or Object on 3 items | Your input is with the decider | Read what happened to your input | Accept your action A-016 |
| **Admin** | Connect ServiceNow to sync actions | ″ | ″ | ″ | ″ | ″ |

### 25.4 Hard constraints

- **HC-007** The agent MUST NOT ask for or accept a password. (Priya Shah · review Mar 1, 2027)
- **HC-012** Suspected security incidents MUST escalate to on-call within 15 minutes. (Priya Shah)
- **HC-015** MUST NOT order hardware above $250 without manager approval. (Lena Ortiz · Apr 1, 2027)
- **HC-019** MUST NOT read or summarize HR records. (Mei Lin)

### 25.5 Requirements (EARS)

- **REQ-020** WHEN an employee asks for a password reset THE AGENT SHALL send an MFA push and change nothing until it is approved. [HC-007] · DEC-03
- **REQ-021** WHEN a ticket is handed to a person THE AGENT SHALL tell the employee the expected wait time. · ideas N-07 and N-11 · 53 customers
- **REQ-022** WHEN an employee reports a broken laptop THE AGENT SHALL offer the next three swap slots. · idea N-03
- **REQ-023** WHEN a hardware order exceeds $250 THE AGENT SHALL route it to the employee's manager for approval. [HC-015] · DEC-04
- **REQ-024** (after the AI Act check) WHEN a conversation starts THE AGENT SHALL say it is an AI assistant and how to reach a person.

### 25.6 Decisions

- **DEC-03** Password resets through chat. Option A: one verification question (Service desk, 35 pts). Option B: MFA push before any change (Security, Legal, 65 pts). **Chosen: B.** Rationale: "HC-007 rules out passwords; an MFA push is the only check that meets it." Pins CI-0231 v2. Follow-up A-015 (Priya Shah, Nov 28).
- **DEC-04** Hardware without approval: **$250**, revisit in Q2 with spend data (A-014, Lena Ortiz).
- **DEC-05** Personal devices: **deferred** as an open question (A-017).
- **DEC-06** After-hours escalation: on-call within 15 minutes (low support, high stakes; carries HC-012).
- **DEC-07** Tone wording: Sam kept his wording after Grace's suggestion; both versions go to the decider.

### 25.7 Actions

| ID | Title | Source | Owner | Acceptance | Status | Due | Priority |
|---|---|---|---|---|---|---|---|
| A-014 | Pull hardware spend data for Q1 | DEC-04 | Lena Ortiz | Accepted | In progress | Dec 15 | Normal |
| A-015 | Configure MFA push for chat-initiated resets | DEC-03 | Priya Shah | Accepted | To do · ServiceNow CHG0031207 | Nov 28 | High |
| A-016 | Write on-call escalation runbook for the agent | DEC-06 | Sam Okafor | **Requested** | To do | Nov 21 | High |
| A-017 | Add personal-device question to the FAQ as out of scope | DEC-05 | Kari Nordmann | Accepted | **Overdue** | Nov 10 | Normal |
| A-018 | Brief Tom Becker on the escalation constraints | Gap | Kari Nordmann | Accepted | Done | Nov 7 | Normal |
| A-019 | Remove HR-record lookup from the agent's data sources | Validation · HC-019 | Mei Lin | Accepted | **Blocked** (waiting on A-015) | Nov 25 | High |
| A-020 | Book pilot review with service desk | Milestone · Pilot live | Kari Nordmann | Accepted | To do | Dec 3 | Normal |

### 25.8 Milestones

Spec locked Nov 14 · Generated Nov 18 · Pilot live Dec 1 · Go-live Jan 12, 2027 · First constraint review Mar 1, 2027.

### 25.9 Library

- **Shared constraints:** LIB-HC-007, 012, 015, 019 (as above) · LIB-HC-021 Customer personal data MUST stay in the US data region (Mei Lin) · LIB-HC-030 A second approver is REQUIRED from $10,000 (Lena Ortiz).
- **Known facts:**
  - F-001 On-call rota lives in PagerDuty (Sam, Oct 2)
  - F-002 Password resets ≈ 40% of IT tickets (ServiceNow report)
  - F-003 Standard laptop ThinkPad T14 (catalogue · Check due)
  - F-004 Approvals take about 3 days (Lena)
  - F-005 Agents may read ServiceNow, KB and inventory (Priya)
  - F-006 AI tools that monitor staff need a works council consultation (Tom · Check due)

### 25.10 External respondents

| Segment | Channel | Invited | Answered |
|---|---|---|---|
| Enterprise customers | Email | 90 | 38 |
| Pro plan customers | In-app prompt | 80 | 29 |
| Free trial | In-app prompt | 40 | 11 |
| Contractors | Support follow-up | 30 | 8 |

**Themes**
- Wants to know the wait time (53) → REQ-021
- Prefers chat for password resets (50) → REQ-020
- Wants extra checks before a reset (42) → HC-007 / DEC-03
- Wants a person for anything billing-related (19) → New
- Asks for SMS instead of an app (6) → below sample

---

## 26. Acceptance checklist (end-to-end demo)

1. Create a project from scratch with type Process and SIPOC + EARS frameworks. The sections include Suppliers, Inputs, Outputs and Customers.
2. In Frame, the smart question set removes 6 questions. "Ask anyway" restores one, and the minutes saved drop by 1.5.
3. Send questions. The phase becomes Collect. The contributor answers 2 questions on the phone flow and adds an idea.
4. Adaptive questions show one topic converged and two in conflict. "Keep asking" on the converged topic reopens it.
5. Close collection and reveal. Items appear with upvotes, comments and approval status. The contributor's vote count appears only after voting.
6. Reject an item with "Duplicate". The author's footprint shows the reason.
7. In Review, simulated runs show conflicts linked to DEC-03 and DEC-04.
8. The decider records DEC-03 with a rationale. The related scenario turns Pass and the lock checklist updates. The decider locks v1.4.0.
9. The instruction check shows 6 issues. "Apply safe fixes" leaves 2 high issues and the score rises.
10. Generate to GitHub · Claude Code. Every gate passes after Fix. The file explorer shows AGENTS.md with source tags. Clicking REQ-020 shows the input, DEC-03 and the test.
11. The flow map highlights Security and risk and dims everything unrelated. Q14 shows as a dead end.
12. Changes v1.3 → v1.4 lists cause chips for each changed line.
13. The Actions list cycles a status cell and bulk-marks 2 actions done. The board and timeline show the same data.
14. The Library proposes a change to LIB-HC-015 and the banner lists 3 affected projects.
15. The customer preview requires consent, then completes 4 questions. Customer evidence offers Create requirement on a New theme.
16. Settings: change "Convergence threshold" and the save bar appears. Saving logs an audit event. A contributor sees only Profile and Notifications.
17. Collapse the sidebar, reload, and it stays collapsed.
