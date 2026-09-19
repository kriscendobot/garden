---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Atomically latch journal-read outages and expose a temporary-unavailable result so cursor consumers can skip quietly during the shared cooldown, instead of every triager/comment watcher repeatedly fetching and warning per repo. Preserve loud structural/authentication failures.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T15:51:34Z
