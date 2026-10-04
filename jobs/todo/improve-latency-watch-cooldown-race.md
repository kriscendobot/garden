---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
scripts/jobs/comment-latency-watch.sh:192-202 logs one failure per repository when a sibling opens the REST quota latch mid-sweep (2026-10-04 01:42:05-07). Recheck the shared REST cooldown after a source failure, stop the sweep quietly, and record a cooldown heartbeat; add a race-regression test.
