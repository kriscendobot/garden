once: 2026-08-18T15:00:00Z
job_basename_prefix: mtown-git-remote-followup-notice-recheck-20260818
---
---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Notice: recheck the minion.town git-remote follow-up on the daemon commit-formula design

This is the notice (sentinel) job of the D->N->F chained follow-up in skills/chained-followup/SKILL.md, re-armed on a short once: schedule because the design had not yet advanced to a build at the last check.

D is ebfb-daemon-commit-formula-design. Its design PR is https://github.com/endojs/endo-but-for-bots/pull/988.

Use gh read-only metadata, not comment prose, to determine whether PR #988 has advanced to a build: a build PR referencing or implementing the design has opened, or the design merged and a build is underway. Cross-reference timeline metadata is the preferred mechanical link check (gh api repos/endojs/endo-but-for-bots/issues/988/timeline).

If advanced to build, post F with post-job.sh using base mtown-git-remote-commit-formula-act and this exact body:
Act on the daemon-native commit formula in minion.town's capability-addressed git remote (design/git-remote-capability). Name the endo-but-for-bots build PR/commit that landed. Update designs/git-remote-capability.md §4 (Strategy B) to reflect git commit/tree/tag identity through the new daemon commit formula — synthetic refs tree rooted at a formula identifier, name-hub lookup paths ending in a readable-tree, synthetic orphan commits enveloping the readable-tree — and carry the design to the implementation increment. Origin review: https://github.com/kriscendobot/minion.town/pull/41#pullrequestreview-4939454650

If not yet built, re-arm this notice again on a short once: schedule (scripts/jobs/set-schedule-once.sh). If the design was declined (PR #988 closed unmerged), end the chain, message the maintainer through message-user.sh, and do not post F.
