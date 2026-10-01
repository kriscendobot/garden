---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In kriscendobot/garden, fix `scripts/jobs/ci-wait-merge.sh` to compare only the latest check run per check name (not every entry) when deciding CI status, so a stale cancelled run on an otherwise-green commit no longer reads as red.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T15:06:23Z
