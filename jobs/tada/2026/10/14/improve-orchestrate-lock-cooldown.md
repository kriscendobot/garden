Implemented and pushed commit `faaa481f33b3` to `main2`.

- Added bounded soft lock acquisition and an orchestrate-specific cooldown.
- Concurrent/repeated ticks now defer cleanly without warning churn.
- Added regression coverage for contention, cooldown expiry, and cooldown isolation.
- Verification: orchestration suite passed 82/82; syntax, ShellCheck, and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-orchestrate-lock-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 958s

<!-- garden-usage-end -->
