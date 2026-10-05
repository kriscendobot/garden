---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/pages-watcher.sh
scripts/jobs/pages-watcher.sh:284 warns and retries every 120 seconds on transient network loss (journalctl 2026-10-05T12:50:25Z) without joining the host-wide API cooldown. Add the preflight cooldown check and atomically latch it on transient network/API-source failures so sibling watchers quiet collectively while preserving fail-closed state. Extend pages-watcher tests for cooldown ownership and silent skip during a live latch.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T13:21:57Z
