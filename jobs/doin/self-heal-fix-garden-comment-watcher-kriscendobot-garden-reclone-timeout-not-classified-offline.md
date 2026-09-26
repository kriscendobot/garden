---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`reclone_clone` in `scripts/jobs/common.sh` (~line 4302-4316) dies fatally on a bare `timeout`-killed clone (rc=124/137) with empty stderr, because it classifies offline/transient outages only via `_fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"` and a SIGTERM-killed `git clone -q` frequently produces no stderr text to match. `sync_clone` (same file, ~line 6796-6860) already guards the equivalent case with `[ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline "..."` before exiting `$GARDEN_OFFLINE_RC`; `reclone_clone` needs the identical rc check added before its `die`, so a self-heal re-clone that stalls on the network exits cleanly (EX_TEMPFAIL, retried next tick) instead of crashing the service. Failure signature: `WARN: ... has a corrupt clone; self-healing by re-cloning` → `clone of ... timed out (>45s) on attempt 1` (rc=124) → `failed after 1 attempt(s) (last rc=124)` with no trailing stderr → `FATAL: clone of ... failed`. Add/extend `scripts/jobs/test/fetch-timeout-test.sh` to cover `reclone_clone` on a hanging clone (rc=124, empty stderr) exiting via the offline path rather than `die`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T04:15:36Z
