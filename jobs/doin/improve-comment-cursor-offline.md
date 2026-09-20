---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Treat cursor-set’s GARDEN_OFFLINE_RC as a quiet, retry-next-tick journal-outage result, matching cursor reads; retain loud diagnostics for structural cursor failures. This prevents one shared transient journal outage from producing repeated per-repo cursor-advance warnings.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-20T03:21:44Z
