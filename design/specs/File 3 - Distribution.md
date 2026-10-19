# File 3 — Distribution · spec (v2)

Component: `Distribution.dc.html`. Data: `data.js` (contributors, channels, invite, followUps, digest, reminderRules, reattest).

## Screens
| ID | Route | Opens for | States |
| --- | --- | --- | --- |
| 3.1 Invite builder | /briefs/:id/distribution/invite | Brief owner | Draft, Sent, purpose missing (send disabled), confirm dialog, bulk bar |
| 3.2 Channels and digests | /briefs/:id/distribution/previews | Brief owner | Email, Slack, Teams invite; round digest (Slack/Teams) with Accept, Keep mine, Comment, Mark done |
| 3.3 Schedule and reminders | /briefs/:id/distribution/schedule | Brief owner | — |
| 3.4 Tracking | /briefs/:id/distribution/tracking | Brief owner, Decider | Round extended, Mid-round (slot at risk), new follow-up row |
| 3.5 Targeted follow-up | /briefs/:id/distribution/follow-up | Brief owner | Prefilled "Security: what verification is required before a password reset?" |
| 3.6 Re-attestation run | /briefs/:id/distribution/re-attestation | Brief owner | Set up, In progress; Needs change creates action A-023 for the brief owner |

## What changed in v2
Language column removed · digest preview added (one per round, never per reply, works without login) · R1 dates Oct 5–16, extension to Nov 13 · follow-up prefilled per spec · re-attestation due Nov 20, Needs change → action · brief footer with US data region.

## Components
Design system: Pill, Button, Select, Input, Textarea, Field, Mark, Switch, Meter, CheckRow, Modal. Inline: channel badge, status pill, constraint chip, funnel tile, follow-up row, digest row, toast.
