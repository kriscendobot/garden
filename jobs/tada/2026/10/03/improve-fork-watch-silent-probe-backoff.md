Implemented and pushed commit `0f66db1f2d8` to `main2`.

- Preserved probe exit codes in failure diagnostics, including silent `rc=2`.
- Added exponential silent-probe cooldown escalation, capped at 3600 seconds and reset by success.
- Preserved fail-open behavior for unknown upstream state.
- Updated design documentation and regression coverage.
- Verification: targeted suite passed 87/87; Bash syntax, ShellCheck warning-level, and diff checks passed. Broader job-system suite exposed three unrelated existing failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-silent-probe-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 688s

<!-- garden-usage-end -->
