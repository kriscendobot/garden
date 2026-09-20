---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Treat cursor-set’s GARDEN_OFFLINE_RC as a quiet, retry-next-tick journal-outage result, matching cursor reads; retain loud diagnostics for structural cursor failures. This prevents one shared transient journal outage from producing repeated per-repo cursor-advance warnings.
