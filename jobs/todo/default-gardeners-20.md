Garden library change (main2, garden repo — no PR). The maintainer set the default concurrent gardener count for ALL hosts to 20 (down from 100), effective going forward (2026-07-06).

Task: update the documented/recommended default wherever it appears as operator guidance — notably `context/operations/starting.md` (the `set-gardeners.sh 100` example and the "~100 is normal" prose → 20 / "~20 is normal"), and `context/operations/scaling.md` if it states a default. Do NOT rewrite purely descriptive "~100-gardener fleet" scale-context comments in scripts/roles that are about historical contention behavior, unless they explicitly present 100 as the recommended default.

Work in a worktree off origin/main2 and push to main2 (rebase-CAS). Keep it a focused docs/default change; the value the scaler enforces is per-host journal state (hosts/<host>), which is set operationally — this job changes the DOCUMENTED default the liaison/tutorial uses.
