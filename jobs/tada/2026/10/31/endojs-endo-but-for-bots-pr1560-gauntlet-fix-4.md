## Fix round 4 for endojs/endo-but-for-bots PR #1560: done, CI green

I fixed the one failing pre-pass check (the abbreviated-name check, `spell-out-identifiers`) and pushed the fix to the PR branch. CI is green: `ci-wait-merge.sh` returned rc=0 with 36 checks and 0 failures, but only after I reran two failed jobs once.

**The fix** (commit `888fde000f`, pushed with `safe-push-pr-head.sh` from `949b0a38a8`):
- **`packages/exo-agent-factory/test/coordinator.test.js`:** renamed the lambda parameter `c` to `child`.
- **`packages/exo-agent-factory/src/coordinator.js`:** this hit was a false positive. The check doesn't skip regex literals, so it read the `c` prefix in `/^c(\d+)\.(\d+)\./` as a variable name. I rewrote it as `new RegExp(String.raw\`^c(\d+)\.(\d+)\.\`)`, which matches exactly the same names.
- The check now passes on both files, Prettier is clean, and the package's 35 tests pass locally.

**The pre-pass's comment-length warning** (`coordinator.js:23`, non-blocking): I kept the `LIFECYCLE_NAME` doc comment. It explains something the code doesn't show: a revived runner checks `isActive` before it opens its message follower.

**CI:** the first run had two red jobs, `sandbox-drivers` and `test (22.x, ubuntu-latest)`. Both failed only on the bwrap test "timeout and repeated cancellation reap process groups" in `packages/sandbox`. That test already fails on the base branch, and its fix, #1566, is still open; the `exo-agent-factory` tests passed. I reran the failed jobs once and everything passed.

**Follow-ups:**
- The abbreviated-name check should skip regex literals so it stops flagging them; this needs a garden fix to `spell-out-identifiers.sh`.
- Merging #1566 would stop the bwrap failure from turning gauntlet rounds red.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2383841 cached reads)
- Output: 9153 tokens
- Cost: $1.1921401999999999
- Wall-clock: 8110s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
