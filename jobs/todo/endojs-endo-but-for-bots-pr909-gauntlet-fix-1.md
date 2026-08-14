---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-pr909-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 1
pr: https://github.com/endojs/endo-but-for-bots/pull/909
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr909-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr909-gauntlet-fix-1 endojs/endo-but-for-bots <pr-head-branch>`.
2. Read the LATEST panel verdict on https://github.com/endojs/endo-but-for-bots/pull/909 (the request-changes `gh pr review` the
   panel-1 stage just posted) for its must-fix items. Apply them.
3. Push the fix as review-feedback follow-up commits to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 909 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)
