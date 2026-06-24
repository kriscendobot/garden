---
ts: 2026-05-14T02:17:20Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 129
    role: source
---

# Dispatch: fixer redrafts PR #129 title + body per pr-formation skill

Dispatch root: `/home/kris/dispatches/fixer--pr-129-redraft--20260514-021720--cbf766` with the project worktree at `feat/formula-introspection` (head `77193d0d8f698d3d6e647cad41a2d8529cea44dd`).

**Trigger and authorization**: kriskowal review on PR #129 at 2026-05-14T02:16:38Z, CHANGES_REQUESTED: "Please refresh the title and description consistent with standing instructions". The "standing instructions" reference is the pr-formation skill. Same shape as the cycle 9 redraft of PR #128.

**PR state**: OPEN, CHANGES_REQUESTED, kriscendobot-authored. Title: "feat(daemon,cli): formula-type introspection — listWithTypes, inspect, workers tenants (re-opened from #39 under the bot)".

**Task**: redraft title + body per `skills/pr-formation/SKILL.md` and the GitHub PR template (). No code changes. No re-request review (maintainer's directive scoped to refresh; further inline CR items if any are out of scope for this dispatch).

**Per-action authorizations** (from the directive):
- Edit PR #129 title + body via `gh pr edit`.
- Post a top-level neutral comment summarizing the redraft.

Report: new title + body, comment URL, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/fixer--pr-129-redraft--20260514-021720--cbf766"` on return.
