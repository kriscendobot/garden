---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
Before dispatching a due Dependabot recheck, deterministically run the existing declaration-compatibility oracle against its live PR and route a proven runtime-engine conflict to the cheap reverify-and-close path. PR #1174 required an agent to rediscover that `better-sqlite3@13` excludes the repository’s advertised Node 20 support; scheduled rechecks should not rely on that judgment.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-07T04:51:07Z
