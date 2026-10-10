---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket.sh
The transaction lock wait at review-docket.sh:420-422 dies with FATAL after 180s (seen 2026-10-10T03:51:51Z) and drops the intake operation. Whatever is holding the lock was not diagnosed. Before `die`, record the holder, either by writing its PID and operation into the lock file or by reading `fuser`/`/proc/locks`, and include that and the wait time in the message. Then make timeout non-fatal for queue producers: write the operation to a host-local spool and exit with a distinct retryable rc. Drain that spool at the start of the next successful transaction, so intake is not lost. Also add a `timeout` around the push and CAS in the lock-holding section so a hung push cannot hold the lock past the wait window.
