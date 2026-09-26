Implemented and pushed commit `4641213040` to `main2`.

- Long project-worktree job bases now use a bounded 20-character key with a stable 12-hex hash suffix; short bases remain unchanged.
- Existing long-path worktrees migrate to the bounded path while preserving in-flight changes.
- Updated reaper protection, usage metering, and progress detection for bounded and legacy paths.
- Added regression coverage for bounds, isolation, deterministic resume, and legacy migration.
- Verification: project-worktree isolation 42/42, botanist worktree 7/7, productive-cycle 10/10; shell syntax and diff checks passed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-project-worktree-socket-paths.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 374s

<!-- garden-usage-end -->
