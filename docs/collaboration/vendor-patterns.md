# Collaboration patterns across strategy, portfolio and work platforms

Author: market analyst, OrgCue advisory panel. Research date: 9 November 2026.

Method: web search only. Direct fetches of vendor sites are blocked by the session's network policy, so every claim comes from search results that quote official help centres, changelogs, vendor blogs, community forums and a few third-party guides. Background on the vendors is in `/home/user/Orgcue.com/docs/vendor-landscape.md`.

Conventions:
- **unverified** means only a weak, single or third-party source supported the claim, or it comes from general product knowledge that no search in this session confirmed.
- No prices are given.
- Height shut down on 24 September 2025 ([alternativeto](https://alternativeto.net/news/2025/3/height-project-management-tool-to-shut-down-by-september-2025)), so it is only mentioned for history. Microsoft Viva Goals was retired on 31 December 2025. Its patterns are cited only where they show something Microsoft did.

---

## 1. Summary

1. **Ownership is converging on "one accountable owner plus a ring of contributors and followers".**
   - Task tools split on the assignee question:
     - Asana, Linear and Jira keep one assignee on purpose.
     - ClickUp, monday, Wrike, Smartsheet, Planner, Notion and Basecamp allow many.
   - Goal tools all add roles around a single owner:
     - WorkBoard: owner, co-owner, updater.
     - Perdoo: one lead plus contributors.
     - Atlassian: owner, contributors, followers.
     - Cascade: owner plus collaborators.
   - Nobody ships a native RACI field. RACI exists only as templates.
2. **Load-sharing is mature in work and PPM tools and absent in strategy tools.**
   - Workload views with drag-to-reassign are table stakes: Asana, ClickUp, Wrike, monday, Smartsheet and Planview.
   - Rule-based assignment is now native in most work tools:
     - round robin in Asana, monday and Jira;
     - "balanced workload" in Jira automation;
     - a triage rotation in Linear.
   - Absence handling is still weak. Few tools reroute work when someone is away; monday's round robin, which skips unavailable people, is the exception. Most users rely on add-ons or AI-agent hacks.
3. **Explicit commitment is the biggest white space.**
   - Almost no work tool lets an assignee accept or decline a task. Linear's team-level Triage Accept/Decline and Profit.co's task accept/reject are the exceptions. Asana users have requested it for years.
   - Commitment shows up in other forms instead:
     - committed vs stretch targets: WorkBoard, and Atlassian goal scoring;
     - cycle and sprint commitment against completion: Jira's velocity chart and Linear's cycle graph;
     - Basecamp's Hill Charts, which separate "still figuring out" from "making it happen";
     - meeting action items: WorkBoard, Fellow, Notion and Microsoft Collaborative notes;
     - mined email promises: Microsoft Viva Briefing "commitments", now paused.
4. **Comments are table stakes and resolution is not.**
   - Threaded comments with @mentions on tasks, goals and status updates are everywhere.
   - Resolving threads is uneven:
     - Linear: resolve, plus an AI summary of the resolved thread.
     - Notion and Confluence: resolve inline comments.
     - ClickUp: assigned comments that must be resolved.
     - Most goal tools: neither.
   - Collaborative planning is the thinnest area:
     - drafts: Perdoo;
     - approval workflows: Quantive, now folded into WorkBoard;
     - an AI alignment cycle with accept, reject or discuss: WorkBoard;
     - catchball: i-nexus, mostly in marketing claims;
     - the Shape Up betting table: a method, not a feature.
5. **Completion and milestones.**
   - Milestones as a task type, automatic roll-up and status updates are table stakes.
   - Real differentiators are rare:
     - completion criteria and evidence enforced at the gate: Planview and other PPM tools; Jira only through validators and apps;
     - approvals that behave correctly: Asana's "Request changes" counts as complete and unblocks dependants, a known complaint;
     - closure with learnings and an outcome review: Atlassian's Learnings tab, Planview's lessons-learned template.
   - Celebration is cheap and loved but only Asana does it well natively (celebration creatures, appreciations).

**Implication for OrgCue.** A text scan of the current build finds approvals, check-ins with confidence, workload, a decision register, a retrospective and a closure checklist. It finds no co-owners or contributors, RACI roles, reactions, triage queue, out-of-office cover, accept/decline, committed-vs-stretch targets, meeting action items, catchball or drafting flow, definition of done or celebrations. This scan is indicative only: it counts strings and does not inspect the UI. The combined strategy, portfolio and work product can win on the joins nobody else owns. Examples: a KR shared across teams with accepted contributions; a meeting that turns decisions and action items into owned, dated work; a milestone sign-off with evidence that rolls up into the KR's confidence.

---

## 2. The five themes

### 2.1 Sharing responsibility

**Patterns**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Single assignee by design | One assignee per task. Copies or subtasks are the answer for shared work. Asana argues that without a single owner "accountability is lost". | Asana | [Why one assignee?](https://asana.com/resources/why-one-assignee); [assign copies](https://asana.com/inside-asana/assign-copies-of-a-task.md) |
| Single assignee plus agent delegation | Issues have one assignee. An agent can be delegated the work while the human stays the owner. The assignee is always subscribed. | Linear | [Assign and delegate](https://linear.app/docs/assigning-issues); [changelog](https://linear.app/changelog/2025-08-14-product-intelligence-technology-preview) |
| Single assignee plus a custom multi-user field | Jira allows one assignee. Admins add a "Collaborators" multi-user picker, but those people do not appear in "assigned to me". | Jira | [Atlassian Community](https://community.atlassian.com/t5/Jira-questions/How-to-assign-issues-to-multiple-users/qaq-p/1319114) |
| Multiple assignees (opt-in) | The Multiple Assignees ClickApp is enabled by an admin. Tasks can go to a person, several people or a Team. | ClickUp | [Multiple Assignees](https://help.clickup.com/hc/en-us/articles/6309029762583-Multiple-Assignees); [Assign tasks](https://help.clickup.com/hc/en-us/articles/6309784302359-Assign-tasks) |
| Multiple assignees, any one completes | Up to 11 assignees. The first person to complete closes the task for all. Premium plans reportedly track each person's completion (staff forum reply, unverified). | Microsoft Planner | [Assign people to tasks](https://support.microsoft.com/en-us/office/assign-people-to-tasks-3a1b23f0-4dce-43a2-ae0f-b4c7bc1164b4); [Tech Community](https://techcommunity.microsoft.com/t5/planner-events/the-new-microsoft-planner-what-s-new-and-what-s-coming-next-ama/ec-p/4247522) |
| Multiple assignees, any one completes | Any assignee can complete the task. Users have asked for years for "each assignee must complete". | Wrike | [Wrike community](https://help.wrike.com/hc/fr/community/posts/115000623005-Each-assignee-must-complete-the-task) |
| Multi-contact column | "Allow multiple contacts per cell" on a Contact List column (Multi-Assign). | Smartsheet | [Smartsheet help](https://help.smartsheet.com/articles/518335); [dev blog](https://developers.smartsheet.com/blog/telescope-product-update) |
| Collaborators and followers | The task creator and assignee are auto-added as collaborators, who are notified of changes. "Leave task" opts out. | Asana | [Understanding tasks](https://help.asana.com/s/article/understanding-tasks) |
| Card members auto-watch | Joining a card makes you a watcher. Checklist items can have their own assignee and due date. | Trello | [Watch a card](https://support.atlassian.com/trello/docs/watching-cards-lists-and-boards/) |
| Goal owner, contributors, followers | The owner keeps the details and the monthly update accurate. Contributors work on it. Followers get updates; the docs pitch more followers as meaning fewer status pings. | Atlassian Goals and Projects | [Follow goals](https://support.atlassian.com/platform-experiences/docs/follow-goals-projects-teams-and-topics); [Atlas 101](https://intercom.help/atlas-by-atlassian/en/articles/5209762-creating-updating-in-atlas-101) |
| KR owner, co-owners, updater | One owner accountable for the outcome. Any number of co-owners, who see the KR as if they own it. A separate "updater" (data provider) enters progress. | WorkBoard | [Key result roles](https://help.workboard.com/en/articles/13341159-key-result-roles-owner-co-owner-data-provider) |
| One lead plus contributors | One person can lead a Result. Contributors can add initiatives and update progress. A team owns the objective. A cross-team OKR uses one lead plus contributors. | Perdoo | [Can more than one user lead?](https://support.perdoo.com/en/articles/5630755-can-more-than-one-user-lead-a-result); [What is a contributor](https://support.perdoo.com/en/articles/5103620-what-is-a-contributor); [OKR owned by 2+ teams](https://support.perdoo.com/en/articles/5991235-what-is-the-best-practice-for-an-okr-that-is-owned-by-2-or-more-teams) |
| Owner plus collaborators, with plan roles | The objective owner defaults to its creator. Collaborators work on it. Plan-level roles (Plan Admin, Update Only, View) gate who can edit success criteria. | Cascade | [Add objectives](https://support.cascade.app/add-objectives-to-the-focus-areas); [User roles](https://support.cascade.app/user-roles-in-cascade) |
| Owner plus editor | The owner is in charge. An editor can change everything, but completion is not credited to them. | Betterworks | [Goals and milestones](https://support.betterworks.com/hc/en-us/articles/4412049001741) |
| Multiple owners plus a check-in owner | Organisation-level OKRs could have several owners, with one named "check-in owner" responsible for updates. Retired product. | Microsoft Viva Goals | [Configuring OKRs](https://learn.microsoft.com/en-us/viva/goals/configuring-okrs) |
| Contribution request | A team requests another team's contribution to a goal. That team accepts or declines, with comments. | Workpath | [Request a contribution](https://workpath.zendesk.com/hc/en-us/articles/4405059595410-Request-a-Contribution-for-a-Goal) |
| RACI and DACI as templates | RACI board templates put roles as columns and people in cells. DACI uses a page template with Driver, Approver, Contributors, Informed. | monday, Confluence, many others | [monday RACI](https://monday.com/blog/project-management/raci-matrix-with-examples/); [Confluence DACI](https://www.atlassian.com/software/confluence/templates/decision) |

**Table stakes**
- An owner field on every object.
- Followers or watchers with notification control.
- Some way to involve several people: multiple assignees, subtasks or copies.
- Ownership can be reassigned by editors.

**Differentiators**
- Separating roles on a goal or KR: accountable owner, co-owners, updater or data provider (WorkBoard), contributor (Perdoo, Atlassian).
- Cross-team contribution handled as a request the other team accepts (Workpath; WorkBoard's alignment cycle).
- Delegating to an AI agent while the human keeps ownership (Linear).
- Per-assignee completion on a shared task (Planner Premium, unverified).
- Native RACI on tasks or deliverables: no mainstream vendor has it, so it is open ground.

**Pitfalls users report**
- "Shared = nobody's" when multiple assignees are on. In Planner and Wrike the first person to tick "done" closes the task for everyone.
- Single-assignee tools force duplicate tasks. The Asana and Jira forums have long-running multiple-assignee requests (e.g. [Asana forum](https://forum.asana.com/t/assign-multiple-assignees-on-one-task/1176.md?page=39)).
- Jira's "Collaborators" workaround hides work from "assigned to me".
- Perdoo will not let one KR align to several objectives because it would "ruin the cascade" ([Profit.co comparison](https://www.profit.co/blog/perdoo-alternative), a competitor source).
- Atlassian goal followers report confusion about who gets update emails ([community](https://community.atlassian.com/t5/Atlas-Group-questions/How-do-I-set-the-remainder-notification-for-Atlas/qaq-p/2918899)).

### 2.2 Sharing load

**Patterns**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Workload view with effort and capacity | Shows effort per person against capacity, flags overload and supports drag-to-reassign. Effort comes from a number custom field. | Asana | [Asana forum](https://forum.asana.com/t/were-excited-to-announce-that-workload-now-has-effort-and-capacity/56622) |
| Workload with time estimates or % of capacity | Per-person capacity per day. Drag tasks between people to rebalance. | ClickUp | [Measure capacity](https://help.clickup.com/hc/en-us/articles/30799838221335-Measure-availability-or-capacity-in-Workload-view); [ClickUp Learn](https://clickup.com/learn/topic/operations/tools/features/workload-views/) |
| Workload charts with a job-role backlog | Blue means within capacity and red means over. Tasks or whole projects can be dragged between users. Unassigned work sits in a "Backlog Box" by job role until it is staffed. | Wrike | [Workload charts](https://help.wrike.com/hc/en-us/articles/360010835433); [Wrike blog](https://www.wrike.com/blog/introducing-workload-management-in-wrike-monitor-balance-optimize/) |
| People view and Capacity view | People view shows the distribution of tasks and supports quick reallocation. Capacity view (Plan 3) is scheduled for GA from mid-October 2026; rollout not confirmed. | Microsoft Planner | [Premium capabilities](https://support.microsoft.com/Planner/teams/advanced-capabilities-with-premium-plans-in-planner); [MC1474110](https://mc.merill.net/message/MC1474110) |
| Away status shown in workload | The profile is set to "Away" with dates. The return date shows when someone mentions or assigns you. OOO dates appear in workload and capacity plans, but only as a warning icon on overlapping tasks. | Asana | [OOO checklist](https://asana.com/resources/out-of-office-checklist); [forum](https://forum.asana.com/t/what-is-workload-without-knowing-your-teams-ooo-out-of-office-time/104178/15) |
| Calendars with planned absences | Organisation, group and user calendars hold absences. The Resource Load module shows load and availability. "Replace Resource" swaps out template placeholders. | Planview AdaptiveWork | [Best practices](https://success.planview.com/Planview_Clarizen/Capacity_Planning_and_Resource_Management/Resource_Management_Best_Practices) |
| Skills-based matching | Match people to tasks by skills, location or qualifications. Spot unassigned but suitable people. | Smartsheet Resource Management | [Smartsheet RM](https://www.smartsheet.com/platform/resource-management) |
| Round robin that respects availability | Rotates through members and only assigns to those marked available. Cannot assign whole teams. | monday.com | [Round robin automations](https://support.monday.com/hc/en-us/articles/29191074306706-Round-robin-automations) |
| Round robin in Rules | "Set assignee" can rotate through an ordered list. Native, but no least-loaded option. | Asana | [Asana forum announcement](https://forum.asana.com/t/new-in-rules-round-robin-assignment-is-now-live/1153580) |
| Balanced workload, round robin, random | The automation "Assign issue" action. It does not skip people on leave; marketplace apps fill the gap. | Jira / JSM | [Smart assign](https://confluence.atlassian.com/automation074/smart-assign-jira-issues-load-balancing-round-robin-and-more-1141481228.html); [community](https://community.atlassian.com/forums/Jira-Service-Management/Assign-issues-to-users-of-a-group-round-robin-skip-user-based-on/qaq-p/2316315) |
| Team triage inbox with rotation | Work from outside the team lands in Triage. A responsible person is notified or auto-assigned and can rotate weekly or follow a PagerDuty, Opsgenie, Rootly or incident.io schedule. Triage rules auto-route. Responsibility needs Business or Enterprise. | Linear | [Triage](https://linear.app/docs/triage); [Triage responsibility](https://linear.app/changelog/2023-10-12-triage-responsibility) |
| Service queues | Queues show work but do not distribute it; assignment is done by automation. | Jira Service Management | [community](https://community.atlassian.com/forums/Jira-Service-Management/Ticket-Assignment-Queue/qaq-p/3192157) |
| Agent-driven reassignment | Users build AI Studio rules that reassign tasks when the assignee is marked out of office. Community-built. | Asana | [forum](https://forum.asana.com/t/using-ai-studio-to-reassign-work-when-out-of-office/1103616) |

**Table stakes**
- A workload view by person.
- Drag-to-reassign.
- Effort as hours, points or task count.
- An overload colour.
- Intake forms into a queue.
- Rule-based auto-assignment to a fixed person.

**Differentiators**
- Availability-aware assignment, where round robin skips absent people (monday).
- A team triage owner on rotation, linked to on-call (Linear).
- Unstaffed demand held by role (Wrike Backlog Box; PPM role-based capacity).
- Skills matching (Smartsheet RM).
- A cross-plan capacity view with absences (Planview, Asana universal workload).
- No vendor documents an automatic "suggest who should take this" reallocation. The claims are generic AI marketing (Planview).

**Pitfalls users report**
- Absence is not joined up. Asana users say PMs must cross-reference PTO outside the tool. Calendar OOO does not sync to Away status. Jira automation cannot exclude people on leave without editing the rule ([Asana forum](https://forum.asana.com/t/holiday-leave-block-off-time-either-as-pto-holiday-or-all-day-task/20302?page=8); [Atlassian Community](https://community.atlassian.com/forums/Jira-Service-Management/Assign-issues-to-users-of-a-group-round-robin-skip-user-based-on/qaq-p/2316315)).
- Effort models are crude:
  - Asana spreads effort evenly across dates, rounds 30 minutes up to 1 hour and ignores subtask effort ([forum](https://forum.asana.com/t/workload-view-does-not-accurately-show-hours-per-week/554597)).
  - ClickUp counts the full estimate, not the time remaining ([feedback](https://feedback.clickup.com/feature-requests/p/dynamic-workload-calculation-based-on-time-remaining-net-effort)).
- Scope confusion. Wrike tallies effort account-wide, so a filtered chart can understate load ([Wrike help](https://help.wrike.com/hc/en-us/articles/360010835433)).
- Planner's People view works within one plan only, and portfolio managers ask for a cross-plan view ([Tech Community](https://techcommunity.microsoft.com/discussions/planner/improve-resource-capacity-and-baseline-governance-in-planner-premium/4536002)).

### 2.3 Commitment

**Patterns**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Accept or decline incoming work (team level) | A Triage item can be accepted (moves to the default status), declined (Canceled, with a comment back to the requester), marked duplicate (merged) or snoozed. | Linear | [Triage](https://linear.app/docs/triage) |
| Accept or reject task assignment | The assignee accepts or rejects a requested task. Can be switched off per assignment. | Profit.co (also Planfix, Hospitable) | [Profit.co](https://www.profit.co/answers/tasks/how-to-enable-accept-reject-task-options-in-profit-co/); [Planfix](https://planfix.com/help/The_Accept_and_Decline_buttons) |
| No accept or decline | A long-standing feature request. Staff point to the Approval task type, which users say is not the same thing. | Asana | [Asana forum](https://forum.asana.com/t/accept-or-reject-tasks-when-assigned-feature-request/254582) |
| Committed vs aspirational OKRs | Committed means delivered at 1.0, pass or fail. Aspirational means about 0.7 on average with high variance. Mixing the two is trap #1 in Google's playbook. | Google method | [Google OKR playbook (PDF copy)](https://awe-hnu.github.io/lectures/IPS/23WT/OKRs/assets/googles-OKR-playbook.pdf); [whatmatters](https://www.whatmatters.com/faqs/committed-aspirational-okrs-examples-difference) |
| Committed target plus stretch target on a KR | When stretch targets are enabled, each KR carries "Committed Target" and "Stretch Target". The committed target drives progress and RAG. Enabling it needs a CSM. | WorkBoard | [Committed key results](https://help.workboard.com/en/articles/13341164-committed-key-results); [advanced KR options](https://help.workboard.com/en/articles/13341175-advanced-key-results-options) |
| 0.0–1.0 goal scoring | The owner scores in each monthly update. 0.0–0.3 is off track, 0.4–0.6 at risk, 0.7–1.0 on track. Committed objectives score 1 when achieved. | Atlassian Goals | [Score a goal](https://support.atlassian.com/focus/docs/score-a-goal/); [goal scoring](https://intercom.help/atlas-by-atlassian/en/articles/6216876-track-objectives-and-key-results-with-goal-scoring) |
| Sprint commitment vs completed | The velocity chart shows committed points at sprint start against completed. Say/do has to be worked out by hand or with apps that track initial vs final commitment and scope change. | Jira | [Velocity chart](https://support.atlassian.com/jira-software-cloud/docs/view-and-understand-the-velocity-chart/); [say/do report (app)](https://community.atlassian.com/forums/App-Central-articles/Say-do-ratio-report-Track-sprint-commitments-vs-delivery-in-Jira/ba-p/3142810) |
| Cycle graph and capacity | Scope line against completed line, updated hourly, with scope added or removed shown. Capacity is based on the last three cycles. Unfinished work rolls over (third-party claim). | Linear | [Cycle graph](https://linear.app/docs/cycle-graph); [changelog](https://linear.app/changelog/2022-09-22-cycles-and-graph-improvements) |
| Hill Charts | Each scope is a dot on a hill. Uphill means figuring it out (unknowns), downhill means making it happen. Stuck dots show where to help. Commentators advise not committing to dates while work is uphill. | Basecamp / Shape Up | [Hill Charts](https://basecamp.com/hill-charts); [Shape Up ch. 12](https://basecamp.com/shapeup/3.4-chapter-12); [Elezea](https://elezea.com/2018/04/tracking-development-uncertainty-with-hill-charts/) |
| Betting table and fixed appetite | Senior people bet on shaped pitches for the next six-week cycle. There is no backlog. A circuit breaker cancels work that does not ship rather than extending it. | Shape Up (Basecamp method) | [Shape Up ch. 8](https://basecamp.com/shapeup/2.2-chapter-08); [glossary](https://basecamp.com/shapeup/4.5-appendix-06) |
| Meeting takeaways become action items | Topics and takeaways convert to action items (there is quick-add syntax). "Meet Now" reloads the last meeting's action items. | WorkBoard | [Meetings](https://help.workboard.com/en/articles/13341303-get-started-with-meetings); [Workstreams](https://www.workboard.com/product/workstreams-actionitems.php) |
| Carry-forward of action items | Incomplete action items roll into the next meeting in a series. Sync with Jira and Asana. | Fellow | [Fellow action items](https://fellow.co/features/action-items) |
| AI meeting notes with action items | A summary and action items come from the transcript, and owners can be tagged. Turning them into database tasks needs a Custom Agent template. | Notion | [AI Meeting Notes guide](https://www.notion.com/en-gb/help/guides/preserve-perfect-meeting-memory-with-ai-meeting-notes); [Meeting Notes Task Creator](https://www.notion.com/custom-agent-templates/meetings-to-tasks) |
| Collaborative notes with follow-up tasks | Teams meeting notes (Loop) have Agenda, Notes and Follow-up tasks. The task list syncs to a Planner plan and To Do. Moving a task to another bucket breaks the sync. | Microsoft Teams, Loop, Planner | [Microsoft support](https://support.microsoft.com/en-us/office/add-a-task-list-to-meeting-notes-94383070-5f2f-4954-8607-7b7ebff5d43e); [Office365ITPros](https://office365itpros.com/2023/05/17/loop-task-list-planner/) |
| Promises mined from email | The Briefing email listed "commitments" (things you promised by email), requests and follow-ups. Now paused, and the related add-in sections are being retired. | Microsoft Viva Insights | [Briefing overview](https://learn.microsoft.com/en-us/Briefing/be-overview); [pause](https://learn.microsoft.com/viva/insights/personal/reference/briefing-pause) |
| Weekly priorities with carry-over rate | Weekly check-in priorities can be completed, carried over or removed. The dashboard reports % complete and % carried over. | 15Five | [Priorities dashboard](https://success.15five.com/hc/en-us/articles/50988309138843); [Priorities in check-ins](https://success.15five.com/hc/en-us/articles/50988983080731) |
| Plan sign-off and approvals | Approval tasks offer Approve, Request changes or Reject (Asana). Files get Approve or Changes required (Wrike). Approval requests pause a workflow (Smartsheet). The Approvals app handles general requests (Teams). | Asana, Wrike, Smartsheet, Microsoft | [Asana approvals](https://help.asana.com/s/article/approvals); [Wrike](https://help.wrike.com/hc/en-us/articles/210325065); [Smartsheet](https://help.smartsheet.com/learning-track/smartsheet-intermediate/approval-requests); [Teams Approvals](https://support.microsoft.com/en-us/teams/free/create-an-approval) |

On "commitments" in Atlassian Goals and Microsoft: no search found a feature called "commitments" in Atlassian Goals or in Planner Goals. Microsoft's only "commitments" feature was the Viva Briefing email above. Planner Goals (Plan 1+, up to 10 goals per plan, linked to tasks) has no commitment semantics ([Neowin](https://www.neowin.net/news/the-new-microsoft-planners-goals-feature-will-allow-you-to-set-and-track-goals-for-plans/), secondary source).

**Table stakes**
- Due dates.
- Sprint or cycle scope with committed-vs-completed reporting (dev tools).
- Approval steps.
- Status plus a target date on goals and projects.

**Differentiators**
- Committed vs stretch targets on the same KR (WorkBoard).
- Scoring that treats committed and aspirational goals differently (Atlassian).
- Accept or decline of incoming work with a reason fed back to the requester (Linear Triage).
- An uncertainty signal separate from % complete (Hill Charts).
- Meeting action items that carry forward until done (Fellow, WorkBoard).
- Carry-over rate as a reliability metric (15Five).
- Commitments mined from conversations (Viva Briefing, now paused, so the field is open).

**Pitfalls users report**
- **Approvals that lie.**
  - In Asana, "Request changes" and "Reject" mark the approval complete and unblock dependants ([forum](https://forum.asana.com/t/requesting-changes-on-an-approval-task-incorrectly-unblocks-a-dependent-task/429384)).
  - In Smartsheet, one approver can approve for everyone ([community](https://community.smartsheet.com/discussions/tagged/approval-request/p4)).
  - In Wrike, every approver must answer before the flow continues ([community](https://help.wrike.com/hc/fr/community/posts/9838323666199-File-Approval-Tweaks)).
- **Velocity charts confuse teams.** Completed can exceed committed because scope added mid-sprint counts. Committed shows blank when estimates were missing at sprint start ([community](https://community.atlassian.com/forums/Jira-questions/Velocity-report-Why-completed-bar-is-higher-than-commited-bar/qaq-p/1766333)).
- **Mixing committed and aspirational goals** breeds defensiveness and sandbagging (Google playbook).
- **Meeting-to-task sync is brittle.**
  - Loop tasks stop syncing when moved ([Office365ITPros](https://office365itpros.com/2023/05/17/loop-task-list-planner/)).
  - Notion needs agent templates to create real tasks.
  - Jira users ask for action items to carry into the next recurring meeting ([LOOM-649](https://jira.atlassian.com/browse/LOOM-649)).

### 2.4 Comments and planning

**Patterns: conversation**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Comments on many object types | Comments and replies on tasks, goals, messages, status updates and table items. Likes on comments. Appreciations. Comments on status updates since 2016, with "create task from the conversation". | Asana | [Task comments](https://help.asana.com/s/article/task-comments-and-attachments); [status update comments](https://asana.com/inside-asana/status-updates-have-comments) |
| Resolve threads with an AI summary | Resolving the root collapses the thread. A summary is generated when a thread is resolved without a closing comment (Business/Enterprise). Emoji reactions. | Linear | [Resolve comments](https://linear.app/changelog/2023-11-08-resolve-comments); [Comments and reactions](https://linear.app/docs/comment-on-issues) |
| Assigned comments | A comment assigned to a person shows as an unresolved item until it is resolved. Works in tasks and Docs (select text, then assigned comment). Threaded replies and reactions. | ClickUp | [Assign comments](https://help.clickup.com/hc/en-us/articles/6311126397591-Assign-comments); [Intro to comments](https://help.clickup.com/hc/en-us/articles/6309646134295-Intro-to-comments) |
| Inline and page comments with resolve and reopen | Select text to comment. Resolve with the tick. Filter the sidebar to resolved comments and reopen them. Reactions. Available through the API and MCP. | Notion | [Comments, mentions and reactions](https://www.notion.com/help/comments-mentions-and-reminders); [MCP reference](https://developers.notion.com/guides/mcp/tools-comments-reference) |
| Comments on updates, goals, dashboards and reports | Anyone can comment on updates. The owner is notified. Slack alerts on updates, comments and mentions. | Cascade | [Post updates and comments](https://support.cascade.app/post-updates-comments-and-collaborate); [Slack](https://support.cascade.app/integrate-slack-with-cascade) |
| Notes on each OKR element, plus manager comments on check-ins | Activity feed notes on objectives, KRs, initiatives and KPIs. Managers comment on direct reports' check-ins. | Perdoo | [Commenting on OKRs](https://support.perdoo.com/articles/1666210-commenting-on-okrs); [check-ins update](https://www.perdoo.com/resources/upgrade-to-11s-and-check-ins/) |
| Comment limits | Goal comments are capped at 2,048 characters and editable only within 24 hours. | Betterworks | [Betterworks support](https://support.betterworks.com/hc/en-us/articles/4412049001741) |
| Video updates | Record a Loom from the Jira issue view or Confluence toolbar. Rovo can draft the issue description from the transcript. Atlassian's internal trial of Loom in place of status meetings claimed 5,000 hours saved (vendor-reported). | Atlassian (Loom) | [Use Loom in Jira](https://support.atlassian.com/jira-software-cloud/docs/use-loom-in-jira-cloud/); [Loom with Jira and Confluence](https://support.atlassian.com/loom/docs/use-loom-with-jira-and-confluence/); [weekly updates play](https://www.atlassian.com/team-playbook/plays/weekly-project-updates) |

**Patterns: async updates and planning**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Scheduled async updates | Project owners get a weekly reminder and goal owners a monthly one. Followers receive digests. Statuses: On track, At risk, Off track, Pending, Paused, Completed. | Atlassian Goals and Projects | [Communicate goals](https://community.atlassian.com/learning/lesson/communicate-goals-across-atlassian-products); [goal status](https://support.atlassian.com/platform-experiences/docs/use-goal-status-to-track-objectives-and-key-results) |
| Update reminders and stale health | A health value (On track, At risk, Off track) on each update. A missed scheduled update shows on the health icon. | Linear | [Initiative and project updates](https://linear.app/docs/initiative-and-project-updates) |
| AI-drafted status | "Draft update with AI" on projects, portfolios and goals. Follows the structure of the previous update. | Asana Smart status | [Smart status](https://help.asana.com/s/article/smart-status) |
| Automatic check-ins | Recurring questions (daily, weekly, monthly) to chosen people at a chosen time, e.g. "What did you work on today?" Replaces status meetings. | Basecamp | [Automatic check-ins](https://basecamp.com/features/automatic-check-ins) |
| Draft OKRs | A Draft toggle excludes the OKR from progress roll-ups. Visibility can be limited to the team. Future timeframes default to Draft. No approval step is documented. | Perdoo | [Draft OKRs](https://support.perdoo.com/en/articles/2754249-draft-okrs) |
| OKR approval workflow | Draft, In review, Approved. The owner picks reviewers, who approve or decline (declined OKRs return to Draft). | Quantive (now WorkBoard) | [Approval workflow](https://help.quantive.com/en/articles/3125479-approval-workflow) |
| AI alignment cycle | An admin starts it after drafting. Managers see AI-suggested alignments and can accept, reject or request a discussion. | WorkBoard | [AI alignment cycle](https://help.workboard.com/en/articles/13341216-workboard-ai-alignment-cycle-enhancing-okr-collaboration) |
| Catchball and X-matrix | A digitised X-matrix, catchball for top-down and bottom-up negotiation, and bowling charts. The negotiation mechanics are not documented publicly (marketing only, unverified). | i-nexus | [i-nexus Hoshin](https://i-nexus.com/hoshin-kanri-software/); [catchball blog](https://blog.i-nexus.com/catchball-process-and-goal-communication) |
| Betting table | Pitches are bet on in cool-down. Unchosen pitches are discarded, not backlogged. | Shape Up | [Shape Up ch. 8](https://basecamp.com/shapeup/2.2-chapter-08) |
| Planning poker | No native Atlassian feature was found. Many Marketplace apps offer private votes, simultaneous reveal, async sessions and write-back to Story Points. | Jira apps | [EstiMate](https://marketplace.atlassian.com/apps/1238269/estimate); [Sync Poker](https://marketplace.atlassian.com/apps/1238131/sync-poker-planning-estimation) |
| Decision records | A `/decision` element in pages plus a Decision report macro that aggregates decisions across spaces (Cloud only). DACI template with status, impact, approver and outcome. Apps add DACI and ADR statuses (proposed, accepted, superseded). | Confluence | [Decision report macro](https://support.atlassian.com/confluence-cloud/docs/insert-the-decision-report-macro); [DACI template](https://www.atlassian.com/software/confluence/templates/decision); [Decision Log app](https://marketplace.atlassian.com/apps/2435494237/decision-log-for-confluence) |

Notion handles decisions only through templates and databases (general knowledge, unverified). Range is cited only in third-party roundups for async check-ins combined with team objectives.

**Table stakes**
- Threaded comments with @mentions on tasks.
- Comments on status updates.
- Emoji reactions or likes.
- Notifications inbox.
- Slack and Teams relay.
- Scheduled update reminders.
- Status with three states (on track, at risk, off track).

**Differentiators**
- Resolve and reopen on any thread, with an AI summary of the resolution (Linear).
- Assigned comments that act as lightweight action items (ClickUp).
- Inline comments inside planning documents (Notion, Confluence).
- Comments on goals, KRs, check-ins, dashboards and reports (Cascade, Perdoo, WorkBoard).
- A decision register that aggregates across pages (Confluence).
- Drafts excluded from roll-ups (Perdoo).
- A review and approval workflow for OKRs (Quantive, now WorkBoard).
- AI alignment suggestions (WorkBoard).
- Native video updates (Atlassian Loom).
- AI-drafted status (Asana, Linear).
- Catchball as a real negotiation workflow (proposal, counter-proposal, agreed target): nobody shows this publicly, so it is open ground.

**Pitfalls users report**
- Comments scattered across objects with no "what changed since I last looked" view.
- Goal comments arrived late in Asana and only with appreciations, not likes ([forum](https://forum.asana.com/t/add-ability-to-add-comments-to-goals/97486)).
- Confluence decisions are hard to list natively, and decisions on unpublished pages do not appear in the report ([community](https://community.atlassian.com/t5/Confluence-questions/How-can-I-get-a-list-of-decision-the-same-way-I-get-a-list-of/qaq-p/1048873)).
- Async check-ins decay when no one reads them ([G2 Learn](https://learn.g2.com/asynchronous-standup-meetings)).
- ClickUp cannot add a comment while resolving an assigned comment ([feedback](https://feedback.clickup.com/feature-requests/p/commenting-when-resolving-assigned-comments)).
- Betterworks lets you edit comments only within 24 hours.

### 2.5 Work complete and milestones

**Patterns**

| Pattern | How it works | Vendor(s) | Source |
|---|---|---|---|
| Milestones and approvals as task types | Milestone and approval task types. Goal progress from projects counts tasks, milestones and approvals. | Asana | [Different types of tasks](https://help.asana.com/s/article/different-types-of-tasks); [goal progress](https://help.asana.com/s/article/progress-status-and-connecting-work-to-goals) |
| Milestone as a task type | Task Type set to Milestone. Shown as a diamond in Gantt. Views can be filtered by task type. | ClickUp | [Milestones](https://help.clickup.com/hc/en-us/articles/6304458574615-Milestones) |
| Milestone in the timeline column, plus baseline | "Set as milestone" in the Timeline column draws a diamond. Gantt baseline snapshots planned dates. Users report the option is missing in the new picker. | monday.com | [Gantt milestones](https://support.monday.com/hc/en-us/articles/360015643840); [Gantt baseline](https://support.monday.com/hc/en-us/articles/360020978159); [community](https://community.monday.com/t/new-timeline-picker-doesnt-have-milestone-choice/110395) |
| Project milestones with auto-progress, separate from health | Milestone progress is computed from closed issues. Health is a lead's judgement in an update. Project graphs predict completion. | Linear | [Linear for PMs](https://linear.app/docs/linear-for-product-managers); [project updates](https://linear.app/docs/initiative-and-project-updates) |
| Definition of done and acceptance criteria | Nothing native. A checklist app with a validator blocks the transition to Done until the DoD items are ticked. A Resolution or "evidence link" field can be required by a validator. | Jira | [Atlassian DoD blog](https://www.atlassian.com/blog/jira-software/8-steps-to-a-definition-of-done-in-jira); [Herocoders](https://herocoders.com/blog/definition-of-done-lists-jira); [FitGap](https://us.fitgap.com/stack-guides/improving-status-accuracy-with-a-definition-of-done-and-evidence-linked-updates) |
| Success criteria on objectives | Objectives carry success criteria, and only some roles can edit them. | Cascade | [Workflow example](https://support.cascade.app/workflow-example-user-with-can-view-plan-permissions) |
| Gate review with deliverables | Gatekeepers review progress, risks, resources and strategic value. Deliverables are listed per stage. In comparable PPM tools, the gate opens only after all approvers agree. | Planview (gated NPD); Oracle PPM, PPM Express for comparison | [Planview best practices](https://planview.com/?p=27547); [Oracle gates](https://docs.oracle.com/en/cloud/saas/project-management/24d/oapem/how-you-manage-project-gates.html); [PPM Express](https://ppmx.helpjuice.com/process-management/approvals-for-stage-transition) |
| Automatic roll-up | Goals take progress automatically from sub-goals, projects or tasks. Percentages are averaged and numbers summed. Weighted goals. Limits conflict between help articles. | Asana | [Goal progress](https://help.asana.com/s/article/progress-status-and-connecting-work-to-goals); [weighted goals](https://help.asana.com/s/article/weighted-goals) |
| KR roll-ups, "rolls up" and "cascades to" relationships | KRs can roll up from other KRs across teams. | WorkBoard | [KR relationships](https://help.workboard.com/en/articles/13341182-key-result-relationships) |
| Outcomes vs outputs | Outcomes go in KRs. Outputs are Initiatives (tasks, projects, deliverables) beneath them. | Perdoo (also Atlassian Goals vs Projects, Asana Goals vs Projects) | [Perdoo outcomes vs outputs](https://perdoo.com/blog/outcomes-vs-outputs) |
| Celebrations and appreciations | Celebration creatures (unicorn, narwhal, yeti, phoenix, otter) on completion, toggled in Display settings. Appreciations on tasks, milestones and status updates. | Asana | [Celebrating teamwork](https://asana.com/inside-asana/celebrating-teamwork); [Appreciations](https://asana.com/inside-asana/appreciations) |
| Recognition tied to values | High Fives, often aligned to company values. | 15Five (Lattice and Betterworks have praise modules) | [TrustRadius](https://www.trustradius.com/compare-products/15five-vs-kudos-vs-lattice) |
| Final score, retrospective, learnings | Each KR gets a final score and a retrospective. A Learnings tab on goals and projects captures learnings at any time. After shipping, owners keep reporting impact as expected vs actual. | Atlassian | [Record learnings](https://support.atlassian.com/platform-experiences/docs/record-and-share-your-project-learnings/); [OKR play](https://wac-cdn.atlassian.com/team-playbook/plays/okrs) |
| Wins and learnings in review rituals | The chief of staff fills a tray with critical KRs. The review has a round of wins and learnings, then low-confidence KRs and their owners' plans. | WorkBoard | [WorkBoard support deck](https://support.workboard.com/hc/article_attachments/15259222091661) |
| Lessons-learned template at each gate and at closure | An Excel template with categorised lessons. | Planview | [Lessons learned template](https://success.planview.com/Planview_Portfolios/Adoption_and_Enablement_Resources/PMO_Document_Templates/Lessons_Learned_Template) |

**Table stakes**
- Milestones (diamonds).
- Done states.
- Automatic % roll-up from tasks to projects to goals.
- Baselines in PPM-grade tools.
- Retrospective and closure templates.

**Differentiators**
- Completion criteria enforced at the transition (Jira with apps; PPM gates).
- Evidence attached to sign-off (PPM; a FitGap pattern for Jira).
- Health separated from % complete (Linear, Atlassian).
- Configurable and weighted roll-up (Asana, WorkBoard).
- A learnings log tied to the goal or project rather than the team (Atlassian).
- Post-delivery outcome review, expected vs actual (Atlassian guidance; PPM benefits tracking).
- Celebration and recognition at the moment of completion (Asana).

**Pitfalls users report**
- Roll-up arithmetic produces nonsense. Asana numeric sub-goals sum unrelated units, e.g. "200 tickets + 3 hires = 203" ([forum](https://forum.asana.com/t/goal-subgoal-automatic-numeric-reporting-up-doesnt-count-subgoals/349686)).
- Atlassian users ask for goal progress inherited from sub-goals ([community](https://community.atlassian.com/forums/Jira-questions/Goal-Progress-Inheritance-from-Sub-goals-in-Atlassian/qaq-p/3232990)).
- 80% complete is not on track. A project can be 80% done and at risk because the hardest 20% is left (third-party Linear write-up).
- Approvals that complete on "Reject" (see 2.3).
- monday's milestone option disappeared from the new picker for some users.
- DoD lives in people's heads unless an app enforces it.

---

## 3. Feature × vendor table

Key: **Y** = native and documented, **P** = partial, workaround, template, add-on or limited plan, **N** = not found. A trailing **?** means general product knowledge not confirmed by a search in this session (unverified).

Columns:
- As = Asana; Mo = monday.com; CU = ClickUp; Li = Linear.
- At = Jira and Atlassian (Goals, Projects, Confluence, Loom); No = Notion.
- SS = Smartsheet; Wr = Wrike; MS = Microsoft Planner, Loop and Teams.
- WB = WorkBoard; Ca = Cascade; Pe = Perdoo.
- LB = Lattice and Betterworks; PV = Planview; BC = Basecamp.

| # | Feature | As | Mo | CU | Li | At | No | SS | Wr | MS | WB | Ca | Pe | LB | PV | BC |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Single accountable owner enforced on tasks | Y | N | P | Y | Y | N | N | N | N | Y | Y | Y | Y | Y? | N |
| 2 | Multiple assignees on one task | N | Y? | Y | N | P | Y? | Y | Y | Y | P? | P | N | P | Y? | Y? |
| 3 | Co-owner or contributor role on goals or KRs | P? | N? | P? | P | Y | N | N | N | P | Y | Y | Y | Y | P? | N |
| 4 | Followers or watchers | Y | Y? | Y? | Y | Y | P? | P? | Y? | N? | P? | P? | P? | P? | Y? | Y? |
| 5 | Native RACI or DACI roles (not just templates) | N | P | P | N | P | P | P | N? | N | N | N | N | N | P? | N |
| 6 | Workload or capacity view with reassign | Y | Y? | Y | P | P? | N | Y | Y | P | N | N | N | N | Y | N |
| 7 | Out-of-office or availability affecting assignment | P | Y | P? | N? | P | N | Y? | Y? | N? | N | N | N | N | Y | N |
| 8 | Team triage or intake queue | Y? | Y? | Y? | Y | Y | P? | Y? | Y? | P? | N | N | N | N | Y? | N |
| 9 | Round robin or balanced auto-assign | Y | Y | P? | Y | Y | N | N? | P? | N | N | N | N | N | P? | N |
| 10 | Accept or decline incoming or assigned work | P | N | N | Y | P? | N | P | N | N | P | N | N | N | P? | N |
| 11 | Committed vs stretch or aspirational targets | N | N | N | N | Y | N | N | N | N | Y | N? | N? | N? | N | N |
| 12 | Cycle or sprint commitment vs completed (say/do) | N | P? | P? | Y | Y | P? | N | N | N | N | N | N | N | P? | N |
| 13 | Uncertainty or confidence signal beyond % (health, confidence, hill) | Y | P? | P? | Y | Y | N | P? | P? | N | Y | Y? | Y? | Y? | Y? | Y |
| 14 | Meeting notes or agenda with action items linked to work | P? | P? | P? | N | P | Y | N | N | Y | Y | N? | N | P? | N | N |
| 15 | Approvals (approve, request changes, reject) | Y | P? | P? | N | Y? | N | Y | Y | Y | N | N | N | P? | Y | N |
| 16 | OKR or plan drafting with review or approval | N? | N | N? | N | P? | N | N | P? | N | Y | P? | P | P? | Y? | N |
| 17 | Threaded comments on goals, KRs or check-ins | Y | P? | Y? | Y | Y | Y? | P? | Y? | N? | Y | Y | Y | Y | Y? | Y? |
| 18 | Resolve and reopen comment threads | N? | N? | Y | Y | Y? | Y | N? | N? | N? | N? | N? | N? | N? | N? | N? |
| 19 | Reactions or likes on comments | Y | Y? | Y | Y | Y? | Y | N? | Y? | Y? | P? | P? | P? | Y? | N? | Y? |
| 20 | Assigned comments or comment-to-task | P | N? | Y | P? | P? | P? | N? | N? | N | P? | N | N | N | N | N |
| 21 | Native video updates | P? | P? | Y? | N | Y | N | N | N | P? | N | N | N | N | N | N |
| 22 | Scheduled async updates with reminders and stale flags | Y | P? | P? | Y | Y | N | Y? | P? | N | Y | Y | Y | Y | Y? | Y |
| 23 | AI-drafted status update | Y | Y? | Y? | Y? | Y? | Y? | Y? | Y? | Y? | Y? | Y? | P? | Y? | Y? | N |
| 24 | Decision records, aggregated | N | N | P? | N | Y | P? | N | N | N | P? | N | N | N | P? | N |
| 25 | Milestones as first-class items | Y | Y | Y | Y | P? | N | Y? | Y? | P? | N | P? | N | Y | Y | N |
| 26 | Completion criteria or DoD enforced at Done | N | N? | P? | N | P | N | N | N? | N | N | P | N | N | Y? | N |
| 27 | Sign-off with evidence (gate or milestone) | P | N? | N? | N | P | N | P | P? | N | N | N | N | N | Y | N |
| 28 | Automatic progress roll-up to goals | Y | Y? | Y? | Y | P | P? | Y? | Y? | P? | Y | Y? | Y? | Y? | Y | P? |
| 29 | Celebrations or kudos | Y | P? | P? | N | P | N | N | N | P? | P | N | P? | Y? | N | P? |
| 30 | Closure, retro or learnings tied to the object | P? | P? | P? | N | Y | P? | P? | P? | N | P | N? | P? | P? | Y | N |
| 31 | Output vs outcome separation (goals above projects) | Y | P? | P? | P | Y | N | P? | P? | P? | Y | Y | Y | Y? | Y | N |

How to read it:
- Rows 10, 11, 14, 16, 18, 24, 26 and 27 are sparse. Those are the gaps.
- Rows 4, 6, 15, 17, 19, 22, 23, 25 and 28 are crowded. Those are table stakes.

---

## 4. The 15 collaboration features a combined strategy, portfolio and work product most needs

The list is ordered by value to OrgCue, which joins strategy (objectives, KRs, KPIs), portfolio (initiatives, gates, budgets, risks) and work (tasks). Each item names the model it borrows and the twist only a combined product can offer.

1. **One accountable owner on every object, plus contributors and followers.**
   - Applies to objective, KR, KPI, initiative, project, milestone, risk, decision and task.
   - Keep a single Accountable field everywhere (Asana and Linear rationale).
   - Add Contributors, who can update and are credited, and Followers, who are informed.
   - On tasks, allow multiple contributors, but completion belongs to the owner. Avoid Planner's and Wrike's "anyone ticks it" trap.
2. **Optional RACI/DACI view generated from those roles.**
   - Owner maps to A, contributors to R, reviewers or approvers to C, followers to I.
   - Shown as a matrix per programme or initiative, with an "A missing" or "two As" warning.
   - Nobody does this natively.
3. **Shared KRs with accepted contributions.**
   - One KR owner. Other teams are invited as contributors (Perdoo, WorkBoard), and they accept or decline the request (Workpath).
   - Each contribution carries its own sub-target and weight, which roll up to the KR (WorkBoard relationships, Asana weighted goals).
4. **Hand-over and absence cover.**
   - A "transfer ownership" action with a hand-over note and a reason, logged in the audit trail.
   - Out-of-office dates with a named cover person. New assignments, approvals and check-in reminders reroute to the cover. Workload and timeline show the absence.
   - This fixes the most common load complaint in Asana and Jira.
5. **Team queues with triage.**
   - Unassigned work and requests land in a team queue with Accept, Decline (with reason, sent back to the requester), Merge duplicate and Snooze (Linear).
   - A rotating triage owner.
   - Rules for round robin or balanced assignment that skip people who are away (monday, Jira).
6. **Workload across strategy and work.**
   - One capacity view per person and team covering tasks, KR ownership and initiative roles.
   - Shows time off, drag-to-reassign and overload warnings at the moment of assignment.
   - Unstaffed demand is held by role, like Wrike's Backlog Box and PPM role capacity.
7. **Lightweight commitment on assignment.**
   - An optional "Accept, Decline or Propose a new date" step for tasks and actions assigned across teams or from meetings.
   - Keep "committed date" separate from "target date".
   - Almost no work tool offers this (only Profit.co among the vendors reviewed), and OrgCue's audience of strategy owners is exactly who wants it.
8. **Committed vs stretch targets and say/do.**
   - KRs carry a committed target and a stretch target, as in WorkBoard. RAG and roll-up use the committed target.
   - Scoring follows Google's model: 1.0 pass or fail for committed, about 0.7 expected for aspirational.
   - Per owner and per team, a say/do ratio: commitments made at the start of a period against delivered, with carry-over rate (15Five) and scope added (Linear, Jira).
9. **Structured check-ins.**
   - Status plus confidence plus narrative on a cadence: weekly for initiatives, monthly for goals (Atlassian).
   - Reminders, and a stale flag when an update is missed (Linear).
   - An AI-drafted update from the linked work (Asana Smart status).
   - Optional short video (Loom).
   - A "still figuring it out vs executing" signal for initiatives, borrowed from Hill Charts.
10. **Conversation on every object.**
    - Threaded comments with @mentions, reactions, resolve and reopen with a resolution summary (Linear, Notion).
    - Assigned comments that become action items (ClickUp).
    - Inline comments on plan documents and business cases.
    - A per-user "since you last looked" digest.
11. **Meetings that produce owned work.**
    - The agenda auto-pulls at-risk KRs, slipping milestones, open risks and pending decisions (the WorkBoard review pattern).
    - Action items are captured live as tasks with owner and date. They carry forward until done (Fellow) and sync to the task list rather than a copy that breaks (the Loop problem).
    - AI notes propose action items and decisions for confirmation (Notion, Teams).
12. **Decision log joined to the work.**
    - Decision records (DACI) with statuses: proposed, approved, rejected, superseded.
    - Created from a comment thread, a meeting or a gate, and linked to the objective, initiative or risk they affect.
    - Aggregated in a register that can be filtered by unit and period (Confluence Decision report).
13. **Collaborative planning cycle.**
    - Draft objectives, KRs and initiatives that stay out of roll-ups (Perdoo).
    - Catchball: propose a target up or down, counter-propose, comment, then Approve or Return (Quantive approval, i-nexus catchball).
    - Alignment suggestions to accept or reject (WorkBoard).
    - A "betting table" view for the portfolio: candidates with appetite and score, chosen or discarded per cycle (Shape Up).
14. **Approvals and milestone sign-off that behave correctly.**
    - Approve, Request changes or Reject, where only Approve completes and unblocks dependants (avoiding the Asana bug).
    - Rules for all approvers or any approver.
    - Completion criteria or definition of done on milestones and gates, with required evidence (link or file) before sign-off (Jira validators, PPM gates).
    - Milestone health from slippage against baseline.
15. **Close-out, learning and celebration.**
    - At completion of a milestone, initiative or OKR period: a closure report, a final score, a retrospective with action items that become tasks, and a learnings log tied to the object (Atlassian).
    - An outcome review that compares expected with actual for benefits and KR movement, separating output from outcome (Perdoo, Atlassian).
    - A visible celebration or kudos moment for the owner and contributors (Asana celebrations and appreciations).

---

## 5. Sources

**Ownership**
- https://asana.com/resources/why-one-assignee
- https://asana.com/inside-asana/assign-copies-of-a-task.md
- https://forum.asana.com/t/assign-multiple-assignees-on-one-task/1176.md?page=39
- https://help.asana.com/s/article/understanding-tasks
- https://help.clickup.com/hc/en-us/articles/6309029762583-Multiple-Assignees
- https://help.clickup.com/hc/en-us/articles/6309784302359-Assign-tasks
- https://linear.app/docs/assigning-issues
- https://linear.app/changelog/2025-08-14-product-intelligence-technology-preview
- https://community.atlassian.com/t5/Jira-questions/How-to-assign-issues-to-multiple-users/qaq-p/1319114
- https://support.microsoft.com/en-us/office/assign-people-to-tasks-3a1b23f0-4dce-43a2-ae0f-b4c7bc1164b4
- https://techcommunity.microsoft.com/t5/planner-events/the-new-microsoft-planner-what-s-new-and-what-s-coming-next-ama/ec-p/4247522
- https://help.wrike.com/hc/fr/community/posts/115000623005-Each-assignee-must-complete-the-task
- https://help.smartsheet.com/articles/518335
- https://developers.smartsheet.com/blog/telescope-product-update
- https://support.atlassian.com/trello/docs/watching-cards-lists-and-boards/
- https://support.atlassian.com/platform-experiences/docs/follow-goals-projects-teams-and-topics
- https://intercom.help/atlas-by-atlassian/en/articles/5209762-creating-updating-in-atlas-101
- https://help.workboard.com/en/articles/13341159-key-result-roles-owner-co-owner-data-provider
- https://help.workboard.com/en/articles/13341182-key-result-relationships
- https://support.perdoo.com/en/articles/5630755-can-more-than-one-user-lead-a-result
- https://support.perdoo.com/en/articles/5103620-what-is-a-contributor
- https://support.perdoo.com/en/articles/5991235-what-is-the-best-practice-for-an-okr-that-is-owned-by-2-or-more-teams
- https://support.cascade.app/add-objectives-to-the-focus-areas
- https://support.cascade.app/user-roles-in-cascade
- https://support.betterworks.com/hc/en-us/articles/4412049001741
- https://learn.microsoft.com/en-us/viva/goals/configuring-okrs
- https://workpath.zendesk.com/hc/en-us/articles/4405059595410-Request-a-Contribution-for-a-Goal
- https://monday.com/blog/project-management/raci-matrix-with-examples/
- https://www.profit.co/blog/perdoo-alternative

**Load**
- https://forum.asana.com/t/were-excited-to-announce-that-workload-now-has-effort-and-capacity/56622
- https://forum.asana.com/t/workload-view-does-not-accurately-show-hours-per-week/554597
- https://asana.com/resources/out-of-office-checklist
- https://forum.asana.com/t/what-is-workload-without-knowing-your-teams-ooo-out-of-office-time/104178/15
- https://forum.asana.com/t/holiday-leave-block-off-time-either-as-pto-holiday-or-all-day-task/20302?page=8
- https://forum.asana.com/t/using-ai-studio-to-reassign-work-when-out-of-office/1103616
- https://forum.asana.com/t/new-in-rules-round-robin-assignment-is-now-live/1153580
- https://help.clickup.com/hc/en-us/articles/30799838221335-Measure-availability-or-capacity-in-Workload-view
- https://feedback.clickup.com/feature-requests/p/dynamic-workload-calculation-based-on-time-remaining-net-effort
- https://clickup.com/learn/topic/operations/tools/features/workload-views/
- https://help.wrike.com/hc/en-us/articles/360010835433
- https://www.wrike.com/blog/introducing-workload-management-in-wrike-monitor-balance-optimize/
- https://support.microsoft.com/Planner/teams/advanced-capabilities-with-premium-plans-in-planner
- https://mc.merill.net/message/MC1474110
- https://techcommunity.microsoft.com/discussions/planner/improve-resource-capacity-and-baseline-governance-in-planner-premium/4536002
- https://success.planview.com/Planview_Clarizen/Capacity_Planning_and_Resource_Management/Resource_Management_Best_Practices
- https://www.smartsheet.com/platform/resource-management
- https://support.monday.com/hc/en-us/articles/29191074306706-Round-robin-automations
- https://confluence.atlassian.com/automation074/smart-assign-jira-issues-load-balancing-round-robin-and-more-1141481228.html
- https://community.atlassian.com/forums/Jira-Service-Management/Assign-issues-to-users-of-a-group-round-robin-skip-user-based-on/qaq-p/2316315
- https://community.atlassian.com/forums/Jira-Service-Management/Ticket-Assignment-Queue/qaq-p/3192157
- https://linear.app/docs/triage
- https://linear.app/changelog/2023-10-12-triage-responsibility

**Commitment**
- https://forum.asana.com/t/accept-or-reject-tasks-when-assigned-feature-request/254582
- https://www.profit.co/answers/tasks/how-to-enable-accept-reject-task-options-in-profit-co/
- https://planfix.com/help/The_Accept_and_Decline_buttons
- https://awe-hnu.github.io/lectures/IPS/23WT/OKRs/assets/googles-OKR-playbook.pdf
- https://www.whatmatters.com/faqs/committed-aspirational-okrs-examples-difference
- https://help.workboard.com/en/articles/13341164-committed-key-results
- https://help.workboard.com/en/articles/13341175-advanced-key-results-options
- https://support.atlassian.com/focus/docs/score-a-goal/
- https://intercom.help/atlas-by-atlassian/en/articles/6216876-track-objectives-and-key-results-with-goal-scoring
- https://support.atlassian.com/jira-software-cloud/docs/view-and-understand-the-velocity-chart/
- https://community.atlassian.com/forums/App-Central-articles/Say-do-ratio-report-Track-sprint-commitments-vs-delivery-in-Jira/ba-p/3142810
- https://community.atlassian.com/forums/Jira-questions/Velocity-report-Why-completed-bar-is-higher-than-commited-bar/qaq-p/1766333
- https://linear.app/docs/cycle-graph
- https://linear.app/changelog/2022-09-22-cycles-and-graph-improvements
- https://basecamp.com/hill-charts
- https://basecamp.com/shapeup/3.4-chapter-12
- https://elezea.com/2018/04/tracking-development-uncertainty-with-hill-charts/
- https://basecamp.com/shapeup/2.2-chapter-08
- https://basecamp.com/shapeup/4.5-appendix-06
- https://help.workboard.com/en/articles/13341303-get-started-with-meetings
- https://www.workboard.com/product/workstreams-actionitems.php
- https://fellow.co/features/action-items
- https://jira.atlassian.com/browse/LOOM-649
- https://www.notion.com/en-gb/help/guides/preserve-perfect-meeting-memory-with-ai-meeting-notes
- https://www.notion.com/custom-agent-templates/meetings-to-tasks
- https://support.microsoft.com/en-us/office/add-a-task-list-to-meeting-notes-94383070-5f2f-4954-8607-7b7ebff5d43e
- https://office365itpros.com/2023/05/17/loop-task-list-planner/
- https://learn.microsoft.com/en-us/Briefing/be-overview
- https://learn.microsoft.com/viva/insights/personal/reference/briefing-pause
- https://success.15five.com/hc/en-us/articles/50988309138843
- https://success.15five.com/hc/en-us/articles/50988983080731
- https://help.asana.com/s/article/approvals
- https://forum.asana.com/t/requesting-changes-on-an-approval-task-incorrectly-unblocks-a-dependent-task/429384
- https://help.wrike.com/hc/en-us/articles/210325065
- https://help.wrike.com/hc/fr/community/posts/9838323666199-File-Approval-Tweaks
- https://help.smartsheet.com/learning-track/smartsheet-intermediate/approval-requests
- https://community.smartsheet.com/discussions/tagged/approval-request/p4
- https://support.microsoft.com/en-us/teams/free/create-an-approval
- https://www.neowin.net/news/the-new-microsoft-planners-goals-feature-will-allow-you-to-set-and-track-goals-for-plans/

**Comments and planning**
- https://help.asana.com/s/article/task-comments-and-attachments
- https://asana.com/inside-asana/status-updates-have-comments
- https://forum.asana.com/t/add-ability-to-add-comments-to-goals/97486
- https://help.asana.com/s/article/smart-status
- https://linear.app/changelog/2023-11-08-resolve-comments
- https://linear.app/docs/comment-on-issues
- https://linear.app/docs/initiative-and-project-updates
- https://help.clickup.com/hc/en-us/articles/6311126397591-Assign-comments
- https://help.clickup.com/hc/en-us/articles/6309646134295-Intro-to-comments
- https://feedback.clickup.com/feature-requests/p/commenting-when-resolving-assigned-comments
- https://www.notion.com/help/comments-mentions-and-reminders
- https://developers.notion.com/guides/mcp/tools-comments-reference
- https://support.cascade.app/post-updates-comments-and-collaborate
- https://support.cascade.app/integrate-slack-with-cascade
- https://support.perdoo.com/articles/1666210-commenting-on-okrs
- https://www.perdoo.com/resources/upgrade-to-11s-and-check-ins/
- https://support.perdoo.com/en/articles/2754249-draft-okrs
- https://help.quantive.com/en/articles/3125479-approval-workflow
- https://help.workboard.com/en/articles/13341216-workboard-ai-alignment-cycle-enhancing-okr-collaboration
- https://support.atlassian.com/jira-software-cloud/docs/use-loom-in-jira-cloud/
- https://support.atlassian.com/loom/docs/use-loom-with-jira-and-confluence/
- https://www.atlassian.com/team-playbook/plays/weekly-project-updates
- https://community.atlassian.com/learning/lesson/communicate-goals-across-atlassian-products
- https://support.atlassian.com/platform-experiences/docs/use-goal-status-to-track-objectives-and-key-results
- https://basecamp.com/features/automatic-check-ins
- https://i-nexus.com/hoshin-kanri-software/
- https://blog.i-nexus.com/catchball-process-and-goal-communication
- https://marketplace.atlassian.com/apps/1238269/estimate
- https://marketplace.atlassian.com/apps/1238131/sync-poker-planning-estimation
- https://support.atlassian.com/confluence-cloud/docs/insert-the-decision-report-macro
- https://community.atlassian.com/t5/Confluence-questions/How-can-I-get-a-list-of-decision-the-same-way-I-get-a-list-of/qaq-p/1048873
- https://www.atlassian.com/software/confluence/templates/decision
- https://marketplace.atlassian.com/apps/2435494237/decision-log-for-confluence
- https://learn.g2.com/asynchronous-standup-meetings

**Completion and milestones**
- https://help.asana.com/s/article/different-types-of-tasks
- https://help.asana.com/s/article/progress-status-and-connecting-work-to-goals
- https://help.asana.com/s/article/weighted-goals
- https://forum.asana.com/t/goal-subgoal-automatic-numeric-reporting-up-doesnt-count-subgoals/349686
- https://asana.com/inside-asana/celebrating-teamwork
- https://asana.com/inside-asana/appreciations
- https://help.clickup.com/hc/en-us/articles/6304458574615-Milestones
- https://support.monday.com/hc/en-us/articles/360015643840
- https://support.monday.com/hc/en-us/articles/360020978159
- https://community.monday.com/t/new-timeline-picker-doesnt-have-milestone-choice/110395
- https://linear.app/docs/linear-for-product-managers
- https://www.atlassian.com/blog/jira-software/8-steps-to-a-definition-of-done-in-jira
- https://herocoders.com/blog/definition-of-done-lists-jira
- https://us.fitgap.com/stack-guides/improving-status-accuracy-with-a-definition-of-done-and-evidence-linked-updates
- https://support.cascade.app/workflow-example-user-with-can-view-plan-permissions
- https://planview.com/?p=27547
- https://docs.oracle.com/en/cloud/saas/project-management/24d/oapem/how-you-manage-project-gates.html
- https://ppmx.helpjuice.com/process-management/approvals-for-stage-transition
- https://perdoo.com/blog/outcomes-vs-outputs
- https://www.trustradius.com/compare-products/15five-vs-kudos-vs-lattice
- https://support.atlassian.com/platform-experiences/docs/record-and-share-your-project-learnings/
- https://wac-cdn.atlassian.com/team-playbook/plays/okrs
- https://community.atlassian.com/forums/Jira-questions/Goal-Progress-Inheritance-from-Sub-goals-in-Atlassian/qaq-p/3232990
- https://support.workboard.com/hc/article_attachments/15259222091661
- https://success.planview.com/Planview_Portfolios/Adoption_and_Enablement_Resources/PMO_Document_Templates/Lessons_Learned_Template

**Context**
- https://alternativeto.net/news/2025/3/height-project-management-tool-to-shut-down-by-september-2025
- /home/user/Orgcue.com/docs/vendor-landscape.md
