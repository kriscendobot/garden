Root cause: the child’s `tada` report existed and carried `orchestration-failed: true`; the halt commit descended from and contained that report. `child_state` therefore correctly detected a gated failure, but `child_failure_detail` ignored `tada/` and falsely described it as “vanished.” This eliminates stale sync and partial commit application as causes of this incident.

Changed:

- Board classification now reads all child locations from one immutable Git commit tree. Unreadable or duplicate/inconsistent locations retry next tick.
- Failure details distinguish completed-but-gated-failure from genuine disappearance.
- Halts preserve downstream children in `plan/` under their held orchestrated gate.
- Updated orchestration role, skill, and design documentation.
- Restored all 21 swept children, still parked and unarmed, in journal commit `de9c9f85a7`.
- Pushed implementation commit `df2226c2b8` to `main2`.

Verification: `scripts/jobs/test/orchestrate-test.sh` passed 39/39, including half-applied-checkout, inconsistent-board retry, gated-tada reporting, and non-destructive halt regressions. Syntax and diff checks passed.

Follow-up: deploy `main2` before the watcher fix is live. The campaign was not relaunched.

Self-improvement: `skills/orchestration/SKILL.md`, `roles/orchestrator/AGENT.md`, and `designs/orchestration-jobs.md`; recorded atomic snapshot reads and recoverable halt behavior.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-vanished-false-positive-and-sweep.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 495s

<!-- garden-usage-end -->
