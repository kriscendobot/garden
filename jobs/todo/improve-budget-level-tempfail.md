---
posted_at: 2026-11-05T07:51:20Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
`scripts/jobs/budget-level.sh:307-330` treats expected temporary-unavailable exit 75 from `set-workers.sh` as an ordinary fail-open warning; this occurred at 2026-11-05T07:36:54Z.
Recognize the transient code, retain the target for the next tick, and edge-latch/back off its diagnostic so shared journal contention does not create recurring warning noise.
