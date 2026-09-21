---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ci-wait-merge.sh
When the live PR `headRefOid` differs from the post-rebase head, terminate promptly with an explicit head-changed/re-enqueue outcome instead of polling the unreachable OID until timeout. Add coverage for an authorized concurrent force-push.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-21T23:22:55Z
