Fixed and pushed commit `ff8840946e5` to `main2`.

- Sweeper now preserves bases with current `doin`, `todo`, or non-doomed `plan` records.
- Repository locks are acquired before the final process-liveness check and destructive removal.
- Hardened `/proc` liveness detection against `pipefail` false negatives.
- Added regressions for reused bases and processes entering worktrees during lock waits.
- Verified all three worktree-sweeper test suites pass; ShellCheck and diff checks pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-worktree-sweeper-live-claim-reused-base.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 603s

<!-- garden-usage-end -->
