---
posted_at: 2026-11-01T05:20:32Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/unblock.sh
The push-retry loop at unblock.sh:89 runs up to `GARDEN_POST_ATTEMPTS` (50) times with no wall-clock limit. `post-job.sh:354-356` already bounds the same loop with `GARDEN_POST_DEADLINE_SECS` (default 300s) and exits rc=75. The unbounded watchdog-notice.sh loop held the producer journal clone lock for 30 minutes (04:15-04:45 on 2026-11-01), and the fix in `7a27474163b` covered only that script. Add the same `post_loop_start`/`SECONDS` deadline check to this loop and exit with `GARDEN_OFFLINE_RC` when it expires. Ideally extract a shared helper in `common.sh` so the other unbounded loops (`post-orchestration.sh:315`, `annotate-plan`, `remove-schedule`, `withdraw-plan`, `review-miss-record`, `mirror-closer`, `record-mirror`) can adopt it. Add a regression test covering an unreachable journal.

<!-- garden-reaped: 0 -->
