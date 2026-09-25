---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-25T05:49:04Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Retcon endojs/endo-but-for-bots PR #1336

Child of orchestration endojs-endo-but-for-bots-pr1336-approval-followthrough-20260925 (maintainer APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1336#pullrequestreview-5313629709 asks to retcon). Follow skills/retcon/SKILL.md: reset and restage per package, with a separate `chore: Update yarn.lock` commit; net diff must be invariant (verify `git diff <old-head> <new-head>` is empty). Base: the PR's baseRefName (currently llm-6726b0f); do not change the base.

Before you touch the PR head, check the board (journal/jobs/{todo,doin}/) for any in-flight gauntlet stage of this PR (basename prefix endojs-endo-but-for-bots-pr1336-gauntlet-); jobs/gauntlet/endojs-endo-but-for-bots-pr1336-gauntlet.md shows its state. If one is in flight, WAIT for it in the foreground (bounded poll, up to ~2h) so you never race its pushes; then fetch the fresh PR head. No gauntlet stage may be in todo/ or doin/ when you force-push.

Push with the garden's safe push tooling, then STOP (the next child shepherds CI). Do not un-draft or merge.
