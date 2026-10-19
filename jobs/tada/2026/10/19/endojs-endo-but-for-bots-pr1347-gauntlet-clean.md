Gauntlet clean stage for endojs/endo-but-for-bots#1347 is done: I added test coverage for the new module and CI is green (25 of 25 checks) on the new head.

**Starting point.** The PR was a draft, and CI was already green at `f7f478eeca`. It adds a new module, `packages/gateway/src/user-daemon.js`, which the per-user daemon uses to register with the gateway and publish weblets.

**Coverage.** I ran c8 with ava in an isolated project checkout. First I had to repair a partial `node_modules` with the EMLINK-safe install (node-modules linker, scripts off). The install also touched `packages/relay-server/src/index.js` (no content change, file mode only), and I reverted that.
- **Before:** `user-daemon.js` had 98.3% line and 91.7% function coverage. The uncovered lines were the populated-list path of `listWeblets` and `getRegistration`.
- **Change:** I extended the first test in `packages/gateway/test/user-daemon.test.js`. It now checks that `listWeblets()` returns the published entry without its handler. It also checks that `getRegistration()` returns the live registration, by unpublishing through it and confirming the gateway's list of weblets for that peer goes empty.
- **After:** 100% statement, branch, function and line coverage. All 9 tests pass, and eslint, the package `tsc`, and the repo-root `tsc` all pass.
- **Dead code:** the change left none behind.

**Push.** I committed `8f85b41bb3` ("test(gateway): cover listWeblets entries and getRegistration") and pushed it with `safe-push-pr-head.sh` (advance mode), moving `build/endo-gateway` from `f7f478eeca` to `8f85b41bb3`.

**CI.** My first `ci-wait-merge.sh` run was set for a 1-hour deadline but got stopped after about 20 minutes. I polled the checks in the foreground until only two were still running, then reran `ci-wait-merge.sh --no-merge` with a 560-second deadline. It returned rc 0: all 25 checks passed, none failed.

**Follow-ups:** none from this stage. The PR is still a draft and goes on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1347-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1447841 cached reads)
- Output: 6406 tokens
- Cost: $0.8862401999999999
- Wall-clock: 2045s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
