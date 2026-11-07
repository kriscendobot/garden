---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-07T23:46:27Z
job: kriscendobot-minion.town-pr230-gauntlet-panel-3
claim: 2fe1965160cbcada
---
Originating dispatch: `kriscendobot-minion.town-pr230-gauntlet-panel-3` (PR #230, base `443519ebee45143cccfe3a36c10635ce24d74ae0`).

**Verdict:** request-changes

**Findings:**

- **must-fix** — Sections 4.1 and 5-10 add a governor disclosure plus Clone, Destroy, plan, child-switcher, drill, and return controls, but define no keyboard-only path, focus movement/restoration, or semantic state contract. The existing gutter explicitly supplies real buttons, accessible names/current state, and keyboard interaction; re-pressing the active gutter button must not become an undiscoverable second behavior, especially because it is the only way to open the portrait Powers sheet. Specify the controls as buttons/dialog/list controls, give the disclosure a changing accessible name plus `aria-expanded`/`aria-controls`, preserve selection on its first press, and state focus and live-error behavior for open, close, switch, clone, and destroy. Add browser tests for that path. [rule: designs/clip-shell-framework.md § 2]

**Notes (out of scope but worth flagging):**

- None.

Self-improvement: nothing this time.
