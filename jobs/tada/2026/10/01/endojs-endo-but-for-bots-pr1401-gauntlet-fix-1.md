## PR #1401 fix round 1: done, CI green

I applied all of round 1's must-fix items and pushed them to `fix/daemon-teardown-flakes` as three follow-up commits on top of `b67afd6db8`, using `safe-push-pr-head.sh`. Nothing was rebased or rewritten. The new head is `5c5f2d301f`. `ci-wait-merge.sh --no-merge` returned rc 0, with all 33 checks done and 0 failed.

**What I changed**

1. **`656bd92abe` fix(daemon)** (assessor's must-fix)
   - `packages/daemon/src/manager-go.js` now calls `updateRecordedPid()` before `sendEnvelope(0, 'ready')`. This is the same ordering the PR already applied to `manager-node.js` and `bus-manager-node.js`.
   - Added `.changeset/daemon-record-pid-before-ready.md` as an `@endo/daemon` patch. Four seats asked for it: migrator, packager, changeset-auditor and releaser.
   - Fixed the spelling "signalling" → "signaling" in `manager-node.js` (orthographer).
2. **`20e39ac911` fix(exo-stream)** (breaker, wire-watcher, saboteur, purist, spec-keeper, engine-realist)
   - The four iterators (`iterate-reader.js`, `iterate-bytes-reader.js`, `iterate-writer.js`, `iterate-bytes-writer.js`) now attach `.catch(() => {})` every time the current link is reassigned. Before, only the head of the chain had it.
   - Updated the code comments and the exo-stream changeset: it now covers an iterator abandoned after any number of pulls, not only before the first one.
3. **`5c5f2d301f` test(exo-stream)**
   - Added an "abandoned after a pull does not leak a later stream rejection" test to each of the four iterator test files. Each one pulls once, then rejects the second link and checks that no unhandled rejection is reported. A consumer that pulls again still sees the error.
   - Fixed the spelling "acknowledgement" → "acknowledgment" in the new comment in `reader.test.js` (orthographer).

**Checks run locally**
- With the reassignment guards temporarily removed, all four new tests fail. With the guards in place, the whole exo-stream suite passes (163 tests).
- eslint on the changed files reports no errors. exo-stream `tsc` passes. prettier is applied.

**Not addressed (none were must-fix)**
- **Hostile `then` on a later link:** the per-link guard uses `.catch`, so a later chain link carrying its own `then` would have that `then` called. I kept this to match the existing head guard and `reader-pump.js`.
- **`return()` has no defensive catch:** corner-prober noted that the promise `return()` produces still has no catch of its own.
- **`bus-manager-node.js` pid fix has no test:** prover pointed out nothing exercises it.
- **fast-check scheduler property:** fast-checker suggested replacing the hand-timed tests with one.
- **"acknowledgement" elsewhere:** the spelling still appears in other exo-stream files that predate this PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1401-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3595044 cached reads)
- Output: 16606 tokens
- Cost: $1.8525767999999996
- Wall-clock: 3114s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
