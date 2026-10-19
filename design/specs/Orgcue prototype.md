# Orgcue prototype · build notes

Entry: `Orgcue.dc.html`. Built from `uploads/Orgcue Product Spec.md` (v1.0). The earlier `Product Prototype.dc.html` and its files are kept as the previous version.

## Files
- `Orgcue.dc.html`: shell (demo bar: View as / Phase / Show all features, top bar, collapsible sidebar persisted in `localStorage['orgcue-navC']`, hash routing, toasts)
- `OcPages.dc.html`: Home (§8), Projects, Templates, Library (§7 shared Board/List/Timeline, §11, §12), Portfolio (§13)
- `OcProject.dc.html`: project header, phase stepper and role tabs (§10.1); Overview, Members + send drawer + external respondents, Input (smart question set §14, adaptive §15, customer evidence §18.3, gaps, items + detail with votes/comments/approve §16), My input, Brainstorm, Actions (§10.10, shared template + drawer + bulk bar)
- `OcSpecGen.dc.html`: Spec tab (§10.8, simulated runs §17, framework coverage §19, decisions, lock) and Generate tab (§10.9, gates, instruction check, files / changes / flow map / segmentation / not-in-any-file §20, pilot, trace, MCP)
- `OcWizard.dc.html`: New project wizard, 6 steps (§9)
- `OcSettings.dc.html`: Settings with draft + save bar and audit events (§21), integrations (§22)
- `OcPhone.dc.html`: contributor phone flow (§10.6) at `#/phone`, customer page (§18.2) at `#/customer`
- `oc-kit.js`: shared store, status colors, block builders, the shared view template; `oc-data.js`: seed data (§25)

## Visual system
The bound Orgpuls design system takes the place of the spec's §6 "Status grid" tokens. Status cells are full-color and always carry text, built from Orgpuls tokens: done → green, working → saffron, blocked/overdue/fail → rust, owner pending/decide → decision tint, to do → sand.
