---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fresh panel on kriscendobot/minion.town#218 at its post-rebase head

https://github.com/kriscendobot/minion.town/pull/218 (guest bond ledger) finished its gauntlet
(panel round 18 clean, un-drafted 16:56Z) at head `e01c98807b0b`. The screened conductor
`screen-minion-town-pr218-e01c988-conduct` then rebased it off the frozen `main-68c3960` onto
live `main` (`27f70ed`), a clean 44-commit rebase, new head `5e2b6232bc4d`. Since then the
exact-panel-head gate (`scripts/jobs/assert-panel-head-fresh.sh`) refuses every conductor
(`-conduct`, `-r2`, `-r3`: `disposition=review-required`). CI is green 4/4 on `5e2b623`.

Task: in an isolated checkout (`ensure-project-worktree.sh <this-base> kriscendobot/minion.town split/pr216-ledger`),
confirm the head is still `5e2b623…` (if it moved, use the current head), run the deterministic
probes (`pre-push-gates.sh --no-auto-fix --probes-only --base-ref <main sha>`), then run a fresh
SINGLE-ROUND panel (`GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 218 <main sha>`)
so a completed panel-run record covers the current head. If it passes, stop: the proxy screen
re-posts the conductor and merges. If it raises must-fix items, post ONE fixer job
(`kriscendobot-minion-town-pr218-fresh-panel-fix-20261024`) naming them, and do not loop.
Authority: minion.town supervised-carry delegation (journal entries/2026/10/07/203746Z-message-gardener-a253b1.md).
