---
role: gardener
handler-timeout: 7200
gauntlet: ironhorse-js-02-errors-coercions-strict-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 1
pr: https://github.com/endojs/endo-but-for-bots/pull/970
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #970

You are ONE stage of a staged gauntlet (ironhorse-js-02-errors-coercions-strict-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).

1. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh ironhorse-js-02-errors-coercions-strict-gauntlet-fix-1 endojs/endo-but-for-bots <pr-head-branch>`.
2. Read the LATEST panel verdict on https://github.com/endojs/endo-but-for-bots/pull/970 (the request-changes `gh pr review` the
   panel-1 stage just posted) for its must-fix items. Apply them.
3. Push the fix as review-feedback follow-up commits to the PR head with
   `/home/kris/garden2/scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     /home/kris/garden2/scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 970 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)

<!-- garden-reaped: 2 -->

<!-- garden-productive-cycle -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-08T08:43:13Z
