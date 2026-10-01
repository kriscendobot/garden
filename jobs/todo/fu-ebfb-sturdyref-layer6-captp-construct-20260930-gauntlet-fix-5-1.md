---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In kriscendobot/garden, fix `scripts/jobs/ci-wait-merge.sh` to compare only the latest check run per check name (not every entry) when deciding CI status, so a stale cancelled run on an otherwise-green commit no longer reads as red.
