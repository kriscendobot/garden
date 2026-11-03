**PR #1641 clean stage: CI is still pending, so I'm not marking this stage done.** `ci-wait-merge.sh` returned rc 4 at its 3600s deadline. On head `c3baa8c6e`, 17 checks have passed and 18 were skipped, with none failed. `test (22.x, macos-15)` is still running, so the driver should re-post this stage to finish the wait.

**Why I pushed a commit:** the `lint` job had failed on the previous head, `be6462bc2`, because the root TypeScript check rejected tests this PR added.
- **Errors:** three TS2345 errors in `packages/agent-tools/test/git-flow.test.js` and one TS2339 in `packages/agent-tools/test/git-tool.test.js`.
- **Fix:** `c3baa8c6e`, `test(agent-tools): narrow the diff results the new tests read`, changes one line in each file and only adds type casts. This goes slightly beyond a coverage pass, but left alone the failure would have halted the gauntlet. `lint` now passes in CI.
- **Local checks:** root `tsc` exits 0, and Prettier and ESLint report no errors on both files (ESLint gives 2 warnings). I pushed with `safe-push-pr-head.sh` and confirmed the new head with `ls-remote`.

**Coverage (no new tests needed):**
- **`exo-git/src/git.js`:** the two changed path-resolution lines (713 and 929) both run under the PR's tests. I measured this with a filtered run of `daemon/test/git.test.js` (`Git.diff`, stash and `Git.add` tests), not the whole file.
- **`agent-tools/src/json-tools/git.js`:** 99.69% lines and 88.88% branches. The only uncovered lines, 626-627, are the unknown-facet error, which this PR didn't touch. The new diff schema is covered.
- **Platform arms:** the PR changes none.

**Dead code:** nothing to remove. The renamed `PATHS_PROP` and `CONFLICT_SIDE_PROP` have no references left, and `OPTIONS_PROP` is still used by `log`.

**Local test failure, not caused by this PR:** `git-flow › makeGitTool derives the rewriter-facet catalog against a real Git cap` fails on this host with "Git repository identity changed". It fails the same way with `exo-git/src/git.js` reverted to the base version, and it's a known baseline failure on this host. The other tests in those two `agent-tools` files pass.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1641-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2075712 cached reads)
- Output: 16231 tokens
- Cost: $1.4882024
- Wall-clock: 5912s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
