---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
Treat a report reference that GitHub definitively says is not a pull request as an issue citation and skip gauntlet inspection. Two completed issue-driven jobs cited `kriscendobot/garden#58`, then failed on the same `PullRequest` GraphQL lookup and were unnecessarily requeued.



<!-- garden-reaped: 3 -->

<!-- garden-elapsed-constancy: 2 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T23:23:28Z
