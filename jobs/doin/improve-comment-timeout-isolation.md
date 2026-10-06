---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1846 treats one source timeout as a host-wide gh-api outage; at 2026-10-06T07:24:24Z this suppressed an unrelated proposal-compartments poll. Keep timeout backoff per slug and open the shared cooldown only when stderr positively identifies a shared network or quota failure.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T07:52:14Z
