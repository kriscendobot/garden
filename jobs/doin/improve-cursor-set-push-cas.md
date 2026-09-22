---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
Classify ordinary non-fast-forward journal push rejections as CAS contention and retry/reconcile them, instead of surfacing “failed to push some refs” as a definite repair-only cursor failure. Keep authentication, permissions, and server-side rejections loud; add a fixture for this push diagnostic.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T13:53:00Z
