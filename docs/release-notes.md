# Release notes

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
- **Activity is linked to the demo person.** In shared workspaces, task and check-in activity is credited to the demo person, Olivia Adams. The audit log shows the signed-in account.
- **Invitations are not emailed.** An invited person signs in with the invited address and chooses Join.
