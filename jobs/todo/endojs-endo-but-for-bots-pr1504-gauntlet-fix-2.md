---
role: gardener
arc: unallocated
handler-budget-role: shepherd
handler-timeout: 10800
gauntlet: endojs-endo-but-for-bots-pr1504-gauntlet
gauntlet_stage: fix
gauntlet_iteration: 2
pr: https://github.com/endojs/endo-but-for-bots/pull/1504
---

# Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1504

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1504-gauntlet). Apply the panel's must-fix items ONCE,
push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-3).

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1504-gauntlet-fix-2 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1504 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. If an exact deterministic pre-pass output block appears below, apply every
   finding in that block; panel-2 stopped before dispatching jurors and there
   is no PR review for this round. If no block appears, read the LATEST panel
   verdict on https://github.com/endojs/endo-but-for-bots/pull/1504 (a request-changes review, or a comment review headed
   `Must-fix before merge` when the bot authored the PR) and apply its must-fix
   items. A prepass-failed report with an absent/empty block is missing
   evidence: fail closed rather than guessing.

<!-- gauntlet-style-prepass-output-begin -->
probe no-inline-import-jsdoc    fail (exit 1)
  fail: packages/sandbox/test/shell-engine.test.js:179 @type uses inline import('node:net'); add a top-of-file @import tag and use a bare type reference
probe no-plain-reexport         fail (exit 1)
  fail: packages/sandbox/src/spawner.js:9 new plain named re-export from '@endo/host-spawner/src/sandbox-spawner.js' lacks a @deprecated JSDoc pointing importers at the original; make it a deprecated compatibility shim and migrate importers, or mark the file reexport-policy-exempt
probe spell-out-identifiers     fail (exit 1)
  fail: packages/host-spawner/test/sandbox-spawner.test.js adds abbreviated identifier `numRuns` (`num` -> spell out, e.g. `number`)
  fail: packages/sandbox/src/drivers/child-process.js adds abbreviated identifier `err` (`err` -> spell out, e.g. `error`)
  fail: packages/sandbox/test/shell-engine.test.js adds abbreviated identifier `numRuns` (`num` -> spell out, e.g. `number`)
advisory comment concision      warn (non-blocking)
  fire pruner packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs:45 (+11-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code
result: 3 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->
3. Push the fix as review-feedback follow-up commits to the PR head with
   `scripts/jobs/gardening/safe-push-pr-head.sh`.
4. Watch CI to terminal, BOUNDED (same as the clean stage):
   `GARDEN_CI_DEADLINE_SECS=3600 \
     scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1504 --no-merge`
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
