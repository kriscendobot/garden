---
ts: 2026-05-13T20:40:48Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 126
    role: source
---

# Dispatch: shepherd drives PR #126 CI to green

Dispatch root: `/home/kris/dispatches/shepherd--pr-126-ci--20260513-204047--1f8d1f` with the project worktree at `ci/no-npm-lifecycle` (head `15c9833f6ef814c4f8f870031cc41f5c5f9ea057`).

**Trigger and authorization**: kriskowal at endojs/endo-but-for-bots#126 (2026-05-13T20:39:52Z): "Please shepherd through CI." Per-action authorizations: push fixup commits to `ci/no-npm-lifecycle`; rerun flaked jobs; post a top-level comment summarizing the green-run URL on success; re-request kriskowal review after CI converges to green.

**PR state**: OPEN, CHANGES_REQUESTED, MERGEABLE. Five failures on the current head:
- `lint`
- `test (24.x, macos-15)`
- `viable-release (18.x, ubuntu-latest)`, `(20.x, ubuntu-latest)`, `(24.x, ubuntu-latest)`

The lint failure is the most likely real signal (deterministic). The macos-15 single-matrix failure may be a flake. The three viable-release failures sharing the same workflow may share a root cause.

Task: drive CI to green per `roles/shepherd/AGENT.md`. Diagnose each failure category, fix in atomic commits per concern, rerun flakes selectively, push and verify. Hard escalation points per role: stop if a failure needs a public-API rewrite, workspace structure change, or more than ~5 files of fix; hand off to a fixer in that case.

**Out of scope**: address the older CHANGES_REQUESTED inline items (the directive was CI-shepherd, not fixer); convert the PR state.

Report: per-failure diagnosis + fix SHA, the final CI rollup state, the re-request response if applicable, and a one-line `Self-improvement: ...`.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/shepherd--pr-126-ci--20260513-204047--1f8d1f"` on return.
