Implemented and pushed commit `ff85753daf5` to `main2`.

- Normalized inline `JOB <slug> <body>` and trailing `ENDJOB` tokens before parsing.
- Preserved fail-closed rejection and no-provider-fallback behavior for malformed replies.
- Tightened the mentor prompt to require standalone delimiter lines.
- Added the exact rejected capture as a fixture plus inline and unterminated-block coverage.
- Verification: `mentor-provider-order-test.sh` passed all 53 checks; `git diff --check` passed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-inline-endjob-parse.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 341s

<!-- garden-usage-end -->
