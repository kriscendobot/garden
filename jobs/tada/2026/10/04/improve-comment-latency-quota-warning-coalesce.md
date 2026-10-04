Implemented and pushed commit `350d6bc198c` to `main2`.

- Primary-quota source stderr is now captured and suppressed.
- The coordinator emits one warning with repository/source context before cooldown.
- Added regression coverage for warning coalescing, context, and stderr suppression.
- Passed comment-latency tests, ShellCheck, syntax checks, and diff checks.
- Broader checks exposed an unrelated pre-existing accountant-role information-hiding failure.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-latency-quota-warning-coalesce.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 317s

<!-- garden-usage-end -->
