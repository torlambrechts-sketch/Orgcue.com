# Collaboration on strategy: research, OrgCue today, recommendations

*Strategy consultant, OrgCue advisory panel. November 2026. I opened the newest build before release at 1440x900 and ran the dialogs.*

## 1. What good looks like, and how the leading tools do it

- **Shared responsibility.** One accountable lead plus contributors, often with a separate updater. Perdoo: "A goal always has one Lead. Add the people from the other teams as Contributors." Cascade lets owners and collaborators post updates and can route reminders to the owner, the collaborators or both, for when an executive owns a goal and a teammate reports. Lattice and Atlassian Goals separate owners from members and followers.
- **Commitment and catchball.** Catchball passes objectives and plans between levels until both sides agree on feasibility and resources. i-nexus builds it into its X-matrix. Profit.co sends alignment requests to the department head to accept or reject, can require approval of OKRs and lets an approver "request changes" on a whole hierarchy. WorkBoard's "Alignment cycle" lets teams accept, reject or request a discussion on proposed alignments. Google's playbook separates committed OKRs (expected score 1.0) from aspirational ones (about 0.7).
- **Check-ins.** Viva Goals (retired December 2025) had cadenced check-ins with notes and confidence, rolling up to aligned parents. Asana, Atlassian and Cascade send update reminders or "Update Requests". Spider Impact can require the owner to approve each KPI value before it scores.
- **Review meetings.** WorkBoard's suggested agenda: a wins round robin, about 20 minutes on at-risk KRs and owners' plans, 15 on critical KRs and 5 on overdue actions, with actions created in the meeting. ClearPoint: pre-reads sent in advance, previous actions reviewed, minutes and owned actions out within 24 hours, briefing books emailed on a schedule.
- **Achievement and close.** Viva Goals closed each OKR with a recommended score and a closing note. ClearPoint records the completion date of a milestone, rolls milestones up to the initiative and compares calculated with reported completion. Asana rolls sub-goals up by average or sum.

## 2. OrgCue today

The build has moved a long way since my first review. Calculated status, dated check-ins, OKR confidence, the decision log, unit scorecards, risk appetite and a governance calendar now exist. What follows is about collaboration only.

| Page | What works | What is missing for collaboration |
| --- | --- | --- |
| **Unit scorecards** `#st-units` | <ul><li>Unit objectives carry a contribution weight to a company objective.</li><li>Roll-up check with the warning "Units are 20 points ahead of the company measure".</li><li>A Check-ins tab with due dates ("monthly by working day 5").</li><li>The Cascade tab runs from company objective to unit objective to team OKR.</li></ul> | <ul><li>**It is top-down only.** "Add unit objective" creates a live objective at once. There is no draft, proposal, counter-offer, agreement or sign-off of a unit's targets.</li><li>Any editor can set the weights.</li><li>Each objective and measure has one owner and no contributors.</li></ul> |
| **OKR alignment** `#st-okr` | The key result check-in records value, confidence and a note, and the quarter week is now correct. | <ul><li>OKRs cannot be added or drafted on this page.</li><li>No contributors.</li><li>No committed or aspirational flag.</li><li>No check-in history or comments on a key result.</li><li>No end-of-quarter close or score.</li><li>"Qualified pipeline" exists three times (K15, UM4 and a Sales key result), each checked in separately.</li><li>Retention scores 88/90 = 98% while the company 2024 target is 88.</li></ul> |
| **Measures** `#st-kpis` and the measure panel | Period, value, calculated status, owner override with a reason, and history ("Check-ins (1)"). | <ul><li>Only the owner is named; there is no updater or delegate.</li><li>No thread on a check-in.</li><li>No "request an update".</li><li>No value approval.</li><li>No marker for when a target is achieved.</li></ul> |
| **Governance calendar** `#st-calendar` | <ul><li>Cadence settings.</li><li>Period lock.</li><li>Overdue check-ins by owner, with a direct "Check in" button.</li></ul> | <ul><li>Nothing is *sent*: no reminders, nudges or escalation to the unit head.</li><li>No attendees or agenda on review events.</li><li>The overdue list cannot be reassigned.</li></ul> |
| **Strategy review** `#st-review`, `#wk-decisions` | <ul><li>"Record decision" captures outcome, decider, rationale and conditions, plus a follow-up action with owner and due date.</li><li>Open actions carry into the next review.</li><li>"Freeze this pack".</li></ul> | <ul><li>No agenda or time boxes.</li><li>No pre-read sign-off: owner comments are not confirmed by a deadline before the freeze.</li><li>No questions in advance and no comments on the pack.</li><li>No attendees, so no read receipts.</li><li>Action owners cannot accept or decline.</li><li>No minutes published after the meeting.</li><li>Headlines and "focus for next quarter" are still fixed text.</li></ul> |
| **Initiative page** `#st-init` | <ul><li>Gate approvals with "Approves / Send back" and quoted comments.</li><li>Change requests with an approver.</li><li>Status updates with highlights, blockers and "Reply".</li></ul> | <ul><li>Milestones are still unnamed labels ("End of Q2 2025", "End of Q1 2026"). Nothing marks one achieved, records evidence or shows slippage.</li><li>No outcome check (did the measure move?) when it closes.</li></ul> |
| **Strategic risks** `#st-risks` | Owner, mitigations, appetite, and "not reviewed in 60 days". | Risks belong to one owner. Mitigation owners in other units are not notified. |

**Load is concentrated.** In Commercial, Paul Reyes owns 3 of the 4 unit objectives and 4 of the 6 measures. He also owns company objective C2, the measures behind F1, F3 and C2, risks SR-1 and SR-6, decision D-14, the Nordics initiative, two overdue actions (A-22 and A-24) and the Sales OKR. Nothing shows the strategy office this, and nothing lets him delegate the routine check-ins.

**Comments exist only on tasks and status updates.** A team cannot discuss a red measure, a proposed target or a risk where it sits.

## 3. Recommendations

Ranks: **Must**, **Should**, **Could**. ★ marks my top 5 to build next.

### Theme 1: Sharing responsibility

| Feature | Rank | What it does and why |
| --- | --- | --- |
| ★ **Lead, contributors and updater** on objectives, unit objectives, measures, key results and risks | Must | <ul><li>One accountable lead, contributors from other units, and a named updater who gets the check-in reminder.</li><li>Matches Perdoo and Cascade.</li><li>Executives own; analysts report.</li></ul> |
| Shared objectives across units | Should | The weights already exist. Let a unit objective have contributors from other units and show it on each unit's scorecard, so cross-unit goals are not owned by one unit alone. |
| Ownership hand-over | Should | Change the owner with a note and an effective date. Open check-ins, actions and risks move with it, and history keeps the previous owner. |
| Accountability view (RACI-lite) per person | Could | <ul><li>One page per leader: what they lead, contribute to, update and decide.</li><li>Useful in reorganisations and at onboarding.</li></ul> |

### Theme 2: Sharing load

| Feature | Rank | What it does and why |
| --- | --- | --- |
| Ownership load map for the strategy office | Should | <ul><li>Shows objectives, measures, actions and risks per person and unit, with overdue counts.</li><li>Spots the over-loaded owner before the review does.</li></ul> |
| Cover during absence | Should | An owner names a deputy for a date range. Reminders and approvals go to the deputy, and the record shows "updated on behalf of". |
| Reassign from the overdue list | Should | The calendar's "Overdue check-ins by owner" gains Reassign and Delegate, so the strategy office can unblock without editing each measure. |
| Unowned items queue | Could | Measures, actions or risks with no owner, or an owner who has left, appear in a triage list for the strategy office. |

### Theme 3: Commitment

| Feature | Rank | What it does and why |
| --- | --- | --- |
| ★ **Catchball and target agreement** | Must | <ul><li>Unit objectives, unit targets and team OKRs move through Draft, Proposed, Counter-proposed (with a reason, the resources needed and a suggested target), Agreed, then Locked for the year.</li><li>Alignment requests go to the parent owner to accept or reject, as in Profit.co and WorkBoard.</li><li>This is the core of Hoshin and the step every BU head expects.</li></ul> |
| Committed or aspirational flag on OKRs and targets | Should | Changes the colour rules (a committed key result is at risk below plan; an aspirational one succeeds at 0.7) and shows the mix in the review. |
| Plan sign-off | Should | The unit head and strategy office sign the annual unit scorecard. After that, changes to targets go through a change request, like the one initiatives already have. |
| Action acceptance and say/do record | Should | <ul><li>Action owners accept, or decline with a reason, and can propose a new date.</li><li>Shows the share of actions done on time and check-ins submitted on time, per person and unit.</li></ul> |
| Check-in value approval | Could | Optional owner or controller approval before a value scores, for finance measures (Spider Impact). |

### Theme 4: Comments and planning together

| Feature | Rank | What it does and why |
| --- | --- | --- |
| ★ **Threads on every strategy object** | Must | <ul><li>Reuse the task side panel's comments, @mentions, followers and resolve on objectives, measures, check-ins, key results, decisions, risks and frozen packs.</li><li>Discussion happens where the number is (Cascade, Asana).</li></ul> |
| ★ **Review meeting workflow** | Must | <ul><li>Attendees.</li><li>An agenda built from exceptions, with time boxes: wins, at-risk items, decisions, overdue actions (WorkBoard).</li><li>A pre-read deadline by which owners confirm their commentary.</li><li>Questions posted in advance.</li><li>Pack sent to attendees, with read status.</li><li>Notes taken live.</li><li>Minutes and actions published within 24 hours (ClearPoint).</li></ul> |
| Request an update | Should | A button on any measure or key result sends a nudge, with an optional question, to the updater. The calendar sends automatic reminders and escalates to the unit head after N days. |
| Draft OKRs together | Should | <ul><li>Add and edit OKRs on `#st-okr` in a draft state, with comments and suggestions from the parent owner.</li><li>Link a key result to an existing measure rather than copying it, which removes the three "Qualified pipeline" copies.</li></ul> |
| Async decision input | Could | Steering members record a view (support, concerns, object) on a pending decision before the meeting, so the meeting covers only real disagreement. |
| Slack and Teams digests of reviews and check-ins | Could | Already on the roadmap. It delivers the cadence where people work. |

### Theme 5: Achievement and milestones

| Feature | Rank | What it does and why |
| --- | --- | --- |
| ★ **Named milestones with sign-off** | Must | <ul><li>Initiative milestones get a name, a date, an owner and a definition of done.</li><li>"Mark achieved" records the date and evidence (a link or file), and the sponsor confirms.</li><li>Slip is shown against the baseline, and progress rolls up to the initiative (ClearPoint).</li></ul> |
| Quarter and year close | Should | Close key results and unit objectives with a recommended score, a closing note and lessons (Viva Goals). Closed items are read-only, and the next cycle can copy them forward. |
| "Target achieved" event | Should | When a check-in crosses a yearly target, the measure is marked achieved with the date, and the win appears in the review's opening "wins" section and the activity feed. |
| Outcome check at initiative closure | Should | When an initiative closes, compare its expected impact with the measure's actual movement and record the outcome against the output. This closes the coverage loop. |
| Celebrate wins | Could | A wins section in the review and a short "kudos" on an achieved milestone or target. Cheap, and good for adoption. |

## 4. Top 5 to build next

1. **Catchball and target agreement** for unit objectives, unit targets and OKRs, with alignment requests.
2. **Threads on every strategy object**, reusing the task panel's comments and mentions.
3. **Review meeting workflow**: attendees, timed agenda, pre-read sign-off, minutes and accepted actions.
4. **Lead, contributors and updater** on every strategy object, with reminders routed to the updater.
5. **Named milestones with sign-off and evidence**, rolling up to the initiative.

These depend on the shared workspace, roles and audit log now being finished. Catchball, sign-off and threads need real users. Build them on that foundation, not in local storage.

## Sources

- Perdoo, best practice for an OKR owned by two or more teams: https://support.perdoo.com/en/articles/5991235-what-is-the-best-practice-for-an-okr-that-is-owned-by-2-or-more-teams
- Perdoo, contributors: https://support.perdoo.com/en/articles/5103620-include-contributors
- Perdoo, confidence levels: https://perdoo.com/blog/okr-confidence-levels
- Cascade, glossary (collaborator): https://support.cascade.app/the-cascade-glossary
- Cascade, posting updates and comments: https://support.cascade.app/post-updates-comments-and-collaborate
- Cascade, requesting updates: https://support.cascade.app/request-updates
- Cascade, changelog (reminder routing): https://feedback.cascade.app/en/changelog
- Lattice, group goals: https://help.lattice.com/en-us/articles/15179243-create-a-group-goal
- Atlassian, what is a goal: https://support.atlassian.com/platform-experiences/docs/what-is-a-goal/
- Atlassian, goal status for OKRs: https://support.atlassian.com/platform-experiences/docs/use-goal-status-to-track-objectives-and-key-results
- Asana, goal progress and status: https://help.asana.com/s/article/progress-status-and-connecting-work-to-goals
- Profit.co, accepting an alignment request: https://profit.co/answers/okrs/where-do-i-notify-and-accept-an-alignment-request
- Profit.co, approving an OKR hierarchy at once: https://www.profit.co/answers/okrs/how-do-i-approve-an-entire-okr-hierarchy-at-once/
- Profit.co, June 2026 release (approval emails): https://www.profit.co/release-updates/june-2026/
- WorkBoard, alignment cycle: https://help.workboard.com/en/articles/13341216-workboard-ai-alignment-cycle-enhancing-okr-collaboration
- WorkBoard, scorecards and reviews: https://workboard.com/product/scorecards-reviews.php
- WorkBoard, meetings: https://www.workboard.com/product/meetings.php
- WorkBoard, agenda deck (support attachment): https://support.workboard.com/hc/article_attachments/15259222091661
- i-nexus, Hoshin kanri software: https://i-nexus.com/hoshin-kanri-software/
- i-nexus, catchball: https://blog.i-nexus.com/catchball-process-and-goal-communication
- Google's OKR playbook (committed and aspirational): https://awe-hnu.github.io/lectures/IPS/23WT/OKRs/assets/googles-OKR-playbook.pdf
- ClearPoint, strategy review meetings: https://www.clearpointstrategy.com/books/how-to-lead-effective-strategy-review-meetings
- ClearPoint, management meeting agendas: https://www.clearpointstrategy.com/importance-of-management-meeting-agendas/
- ClearPoint, briefing book content: https://next-support.clearpointstrategy.com/en/articles/12703519-exports-share-information-creating-and-selecting-briefing-book-content
- ClearPoint, milestone roll-up: https://support.clearpointstrategy.com/en/articles/8501114-setting-up-a-milestone-roll-up-using-project-evaluations
- ClearPoint, managing completed projects: https://next-support.clearpointstrategy.com/en/articles/12769949-advanced-topics-managing-completed-projects
- Spider Impact, KPI value approval: https://spiderstrategies.com/videos/kpi-value-approve
- Spider Impact, brochure: https://resources.spiderstrategies.com/docs/Spider%20Impact%20Brochure.pdf
- Viva Goals, check-ins: https://support.microsoft.com/topic/check-in-with-viva-goals-c0244789-4388-4d2d-9d20-3678900d9b98
- Viva Goals, closing OKRs: https://learn.microsoft.com/en-us/viva/goals/viva-goals-healthy-okr-program/close-okrs-overview
- Viva Goals retirement (Message Center MC1193421): https://mc.merill.net/message/MC1193421/v/2025-12-19T17-31-03-99Z
- Betterworks, goals: https://www.betterworks.com/product/goals

**Not confirmed:**
- WorkBoard agenda timings come from a single support deck.
- ClearPoint approval workflows were a beta in an older release note.
- Betterworks shared-goal detail comes from vendor marketing.
- Microsoft has named no successor to Viva Goals beyond Planner goals (MC1193421). WorkBoard, which owns Quantive, offers migration.
