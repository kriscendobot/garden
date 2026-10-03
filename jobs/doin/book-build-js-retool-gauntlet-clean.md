---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: book-build-js-retool-gauntlet
gauntlet_stage: clean
gauntlet_iteration: 0
pr: https://github.com/kriscendobot/garden-book/pull/6
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: CLEAN — kriscendobot/garden-book PR #6

You are ONE stage of a staged gauntlet (book-build-js-retool-gauntlet). Do ONLY the clean stage, then STOP.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Idempotence first. `gh pr view https://github.com/kriscendobot/garden-book/pull/6 --json isDraft,state,statusCheckRollup`. If the
   PR is already the right shape (coverage already pushed, CI GREEN at the current
   head), this stage is a NO-OP: skip to the marker with clean=done.
2. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh book-build-js-retool-gauntlet-clean <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/garden-book/pull/6 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
3. In that checkout: run the coverage pass on the touched packages
   (skills/coverage-driven-testing) and remove any dead code the change orphaned.
4. If you changed anything, push follow-ups to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
5. Watch CI to a terminal state, BOUNDED so this handler is never killed mid-wait:
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/garden-book 6 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING at the deadline): CI is not terminal — report still-pending
     so the driver re-posts this stage on a fresh budget (do NOT emit clean=done).
   - rc 3 (RED): this stage FAILS. Begin your report with a line
     `orchestration-failed: true` and describe the failing checks; do NOT emit any
     clean=done marker (the driver halts the gauntlet and surfaces it).
   - rc 5 (BILLING-BLOCKED): GitHub Actions refused to START the jobs because of the
     account's payment/spending limit. The script already alerted the maintainer. Do
     NOT rerun, push, or message anyone, and do NOT write `orchestration-failed`:
     emit the ci-billing-blocked marker and the driver parks the gauntlet.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: clean=done -->            (coverage clean, CI green)
  <!-- gauntlet-stage-result: clean=still-pending -->   (CI still pending at deadline)
  <!-- gauntlet-stage-result: clean=ci-billing-blocked -->  (ci-wait-merge rc 5)

## Supervisor note: checkless repo (garden-book-supervisor-20261003-after-art, 2026-10-03)

`kriscendobot/garden-book` has **no GitHub Actions workflows**, so no check ever attaches to a PR head. That is verified: `.github/workflows` is absent and the rollup is empty. Run the step-5 wait as
`GARDEN_CI_ALLOW_NO_CHECKS=1 GARDEN_CI_DEADLINE_SECS=3600 scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/garden-book 6 --no-merge`
so an empty rollup counts as green rather than looping to a still-pending halt. The repo's real check is local. Run `npm ci && npm test` in your checkout, plus `node build/build.mjs` (or the README's build command), and treat a failure there as RED.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T07:42:05Z
