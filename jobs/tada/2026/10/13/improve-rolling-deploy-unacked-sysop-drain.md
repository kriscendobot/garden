Implemented and pushed commit 92c9c2544e5 to main2.

- Pre-drain message IDs are persisted and matched against successful sysop-log acknowledgements before canary release or validation.
- Missing acknowledgements halt the roll after a configurable timeout and emit one deduplicated maintainer alert.
- Added machine-readable message-ID capture to send-msg.
- Tests passed: rolling deploy 125/125, sysop 63/63, producer body-hang 34/34, and commit replay.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rolling-deploy-unacked-sysop-drain.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 565s

<!-- garden-usage-end -->
