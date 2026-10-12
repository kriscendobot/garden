Fix round 5 for endojs/endo-but-for-bots#1412 is pushed and CI is green: 33 checks, 0 failed, and `ci-wait-merge.sh` returned rc 0.

**Must-fix applied (corner-prober #1):** `nonNegative` in `packages/claude/src/stream-reducer.js` used to accept any finite count of 0 or more. A usage value above `Number.MAX_SAFE_INTEGER` (such as `2**53` or `Number.MAX_VALUE`) therefore got past the reducer but failed `InferUsageShape`, the return guard on `infer`. That turned a successful turn into a rejection. The function now keeps only counts from 0 to `MAX_SAFE_INTEGER` and turns `-0` into `0`.

**Tests added** in `packages/claude/test/stream-reducer.test.js`:
- `MAX_SAFE_INTEGER` is kept, while `MAX_SAFE_INTEGER + 1`, `2**53` and `MAX_VALUE` are dropped.
- `-0` comes back as `+0`.
- The resulting usage record passes `mustMatch` against `InferUsageShape`.
- `-1`, `NaN`, `±Infinity`, `'3'`, `null` and `undefined` are all dropped. A fractional `1.5` is kept, because the guard does not require integers.

This also covers the reducer half of corner-prober's summary-fix #2.

**Checks:** all 179 `@endo/claude` tests pass, and eslint, package `tsc` and root `tsc -p tsconfig.json` are clean.

**Push:** commit `f3591289bd`, "fix(claude): drop usage counts the seam's InferUsage guard refuses", went on as a follow-up commit through `safe-push-pr-head.sh`, moving the head from `bade55a5b2` to `f3591289bd`.

**Pruner summary-fix:** nothing to change. The current PR body no longer has a "Why parallel modules stay separate" section, because the earlier head commit had already moved that rationale into the design doc.

**Not addressed, left for later or for the panel:**
- The scribe's completion-summary comment was not posted.
- The remaining summary-fix test-coverage items were not done: turn-limit equality, interleaved system or stream events, direct tests for `runBoundedCleanups` and `makeTerminationRace`, and the `buildArgv` error messages.
- The assessor's should-fix is open: the SDK backend never closes its MCP server on the normal path.

The first background CI wait hit its time limit and was stopped. A detached re-run of `ci-wait-merge.sh` then finished green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1303984 cached reads)
- Output: 7078 tokens
- Cost: $0.9049968
- Wall-clock: 2389s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
