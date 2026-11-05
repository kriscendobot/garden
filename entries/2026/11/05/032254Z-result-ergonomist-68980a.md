---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-05T03:23:01Z
---
Dispatch: kriscendobot-minion.town-pr247-gauntlet-panel-2. PR #247.

**Verdict:** request-changes

**Findings:**
- **must-fix** — `designs/ordered-gutter-context-menu.md` §3 makes Rename, Clone, Freeze, and Destroy reachable only by right-click, long-press, or an expert keyboard gesture. The existing gutter offers direct button interactions, but this surface has no visible or announced menu trigger, so keyboard and assistive-technology users cannot discover the management actions. Add a focusable per-entry “More actions” control (or an equivalent visible, documented trigger) that opens the same menu. [proposed-rule: Every persistent item with essential management actions must expose an obvious, keyboard-operable way to discover those actions, not only a context-menu gesture.]
- **must-fix** — §3 confirms Destroy but lets the one-way Freeze run directly, despite saying it permanently disables the action. Accidental selection can irreversibly change a clip with no warning. Make Freeze an explicitly confirmed “Freeze...” flow that names the clip and states the permanent effect, matching the destructive-action affordance. [proposed-rule: A user-triggered irreversible operation must require an explicit confirmation that identifies its target and permanent consequence.]
- **must-fix** — §3 labels “Clone with other powers...” and lists Keep, Leave out, and Replace with an owner-facet-minted inventory handle, but supplies no picker, cancellation path, or validation/error presentation for choosing that replacement. The user cannot tell which inventory will be used or safely complete the advertised action. Specify an accessible chooser and its cancel, unavailable, and validation states before the clone is committed. [proposed-rule: A menu action that requires a user-selected capability or resource must specify a discoverable selection flow and visible cancel and failure outcomes.]

Self-improvement: nothing this time.
