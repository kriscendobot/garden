---
posted_at: 2026-10-31T05:51:29Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
At scripts/jobs/comment-latency-watch.sh:209-259, the low-priority multi-source sweep checks the REST reserve only before collection and still hit primary-quota exhaustion at 2026-10-31 05:31:39Z and 05:39:26Z. Recheck the shared REST cooldown and `gh_rest_budget_defer` between source handlers, stop with a cooldown heartbeat when reserve is reached, and leave remaining quota to acknowledgment watchers.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T06:05:28Z
