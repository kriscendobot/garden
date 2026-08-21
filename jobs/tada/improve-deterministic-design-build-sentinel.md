Implemented and pushed commit `0781a825de` to `main2`.

- Added declarative `DESIGN-BUILD-RECHECK` handling that bypasses the agent classifier.
- Uses typed GitHub PR and cross-reference timeline metadata only.
- Deterministically posts the fixed follow-up, re-arms a one-time schedule, or messages the maintainer when closed unmerged.
- Added regression fixtures covering all outcomes, agent bypass, and metadata failure.
- Targeted test passed. Full job-system suite: 372 passed; one unrelated issue-inbox stderr assertion failed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deterministic-design-build-sentinel.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 555s

<!-- garden-usage-end -->
