---
withdrawn: true
withdrawn_reason: the sentinel's question is already answered and its blocker is elsewhere: it exists to detect whether endojs/endo-but-for-bots#988 advanced to a build, and #988 is OPEN/draft/CONFLICTING and untouched since 2026-08-14. Re-arming would re-ask a question gated on #988's conflict; posted endojs-endo-but-for-bots-pr988-weave-20260901 instead (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:40:08Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: gardener
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-21T23:03:04Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-21T23:03:04Z
---

---
role: gardener
tier: minion
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-21T22:18:56Z cleared=none -->

---
role: gardener
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Notice: recheck the minion.town git-remote follow-up on the daemon commit-formula design

This is the notice (sentinel) job of the D->N->F chained follow-up in skills/chained-followup/SKILL.md, re-armed on a short once: schedule because the design had not yet advanced to a build at the last check.

D is ebfb-daemon-commit-formula-design. Its design PR is https://github.com/endojs/endo-but-for-bots/pull/988.

Use gh read-only metadata, not comment prose, to determine whether PR #988 has advanced to a build: a build PR referencing or implementing the design has opened, or the design merged and a build is underway. Cross-reference timeline metadata is the preferred mechanical link check (gh api repos/endojs/endo-but-for-bots/issues/988/timeline).

If advanced to build, post F with post-job.sh using base mtown-git-remote-commit-formula-act and this exact body:
Act on the daemon-native commit formula in minion.town's capability-addressed git remote (design/git-remote-capability). Name the endo-but-for-bots build PR/commit that landed. Update designs/git-remote-capability.md §4 (Strategy B) to reflect git commit/tree/tag identity through the new daemon commit formula — synthetic refs tree rooted at a formula identifier, name-hub lookup paths ending in a readable-tree, synthetic orphan commits enveloping the readable-tree — and carry the design to the implementation increment. Origin review: https://github.com/kriscendobot/minion.town/pull/41#pullrequestreview-4939454650

If not yet built, re-arm this notice again on a short once: schedule (scripts/jobs/set-schedule-once.sh). If the design was declined (PR #988 closed unmerged), end the chain, message the maintainer through message-user.sh, and do not post F.
