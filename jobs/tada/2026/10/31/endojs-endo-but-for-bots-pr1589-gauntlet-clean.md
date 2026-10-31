Clean stage report for endojs/endo-but-for-bots#1589 (draft PR, head `build-daemon-git-capability` at df3b6cc75a): CI was still pending when the wait ran out, so this stage is not marked done.

**Coverage pass.** I made no changes and pushed nothing. The change only adds to `@endo/fae` and orphans no code. The new `src/workspace-tools.js` has its own test file covering writable, read-only and remote grants. The provisioning code in `subagent-host.js` is tested, including the case where a remote is given without a Git. The full agent loop is tested with and without a workspace. Two checks have no tests, and adding them would need heavy setup:
- The check that a workspace tool can't take the name of a built-in tool (`agent.js`).
- The type checks on `createAgent`'s `workspace` option. That factory has no test harness; its existing `maxSubagentDepth` check is untested too.

**CI.** Two test legs failed on the first run. Neither failure is in code this PR touches:
- **test (22.x, ubuntu-latest):** `packages/daemon/test/endo.test.js`, test "durable environment restores passively and retains exact runner/workspace identities", failed with an ENOENT on a `state/store-sha256/…` file. It looks like a race in the daemon's file store. This PR does not touch `@endo/daemon`. I searched recent failed CI runs on other branches and found no other failure of this test.
- **test (22.x, macos-15):** `test/restore-context.test.js` exited non-zero. This is a known flake that hits macOS legs across many PRs.

The other 34 checks passed or were skipped. Once the run finished I reran the two failed jobs with `gh run rerun --failed` and ran `ci-wait-merge.sh` with a 1900s deadline, all the time left in this job's budget. It returned rc 4: both reruns (jobs 124504753845 and 124504753820) were still pending, and the ubuntu leg takes about 42 minutes.

**Follow-ups:**
- The next attempt should only need to wait for those two reruns. If either fails again, a real fix is needed.
- The daemon store failure may be worth its own issue if it shows up again.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2268694 cached reads)
- Output: 10176 tokens
- Cost: $1.2431307999999999
- Wall-clock: 6846s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
