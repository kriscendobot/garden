---
posted_at: 2026-11-16T07:51:07Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
scripts/jobs/budget-level.sh:490–494 freezes cleric allocation and logs the same warning every tick; 2026-11-16T07:50:12 shows a host persistently above its cap. Route this failure through `report_freeze`/`report_unfreeze` with a stable cleric preflight key, matching the monk path at lines 172–181, so one onset alert and one recovery are emitted rather than repeated supervisor noise.

<!-- garden-reaped: 0 -->

<!-- garden-transient-elapsed: kind=exit0 through=0 values=57 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-16T08:03:40Z
