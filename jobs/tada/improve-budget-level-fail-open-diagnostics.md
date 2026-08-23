Implemented and pushed commit `c1992d94bc` to `main2`.

- Isolated per-pool spend reads, host-capacity reads, target calculation, and local/remote actuation failures.
- Added diagnostics containing pool, host, failed operation, and exit status.
- Preserved later pool processing and scheduled-dispatch fail-open behavior.
- Added regression coverage for local/remote actuation failures, read failures, and scheduled exit semantics.
- Verification: `live-budget-admission-test.sh` passed all 11 tests; Bash syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-fail-open-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 212s

<!-- garden-usage-end -->
