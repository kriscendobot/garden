---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
Isolate each pool’s read/actuation failure so one failed worker-level update cannot abort the whole controller tick; log the pool, host, failed operation, and exit status, while preserving fail-open behavior for other pools and scheduled dispatch.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-23T04:21:17Z
