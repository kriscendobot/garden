Implemented and pushed commit `5acfa4b1fc2` to `main2`.

- Recognizes matching coalesced gauntlet `review-budget-reached` notices as informational.
- Prevents unrelated notices or additional fleet work from bypassing the gate.
- Keeps the async follow-up sweep consistent with completion gating.
- Added regression coverage for gate and sweep behavior.
- Focused tests, syntax checks, ShellCheck, and diff checks passed.
- Broader suite encountered unrelated existing scaler/plan-queue failures and a concurrent fixed-path gauntlet-test collision.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-recognize-gauntlet-budget-notice.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 779s

<!-- garden-usage-end -->
