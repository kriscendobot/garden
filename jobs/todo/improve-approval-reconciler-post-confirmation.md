---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
Capture and classify `post-job.sh` failures instead of discarding them; use a bounded retry/backoff and re-fetch confirmation before deferring to the next 15-minute tick. This prevents a transient journal push/fetch race from delaying an approved PR’s shepherd job while retaining actionable diagnostics.
