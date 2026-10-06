Implemented and pushed commit `25d00928de4` to `main2`.

- Bounded notice delivery, clone remediation, and cleanup by the remaining tick budget.
- Persisted deferred notices, remedies, cleanups, and clone inspections for retry.
- Ensured heartbeat records deferred-work counts before exit.
- Added timeout regressions for hung notice delivery and clone rebuilding.
- Verified with `bash scripts/jobs/test/journal-contention-watch-test.sh` and shell syntax checks.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-contention-watch-time-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 454s

<!-- garden-usage-end -->
