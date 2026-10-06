---
arc: garden-upkeep
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build on kriskowal/garden `main2` (direct push, no PR): finish stage 5 of the `jobs/tada/` date-sharding chain, which stopped when `garden-tada-shard-orchestration` halted at stage 3. Two things are already true today: `journal2` has zero flat `jobs/tada/*.md` entries left, and completions are written under `tada/<yyyy>/<mm>/<dd>/`. First confirm both, then remove the stage-2 flat-path read fallback while keeping the centralized `common.sh` tada helpers, add the recent-completions affordance the `garden-tada-shard-01-design` report specifies, run the job-system test suites, and say in the report that the parked `garden-tada-shard-04-migrate` and `garden-tada-shard-05-cleanup` plan entries are superseded.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T17:05:47Z
