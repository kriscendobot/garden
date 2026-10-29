Implemented and pushed commit `020321e1e9e` to `main2`.

- Added a bounded, concurrent immediate retry for units found inactive by coherent-release verification.
- Re-verifies after retry; recovered units no longer produce warnings, while surviving stragglers do.
- Added transient-recovery and persistent-survivor regression coverage.
- Tests passed: `deploy-release-boundary-test.sh` (23/23) and `deploy-garden-test.sh` (224/224).
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-coherent-release-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 233s

<!-- garden-usage-end -->
