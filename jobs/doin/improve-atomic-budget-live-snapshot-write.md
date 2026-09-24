---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
`_budget_publish_local_pool_once` writes the live snapshot with a bare `> "$file"` truncating redirect (usage-meter.sh:611 legacy path, :666 per-pool path), while every other host publishing to the same `budget/live/<pool>/<host>` file does the same non-atomic truncate-in-place. A concurrent reader in `meter_remote_snapshot_total` (usage-meter.sh:562-594) can observe a partially-written file and hit the field-mismatch path (return 9) — exactly the `reason=snapshot-field-mismatch` WARN logged 2026-09-24T21:50:07Z for pool=claude-oros host=oros-studio-garden-ce242c49. The companion WARN three minutes earlier (`operation=read-remote-spend exit_status=1 reason=unknown`, 21:35:07Z) is consistent with the same race hitting an unguarded path that falls outside the documented 6-9 codes, since no line in `meter_remote_snapshot_total` otherwise returns 1. Fix: write to `$file.tmp.$$` then `mv` into place (already the pattern used two functions later for `budget/live/$GARDEN` latch files and in `budget-level.sh`'s `dwell_bump`/`dwell_reset`), for both the legacy write at usage-meter.sh:611 and the per-pool write at usage-meter.sh:666. While there, audit `meter_remote_snapshot_total` for any command that can raise an un-enumerated exit code under the caller's `set -euo pipefail` and give it an explicit `return 9` (or new code) instead of falling through to bash's default.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T21:52:46Z
