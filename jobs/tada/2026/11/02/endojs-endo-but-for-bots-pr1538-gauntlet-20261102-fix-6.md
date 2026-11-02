---
orchestration-failed: true
---
orchestration-failed: true

**PR #1538 fix round 6: the fixes are pushed, but CI is red on one job and could not be rerun from this host.** The head is now `6e12d1b01fe`. `ci-wait-merge` returned rc 3, with 34 of 35 checks passing.

**The red job:** `test (24.x, macos-15)` failed in `packages/daemon/test/http-content-plane.test.js`.
- **Failure:** every assertion passed, then the file exited 1 on an unhandled `ClientDestroyedError` rejection.
- **Likely a flake:** it matches the known flake from `ebfb-daemon-test-flakes-20261003`, and the same macOS failure passed on rerun on #1573. This round doesn't touch the HTTP content plane, the previous head's CI was green, and the test passed 3 of 3 runs on this host (Linux).
- **Not proven:** nothing has rerun it on macOS yet, because this host's token gets a 403 on `gh run rerun`.

**Fixed: all three must-fix items**
- **Archivist 1:** the design doc now says the remote's Git name is `origin` and that it has no pet name. Finding 3, the same contradiction in the `provideGitClone` JSDoc, is fixed too.
- **Archivist 2:** the "Resolved" bullet now says the identity boundary shipped via #706.
- **Decomplector 1:** `DriverProcess.kill` is back to `TerminationSignal`, and the migration note is gone.
  - **Init kill kept:** the group holds only the launcher, because the init calls `setsid()`, and `--die-with-parent` is armed late. The driver comment now records this, and the stand-in test fails with the init kill removed.
  - **Behaviour change:** every termination signal now kills the init first, so `SIGINT`, `SIGHUP` and `SIGQUIT` also end the workload at once. The old branch could strand the init on those signals. The changeset says this and stays `minor`.

**Fixed: should-fix and trims**
- **Breaker 1:** a second `provideGitClone` on a directory being cloned is now refused, so it can't delete the first clone. The new test fails without the guard.
- **Breaker 2:** the `runRemoteGitAt` JSDoc no longer overclaims; it now excepts a descendant that leaves the process group.
- **Coverage-auditor:** the false XS coverage comment is corrected and cites the tracked job `ebfb-xs-daemon-start-without-fetch`.
- **Pruner:** the flagged design-doc and code comments are trimmed, and the PR-body trims are queued in the body job below.

**Not changed**
- **Breaker 3:** rebinding an existing pet name overwrites it, the same as `provideGit` and `provideGitRemote`.
- **Decomplector 2, `taskkill`:** an earlier panel required it as a must-fix, and a code comment explains why it's there.
- **Decomplector 2, renames:** already in the branch history, so splitting them out would mean rewriting it.
- **Coverage-auditor finding 3:** this is a panel tooling gap (no c8 report), not a defect in this change.

**Testing**
- **Passing locally:**
  - sandbox `bwrap` and `lifecycle`: 67 tests
  - `provideGitClone`: 13 tests
  - the changed bwrap test, after its final type fix
- **Lint:** ESLint reports no errors on the source and test files in `@endo/daemon`, `@endo/sandbox` and `@endo/git`, apart from the unlinted floot test and `.d.ts` files.
- **Type errors:** `tsc` still reports errors outside this round's edits, including `src/policy.js:964` and `src/host.js:1787`; I didn't compare them against the base branch.
- **Not run locally:** the full test suite.

**Still open**
- **PR description is stale:** it still describes the `DriverProcess.kill` contract change, which is no longer true. This host gets a 403 on `gh pr edit`, so I posted `endojs-endo-but-for-bots-pr1538-body-fix6`, pinned to `endolin-garden-ece02cb4`. It was still unclaimed in `todo/` at last check, about an hour after posting. Panel-7 may flag the stale text if this job hasn't run first.
- **Rerun job unconfirmed:** `post-job.sh` reported posting `endojs-endo-but-for-bots-pr1538-rerun-macos-fix6` at 13:45, also pinned to that host. It never appeared in this host's journal checkout (`todo/`, `doin/` or `tada/`), and the CI run is still on attempt 1. Check that the job exists; if it doesn't, the failed job needs rerunning from a host that can.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (4816833 cached reads)
- Output: 42705 tokens
- Cost: $3.0745306
- Wall-clock: 5450s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
