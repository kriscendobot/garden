---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-pr992-gauntlet
gauntlet_stage: clean
gauntlet_iteration: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/992
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #992

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr992-gauntlet). Do ONLY the clean stage, then STOP.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Idempotence first. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/992 --json isDraft,state,statusCheckRollup`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr992-gauntlet-clean endojs/endo-but-for-bots <pr-head-branch>`
   (the head branch is `gh pr view https://github.com/endojs/endo-but-for-bots/pull/992 --json headRefName -q .headRefName`).
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 992 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     `orchestration-failed: true` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-15T06:35:16Z
