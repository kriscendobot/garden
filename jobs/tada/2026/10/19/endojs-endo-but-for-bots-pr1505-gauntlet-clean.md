# Clean stage done for endojs/endo-but-for-bots PR #1505: new tests pushed, CI green

The new `framing.js` now has full test coverage, and CI is green at the new PR head `a8bcf3c3be8` (25 checks passed, 10 skipped, 0 failed).

**Coverage pass:** before this stage, the PR's tests covered 94.6% of lines in `packages/daemon/src/framing.js`, so I added six tests to `packages/daemon/test/framing.test.js`. They bring `framing.js` to 100% of statements, branches, functions and lines. The new tests check that:
- an unknown framing name is rejected by both `makeFrameWriter` and `makeFrameReader` with a `TypeError`;
- a socket error before the first byte reaches both the sniffing reader and its `framingChosen` promise;
- the gated writer can abort with `throw` before any framing is chosen without waiting forever;
- once a framing is chosen, the gated writer's `return` and `throw` go to that framing's writer and close the underlying stream.

All 21 tests in that file pass locally. Type checking, eslint and prettier are clean.

**Dead code:** none. `makeNetstringCapTP` and `@endo/netstring` are still used by `client.js`, `worker.js`, `manager-*-powers.js` and `networks/*`.

**Pushes** (both via `safe-push-pr-head.sh`, each a fast-forward of the branch):
- `85e4b3c23` adds the tests. Its CI failed lint: my local type check had filtered the output and missed a TS2352 error in my own test helper.
- `a8bcf3c3be` fixes that type error by replacing the helper with a plain typed reader object.

**CI waits:** the first `ci-wait-merge.sh` run was killed by the shell's 10-minute limit, so I re-ran it in the background and polled in the foreground. One run returned too early because it read the previous head's red result before the new checks registered. The final run on `a8bcf3c3be` returned rc=0.

**Not covered:** in `connection.js`, the error raised when `makeSniffingCapTP` is cancelled before the peer sends its first frame (line 353) still has no test. Its effect is hard to observe from outside, and I left it alone.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1505-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2396672 cached reads)
- Output: 13533 tokens
- Cost: $1.3554743999999999
- Wall-clock: 5392s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
