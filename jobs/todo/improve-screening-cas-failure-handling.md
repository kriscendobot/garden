---
posted_at: 2026-11-07T18:21:05Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/screen-delegated-prs.sh
scripts/jobs/screen-delegated-prs.sh:150 turns an exhausted journal CAS retry into `die`, causing the dedicated unit failure recorded at 2026-11-07T17:50:45Z. Preserve the bounded retry and failure streak, but classify contention/transient journal failures as a clean, deferred tick after recording the coalesced watchdog state; reserve nonzero exit for unrecoverable local faults.


<!-- garden-transient-elapsed: kind=exit0 through=0 values=26 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-07T18:53:09Z -->
