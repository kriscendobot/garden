---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-05T05:49:48Z
---
project: minion-town
Dispatch: kriscendobot-minion.town-pr247-gauntlet-panel-5. PR #247.

**Verdict:** request-changes

**Findings:**
- **must-fix** — `designs/ordered-gutter-context-menu.md` §3 says every entry has a visible More actions button “beside” its clip button, each meeting the pointer-target minimum even in the collapsed gutter, but does not define the layout change. The shipped sibling gutter is a 56px narrow column with 40px clip buttons. Two adjacent target-sized controls cannot fit there. Specify a compact/expanded and portrait layout (including focus and reorder behavior) so the required control remains usable rather than making each entry too small or widening the gutter accidentally. [rule: designs/clip-shell-framework.md § 2]
- **must-fix** — §3 gives Freeze and alternate-powers Clone an alert/retry flow, but New Clip, Rename, ordinary Clone, reorder, and Destroy only have catalog refusals or the generic §4 redraw rule. A quota refusal, `name-taken`, `catalog-recovering`, or failed/restarted destroy can therefore look like an ignored input. Specify a consistent visible error/status and recovery path for every user-triggered mutation, retaining the user’s dialog/input where applicable. [proposed-rule: Every user-triggered mutation must specify a visible success or failure outcome and a recovery path; a background redraw alone is not an error surface.]

Self-improvement: nothing this time.
