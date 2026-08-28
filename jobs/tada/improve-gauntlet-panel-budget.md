Raised staged-gauntlet panel timeout from 7,200s to 10,800s, preserving ~1 hour of claim-TTL headroom. Added regression coverage for the new default and claim-sized invariant.

Verified:
- `gauntlet-test.sh`: 38 passed
- `build-handler-budget-test.sh`: 26 passed
- Bash syntax and `git diff --check`: passed

Pushed commit `d77ddca3ab` to `main2`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-panel-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 44 tokens (1400732 cached reads)
- Output: 9928 tokens
- Cost: $1.5273890000000003 (1 engagement(s) unpriced)
- Wall-clock: 303s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
