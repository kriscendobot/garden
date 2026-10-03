---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: book-build-js-retool-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 3
pr: https://github.com/kriscendobot/garden-book/pull/6
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: FIX round 3 — kriscendobot/garden-book PR #6

You are ONE stage of a staged gauntlet (book-build-js-retool-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-4).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh book-build-js-retool-gauntlet-fix-3 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/garden-book/pull/6 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. Read the LATEST panel verdict on https://github.com/kriscendobot/garden-book/pull/6 (the request-changes `gh pr review` the
   panel-3 stage just posted) for its must-fix items. Apply them.
3. Push the fix as review-feedback follow-up commits to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/garden-book 6 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
   - rc 5 (BILLING-BLOCKED): Actions refused to start the jobs (account payment/
     spending limit); the maintainer is already alerted. Do NOT rerun, push more, or
     write `orchestration-failed`: emit the ci-billing-blocked marker (the driver parks).

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)
  <!-- gauntlet-stage-result: fix=ci-billing-blocked -->  (ci-wait-merge rc 5)

## Supervisor note: checkless repo (garden-book-supervisor-20261003-retool, 2026-10-03)

`kriscendobot/garden-book` has no GitHub Actions workflows, so no check ever
attaches to a PR head. Run the CI wait with
`GARDEN_CI_ALLOW_NO_CHECKS=1` prepended so an empty rollup counts as green.
Treat local `npm ci && npm test` plus
`node build/build.mjs chapters out` as the real gate.
