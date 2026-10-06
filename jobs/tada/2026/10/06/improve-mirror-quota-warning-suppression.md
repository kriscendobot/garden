Implemented and pushed commit `0ae291ef036` to `main2`.

- Primary-quota refusals now suppress captured handler diagnostics and per-mapping warnings, leaving only the aggregate cooldown warning.
- Added regression assertions covering single-warning behavior and diagnostic suppression.
- Verified with syntax/diff checks and `mirror-closer-test.sh --no-e2e`: 79 passed, 0 failed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-quota-warning-suppression.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 173s

<!-- garden-usage-end -->
