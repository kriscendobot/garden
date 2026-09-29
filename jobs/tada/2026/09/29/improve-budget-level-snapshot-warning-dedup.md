Implemented and pushed commit `7b2d6a401c8` to `main2`.

- Added persistent remote-spend failure latches keyed by pool, host, operation, and reason.
- Repeated warnings are suppressed and counted; valid snapshots emit recovery summaries and re-arm the latch.
- Added focused stale-snapshot, field-mismatch, recovery, and re-arm coverage to CI.
- Tests passed: new regression, proportional leveling (9/9), adjacent warning-latch tests, Bash syntax, and ShellCheck.
- Follow-up: the broader live-budget suite retains three unrelated stale `gardener`-versus-`monk` expectations (55 other checks passed).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-snapshot-warning-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 448s

<!-- garden-usage-end -->
