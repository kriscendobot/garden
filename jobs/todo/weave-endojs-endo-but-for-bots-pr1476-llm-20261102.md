---
role: weaver
tier: mentor
arc: minion-town-mcp-ocapn
posted_at: 2026-11-02T00:08:36Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-02T00:11:40Z cleared=none -->

---
role: weaver
arc: minion-town-mcp-ocapn
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Weave endojs/endo-but-for-bots#1476 onto current llm (pin the merge base)

PR: https://github.com/endojs/endo-but-for-bots/pull/1476 (draft; Phase 1 of the ocapn-noise session-reconnect stack #1476 → #1478 → #1481 → #1482 → #1483).

Pin the merge base: snapshot the current `llm` tip to a new frozen `llm-<short-sha>`, rebase head `build/ocapn-noise-session-reconnect-heartbeat` (now 3a1750f777) onto it, resolve conflicts, force-push the head, and move the PR's base field to the new snapshot (skills/frozen-base-branch, skills/verify-upstream-state-before-pinning).

Why: the PR's base `llm-61cd656` (2026-10-16) predates llm commit 27705a4cdf ("test(sandbox): fix Linux resource limit and cleanup assertions"). Since `ubuntu-latest` moved to Ubuntu 26.04, every PR on that base goes red in `sandbox-drivers`, `test (22.x/24.x, ubuntu-latest)` and `cover` with `bwrap › prlimit nproc cap…` (`/bin/sh: ulimit: Illegal option -u`) and `bwrap › bwrap parent death leaves no owned process group`. #1476 was last green 2026-10-17, before the image switch. The dependent #1478's gauntlet halted on that red. Watch CI on the new head to green with `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1476 --no-merge`; any remaining red must be investigated, not waived.

Do not touch the dependent PRs; a separate child weaves #1478 next. Leave the PR draft. In your report, name the new #1476 head SHA.

<!-- garden-reaped: 0 -->
