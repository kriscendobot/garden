---
ts: 2026-05-20T00:53:55Z
kind: dispatch
role: steward
to: fixer
dispatch_id: 54bedd
dispatch_root: /home/kris/dispatches/fixer--54bedd
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 301
    role: target
---

# Dispatch fixer 54bedd — diagnose Node 22-specific test failure on PR #301

PR #301 (kriskowal-error-trace, rebased onto origin/llm tip by weaver 3c22d7, head `98e84083d`) has CI failing only on Node 22.x (both ubuntu-latest and macos-15); Node 20.x and 24.x pass. Origin/llm is green on 22.x — failure is introduced by the rebase + error-trace aggregator + cherry-picked endolinbot hotfix commits.

Failing job: `test (22.x, ubuntu-latest)` (job id 76863650930, run 26133510155).

Key log signature: `packages/daemon/test/endo.test.js` exits with code 1. The exit is process-level (no test-assertion stack trace visible in the log; tests around it pass with ✔). The exit happens during or after the test run completes, not on a specific assertion.

Suspect surfaces:
- A V8/Node 22 behavior change affecting an async hook, unhandled rejection, or process teardown.
- The new `marshalSaveError` + `traceAggregator` machinery in the daemon (PR #301's main payload) may have a Node-22-specific timing or shape issue.
- The cherry-picked hotfix commits during the rebase (`2d7ed75b9` and `3bfa125a0` per the weaver's report) added `controlPowers.makeWorker` slot ordering that may behave differently on Node 22.

Approach:
1. Run `packages/daemon` tests locally on Node 22 (`nvm use 22 && cd packages/daemon && yarn ava test/endo.test.js` or equivalent). Confirm the failure reproduces locally.
2. Bisect: which test or hook is causing the exit? Try `yarn ava test/endo.test.js --serial --fail-fast` to surface the precise failing setup.
3. Once the failure is localized, identify whether it's:
   - (a) a Node 22-only V8 behavior change in the daemon's async / process / error-handling code
   - (b) a regression introduced by the error-trace aggregator's `marshalSaveError` integration
   - (c) something in the rebase's conflict-resolution slots (worker kind / marshalLoadError) that breaks on Node 22
4. Land a minimal fix as one or two focused commits. Reference PR #301 in the body.

Run `yarn lint:prettier` locally before push.

Report: reproduction outcome (yes/no), root-cause identification, fix commits (sha + what they fix), post-fix `yarn ava` on packages/daemon under Node 22 status, and any follow-ups (e.g., if the same shape lurks elsewhere or wants a regression test).

When done, the steward will tear down your dispatch root and re-trigger CI.
