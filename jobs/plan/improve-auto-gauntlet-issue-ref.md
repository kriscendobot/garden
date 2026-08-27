---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 100000
doomed: true
doom_signature: elapsed-constancy
doom_count: 1
requeue_cycles: 4
deadline_overruns: 0
elapsed_constancy_confirmations: 2
doomed_at: 2026-08-27T23:33:04Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-27T23:33:04Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
Treat a report reference that GitHub definitively says is not a pull request as an issue citation and skip gauntlet inspection. Two completed issue-driven jobs cited `kriscendobot/garden#58`, then failed on the same `PullRequest` GraphQL lookup and were unnecessarily requeued.
