# Collaboration on strategy, projects and tasks: research and recommendations

In November 2026 the same advisory panel that reviewed OrgCue before researched how leading platforms handle collaboration. The panel is four AI reviewers working in fixed roles: a strategy consultant, a PMO director, a SaaS founder and a market analyst. The analyst covered 15 vendors with about 140 sources. The three experts each researched their own field and tested the newest OrgCue build against what they found. Vendor websites could not be fetched from the research environment, so claims rest on search results that quote official help centres and changelogs; weak claims are marked "unverified" in the full reports. The full reports are in `docs/collaboration/`:

| Report | File |
| --- | --- |
| Vendor patterns: five themes, a 31-row feature by vendor table, sources | `collaboration/vendor-patterns.md` |
| Strategy consultant: collaboration on strategy | `collaboration/strategy-view.md` |
| PMO director: collaboration on programmes and projects | `collaboration/pmo-view.md` |
| SaaS founder: tasks, teamwork and adoption | `collaboration/founder-view.md` |

## What leading platforms do

| Theme | Table stakes | Rare, so worth winning | Pitfalls users report |
| --- | --- | --- | --- |
| **Sharing responsibility** | One assignee per task plus collaborators and followers (Asana, Linear, Jira). Goals with an owner and contributors (Perdoo, Atlassian Goals). | Separate updater and co-owner roles on goals (WorkBoard). A RACI view: no vendor has one built in, only templates. | Several assignees where any one of them ticking "done" closes the task for everyone (Planner, Wrike). |
| **Sharing load** | Workload views with drag to reassign (Asana, monday.com, ClickUp, Wrike). | Round robin that skips people who are away (monday.com). A rotating team triage owner (Linear). Resource requests negotiated with line managers (ServiceNow, Planview). | Absence is not taken into account, so work piles onto people who are away. |
| **Commitment** | Committed against completed work per sprint or cycle (Jira, Linear). | Accepting or declining assigned work (only Linear triage and Profit.co). Committed against stretch targets (WorkBoard, Atlassian). Meetings that turn into owned action items (WorkBoard, Fellow). | Action items copied out of meetings that never sync back to the task list. |
| **Comments and planning** | Threaded comments with mentions on tasks. | Resolving threads (Linear, Notion, ClickUp, Confluence). Draft objectives and approval of targets (Perdoo, Quantive's former flow). Catchball (only i-nexus). A decision report (Confluence). | Planning happens in documents and meetings outside the tool. |
| **Work complete and milestones** | Milestones and automatic progress roll-up. | Done criteria enforced when work is completed. Milestone sign-off with evidence (PPM stage gates). Closure with learnings (Atlassian). | Rejecting an approval still counts as done and unblocks dependent work (Asana). Roll-ups that add up unrelated numbers. |

## What the panel found in OrgCue

OrgCue already has the parts that collaboration needs:
- an assignee, followers and @mentions;
- an inbox and team activity;
- status updates with replies;
- decisions and actions;
- gate approvers;
- check-ins with confidence;
- kudos.

What it lacks is agreement, discussion beyond tasks, and work that reaches the people who must act.

| Strategy consultant | PMO director | SaaS founder |
| --- | --- | --- |
| Unit objectives and targets go live at once; nothing is proposed, counter-proposed or agreed. | Initiatives have one "owner": no sponsor, delivery lead or benefits owner, and no accepted hand-over between stages. | Assigned work is never accepted; nobody says "yes, by Friday". |
| Measures, key results, decisions and risks cannot be discussed. | Capacity is a number per role, with no request or confirmation from line managers. | Comments are flat at the bottom of the task panel and cannot be resolved. |
| Reviews have no attendees, agenda, pre-reads or minutes, and action owners cannot accept their actions. | Steering actions never reach the owner's My work, and there is no say/do record. | The workload view hides overload, because overdue work does not count in future weeks. |
| Milestones are unnamed quarters and cannot be marked achieved. | A milestone counts as met once its quarter passes; "scope delivered and accepted" is a tick box. | The inbox can only be read and archived. Nothing reaches people outside the app. |

## What the panel recommends

All four agree on three things. Each also ranked other features; the full lists are in the reports.

1. **Agreement, not just assignment.** Tasks, actions, hand-overs, resource requests and targets should be accepted, declined with a reason, or answered with a new date. For objectives and targets, that means catchball and target agreement.
2. **Discussion on the objects people decide about.** Comment threads with mentions, reactions and resolve belong on objectives, measures, key results, gates, change requests, decisions, risks, budgets and benefits, as well as on tasks. A thread can become a decision or an action.
3. **Completion that someone accepts.** Named milestones and deliverables should have completion criteria and a named accepter, with evidence. A milestone counts as met only when it is accepted. The result should roll up to the initiative and to the key result's confidence.

| Build next (Now) | Next | Later |
| --- | --- | --- |
| One owner, contributors and followers on every object, with a RACI view | Resource requests with negotiation | Agreed baselines and benefit hand-over |
| Accept, decline or propose a new date | Absence cover and hand-over | Celebrate finished work |
| Comment threads on every object | Team triage queues | Rule builder for automation |
| Milestones with acceptance and evidence | Committed and stretch targets with say/do | Portfolio planning cycle |
| Catchball and target agreement | An inbox you can act from | |
| Review meetings that produce owned work | Workload you can act on | |
| | Done criteria and review before completion | |

Email and Slack or Teams digests came up as essential for adoption. They are external connections, so they stay with the integration items on the roadmap.

All of these items are on the Product roadmap page (`/#roadmap`) as Planned or Exploring. Each shows which panel members asked for it and the vendors that set the bar.

**Packaging, as the founder suggests (tier names only):**
- **Free:** owners and collaborators, threaded comments, the inbox. Don't gate what spreads the product.
- **Team:** accept or decline, weekly planning and check-ins, workload, kudos.
- **Business:** triage queues, capacity with time off and cover, done criteria and approvals, say/do reports, the rule builder.
- **Enterprise:** approval chains, enforced policies, an audit trail of commitments.
