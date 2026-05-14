---
ts: 2026-05-14T09:42:44Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 135
    role: source
---

# Dispatch: shepherd drives PR #135 lint failure to green

Dispatch root: `/home/kris/dispatches/shepherd--699c9b` at `feat/mount-core` head `612dc601fd57317755af18c1cfb8c74edd07e66a`.

**Trigger**: post-fixer CI converged with 22/23 SUCCESS + 1 FAILURE on `lint`. The fixer's local lint passed; the CI failure is environment-specific. Judge re-dispatch is blocked until CI green; shepherd's lane.

**Per-action authorizations**: push fixup commits to feat/mount-core. No comment/re-request authority needed for this dispatch (the upstream maintainer review is on the bot-self panel's verdict cycle; the judge re-dispatches the panel once CI is green).

**Task**: diagnose the lint failure (), apply the smallest fix per the shepherd role, push, verify the next CI run lands green. Hard escalation: if the fix needs more than ~5 files or a workspace structure change, hand off via message-to-liaison.

Report: failure root cause, fix SHA, final CI rollup, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/shepherd--699c9b"` on return.
