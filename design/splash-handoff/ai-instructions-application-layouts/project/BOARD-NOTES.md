# Board review — Specs v9 (20 Oct 2026)

Mission: a system that drafts AI specifications and optimised AI instructions for applications, documents and processes, fed by internal and external people answering the questions that matter. Judged on UI, adoption and the odds of a successful SaaS.

## Board
Nina Fjeld (Head of Product, PLG) · Kwame Osei (Principal UX) · Dr. Lena Voss (AI research, evals) · Rafael Moreno (Staff engineer, LLM systems) · Astrid Haugen (ISO/IEC 42001 lead auditor) · Priya Natarajan (Change management, HR) · Bjørn Lie (Operations manager, the buyer) · Maya Chen (Technical writer) · Tom Reilly (Growth and pricing) · Sofia Marin (Security lead)

## Pages reviewed
AI Instructions Prototype v8 · AI Draft Compliance · AI Use Cases · LLM Instruction Map

## Scorecard (before, 1–5)
Information architecture 2 · Words 2 · Time to first value 3 · Stakeholder experience 3 · Daily use 3 · Lifecycle 2 · AI quality 2 · Data model 2 · Compliance 4 · Security and privacy 3 · Buyer fit and pricing 3 — average 2.6

## Changed on "Specs v9 — Board Edition.dc.html"
1. One shell: Today, Use cases, Start, Answer. The reviewed pages stay linked in the header.
2. One object model: Use case → Specification + Instruction set; question → answer → requirement → rule → test → control.
3. Today replaces the dashboard: one inbox across use cases, next three actions, response funnel.
4. Four tabs per use case (Plan, Input, Build, Live) instead of 7 + 12 + 6 across three pages.
5. One lifecycle (Idea → Assess → Specify → Build → Release → Live); file stages nest under Build; the gate is the exit of Build.
6. Input as a feed: quoted answers, one-click accept as System or Instruction requirement, duplicates merged on arrival.
7. Build side by side: specification and instruction set, source coverage, AI-written share, gate per file, fixes in place.
8. Eval panel: version comparison, rubric grading, Must-to-test coverage, run against the model.
9. Start with three doors: template, import a document (gap questions), describe it.
10. Answer page: time promise, why we ask you, what the answer becomes, closed loop, no account.
11. Ten nouns (glossary) used on every screen.
12. Packaging: Starter 0 kr · Team 1 900 kr · Compliance 4 900 kr, per active use case a month; respondents free.
13. Six adoption metrics with targets.

## Specified, not built
Real model runs · event-sourced data model, Git-backed files, API · SSO, roles, EU residency, retention, PII masking · Teams/Slack/e-mail, SharePoint/Confluence · industry template packs · monitoring in use.

## Decisions (20 Oct, round 2)
Approver: depends on setup, the owner of the use case by default (per-use-case setting) · Respondents see accepted answers, can comment and upvote; a use case can be made private · English only · Gate optional for Low risk, required for Medium and High.

## Round 2 — changed on "Specs v9 - Board Edition.dc.html"
14. Detail panel: every phase, person, requirement, file, section and setting opens on the right without leaving the page.
15. Flow tab: people → answers/requirements → file sections → files as one picture; clicking lights up the lineage and opens the details.
16. AI instruction tab: the compiled text the model runs on, section by section; each sentence cites its requirement or is labelled AI-written; provenance, missing input and versions beside it.
17. Settings per use case: approver, answer visibility, risk, gate (optional for Low), language. Approvals, inbox and exit criteria follow the approver; the gate criterion follows the risk.
18. Answer page: colleagues' accepted answers with upvotes when the use case allows it.
19. UC-02 gained its AI instruction file; saved demo data reloads fresh (storage key v10).

## Round 3 — one application
20. The files editor (v8), the compliance gate, the portfolio with intake and the research map are mounted as screens inside "Specs v9 - Board Edition" under Workbenches. Each page still opens on its own; embedded, it drops its own header and menu.

## Round 4 — charter and elements
21. Charter on every use case: problem today, who it is for, goal, success, expected value, out of scope, sponsor. Editable in a panel; empty fields are flagged.
22. Elements tab: the research map's 13 groups / 74 elements checked against each use case. Status per element: covered (accepted requirement or set by the system), asked, missing, inherited from the company layer, or supplied at run time. "Ask" sends the element's question to the right persona and places it in the right file section; "Ask for all missing" does it in one click. Each element opens a panel with scope, volatility, how to collect it, who, and its answers.
23. Specify cannot be approved while project elements are unasked; the phase panel lists the criterion.
24. Glossary gained Element and Charter. Saved demo data reloads fresh (storage key v11).

25. Element catalogue now carries all 74 leaves of the research map verbatim (scope, volatility, how, who), with a person, question and file section for every project-scope element that can be asked.

## Round 5 — what was missing
26. Sources screen: tickets, transcripts, API schema, repository, documents, customer sample; connect per use case, findings land in Input as answers (tagged to elements), tests and tool schemas.
27. Claude drafts rules from accepted answers (window.claude when reachable, offline heuristic otherwise); approved sentence by sentence beside the quote; approved rules replace quotes in the AI instruction and the export.
28. Export package panel: system-prompt.md (company layer + rules with [R-codes] + examples), tools.json, evals.jsonl, CLAUDE.md; copy per file or all; "Open pull request".
29. Run against the model grades the test cases against the rules via Claude when reachable; otherwise the simulated run is labelled as such.
30. Examples (good/bad) and Red team (attack prompts from the boundaries; failures become tests) in Build.
31. Conflicts decided side by side; superseded answers stay in history. Two-source rule for Must requirements with Must/Should toggle and "Ask for second sources"; Specify exit requires it.
32. Company layer screen: inherited rules editable with owner and review date; prepended to the export.
33. Plan screen for PMs: phases with planned dates and late flags, workload per person, status report, history of every change (event log with IDs).
34. New people: Ticket analysis, Repository, Customer sample. Storage key v13.

## Round 6 — ask many people
35. "Ask people…" composer (drawer) from Plan, Input, every element and "Ask for all missing": choose questions (element questions, missing elements in one click, or free text) and any set of people, internal or external. Fan-out creates one open question per person; duplicates are skipped. Input rows show "Also asked …, n of m answered"; disagreeing answers go to the conflict card; two answers make a Must stand.
