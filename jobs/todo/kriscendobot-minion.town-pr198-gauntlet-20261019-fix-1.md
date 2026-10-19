---
role: gardener
handler-budget-role: shepherd
handler-timeout: 7200
gauntlet: kriscendobot-minion.town-pr198-gauntlet-20261019
gauntlet_stage: fix
gauntlet_iteration: 1
pr: https://github.com/kriscendobot/minion.town/pull/198
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: FIX round 1 — kriscendobot/minion.town PR #198

You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr198-gauntlet-20261019). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr198-gauntlet-20261019-fix-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/198 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. If an exact deterministic pre-pass output block appears below, apply every
   finding in that block; panel-1 stopped before dispatching jurors and there
   is no PR review for this round. If no block appears, read the LATEST panel
   verdict on https://github.com/kriscendobot/minion.town/pull/198 (a request-changes review, or a comment review headed
   `Must-fix before merge` when the bot authored the PR) and apply its must-fix
   items. A prepass-failed report with an absent/empty block is missing
   evidence: fail closed rather than guessing.

<!-- gauntlet-style-prepass-output-begin -->
probe prefer-endo-primitives    fail (exit 1)
  fail: test/home-page.test.ts adds hand-rolled SHA-256; use @endo/sha256 (or mark a justified prefer-endo-primitives-exempt file)
probe spell-out-identifiers     fail (exit 1)
  fail: src/waitlist/stores/dynamodb.ts adds abbreviated identifier `DynamoDB` (`db` -> spell out, e.g. `database`)
  fail: test/waitlist.test.ts adds abbreviated identifier `numRuns` (`num` -> spell out, e.g. `number`)
  fail: test/web/guest-web-http.test.ts adds abbreviated identifier `args` (`args` -> spell out, e.g. `arguments`)
advisory comment concision      warn (non-blocking)
  fire pruner deploy/aws/scripts/deploy-waitlist-store.sh:5 (+3-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code
result: 2 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->
3. Push the fix as review-feedback follow-up commits to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh kriscendobot/minion.town 198 --no-merge`
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
