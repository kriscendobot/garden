Implemented and pushed commit `7ff6f44ce68` to `main2`.

- `post-job.sh` now stamps `handler-budget-role: builder` on automatic `-build` and `-build-<n>` jobs lacking explicit execution-budget metadata.
- Explicit roles/timeouts and manual or canary jobs remain unchanged.
- Added regression coverage; focused suites passed 98 checks. Repository checks passed all 13 suites.
- The broad legacy test harness reported 24 unrelated existing failures among 387 passes.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-build-job-budget-inference.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 691s

<!-- garden-usage-end -->
