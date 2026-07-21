# Run the gauntlet on endojs/endo-but-for-bots#818

Repo: endojs/endo-but-for-bots (base `llm`).
PR: https://github.com/endojs/endo-but-for-bots/pull/818 — feat(endor): full
CommonJS require linkage in the archive loader (supersedes auto-closed #816;
same commit rebased onto `llm` now that the #805 → #812 stack landed).

Run the full PR-creation chain end to end on this existing draft: clean →
panel review → fix-loop → un-draft (skill: skills/pr-creation-flow/SKILL.md).
The branch is `feat/endor-cjs-require-linkage`; tests are green locally
(147 endo + 120 xsnap) and real-execution evidence is in the PR body.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-21T21:44:41Z
