---
ts: 2026-05-14T14:53:38Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
---

# Dispatch: shepherd drives PR #243 CI to green

Dispatch root: `/home/kris/dispatches/shepherd--76015f` at `chore/eslint-numeric-separators-style` head `6b738ccc5`.

Trigger: post-weaver-rebase CI converged at 21 SUCCESS + 5 FAILURE. Failures: `lint`, `test-ocapn-guile-interop`, `test`, `viable-release (20.x ubuntu)`, `viable-release (24.x ubuntu)`.

The viable-release failures match the base-staleness class the shepherd resolved on PR #135 (commits `bc599604` and `b0f02f656`). Lint may be a related staleness or a real issue.

Per-action authorization: push fix commits to chore/eslint-numeric-separators-style.

Task: diagnose each failure (). Apply smallest fix per the shepherd role. Push. Verify CI converges green. Hard escalation: >5 files, workspace structure, or substantive logic rewrite → handoff via message.

NOT in scope: address panel must-fix items (handled in prior fixer iters); convert PR out of draft (judge); workflow file edits.

Report: per-failure diagnosis + fix SHAs, final CI rollup, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/shepherd--76015f"` on return.
