# Demo script

About 15 minutes, on https://orgcue.vercel.app. It follows the spec §26 acceptance checklist. Start with **Reset demo** in the dark strip so everyone sees the Lumio Inc. seed. Every step below writes to Supabase, so a reload keeps the state. The same steps run automatically with `npm run test:e2e`.

Use the dark strip for **View as** (Owner, Decider, Contributor, Org admin) and **Phase**. The role resets to Owner on reload. The phase is stored on the project.

## 1. Frame a new project (Owner)
1. Click **＋ New project**, then **Start from scratch** and **Continue**.
2. Name it, pick type **Process**, and keep SIPOC + BPMN and EARS. Click Continue through Sections, Questions and People, then **Create project**.
3. You land on its Members tab. Sections include Suppliers, Inputs, Outputs and Customers (§26.1).

## 2. Smart question set (Owner, Frame)
1. Set Phase to **Frame** and open IT Helpdesk Agent v1 → **Input**.
2. The card reads "6 questions removed · 9 min saved". Press **Ask anyway** on the first one: 5 removed, 7.5 min (§26.2).

## 3. Send and collect
1. **Members** → **Send** → **Send to 8 members**. The phase becomes Collect (§26.3).
2. Click **Phone flow** in the strip and answer as Sam: Start, Continue, Next, Next, write an idea, **Add idea**, **Finish**. Sam's answers and idea now show on My input.
3. **Input**: the adaptive table shows one topic converged (Done) and two in conflict. **Keep asking** reopens the converged one (§26.4).

## 4. Reveal and review
1. **Close collection and reveal**. After about 2 seconds the phase is Review and the items appear (§26.5).
2. Open "After 8 pm, open a high-priority ticket…" and choose **Reject… → Duplicate** (§26.6).
3. View as **Contributor** → **My input**. The footprint shows "Rejected · Duplicate". In Team input, counts appear only after **▲ Vote**.
4. **Customer page** in the strip: Start is disabled until you tick consent. Answer the 4 questions and send. Back on Input, **Create requirement** on the billing theme drafts REQ-025 (§26.15).

## 5. Decide and lock (Decider, Decide)
1. Phase **Decide**, View as **Decider**, open **Spec**. Simulated runs link conflicts to DEC-03 and DEC-04 (§26.7).
2. In DEC-03, pick **MFA push before any change**, write a rationale, and **Record decision**. "Password reset at 8am" turns Pass and the lock checklist updates.
3. DEC-07: **Choose Sam's**. Then **Lock v1.4.0**. The version is stored with its hash (§26.8).

## 6. Generate (Decider, Validate)
1. Phase **Validate**, open **Generate**. The instruction check shows 6 issues. **Apply safe fixes** leaves 2 high issues and the score rises (§26.9).
2. **Fix** the remaining gate items, then **Approve diff…**. The file explorer shows AGENTS.md with source tags. Click a REQ-020 line to see its input, DEC-03 and its test (§26.10).
3. Under Generated output, open **Flow map** and click Security and risk to dim everything else. Q14 Emoji is a dead end (§26.11). The **Changes** view lists a cause chip for each changed line (§26.12).

## 7. Run it (Owner)
1. **Actions**: click a status cell to cycle it. Tick two rows and press **Mark done**. Board and Timeline show the same data (§26.13).
2. **Library**: **Propose change** on LIB-HC-015. The banner lists the 3 affected projects. **Withdraw** reverts it (§26.14).
3. View as **Org admin** → **Settings → Questions and library**. Change the convergence threshold. The save bar appears, and **Save changes** logs an event in **Compliance and audit** (§26.16). As Contributor, Settings shows only Profile and Notifications.
4. Collapse the sidebar and reload. It stays collapsed (§26.17).

## What is simulated
The merge and cluster pipeline, AI drafting, gates, generated files, the flow map, integrations and email, Slack or Teams sends are seeded or simulated (docs/ASSESSMENT.md §3). The evidence pack downloads a real JSON dump of the project. CSV downloads the rows of the current list.
