Implemented bounded budget snapshot publication retries and pushed commit `df216978f3` to `main2`.

- Re-syncs and rebuilds the cadence-bucketed snapshot after a lost journal CAS.
- Defaults to three bounded attempts with jittered backoff.
- Preserves fail-open behavior after retry exhaustion or resync outages.
- Added regression coverage for transient push races, rebuilt state, and bounded persistent failure.
- Verified with ShellCheck, syntax checks, live-budget admission tests, warning-dedup tests, and the new retry test.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-snapshot-publish-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 271s

<!-- garden-usage-end -->
