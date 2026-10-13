---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
scripts/jobs/approval-reconciler.sh:647-650 aborts the entire suffix after #180’s 60s approval timeout at 2026-10-13T09:07:36Z, deferring 47 later PRs every tick.
Persist a bounded per-PR/stage cooldown after a timeout, skip that probe while its cooldown is live, and clear it on a successful probe so later PRs continue to reconcile; add deterministic coverage for progress past a repeatedly slow PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-13T09:37:10Z
