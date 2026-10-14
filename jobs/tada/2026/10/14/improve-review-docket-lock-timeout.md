Implemented and pushed commit `c80a362ec80` to `main2`.

- Bare reconcile lock waits/window exhaustion now preserve the cursor, log deferral, and exit successfully.
- Intake lock failures remain retryable and spooled.
- Added coverage for lock-wait and in-transaction timeout outcomes.
- Verified with Bash syntax checks and both review-docket test suites; all passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-lock-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 149s

<!-- garden-usage-end -->
