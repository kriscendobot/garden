---
role: gardener
handler-timeout: 7200
gauntlet: ironhorse-full-test262-automation-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 4
pr: https://github.com/endojs/endo-but-for-bots/pull/969
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #969

You are ONE stage of a staged gauntlet (ironhorse-full-test262-automation-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-5).

1. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh ironhorse-full-test262-automation-gauntlet-fix-4 endojs/endo-but-for-bots <pr-head-branch>`.
2. Read the LATEST panel verdict on https://github.com/endojs/endo-but-for-bots/pull/969 (the request-changes `gh pr review` the
   panel-4 stage just posted) for its must-fix items. Apply them.
3. Push the fix as review-feedback follow-up commits to the PR head with
   `/home/kris/garden2/scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     /home/kris/garden2/scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 969 --no-merge`
   - rc 0 (GREEN): success.
   - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
   - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
  <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-08T07:53:11Z
