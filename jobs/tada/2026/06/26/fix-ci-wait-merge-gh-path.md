## Completion report — `fix-ci-wait-merge-gh-path`

**Root-cause path bug:** `scripts/jobs/gardening/ci-wait-merge.sh` resolved its gh binary with `GH="${GARDEN_GH:-gh}"` and then hard-checked it via `require_tools "$GH"`. When `GARDEN_GH` pointed at a `mktemp -d` gh wrapper (e.g. `/tmp/tmp.rrolnKVTO1/gh`) that had **already been cleaned up** by the time the check ran during the up-to-90-minute CI-wait, `require_tools` fired the missing-tool guard and the step **died and silently dropped the merge** — the root cause of the endo-but-for-bots #178 conduct failures (two conduct jobs ended unmerged; the liaison merged #178 by hand). The loud-tool-failure hardening correctly surfaced it; this fixes the underlying tool-path bug.

**Fix (committed `d2811ba9e`, pushed to `origin/main2`):**
- `GH` now defaults to the PATH-resolved `gh`, which `common.sh` pins to the **durable fleet wrapper** (`scripts/jobs/bin/gh`) at the front of PATH for the fleet's lifetime (and pins the bot identity). That path survives the entire wait.
- `GARDEN_GH` is still honored as a test seam, **but only when it resolves to a runnable command at check time**. A stale/vanished override no longer dies — it falls back to the durable wrapper **loudly** (`log`) and carries the merge to completion. `require_tools "$GH"` now targets a path that is guaranteed durable.

**Audit:** Swept the conductor/gardening CI-wait flow and handlers for the same stale-temp-PATH pattern. `ci-wait-merge.sh:63` was the **only** `require_tools` target pointing at a variable/ephemeral path; every other gardening/handler script uses literal `require_tools gh jq` (durable PATH lookups), and the other `mktemp` uses (`local-verify.sh`, `panel.sh`, `garden-pr.sh`) are scratch trace/output files, not tool-resolution targets. No further occurrences.

**Tests & verification:**
- Added **T8** regression test: stale `GARDEN_GH` at a vanished path falls back to a durable on-PATH wrapper and still merges (exit 0). Under the old code this would have died with exit 1 — a genuine guard.
- Full suite: **PASS=14 FAIL=0**. `bash -n` clean on both files; `shellcheck` clean on changed lines (only pre-existing SC1091/SC2034 on unchanged source/`GARDEN_TAG` lines).

**Deploy:** Pushed to `origin/main2`; the live tree (clean, no tracked edits) fast-forwards via the active `garden-watchman.timer`. `ci-wait-merge.sh` is read fresh on each conduct invocation, so no daemon restart is required.

**Follow-up:** Complements `harden-conductor-ci-wait-complete-merge` (the "ends while waiting" logic). Both are now in place: the conductor blocks until CI settles *and* resolves `gh` durably, so a green-but-unmerged PR can no longer be left behind. No new follow-ups.

**SHA:** `d2811ba9e8510aa511d6c1f048b139d9209a7679`
