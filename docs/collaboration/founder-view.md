# Collaboration on tasks and teamwork: founder and product view

Reviewer: SaaS founder on the advisory panel (two collaboration and work-management companies). Basis: web research (sources at the end), the newest build (9 Nov 2026, before release) and `docs/work-management.md`.

**Summary.** OrgCue has the nouns of collaboration (assignee, followers, @mentions, inbox, status updates, approvals, kudos) but few of the loops that make people come back. Work is assigned but never accepted. Comments are posted but never resolved. Load is shown, but you cannot act on it, and nothing reaches people outside the app. The market leaders win on the loops, not the nouns.

## 1. What the leaders do

| Theme | Pattern worth copying | Who |
| --- | --- | --- |
| Responsibility | One assignee for accountability, many collaborators who get notified. Collaborators do not see the task in My Tasks. | Asana |
| | Multiple assignees as an option you can switch on; Trello checklist items with their own owner and date. | ClickUp, monday.com, Trello |
| Load | A triage inbox with a rotating triage owner, which can be synced from on-call schedules. Business plan and above. | Linear |
| | Workload by person against capacity; reassign by dragging. | monday.com, Asana |
| | Out-of-office dates in workload, but cover is still manual; Jira routes by component lead. | Asana, Jira |
| Commitment | Cycles with automatic rollover of unfinished work. Practitioners track the rollover rate as the sign of over-commitment. | Linear |
| | Accept or decline buttons, a reason required to decline, and the assigner notified. These are rare in mainstream tools (Planfix, Oracle Agile). | Planfix, Oracle Agile |
| | Tasks from Teams chat and meeting notes (Loop task lists) land in Planner "Assigned to me"; Premium plans add goals and sprints. | Microsoft Planner, Loop |
| Comments and planning | Assigned comments that must be resolved, and the resolver is recorded. Time-stamped video Clips with transcripts. | ClickUp |
| | Resolve comments from the inbox (Notion); "Seen by" and reactions on updates (monday.com). | Notion, monday.com |
| | Automatic check-ins ("What did you work on?") rolled into a digest. | Basecamp |
| | A Pulse feed of project updates, with a daily or weekly digest by 7 am and audio playback. | Linear |
| Finishing | Approval tasks (Approve, Request changes, Reject) and milestones. | Asana |
| | A Definition of Done enforced by a workflow validator; an evidence-links field. | Jira |
| | Random celebration creatures and appreciation stickers. | Asana |
| Adoption | Notification bundling; "Work Can Wait" quiet hours with a catch-up summary; a "Pings and @mentions only" mode. | Basecamp |
| | Inbox snooze and reminders; a Priority inbox (2026). | Linear |

Height shut down in September 2025. Its AI-first task tool did not survive, a reminder that loops and distribution beat features.

## 2. OrgCue today: friction and missing loops

**My work** (`wk-my`)
- Good: date buckets and logged hours against the estimate.
- It lists only tasks where I am the assignee. There is no "Helping on", "Waiting on others" or "Delegated by me" view, so shared work disappears.
- There is no way to plan or commit to a week.
- The demo clock reads 16 Sept 2024, and the task panel says "Overdue by 256 days".

**Inbox**
- Four item types. The only actions are mark read and archive.
- You cannot reply, accept, snooze or approve inline.
- "Asked for a status update" opens the initiative page, but shows no due date for the update.
- Nothing leaves the app: there is no email, digest, Slack or Teams.

**Team activity** is a flat feed of six events, with no reactions and no recognition.

**Task panel**
- There is a single assignee drop-down. Yet the list shows two avatars ("ML JK"), and the panel says "Also assigned: Jonas Keller" as read-only text carried over from the project plan. Who is accountable is ambiguous, which is exactly the problem Asana's one-assignee rule avoids.
- Comments sit at the very bottom, below Fields, Time and Schedule.
- Comments are flat: no replies, reactions, resolving, attachments or assigned comments.
- The mention chips offer only six people (not Tom Weiss or Dianne Miles).
- "Mark complete" asks for nothing: no done criteria, no reviewer.
- Date inputs use US format (01/04/2024), while the list uses UK format (4 Jan).

**Board** has three columns (Not started, In progress, Done). There is no Blocked or In review column, even though "Blocked" is a preset filter.

**Workload**
- One flat capacity (6 h a week) for everyone.
- Overdue estimates are not rolled forward. Marta has 11 open tasks yet shows empty future weeks, so the most overloaded people look free.
- There is no Unassigned row and no time off.
- I found no way to reassign from the grid.
- Role capacity (`wk-capacity`, FTE per quarter) is not linked to task workload.

**Timesheets**: weekly submission and approvals work well.

**Automation**: six fixed rules with on/off switches. There is no rule builder, and time-based checks run only when you click "Run time-based checks now".

**Requests** are portfolio intake (scored ideas). They are not a team triage queue for small asks.

**Programmes and status updates**: well structured, with highlights, blockers and next steps, plus replies. There is no "seen by", no reactions and no reminder schedule. Initiatives do have gate criteria and approvals ("Gate: 0/4 criteria, 0/2 approvals"), so done criteria exist at the gate but not on tasks.

**Values in action** (`st-kudos`) has kudos with counts, but it sits in Strategy, cut off from task completion and team activity.

**Mobile (390 px)**: the My work tables are cut off after two columns.

## 3. Recommendations

★ marks the top 5 to build next.

### A. Sharing responsibility
- **Must ★: Owner plus collaborators.**
  - Replace "Also assigned" with one accountable Owner and named Collaborators, with an optional Reviewer.
  - Collaborators see the task under "Helping on" in My work, and hours can be split between people in workload.
  - Keeps Asana's clarity and meets ClickUp/monday demand for shared work.
- **Should: Hand over.**
  - Reassigning in-progress work asks for a hand-over note, and the new owner accepts it.
  - The activity log keeps the chain.
- **Should: "Waiting on others" and "Delegated by me" sections in My work.** Managers track what they handed out.

### B. Sharing load
- **Must ★: A workload view you can act on.**
  - Roll overdue estimates into this week, add an Unassigned row, and set capacity and time off per person.
  - Drag a task from a cell to another person, with a preview of their new load.
  - Today the view hides the real overload.
- **Must: Team triage queue.**
  - Ownerless tasks (from comments, requests, rules or chat) land in a team Triage list.
  - A weekly rotating triage owner clears it (Linear).
- **Should: Away and cover.**
  - Set away dates and a cover person.
  - Flag due dates that fall in the absence.
  - Route new assignments and mentions to the cover.

### C. Making commitment visible
- **Must ★: Accept, decline or propose a date.**
  - A new assignment starts as *Proposed*. The assignee accepts it, declines it with a reason, or counter-proposes a date, from the inbox or by email.
  - Accepted work is *Committed*.
  - Unanswered assignments are nudged after two working days.
  - Rare in mainstream tools, so a differentiator for governance buyers.
- **Should: "Plan my week" and say/do.**
  - On Monday, pick committed tasks against your capacity.
  - On Friday, see committed against done, with automatic rollover.
  - Report the rollover rate to leads as the over-commitment signal.
- **Should: Due-date history.**
  - Moving a committed date asks for a reason; "slipped twice" is flagged and feeds programme health.
- **Could: Meeting actions become tasks.** Actions in Decisions and actions, and in meeting notes, become owned tasks that need acceptance (Loop to Planner).

### D. Comments and planning
- **Must ★: Real threads.**
  - Replies, emoji reactions, resolve and reopen, attachments.
  - "Assign as action", where the resolver is recorded (ClickUp).
  - Mention anyone.
  - Move the discussion to a Discussion tab near the top of the panel.
  - Reuse it on status updates, risks and decisions.
- **Should: Automatic check-ins.**
  - Scheduled team questions ("What will you finish this week?") with a digest of the answers.
  - Replaces stand-ups and feeds weekly planning (Basecamp).
- **Should: Update requests with a due date, plus "Seen by" on updates.** Closes the request loop and shows leaders who read what.
- **Could: Video or voice clips in comments, with transcripts, and AI thread summaries.** Async walkthroughs for distributed teams.

### E. Finishing work
- **Must: Done criteria and review.**
  - A completion checklist on a task, with an optional reviewer.
  - Completing it moves the task to *In review*, where the reviewer chooses Approve or Request changes (Asana approvals, Jira's done validator).
  - Add In review and Blocked columns to the board.
- **Should: Task milestones that roll up.**
  - Milestone tasks appear on the initiative timeline.
  - They carry evidence links into gate criteria.
- **Should: Celebrate and recognise.**
  - A completion moment for milestones and initiatives, not every task.
  - A "Give kudos" button on completed work that feeds Values in action and Team activity.

### F. What makes it get used
- **Must ★: A notification engine that leaves the app.**
  - Settings per event, bundling, a daily "your day" email and a weekly digest, quiet hours with a catch-up summary, and snooze.
  - An actionable inbox (accept, reply, approve inline) and Slack/Teams delivery.
  - Without this, none of the loops above close.
- **Should: Nudges that escalate gently.** Unaccepted work, stale in-progress tasks and overdue updates go to the person first, and to their lead only after a second miss.
- **Should: Mobile web for three jobs.** Triage the inbox, update or complete a task, approve.
- **Should: Social proof.**
  - "Seen by", "4 of 6 updates in" on programmes, and an invite when you @mention a non-user (the viral loop).
- **Could: A custom rule builder with scheduled checks.** Today's six fixed rules will not stretch.

## 4. Top 5 to build next
1. **Notification engine and actionable inbox**: digests, email and Slack/Teams, snooze, inline actions.
2. **Accept, decline or propose a date on assignments.**
3. **Threaded comments**: replies, reactions, resolve, assigned comments.
4. **Owner plus collaborators**, with "Helping on" and "Waiting on others" in My work.
5. **A workload view you can act on**: overdue work rolled in, Unassigned row, time off and cover, drag to reassign.

Close behind: the triage queue, and done criteria with review.

## 5. Plan tiers
- **Free:** owner plus collaborators, threaded comments and reactions, the inbox, email digests and mobile web. Never gate the features that spread the product.
- **Team:** accept or decline, Plan my week and check-ins, Slack/Teams, the workload view, celebrations and kudos, saved views.
- **Business:** triage queues with rotation, capacity with time off and cover, done criteria and approvals, milestone sign-off, say/do and rollover reports, and the custom rule builder.
- **Enterprise:** multi-step approval chains, enforced done policies, an audit trail of commitments and approvals, admin notification policies, manager and cover from SCIM, and comment retention.

## Sources
- Asana: one assignee and collaborators: https://help.asana.com/s/article/assign-tasks-to-teammates, https://asana.com/resources/why-one-assignee
- Asana: approvals and milestones: https://help.asana.com/s/article/approvals, https://help.asana.com/s/article/different-types-of-tasks
- Asana: out of office: https://asana.com/resources/out-of-office-checklist, https://forum.asana.com/t/what-is-workload-without-knowing-your-teams-ooo-out-of-office-time/104178
- Asana: notifications and email: https://help.asana.com/s/article/email-notifications, https://asana.com/features/project-management/inbox
- Asana: celebrations: https://asana.com/inside-asana/new-celebrations
- Linear: triage: https://linear.app/docs/triage, https://linear.app/changelog/2023-10-12-triage-responsibility
- Linear: cycles: https://linear.app/docs/use-cycles
- Linear: Pulse and project updates: https://linear.app/docs/pulse, https://linear.app/docs/initiative-and-project-updates, https://linear.app/blog/how-we-run-projects-at-linear
- Linear: inbox, snooze and Priority inbox: https://linear.app/docs/snooze, https://linear.app/changelog/2026-09-03-priority-inbox
- ClickUp: https://help.clickup.com/hc/en-us/articles/15910033487639-Multiple-Assignees-FAQ, https://help.clickup.com/hc/en-us/articles/6311126397591-Assign-comments, https://help.clickup.com/hc/en-us/articles/6311242882967-Clip-screen-recordings
- monday.com: https://support.monday.com/hc/en-us/articles/360010166559-Resource-management-with-Workload, https://support.monday.com/hc/en-us/articles/115005900249
- Notion: https://www.notion.com/help/comments-mentions-and-reminders
- Basecamp: https://basecamp.com/features/automatic-check-ins, https://basecamp.com/features/hill-charts, https://signalvnoise.com/svn3/basecamp-3-work-can-wait, https://signalvnoise.com/svn3/new-in-basecamp-get-notified-when-someone-adds-a-to-do/
- Trello: https://support.atlassian.com/trello/docs/how-to-use-advanced-checklists-to-set-due-dates/, https://help.trello.com/article/799-watching-cards-lists-and-boards
- Jira: https://www.atlassian.com/blog/jira-software/8-steps-to-a-definition-of-done-in-jira, https://support.atlassian.com/jira/kb/manage-components-default-assignee-jira-software/
- Microsoft Planner and Loop: https://support.microsoft.com/office/manage-your-tasks-from-loop-task-lists-and-collaborative-notes-in-planner-and-to-do-94383070-5f2f-4954-8607-7b7ebff5d43e, https://support.microsoft.com/en-us/office/6cdba2aa-da06-4e08-be4c-baaa4fda17ba
- Accept and decline precedents: https://planfix.com/help/The_Accept_and_Decline_buttons, https://docs.oracle.com/cd/E83928_04/otn/pdf/user/html_agaac/output/chapter_5.htm
- Height shutdown: https://alternativeto.net/news/2025/3/height-project-management-tool-to-shut-down-by-september-2025

Unverified: whether Microsoft Planner has native task approvals (none found), and monday.com's plan gating for Workload (sources conflict).
