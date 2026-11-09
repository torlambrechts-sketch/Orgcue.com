# Measures, targets, the initiative portfolio and initiative tasks

This note describes how OrgCue connects strategy to measures, targets, initiatives and tasks. All numbers are sample data for the demo company, MosaicX.

## The model

```
Objective ──< Measure (KPI) >── linked with an expected impact ──< Initiative ──< Task
   │            baseline, actual, trend,                              owner, status, budget,
   │            targets for 2024, 2025, 2026                          spent, timeline, milestones
   └─ every objective has one headline measure; it can have supporting measures too
```

- **Measures (KPIs).** Each has:
  - a baseline (2023), the latest value and a quarterly trend;
  - year-end targets for 2024, 2025 and 2026;
  - a direction (higher or lower is better);
  - an owner, a data source and an update frequency.
  - The headline measure of an objective is the same number shown on the strategy map, scorecard and OGSM, so a check-in updates them all.
- **Links with expected impact.** An initiative is linked to the measures it should move, with the change it is expected to make by 2026. Examples: Nordics market entry, +£6.5M recurring revenue; Cybersecurity awareness, −6 points on the phishing click rate.
- **Coverage.** For each measure, OrgCue compares the gap to the 2026 target with the impact of everything planned:
  - **Covered:** planned impact is at least 100% of the gap.
  - **Partly covered:** 60 to 99%.
  - **Big gap:** under 60%.
- **Tasks.** Each initiative has its own task list with an owner, a due quarter and a status. Task progress is the share of tasks done.

## Where to find it

| Page | Address | What you can do |
| --- | --- | --- |
| Measures and targets | `/#st-kpis` | See every measure grouped by perspective. Switch the progress year, filter, hide columns, add a measure. Click a measure to see its chart, record a value, edit targets or open the initiatives behind it. |
| Initiative portfolio | `/#st-portfolio` | **By target:** each measure with its coverage bar and the initiatives that move it. **Initiatives:** a list with budget, spend, task progress and linked targets. Add an initiative. |
| Initiative page | `/#st-init` (opened from the portfolio, roadmap, map or search) | Edit the initiative, link or unlink measures, change expected impact, add, edit, complete or delete tasks, open its project plan. |

**Connected pages.** These now draw on the same links:
- **Strategy map:** the side panel lists the objective's measures and initiatives.
- **Roadmap:** each bar opens its initiative page.
- **Ambition page:** its "close the gap" table comes from the initiatives' expected impact on recurring revenue.
- **Search:** finds measures and initiatives.

## Patterns borrowed

- **Yearly targets with a check-in:** ClearPoint and Spider Impact measures, and Perdoo's KPI board.
- **"Red measures with no initiative behind them":** Spider Impact's Scorecard Insights. The measures page counts them.
- **Initiatives with no measure:** Workpath's "isolated islands". The portfolio counts them.
- **Expected impact per initiative and target coverage:** Jibility's capability-gap view and WorkBoard's portfolio views, applied to measures.

## Data changes in this release

- **Corrected 2024 targets.** Operating margin is now 16%, client retention 88% and NPS 40, matching the X-matrix annual objectives. The 2026 ambition values (18%, 90%, 45) are the 2026 targets.
- **Initiative fields.** Initiatives gained a description, spend to date, links to measures and tasks.
- **Older saved data still works.** Data saved in a browser before this release gains these fields automatically.
