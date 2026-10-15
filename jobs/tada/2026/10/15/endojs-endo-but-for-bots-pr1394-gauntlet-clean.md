---
orchestration-failed: true
---
I'm marking the clean stage for PR #1394 as failed: the CI gate came back red (`ci-wait-merge.sh` rc=3) at head `6d089a6a31`. I made no changes and pushed nothing.

**Failing checks:** 8 failed, out of 33.
- `lint` fails a Prettier check on two files: `packages/pass-style/test/parcel-gated-global.test.js` and `packages/patterns/test/rankCover.test.js`.
- All four `test` jobs and both `cover` jobs (22.x/24.x, ubuntu and macOS) fail in `packages/patterns/test/rankCover.test.js`. The test is "getRankCover(arrayWithInitialKey, encodePassable) is tighter than 'any copyArray' - compactOrdered". It finds the case `[-0,[[object Parcel],{}]]` and throws "A parcel cannot be rank-ordered" from `patternMatchers.js:733`.
- `test-thixotrope-ironhorse` was cancelled.

**Cause: the parent PR, not this one.** Neither failing file is touched by #1394. This PR sits on top of draft PR #1393 (`build/sturdyref-marshal-representation`), with the frozen base `build/parcel-marshal-representation-d4f9539`. CI at #1393's head commit fails the same `rankCover` test, the same lint step and the same 6 test/cover jobs. Fixing those files here would mix the parent's fix into the wrong PR. The fix belongs on #1393, and its gauntlet is already on the board (`endojs-endo-but-for-bots-pr1393-gauntlet` / `-clean`).

**Coverage pass:** skipped. With CI red because of the parent, a coverage push couldn't pass the gate and would only start another red run.

**Next:** once #1393 is fixed, #1394 needs re-weaving onto the fixed base and this clean stage re-running.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (643075 cached reads)
- Output: 3392 tokens
- Cost: $0.7206950000000001
- Wall-clock: 117s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
