---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/promote-plan.sh
Before promoting an orchestrated child, preserve or require execution metadata for long-running named stages; specifically prevent a `*-shepherd-*` child without `role: shepherd` or an equivalent handler budget from entering `todo/` at the 2400s default. PR #796’s orchestrated shepherd child deterministically overran that wall.
