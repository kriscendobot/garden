Implemented and pushed `c51989b1ca` to `main2`.

- Added deterministic orchestration child-stall detection for requeue growth, excessive requeues, and expired handler budgets.
- Stall failures now follow existing child-failure policy and name the child/host/reason in halt notices.
- Added hermetic regression coverage; `orchestrate-test.sh`: 18 passed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-orchestrate-child-stall-detection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 496s

<!-- garden-usage-end -->
