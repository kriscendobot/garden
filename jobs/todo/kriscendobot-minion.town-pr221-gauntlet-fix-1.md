---
role: gardener
arc: unallocated
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: kriscendobot-minion.town-pr221-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 1
pr: https://github.com/kriscendobot/minion.town/pull/221
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: FIX round 1 — kriscendobot/minion.town PR #221

You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr221-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr221-gauntlet-fix-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/221 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. If an exact deterministic pre-pass output block appears below, apply every
   finding in that block; panel-1 stopped before dispatching jurors and there
   is no PR review for this round. If no block appears, read the LATEST panel
   verdict on https://github.com/kriscendobot/minion.town/pull/221 (a request-changes review, or a comment review headed
   `Must-fix before merge` when the bot authored the PR) and apply its must-fix
   items. A prepass-failed report with an absent/empty block is missing
   evidence: fail closed rather than guessing.


3. Push the fix as review-feedback follow-up commits to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 221 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
   - rc 5 (BILLING-BLOCKED): Actions refused to start the jobs (account payment/
     spending limit); the maintainer is already alerted. Do NOT rerun, push more, or
     write `orchestration-failed`: emit the ci-billing-blocked marker (the driver parks).

Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
completion signal; the completion signal itself stays the very last line:
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)
  <!-- gauntlet-stage-result: fix=ci-billing-blocked -->  (ci-wait-merge rc 5)
