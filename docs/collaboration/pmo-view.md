# Collaboration on programmes and projects: PMO director view

Reviewed the newest build before release (demo date 16 Sept 2024).

## 1. Best practice and how the leading tools support it

- **Resource requests are a negotiation with states.** In ServiceNow SPM the PM submits a resource plan (Requested). The resource manager then confirms it as a soft booking and allocates it as a hard booking. Any later edit sends it back to Requested [1]. In Planview the resource manager approves, partly fills or rejects a PM's request, explaining the outcome in a discussion post [2]. OnePlan's "Negotiations" sets a row back to Proposed whenever either side changes it and shows the old value next to the new one [3]. In SAP PPM, the line manager's approval turns a soft booking into a hard one [4]. Smartsheet shows tentative (unapproved) projects in grey beside confirmed ones [5]. Listings describe a Tempus request workflow with approval indicators, but I found no Tempus documentation (unverified) [6].
- **Commitment is a recorded act.** In SAFe PI planning, as supported by Jira Align and its apps, teams split objectives into committed and uncommitted and take a confidence vote [7]. A cross-team dependency in Jira Align is a contract: the responding team commits to the "needed by" sprint or proposes another, and the requesting team accepts or declines [8]. Jira Plans adds a dependencies report and team capacity [9]. MS Project keeps 11 baselines and suggests one per phase end [10]; Smartsheet keeps one resettable baseline with a variance column [11].
- **Acceptance and gates need evidence.** In Planview the gate sequence is: update deliverable statuses, then complete a gate assessment, then the gate authority decides. A rejection is logged with its reason, and approvers can delegate [12]. Asana has an approval task type [13]. In Wrike a task cannot be approved while its file approvals are pending [14]. Smartsheet approvals pause a workflow until sign-off [15].
- **Hand-over and closure.** PRINCE2 updates the benefits approach and writes a lessons report at closure, starting from a lessons log opened on day one [16]. MSP gives benefits ownership to the business change manager (BCM), because programmes often close before their benefits arrive [17]. In ServiceNow practice, a project is complete when the sponsor accepts the closure report [18].
- **RACI.** Allow exactly one Accountable per deliverable or decision, and any number of Responsible [19]. None of the tools I checked has RACI as a native object (Celoxis has change-request approval chains, vendor claim [20]), so OrgCue could fill this gap.

## 2. OrgCue today

**Much better than last review.** Each gate now has criteria, and an unmet criterion can carry a written explanation. Gates also have named approvers and an "all" or "any" rule. The new pieces are:
- change requests (CR-1 to CR-3) with an approver and the impact on the baseline;
- baseline history;
- monthly phasing with purchase orders;
- benefit profiles;
- role demand by quarter;
- scenarios;
- intake scoring;
- a decision log whose actions feed the steering pack.

The weak spot: they record what the owner did, not what the other side agreed to.

**Responsibility.**
- An initiative has a single "Owner". There is no sponsor, delivery lead or BCM.
- Requests have a "Sponsor" field, but the initiative form has none.
- Gate approvers are set per gate type for the whole portfolio. Every Business case is approved by Dianne Miles and Liza Martines, whatever the programme. Approvers cannot delegate or name cover.
- The closure step "Hand over to operations" is a tick box that names nobody on the receiving side.

**Sharing load.**
- Capacity (`#wk-capacity`) is a flat FTE per role for every quarter an initiative runs. Nordics needs 5.5 FTE from Q1 2025 to Q1 2026, with no ramp.
- Supply is a few named people plus "wider team" FTE, for example 5 of the 6.5 consultants.
- There is no request, proposal or confirmation, and no line-manager view.
- The Approved gate criterion "The team is named and available" is a tick box with no link to capacity.
- `#resources` still shows January to May 2023 for a different cast.

**Commitment.**
- Initiative milestones are quarter numbers. The code (`ok = m+1 <= NOWQ`) marks a milestone done once its quarter has passed. Nobody accepts it.
- The Approved gate criterion "The plan and milestones are agreed" is a tick box that records nobody's agreement.
- Nordics' Baseline 1 was "set on 31 Dec 2024", which is after the demo date, and it was set at the Business case stage, before approval.
- Steering actions A-22 to A-24 appear only in `#wk-decisions` and the steering pack. My work shows none of them. A-22 is overdue, and its owner gets no notice.

**Comments and joint planning.**
- Only status updates have Reply. Gates, change requests, decisions, RAID items, budget lines, benefits and scenarios cannot be discussed.
- Initiative dependencies, with clashes and the critical path, are drawn by one side. The other team never agrees to them.
- A scenario has one author ("Created by Jonas Keller") and a one-click "Apply to live plan", with no review step.
- Governance meetings link tasks and RAID items but produce no decisions or actions.
- Every RAID "Review by" date (Feb to Jul 2024) is overdue, and none is flagged.

**Work complete and milestones.**
- The Delivery gate criterion "Scope is delivered and accepted" is a tick box. You cannot attach a deliverable, evidence or the name of the person who accepted it.
- Market research is in the Closing stage at 21% complete and Off track. Its closure card already ticks "Hand over to operations" and "Lessons learned captured", but:
  - its only benefit, "A clear go/no-go decision", is At risk with nothing realised;
  - no retrospective exists for it (retros cover only Demo project and Management system Phase 1);
  - no decision records closing it early.
- Closing is the "Last stage, no gate". Sign-off lives on a separate page (`#closure`, "Pending").
- The project Gantt has no milestone rows or baseline bars. Tasks that have not started but were due in January and February 2024 show in grey and are not flagged.

## 3. Recommendations

★ = top 5 to build next.

### Responsibility

| Rank | Feature | What and why |
| --- | --- | --- |
| **Must ★1** | **Initiative roles and accepted hand-overs** | Add Sponsor (Accountable), Delivery lead, Benefit owner/BCM and PMO contact to each initiative. At Approved→Delivery and Closing→operations, the incoming person accepts the hand-over, with a note. Every approval below needs these names. |
| Should | RACI on deliverables, milestones and gates | Allow one A and several R, C and I on each item. Warn when there is no A, or two. |
| Should | Gate authority per programme, with delegation | A programme board approves its own gates. An approver can name cover for an absence, and a gate waiting on someone who is away gets flagged. |

### Sharing load

| Rank | Feature | What and why |
| --- | --- | --- |
| **Must ★2** | **Resource requests with negotiation** | The PM asks for a role or a named person, with FTE by month. The line manager confirms (soft), allocates (hard), proposes someone else or a date, or declines with a reason. Any change sends the request back to Proposed and shows the old value. The heat map then shows agreed commitments. |
| Should | Tentative and confirmed demand | Demand before approval shows in grey (the Smartsheet pattern). The criterion "Team is named and available" is computed from hard allocations. |
| Should | One people model and a line-manager view | Merge Resources, role capacity and task Workload. Absences reduce capacity. Each manager sees their people across initiatives and the requests waiting for them. |
| Could | Cover and reassignment | When someone is away, suggest others in the role. |

### Commitment

| Rank | Feature | What and why |
| --- | --- | --- |
| **Must ★3** | **Steering actions into My work, plus say/do** | Decision actions land in the owner's inbox. The owner acknowledges them or proposes another date. Overdue actions carry into the next pack automatically. Report the share of actions done on time for each board. |
| Must | Baselines that the team agrees | The PM proposes a baseline, the delivery leads accept it, and the sponsor approves it. Each version records who agreed. A baseline cannot be set before the Approved gate or dated in the future. |
| Should | Milestone commitments and slippage | Each milestone has a name, an owner, a baseline date and a forecast date. Show slippage trends and the team's hit rate. That rate feeds the existing "Milestones hit on time" measure. |
| Could | Committed and stretch, with a confidence vote | For quarterly or PI objectives. |
| Could | Accept or decline assignments | The assignee can say "can't by then" before work slips. |

### Comments and joint planning

| Rank | Feature | What and why |
| --- | --- | --- |
| **Must ★4** | **Threads on governance objects** | Comments with @mentions and resolve on gates, gate criteria, change requests, decisions, RAID, budget lines, benefits and scenarios. A resolved thread can be turned into a decision or an action. |
| Should | Dependency agreements | The consuming initiative asks for a deliverable by a date. The providing owner commits or counter-proposes. A clash notifies both owners. |
| Should | Planning workshop mode | A shared scenario with contributors and comments, and a "propose to steering" step that logs a decision instead of being applied in one click. |
| Should | Meetings that produce records | Build the agenda from pending gates, change requests and decisions. Minutes create decisions and actions directly. |
| Should | RAID review cadence | Flag overdue reviews, let risk owners discuss in a thread, and escalate an item to a programme or strategic risk. |

### Work complete and milestones

| Rank | Feature | What and why |
| --- | --- | --- |
| **Must ★5** | **Deliverable and milestone acceptance with evidence** | A deliverable or milestone has acceptance criteria, evidence (a file or link) and an accepter, who is the A from the RACI. The accepter accepts it, or rejects it with a reason. A milestone is met only when it is accepted, not when its quarter passes. "Scope is delivered and accepted" is computed from these records. |
| Must | Benefits hand-over at closure | Each benefit passes to an operations owner, who accepts it. Tracking continues after closure. Closure is blocked while any benefit has no owner. |
| Should | Gate evidence and frozen gate packs | Each criterion carries an owner and evidence. The pack is frozen at the moment of decision so later audits see what the board saw. |
| Should | Closure as a real gate | The closure report shows performance against the baseline, reconciled finance from the Finance tab and open RAID items handed over. The sponsor signs it off. An early-closure decision handles cases like Market research at 21%. |
| Should | Lessons that come back | Link retros to initiatives; show tagged lessons at gates of similar initiatives. |
| Could | Celebrate accepted milestones | Post them to the programme feed and to Kudos. |

## Sources

1. ServiceNow resource plans: https://www.servicenow.com/docs/r/zurich/it-business-management/resource-management/c_ResourcePlans.html ; Confirm and allocate: https://www.servicenow.com/docs/r/MrftC6mNgCta3UqwXSW7Kg/QKJSATIltzTfNyo_9tgZtw
2. Planview AdaptiveWork staffing requests: https://success.planview.com/Planview_AdaptiveWork/Capacity_Planning_and_Resource_Management/Requesting_Resources_(Staffing_Requests) ; PPM Pro fulfilling requests: https://success.planview.com/Planview_PPM_Pro/070_Project_Staffing/020_Centralized_Project_Resource_Staffing/030_How_to_Fulfill_Staffing/040_Fullfilling_Staffing_Requests
3. OnePlan Negotiations: https://support.oneplan.ai/hc/en-us/articles/360060283091
4. SAP PPM soft and hard booking: https://help.sap.com/saphelp_ppm50/helpdata/en/4a/c297f3229d34cae10000000a421138/content.htm
5. Smartsheet project types: https://help.smartsheet.com/articles/2481171-project-types
6. Tempus Resource listing (unverified): https://www.getapp.sg/software/129383/tempus-resource
7. Atlassian PI objectives: https://success.atlassian.com/solution-paths/quarterly-planning-guidance-with-jira-cloud/conduct-a-pi-planning-event/how-to-track-and-manage-program-increment-pi-objectives
8. Jira Align dependency workflow (community): https://community.atlassian.com/forums/Jira-Align-articles/Understanding-the-Dependency-Workflow-in-Jira-Align/ba-p/3127047
9. Jira Plans: https://www.atlassian.com/software/jira/guides/advanced-roadmaps/overview
10. MS Project baselines: https://support.microsoft.com/en-us/project/set-and-save-a-baseline
11. Smartsheet baselines: https://help.smartsheet.com/articles/2482093
12. Planview process flows: https://success.planview.com/capabilities/Product_Portfolio_and_Pipeline_Planning/Process_flows ; Lifecycle Approvals widget: https://success.planview.com/Shared_capabilities/Planview.Me/Planview.Me_widget_library/Lifecycle_Approvals_widget
13. Asana task types: https://help.asana.com/s/article/different-types-of-tasks
14. Wrike approvals: https://wrike.com/features/approvals
15. Smartsheet approvals: https://help.smartsheet.com/articles/2479276-request-approval-from-stakeholders
16. PRINCE2 closing: https://prince2.wiki/processes/closing-a-project ; Lessons log: https://prince2.wiki/management-products/lessons-log
17. AXELOS BCM: https://www.axelos.com/resource-hub/blog/business_change_manager_for_programmes ; Outputs to outcomes: https://axelos.com/resource-hub/blog/outputs_to_outcomes_journey
18. UMass Boston closing phase: https://umb.edu/it/about/project-management-office/project-closing-phase
19. RACI: https://en.wikipedia.org/wiki/Responsibility_assignment_matrix
20. Celoxis workflow (vendor claim): https://de.celoxis.com/article/workflow-automation-software
