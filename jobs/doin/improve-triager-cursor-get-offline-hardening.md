---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Two `cursor-get.sh` call sites (line ~463 `old_sha=$("$HERE/cursor-get.sh" "$CURSOR_KEY" | ...)` and line ~477 `fail_state="$("$HERE/cursor-get.sh" "$FAIL_KEY")"`) are bare command substitutions under `set -euo pipefail` with no rc guard. `cursor-get.sh` calls `sync_clone`, which on a journal-connectivity outage does `exit "$GARDEN_OFFLINE_RC"` (75, EX_TEMPFAIL) — an `exit`, not a `return`, so it terminates cursor-get.sh's process outright. That non-zero exit trips triager.sh's `set -e` and kills the whole script, which systemd then logs as `Failed with result 'exit-code'`.

Observed live: during the 2026-09-18 04:50–05:16Z journal-fetch outage, `ci-watcher.sh` (which already guards this exact case, per its own header comments about "never guess board state") logged a clean `WARN … skipping this tick` on every affected repo, while `garden-triager@kriscendobot-list`, `@kriscendobot-endo-but-for-bots`, and `@kriscendobot-finbot` all hard-failed with `Failed with result 'exit-code'` at 04:54:00–04:54:20, squarely inside the same outage window.

Fix: capture the rc of both `cursor-get.sh` invocations (`if out=$(...); then rc=0; else rc=$?; fi` pattern already used elsewhere in this file, e.g. around the fetch classification) and, when `is_environmental_rc "$rc"` (already defined in `scripts/jobs/common.sh`) is true, log a WARN and `exit 0` (clean skip, retried next tick) instead of letting `set -e` kill the unit. This brings `triager.sh`'s journal-read path up to the same fail-open standard its own repo-fetch path already meets, and matches the pattern `approval-reconciler.sh` uses for its own journal-fetch guard.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-18T05:22:21Z
