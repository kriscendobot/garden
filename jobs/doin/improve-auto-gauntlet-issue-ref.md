---
tier: mentor
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T20:54:30Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
Treat a report reference that GitHub definitively says is not a pull request as an issue citation and skip gauntlet inspection. Two completed issue-driven jobs cited `kriscendobot/garden#58`, then failed on the same `PullRequest` GraphQL lookup and were unnecessarily requeued.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T20:54:43Z
