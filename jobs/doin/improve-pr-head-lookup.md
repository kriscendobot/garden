---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ensure-pr.sh
Replace the capped all-open-PR marker scan with a targeted head-branch lookup or pagination. A repository with 200 open bot PRs makes a known branch’s PR lookup inconclusive and blocks repair automation unnecessarily.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T08:28:18Z
