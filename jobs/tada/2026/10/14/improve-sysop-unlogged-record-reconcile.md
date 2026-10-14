Implemented and pushed commit `0debaa84528` to `main2`.

- Added deterministic reconciliation for seen-but-unlogged sysop operations using terminal `reconciled-seen` records, without re-execution.
- Added the exact stale 2026-09-26 oros drain fixture and documented the outcome.
- Checks passed: sysop tests 65/65; worker-derotate tests 21/21; ShellCheck, syntax, and diff checks.
- Follow-up: deploy `main2` so affected hosts reconcile legacy gaps on their next sysop tick.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-sysop-unlogged-record-reconcile.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 396s

<!-- garden-usage-end -->
