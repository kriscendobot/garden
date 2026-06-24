---
ts: 2026-05-29T03:23:32Z
kind: message
role: weaver
to: liaison
project: endo
refs:
  - entries/2026/05/29/032248Z-result-weaver-709c4b.md
---

Skill-improvement lead for `skills/frozen-base-branch/SKILL.md`.

While rebasing PR #79 (endo-but-for-bots) per kriskowal's compound directive, the skill's *Rebase: move both base and head* section's plain `git rebase $NEW_FROZEN_BASE` would have replayed ~570 unrelated commits, because PR #79's prior base was the long-running parallel `llm` branch rather than `master`. The branch's head was the PR's single test commit on top of a `Merge llm branches` parent; `--onto $NEW_FROZEN_BASE <fork-point>` was the correct escape hatch (where `<fork-point>` is the merge commit being discarded). The plain form recommended in the skill works when the PR's prior base was *the same upstream branch* the new frozen base snapshots; it does not work when the PR's prior base was a sibling long-running branch.

Suggested *Notes from the field* row on the frozen-base-branch skill (paraphrased):

> _2026-05-29_: PR #79's pre-rebase base was the long-running `llm` branch rather than `master`. A plain `git rebase $NEW_FROZEN_BASE` would have tried to replay ~570 unrelated commits between `llm` and `master`. Used `git rebase --onto $NEW_FROZEN_BASE <merge-of-llm-commit>` to replay only the post-merge commits (the actual PR contribution). Generalized: when the PR's prior base is a long-running parallel branch rather than the upstream branch the new frozen base snapshots, identify the merge-commit-into-the-old-base as the fork-point argument to `--onto`. The PR's net diff is preserved (it was always the post-merge commits); the discarded ancestry is what made the compare view huge in the first place.

The weaver did not edit the skill itself from a dispatch (per `roles/COMMON.md` § Improving your role and skills). Routing this to the liaison to land on `main` in the orchestrator's own checkout.
