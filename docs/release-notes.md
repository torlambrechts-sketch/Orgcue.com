# Release notes

## November 2026: the planned collaboration, strategy, portfolio and work features

This release builds the 22 Planned items on the Product roadmap (`/#roadmap`) that need no outside service. They are now in the roadmap's Shipped column. Their records live in 39 new database tables (see `docs/database.md`), and the demo company has sample data for each of them.

### Collaboration
- **Owners, contributors and followers** (RM40). Every task, measure, objective, initiative, decision, risk and action has one owner, plus contributors, people to consult and followers. The Who does what page (`/#wk-raci`) shows this as a RACI grid and flags records with no owner or two owners.
- **Accept, decline or propose a new date** (RM41). New tasks, actions and hand-overs wait for the assignee to accept, decline with a reason, or propose another date. The date they commit to is kept apart from the due date.
- **Comment threads on every object** (RM42). Threads have replies, @mentions, reactions, resolve and reopen. You can turn a comment into an action or a thread into a decision. Pages open the shared discussion panel from their header.
- **An inbox you can act from** (RM50). My work's inbox bundles updates per item. You can reply, accept, approve and snooze from the inbox, and set quiet hours.

### Strategy
- **Catchball and target agreement** (RM44, `/#st-agree`). Unit owners draft, propose, counter-propose, agree and lock objectives, targets and key results. They can send alignment requests to the parent owner. A shared key result has contributions that each team accepts.
- **Review meetings that produce owned work** (RM45, `/#st-meet`).
  - A meeting has attendees, an agenda built from the exceptions and a pre-read deadline.
  - Its minutes produce actions. Each action lands in its owner's My work and carries forward until done.
- **Committed and stretch targets** (RM49, `/#st-commit`). Status uses the committed target. A say/do rate is shown per owner and team for each period.
- **One status model** (RM61). OGSM, V2MOM, the X-matrix, the ambition and the heat map all read the same calculated statuses, targets and baselines.

### Portfolio
- **Milestones with acceptance and evidence** (RM43). A milestone has an accepter, criteria and evidence, and is met only when accepted. Late milestones roll up to the initiative and flag the key results that depend on them.
- **Resource requests** (RM46, `/#wk-capacity`).
  - A project manager requests a role or person for a period.
  - The line manager confirms, proposes another person or time, or declines.
  - Bookings go from soft to hard and show beside capacity.
- **Approved date changes move dependent work** (RM63). Approving a later end date offers to move each dependent initiative, or to raise a change request for it.
- **Capex and opex by month** (RM64). The finance grid and the budget totals split capex and opex month by month.

### Work
- **Absence cover and hand-over** (RM47, `/#wk-teams`). Time off has a named cover, who receives new assignments, approvals and check-in reminders. A hand-over moves ownership with a note, and takes effect when the new owner accepts.
- **Team triage queues** (RM48, `/#wk-teams`).
  - Each team has a queue with accept, decline, merge and snooze.
  - A triage owner rotates, and you can swap turns.
  - Round robin skips people who are away.
- **Workload you can act on** (RM51, `/#wk-tasks`, Workload view). It shows overdue work carried forward, a row for unassigned work and time off. You can drag work to reassign it, and you are warned before overloading someone.
- **Done criteria and review** (RM52). A task can have done criteria and a reviewer. A reviewed task completes only when the reviewer approves.
- **Templates** (RM65, `/#wk-templates`). Save an initiative or project as a template with its tasks, phases, roles and gates, then start new work from it.
- **Recurring tasks** (RM66). Tasks can repeat weekly, every two weeks, monthly or every three months. Completing one creates the next.
- **Live dashboard actions and assistant search** (RM69). The dashboard's Actions widget and the assistant's search read live tasks, actions and records.

### Platform
- **Accounts linked to people** (RM60).
  - Each member of a shared workspace is linked to a person, set when they accept an invitation or by an admin on the members list.
  - New members get a new person.
  - Their assignments, comments, check-ins and approvals now carry their own name instead of the demo person's.
- **Live demo dates** (RM67).
  - The demo company is stored as of 16 September 2024. Each new demo session, reset or shared workspace copied from the demo moves every date forward by whole years, so the demo's "today" falls in the current year. In November 2026 that date is 16 September 2026.
  - The code no longer assumes fixed years: target years come from the planning horizon or the targets themselves.
  - Stale sample data (resource data and RAID review dates) has been brought up to date.
- **One date format** (RM68, `/#settings-pl-dates`). Dates follow a workspace setting everywhere, including project cards: day first (the default), month first or ISO.

### Database
- Migrations `20261110100000_platform2_member_people.sql` (person links), `20261110100100_platform2_shift_years.sql` (`orgcue_shift_years` and the shifted demo copies), `20261110100200_planned_tables.sql` and `20261110100300_planned_demo_data.sql`.
- There are now 202 tables, with 113 enforced parent-child keys and 288 indexed references.

### Known limits
- **Shifted demo dates.** Shifted demo dates keep their calendar date, not their weekday. So in a shifted demo a few sample days off fall partly on a weekend: for example, Marta's day off on 20 September is a Sunday in 2026.
- **Earlier demo sessions keep their data.** Demo sessions started before this release keep their 2024 dates and have no sample data for the new features. Help › Reset demo data brings them up to date.
- **Invitations are still not emailed** (RM62, Planned).

### What is still on the roadmap
- **Planned, needing an outside service:** KPI data connectors, Slack and Teams, Jira and Azure DevOps sync, single sign-on and SCIM, scheduled email digests and invitation emails.
- **Exploring:**
  - AI agents;
  - the public API and MCP server;
  - phone apps;
  - BI connectors;
  - data residency;
  - agreed baselines and benefit hand-over;
  - celebrating finished work;
  - a rule builder;
  - a portfolio planning cycle;
  - a dashboard builder;
  - linked documents;
  - guest access;
  - presence.

## November 2026: everything database driven

- **Database:** every record now lives in typed tables in Supabase: 163 tables across strategy, portfolio, work, projects, platform and product content, with 80 enforced parent-child keys and 190 indexed references. See `docs/database.md`.
- **No hardcoded data:** the page no longer contains sample data or seeding code. It loads the workspace's rows at start, and after each change it sends only the rows that changed, with a version check.
- **Demo data:** the sample company is stored in the database as a read-only demo workspace.
  - A visitor without an account gets a private demo session, which is a copy kept for 14 days after the last visit.
  - Reset demo data restores it.
  - Signed-in users can copy their session into a shared team workspace.
- **The demo's "today":** the demo company is dated 16 September 2024, and that date is stored as data. A workspace without that date uses the real date.
- **Empty workspaces:** every page works with no data, showing empty states.
- **Security:** data tables are reached only through functions that check access first. Text loaded from the database cannot inject markup.


## November 2026: shared workspaces, finance, governance and planning

This release builds the Planned and Exploring items on the Product roadmap (`/#roadmap`) that need no AI, phone app or outside service. Each item now sits in the roadmap's Shipped column.

### Platform
- **Shared workspaces** (Settings › Workspace and sign-in, `/#settings-pl-workspace`).
  - The local demo still works without an account.
  - When you sign in with email and password, you can create a shared workspace from the demo data or join one you were invited to.
  - Saves go to Supabase with a version check, so two people cannot overwrite each other without warning.
  - Other members' changes arrive as they happen: through Realtime, and through a check every 20 seconds, when the page regains focus and when you come back online.
  - A chip in the top bar shows Local demo, Saved, Saving or Offline.
  - The database schema is in `supabase/migrations/`. Row level security covers every table. A save function checks the member's role and version, the last admin cannot leave, and invitations are accepted only for a confirmed email address.
- **Roles and permissions:** Admin, Editor, Contributor and Viewer.
  - Every change is checked against your role, and a blocked action says why.
  - In the demo you can switch role with "View as", in the profile menu.
- **Audit log** (`/#settings-pl-audit`, admins): who did what and when, with search, filters, dates and CSV export.
- **Import** (`/#settings-pl-import`, admins).
  - Sources: a CSV file, text pasted from Excel, or a Jira CSV export.
  - It imports tasks, initiatives or measure values, with column mapping, a preview with row errors, and undo.
  - Files are read in the browser; nothing is uploaded.

### Portfolio
- **Finance:** budget, actuals and forecast by month for every initiative.
  - It also tracks capex and opex, and purchase orders as committed spend.
  - The estimate at completion (actuals plus forecast) now drives every forecast figure in the app.
  - Budget lines are allocations within the approved budget, and any amount not yet allocated is shown.
  - The Budgets page adds a "By initiative" view and a "By month" view.
- **Gates:** each stage has its own criteria, named approvers and a rule (all approvers or any one).
- **Change requests:** a request can change the end date, the budget or the scope.
  - Approval re-baselines the initiative and keeps the baseline history.
  - Portfolio control has a new Changes tab.
- **Benefit profiles:** each benefit has an owner and planned and realised value by quarter. The Benefits page has a portfolio view.
- **Critical path:** the timeline shows the chain that sets the latest end date. "What if it slips?" shows what moves and which targets are affected, without changing live data.
- **Capacity** (`/#wk-capacity`): demand against capacity by role and quarter, with drill-down and editors for demand and capacity.
- **Scenarios** (`/#wk-scenarios`).
  - Include or exclude initiatives, move them, rebudget them and change the yearly caps.
  - See spend, capacity, dependency conflicts and 2026 target coverage, and compare scenarios side by side.
  - Apply a scenario to the live plan after confirming.

### Strategy
- **Unit scorecards** (`/#st-units`): each business unit has its own objectives and measures, linked to company objectives with weights.
  - Status is calculated and check-ins are dated.
  - A cascade view shows how unit results roll up.
  - The heat map now calculates linked cells.
- **Strategic risks** (`/#st-risks`): a register with appetite per category and a 5×5 grid. The strategy review shows the risks above appetite.
- **Governance calendar** (`/#st-calendar`): reviews, board meetings, check-in deadlines and meetings, with cadence settings.
  - It lists overdue check-ins by owner.
  - Locked periods refuse new check-ins.
- **Frozen board packs:** freeze the strategy review each quarter and compare a frozen pack with live data. Export it as PDF, HTML or CSV.

### Work
- **One task list:** project plans and their initiatives now share one task list. The Table, Kanban, Gantt, team, KPI and calendar views read and write the same tasks.
- **Custom fields and saved views:** add your own task fields, and save views for yourself or the team.
- **Timesheets** (`/#wk-time`): weekly hours per task, with submit and approval. Hours roll into tasks, initiatives and workload.
- **Critical path for tasks:** a toggle on the Tasks timeline, with slack shown in the task panel.

### Fixes
- **Escaping:** some older views put user-entered text into the page without escaping it, including budget line details, people's names and chart legends. These are now escaped. In addition, angle brackets in any loaded text value become look-alike characters, so text from a shared workspace cannot run scripts.
- **Baselines:** no baseline is dated in the future.
- **Migrated plan tasks:** long-overdue tasks from the project plans are rescheduled, or completed when their initiative is closing.

### Collaboration research
The advisory panel researched collaboration in leading platforms; see `docs/collaboration-research.md`. Its 17 recommendations are on the roadmap as Planned or Exploring.

### What is still on the roadmap
Everything not built here is on the roadmap page (`/#roadmap`):
- the collaboration features recommended by the panel;
- integrations: SSO and SCIM, Slack and Teams, Jira sync, KPI data connectors, digests and invitation emails, the API and MCP server, BI connectors;
- AI agents and phone apps;
- the gaps found while building this release:
  - linking accounts to people;
  - one status model on every strategy page;
  - approved date changes that move dependent work;
  - capex and opex by month;
  - templates and recurring tasks;
  - live demo dates and fresh sample data;
  - one date format;
  - live data for the dashboard actions and the assistant's search;
  - a dashboard builder, linked documents, guest access and presence.

### Known limits
- **Auth site URL (needs a setting change).** The Supabase project's auth site URL is still `http://localhost:3000`, so confirmation and magic-link emails point there. To fix it, open Authentication › URL Configuration in the Supabase dashboard:
  - set the Site URL to `https://www.orgcue.com`;
  - add `https://www.orgcue.com/**` to the redirect URLs.
- **Live updates are partly tested.** The Realtime push could not be tested from the build environment. The regular version check is tested.
- **Activity is linked to the demo person.** In shared workspaces, task and check-in activity is credited to the demo person, Olivia Adams. The audit log shows the signed-in account. (Fixed by RM60 in the next release: members are now linked to their own person.)
- **Invitations are not emailed.** An invited person signs in with the invited address and chooses Join.
