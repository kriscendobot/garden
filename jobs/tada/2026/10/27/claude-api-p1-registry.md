Completed Phase 1 in draft PR [endojs/endo-but-for-bots#1573](https://github.com/endojs/endo-but-for-bots/pull/1573), head `43bf47ffcb`.

- Added the durable owner-scoped provider registry, attenuated facets, secret retention, reconciliation, supersession, retirement, audit history, and crash-boundary coverage across `@endo/hosted-agent` and `@endo/daemon`.
- Reconciled the implementation and PR body with the settled Anthropic-only phase-one policy.
- Isolated `yarn.lock` in commit `9082f29c91`; the resulting source tree is byte-identical to the prior tested head.
- Verified 853 hosted-agent tests, deterministic pre-push gates, diff checks, and design/phase gates. The prior focused run records 28 daemon tests passing; this session’s restart rerun was blocked by a reported garden cache Node-ABI mismatch.
- Updated arc tracker #227 and retained its maintainer review request. Current unrelated CI failures are missing `tred` and sandbox shell support; the staged gauntlet/shepherd owns follow-up.
- Self-improvement: reported the project-worktree native-module cache ABI mismatch to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-api-p1-registry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 7631s

<!-- garden-usage-end -->
