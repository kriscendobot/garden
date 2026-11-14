---
posted_at: 2026-11-14T05:51:29Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/foreman.sh
Defect: lines 412-419 suppress the promotion error and repeatedly select the same paused deferred job, while lines 737-740 turn the same `rc=78` refusal into a failed service; observed from 04:25:54 through 05:49:09. Detect `GARDEN_PAUSED_RC` explicitly, exclude paused-project candidates from this tick’s deferred admission, and record a nonfatal decision instead of failing the unit or starving other eligible work.
