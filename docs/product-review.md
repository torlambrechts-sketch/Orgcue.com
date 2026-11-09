# Product review: advisory panel, changes made and roadmap

In November 2026 a panel of four reviewed OrgCue: a strategy consultant, a PMO director, a SaaS founder and a market analyst. They are AI reviewers working in those roles. Each used the live product on their own and wrote up their findings separately. The market analyst researched more than 40 vendors; that report is in `docs/vendor-landscape.md`. This note summarises what they found, what changed in this release and what is left for the roadmap. In the app, the same content is on the **Product roadmap** page (`/#roadmap`, flag icon in the left rail).

## What the panel agreed

1. **The core idea is rare and worth leading with.** One thread runs from objective to measure, initiative and task, and the product shows how much of each target gap is covered.
2. **Consistency was the biggest weakness.** The same initiative had different dates, budgets and statuses on different pages. One example: the Management system budget was £354k on one page and £420k on another. One example: Market research was "Closing" on one page and "Delivery, Off track" on another. Recurring revenue was "on track" on one page, "behind" on another and "ahead" on a third.
3. **Strategy needs a working system, not just views.** That means:
   - status calculated from the numbers;
   - dated check-ins;
   - confidence on OKRs;
   - a log of decisions and actions that carries into the next review.
4. **Before OrgCue is more than a demo, it needs:**
   - real shared, multi-user data;
   - roles and permissions;
   - budgets by month.
5. **Positioning.** OrgCue should be the strategy-to-delivery layer above Asana, monday.com and Jira. It should connect to them rather than compete on tasks. The way in is the quarterly review pack, written from live data.

## Each reviewer's view

| Reviewer | Strongest today | Biggest gaps | Build now |
| --- | --- | --- | --- |
| Strategy consultant | Target coverage, the exceptions-first review, the initiative page | Status typed by hand; OKRs with no check-ins; no decision log; no real cascade to units; no strategic risks | Measurement engine; review workflow with decisions and actions; one objective model with a cascade |
| PMO director | Four health signals with baselines; initiatives linked to KPIs; status updates that flag when they are stale | Projects and initiatives stored separately; no intake; gates with no criteria; no monthly budgets; no capacity by role | One initiative record; intake and gate decisions; monthly budget, actuals and forecast |
| SaaS founder | One line from board to tasks; the review pack; portfolio control | No multi-user back end; no first-run experience; three areas that model the same thing twice; AI that ignored the data | Guided first run; one thread with alignment; an assistant that answers from the data |
| Market analyst | Hoshin and benefits tracking set OrgCue apart; strategy, portfolio and work in one product matches where the market is heading | AI agents, integrations, an API or MCP server, and enterprise trust features are now expected | Assistant on live data; shared data; Slack and Teams |

**Recommended positioning (founder).**

> "The strategy-to-delivery system for mid-size companies: one thread from the board's ambition to this week's tasks, and the quarterly review pack writes itself."

The ideal customer is the COO, head of strategy or head of PMO at a company of 200 to 2,000 people.

**Suggested packaging (tier names only).**

| Tier | For | Includes |
| --- | --- | --- |
| Free | Small teams | Strategy on a page, OKRs, measures, My work and tasks |
| Team | One leadership team | All strategy frameworks, initiatives, the review pack, Slack and Teams, CSV import |
| Business | The main target customer | Portfolio control, programmes, stage gates, budgets, RAID, workload, connectors, the assistant |
| Enterprise | Large or regulated buyers | SSO, SCIM, audit log, advanced roles, several strategies and business units, API, data residency |

## What changed in this release

| Change | Where | Asked for by |
| --- | --- | --- |
| **Calculated status.** Status follows progress against the plan for the year. A measure is on track within 15 points of plan and at risk within 30. Owners can override, but must give a reason. | `/#st-kpis` | Strategy consultant |
| **Dated check-ins.** Each check-in records the period, value, status and comment, and keeps a history. Target changes are recorded too. | Measure detail | Strategy consultant |
| **OKR check-ins with confidence.** Click a key result to record its value, a confidence level (high, medium or low) and a note. The page now gives the correct quarter week. | `/#st-okr` | Strategy consultant |
| **Decisions and actions.** A log of decisions with their rationale and follow-up actions. The strategy review reads its decisions and open actions from this log. Stage gates and requests also write to it. Approving an investment moves the initiative to Approved. | `/#wk-decisions`, `/#st-review` | Strategy consultant, PMO director |
| **Requests (demand intake).** Submit a request and it is scored on value, fit with the strategy, ease and risk. Accepted requests become initiatives at the business case gate. Rejected ones keep their reason. | `/#wk-intake` | PMO director |
| **One initiative record, first step.** Project cards now take their dates, status, budget and spend from the initiative. Editing a project card updates its initiative. In the review pack, "committed" now means approved work only. Prioritisation marks running work as Committed rather than Hold. | Dashboard, `/#st-review`, `/#st-priority` | PMO director, founder |
| **Assistant that answers from live data.** It answers what is off track and why, where money is at risk, whose updates are overdue, what you have to do, where target gaps are not covered and what decisions are pending. It also writes a steering brief. It can draft a status update for any initiative, which you review before posting. | Sparkle button | Founder |
| **First run.** A welcome card asks your role. A five-step strategy tour and a five-step portfolio tour are also in Help. | Dashboard, Help | Founder |
| **Product roadmap page.** It shows the roadmap with voting and suggestions, what has shipped, how features compare with leading vendors, a vendor table and the panel's review. | `/#roadmap` | User request |
| **Corrections.** | Several pages | All |

The corrections in the last row:
- The review pack no longer claims Nordic clients were signed.
- The market study is now at the Closing stage everywhere.
- Office 365 is opex.
- "Unbudgeted costs" is now "Forecast overspend".
- The governance meeting date is now a real Friday.
- Completing a blocked task now shows a warning.
- Dialogs close when you move to another page.

Recalculating statuses changed some objectives:
- Recurring revenue, Digitise core processes and Keep teams engaged are now **at risk**.
- Win in two new markets and One source of truth are now **off track**.
- Improve operating margin is now **on track**.

## Known issues left open

These were raised by the panel and are on the roadmap rather than fixed here:
- **Projects and Work still have separate task lists.** Roadmap item: "One task list".
- **Budget lines don't match initiative budgets.** On the Budgets page, the line items for a project don't add up to its initiative's approved budget. Roadmap item: "Monthly budgets".
- **Different baselines for recurring revenue.** The ambition page and the X-matrix bowling chart measure it against different baselines than the scorecard. The X-matrix also leaves out the Nordics.
- **Static pages.** The OGSM, V2MOM and heat map pages keep their own hand-set statuses.
- **Dates.** The demo date is fixed at 16 September 2024. Resource data is from 2023, and RAID review dates are in the past.
- **No back end yet.** All data stays in one browser.

## Roadmap

The roadmap page holds the full list, with the reason for each item and the vendors that set the standard. In short:

- **Now:** real accounts and shared data; roles and permissions; monthly budgets, actuals and forecast; one task list; business unit scorecards and a real cascade.
- **Next:**
  - gate criteria and named approvers;
  - capacity by role and what-if scenarios;
  - KPI data connectors;
  - Slack and Teams;
  - Jira and Azure DevOps sync;
  - board pack export and digests;
  - custom fields and saved views;
  - strategic risks;
  - SSO, SCIM and audit log;
  - Excel and Jira import;
  - change requests.
- **Later:**
  - AI agents;
  - public API, webhooks and MCP;
  - strategy scenarios;
  - benefit profiles;
  - timesheets;
  - phone apps;
  - BI connectors;
  - critical path;
  - governance calendar;
  - data residency.
