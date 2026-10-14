Implemented and pushed commit f34f023699a to main2.

- Normalized `GARDEN_OFFLINE_RC` from review-docket reconciliation to exit 0 while logging that the next timer tick will retry.
- Preserved non-transient failure exit codes.
- Added regression coverage for default/custom offline codes, retry logging, success, and non-transient failures.
- Verified with ShellCheck, `review-docket-reconcile-test.sh`, and `review-docket-test.sh`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-transient-exit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 121s

<!-- garden-usage-end -->
