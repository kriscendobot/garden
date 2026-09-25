---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
meter_remote_snapshot_total (usage-meter.sh:585, strict-equality gate at 601/621) rejects a live snapshot outright whenever the locally-computed `cutoff` disagrees with the file's own `window_start_epoch`, even when pool/cap/spend/timestamps all match — `_meter_snapshot_mismatch` (usage-meter.sh:570) reports `diverged=window` alone. Two consecutive budget-level ticks (2026-09-25 01:35 and 01:50) hit exactly this for pool=claude-oros host=oros-studio-garden, discarding a well-formed spend reading both times and falling to fail-open with no leveling signal for that host/pool. The reader computes its expectation via `subscription_window_start_epoch` on a possibly-stale journal-recorded reset fact, while the publishing host stamps its own live window directly — the publisher is the authoritative source for its own subscription's reset boundary, so a window-only divergence (all other fields agreeing) should be accepted using the file's `window_start_epoch`, not treated as a hard mismatch. Change `meter_remote_snapshot_total` so a `diverged=window`-only mismatch trusts the snapshot's own `w` value instead of returning rc 9, keeping rc 9 for divergence on pool/cap/spend/timestamp fields where the file itself is untrustworthy.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T01:52:35Z
