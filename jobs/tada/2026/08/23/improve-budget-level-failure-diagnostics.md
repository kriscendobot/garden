Implemented and pushed commit 3e4d4a54bc to main2.

- Scheduler now captures the budget-level controller’s stderr and exit status.
- Failures retain detailed scheduler logs and raise one throttled, coalesced, actionable maintainer alert.
- Recovery closes and re-arms the alert episode.
- Added regression coverage: 14/14 targeted tests pass.
- Full suite: 376 passed; one unrelated issue-inbox stderr assertion failed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-failure-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 349s

<!-- garden-usage-end -->
