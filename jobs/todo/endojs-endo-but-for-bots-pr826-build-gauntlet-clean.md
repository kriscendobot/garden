---
role: gardener
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-pr826-build-gauntlet
gauntlet_stage: clean
gauntlet_iteration: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/910
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #910

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr826-build-gauntlet). Do ONLY the clean stage, then STOP.

1. Idempotence first. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/910 --json isDraft,state,statusCheckRollup`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr826-build-gauntlet-clean endojs/endo-but-for-bots <pr-head-branch>`
   (the head branch is `gh pr view https://github.com/endojs/endo-but-for-bots/pull/910 --json headRefName -q .headRefName`).
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   `/home/kris/garden2/scripts/jobs/gardening/safe-push-pr-head.sh`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   `GARDEN_CI_DEADLINE_SECS=3600 \
     /home/kris/garden2/scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 910 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     `orchestration-failed: true` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)

<!-- garden-reaped: 1 -->
