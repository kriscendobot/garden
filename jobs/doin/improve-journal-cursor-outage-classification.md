---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Harden journal-fetch failure classification so the simultaneous rc=1 cursor-read failures latch as one temporary journal outage and make sibling watchers skip quietly, while preserving genuinely local clone/auth failures as loud diagnostics.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-19T16:51:21Z
