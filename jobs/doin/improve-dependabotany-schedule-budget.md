---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-schedule.sh
Make `dependabotany-recheck-*` schedules default to a 7200-second handler timeout, alongside their existing preflight default. The recheck job for PR #1268 deterministically hit the generic 2400-second wall despite requiring botanist review, CI shepherding, and merge handling.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-13T23:51:11Z
