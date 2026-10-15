Implemented and pushed commit `bf605277e30` to `main2`.

- Bounded spool draining to reserve half the transaction window for the requested operation.
- Added regression coverage for a hung spool head followed by `reenter`, confirming reentry is attempted and safely retained on timeout.
- Passed `review-docket-test.sh`, `review-docket-reconcile-test.sh`, syntax checks, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-docket-spool-starvation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 207s

<!-- garden-usage-end -->
