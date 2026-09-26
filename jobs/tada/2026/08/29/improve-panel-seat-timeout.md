Implemented and pushed commit `85fa0da92b` to `main2`.

- Added configurable per-seat timeouts, clamped below the applied panel handler budget.
- Timed-out seats are deterministically classified and retried.
- Preserved stderr from every attempt in per-seat diagnostics.
- Added regression coverage for recovery, exhaustion, stderr retention, and budget clamping.
- Updated the panel skill documentation.
- Verified all panel tests, handler-budget tests, ShellCheck, and clean diff checks pass.

Follow-ups: none.

Self-improvement: `skills/panel/SKILL.md`; documented bounded seat execution and timeout diagnostics.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-panel-seat-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 361s

<!-- garden-usage-end -->
