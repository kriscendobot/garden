Implemented and pushed commit `2e8c68b417` to `main2`.

- Added a host-local outage latch for live budget snapshot publication.
- First failure emits a WARN; repeated failures are counted silently.
- Recovery emits one summary with failure count, duration, and outage start.
- Publication remains fail-open.
- Added regression coverage for warning deduplication, recovery, and re-arming.

Verification:

- New regression test passed.
- Live-budget admission suite: 17/17 passed.
- Scaler desired-count suite: 15/15 passed.
- Full job suite: 378/379 passed; one unrelated issue-inbox stderr assertion failed.
- Bash syntax, targeted ShellCheck, and `git diff --check` passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-snapshot-warning-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 273s

<!-- garden-usage-end -->
