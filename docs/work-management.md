# Programmes, portfolio control, tasks and collaboration

This note describes the Work section of OrgCue: how programmes, initiatives and tasks are managed, controlled and shared. It also lists the practices taken from leading work-management and portfolio tools. All data is sample data for the demo company, MosaicX. The demo's "today" is 16 September 2024 and you are signed in as Olivia Adams.

## The model

```
Programme ──< Initiative ──< Task ──< Subtask
   lead,        stage, baseline,      assignee, start, due, priority, estimate,
   status       forecast cost,        dependencies, comments, followers, activity
   updates      status updates, follows
```

- **Programmes.** There are four: Growth, Client excellence, Digital core, and People and skills. Each has a lead and its own status updates. Every initiative belongs to one programme.
- **Initiatives** gain:
  - a stage (Idea, Business case, Approved, Delivery, Closing);
  - a baseline end date;
  - a forecast cost;
  - dependencies on other initiatives;
  - followers.
- **Health.** Each initiative gets four signals, and a programme shows the worst signal of its initiatives.

  | Signal | What it compares |
  | --- | --- |
  | Schedule | forecast end against the baseline |
  | Budget | forecast cost against the budget |
  | Progress | share of tasks done against share of time used |
  | Risk | open items in the RAID log |
- **Status updates.** An update has:
  - a status (On track, At risk or Off track);
  - a one-line summary;
  - highlights, blockers and next steps.

  The form says what changed since the last update. An initiative with no update in three weeks is flagged.
- **Tasks** have:
  - an assignee, start and due dates, a priority and an estimate in hours;
  - subtasks;
  - "waits on" dependencies;
  - comments with @mentions, followers and an activity log.

## Where to find it

| Page | Address | What you can do |
| --- | --- | --- |
| My work | `/#wk-my` | Your tasks, grouped as Overdue, Today, This week, Next week, Later and Done. The inbox holds mentions, assignments, update requests and rule alerts; you can filter it, mark items read and archive them. Team activity shows what others changed. |
| Portfolio control | `/#wk-portfolio` | **Health:** each programme with its initiatives, the four signals, budget and forecast, baseline slip and the age of the last update; status chips filter the table. **Timeline:** baseline and forecast bars, milestones, dependencies, with clashes in red. **Stage gates:** approve an initiative to the next stage, or send it back with a reason. |
| Programmes | `/#wk-program` | One programme: signals, initiatives, timeline, status updates with replies, what is due in 30 days and open risks. Write a programme update. |
| Tasks | `/#wk-tasks` | Every task as a **list** (group by initiative, assignee, status, priority or programme), **board** (drag between statuses), **timeline** (with dependencies), **calendar** or **workload** (hours per person each week against capacity). Presets: My open tasks, Overdue, Due this week, Blocked. |
| Automation | `/#wk-rules` | Switch rules on or off, run the overdue check, and see recent runs. |
| Task panel | opens from any task | Complete, follow, rename, reassign, set dates, priority and estimate, add subtasks and dependencies, and comment with @mentions. |

**Connected pages.** These also link into the Work section:
- **Initiative page** (`/#st-init`): shows the programme and stage, a Follow button and the latest status updates. Its tasks open in the task panel.
- **Bell:** shows the inbox.
- **Search:** finds programmes and tasks.
- **RAID log:** receives issues raised by the Off track rule.

## Automation rules

| Rule | When | Then | On by default |
| --- | --- | --- | --- |
| R1 | a task is assigned to someone | notify the new assignee | yes |
| R2 | someone is @mentioned in a comment | notify them | yes |
| R3 | a blocking task is completed | tell the assignee of the waiting task they can start | yes |
| R4 | every task in an initiative is done | move the initiative to Closing | no |
| R5 | a task is overdue (checked when you run checks) | raise it to High priority and notify the assignee | no |
| R6 | a status update is Off track | log an issue in the RAID log | yes |

## Practices borrowed

The research covered Asana, monday.com, ClickUp, Jira and Jira Product Discovery, Smartsheet, Wrike, Linear, Microsoft Planner, Planview and Atlassian Goals and Projects.

- **Portfolio table with a health summary.** Asana Portfolios and Smartsheet Control Center show one row per project with status, progress, owner and latest update. Planview splits health into schedule and cost signals. OrgCue adds status counts you can click to filter, and treats "No update" as its own state.
- **Status updates with a required status and set sections.** Asana's template has Summary, Accomplishments, Blockers and Next steps. Linear flags missing updates and separates health from how fresh the update is. OrgCue's form also says what changed since the last update.
- **Programme rollups.** Linear Initiatives show the status of each child project; Jira Plans roll dates up to the parent. Each programme row shows its initiatives' status counts and its worst signal.
- **Baselines and dependencies on the timeline.** monday.com and Smartsheet draw grey baseline bars under live bars, show a today line, and mark late dependencies in red.
- **Workload heat map.** Asana, monday.com, ClickUp and Wrike show people by week against capacity, in green, amber and red. Clicking a cell shows the tasks behind it.
- **Task side panel.** Asana, ClickUp and Linear put fields, subtasks, "blocked by" and "blocking" lists, comments with @mentions, followers and an activity log in a panel that opens beside the list.
- **My Work sorted by date.** monday.com My Work groups tasks as Past dates, Today, This week, Next week and Later. The buckets move by themselves as dates pass, unlike Asana's "Recently assigned".
- **Inbox with filters.** The inboxes in ClickUp, Linear and Asana. OrgCue filters by mentions, assignments, requests and rules.
- **Rules as plain sentences.** Asana and monday.com write rules as "When this happens, then do that". Every rule has an on/off switch and a run log, following Jira Automation's audit log.
- **Stage gates.** Planview lifecycles and Smartsheet approvals. Each gate asks one question, an approval records who decided, and sending back needs a reason. Unlike Asana's approvals, a rejected item stays open and visible.
- **Following.** Atlassian Home and Linear let people follow projects and tasks. The creator, assignee and commenters follow a task automatically.

## Data changes in this release

- **Initiatives** gained a programme, a stage, a baseline, a forecast cost, dependencies and followers.
- **Tasks** gained an id, start and due dates, a priority, an estimate, subtasks, dependencies, comments, followers and an activity log.
- **Six sample tasks are assigned to Olivia Adams.** They come with sample comments, notifications and status updates.
- **Nordics market entry** is now At risk, matching its latest status update.
- **Older saved data still works.** Data saved in a browser before this release gains these fields automatically.
