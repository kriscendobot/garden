---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
Treat a timed-out shared cursor-IO lock as temporary unavailability (with one bounded diagnostic), not a fatal failure; the lock wedge blocked cursor advancement across watchers for five minutes and contributed to repeated retry noise. Remove the misleading manual lock-file deletion advice and add safe holder/recovery diagnostics.
