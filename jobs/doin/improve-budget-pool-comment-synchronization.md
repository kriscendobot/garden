---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-budget-pool.sh
Harden the setter’s comment cleanup to remove or refresh stale pool-specific cap values embedded in shared prose headers, not only host-scoped calibration blocks. The current header still advertises a superseded 595M cap while the authoritative row is 143M, creating recurring operator-confusion risk after deliberate promotions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-11T19:21:10Z
