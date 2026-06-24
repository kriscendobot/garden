---
ts: 2026-05-14T05:40:49Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
---

# Dispatch: fixer redrafts PR #109 title + body per pr-formation skill

Dispatch root: `/home/kris/dispatches/fixer--pr-109-redraft--20260514-054048--3edfcc` with the project worktree at `feat/syrups-package` (head `642ce3fd6b8c5ff0d3cae7657eaa42145810662a`).

**Trigger and authorization**: kriskowal at endojs/endo-but-for-bots#109 (2026-05-14T05:39:51Z): "PR title and description need an update."

This is the third instance of the same pattern (#128 cycle 9 fixer; #129 earlier this cycle). The maintainer is normalizing PR title + body shape across the open queue. Dispatch shape identical to those precedents.

**Task**: redraft title + body per `skills/pr-formation/SKILL.md` and the GitHub PR template. No code changes. No re-request review.

**Per-action authorizations**: edit PR title/body; post a neutral top-level comment summarizing the redraft.

Report: new title, new body, comment URL, one-line self-improvement.

Teardown: steward runs `skills/dispatch-worktree/dispatch-teardown.sh "/home/kris/dispatches/fixer--pr-109-redraft--20260514-054048--3edfcc"` on return.
