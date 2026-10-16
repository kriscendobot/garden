I applied panel round 1's must-fix items to PR #1478 and pushed them. CI is green on the new head: `ci-wait-merge.sh --no-merge` returned rc 0 with all 35 checks done and none failed.

**What changed** (three commits on `build/ocapn-noise-session-queue`, 11664d0e4f → 2ef916f757, pushed with `safe-push-pr-head.sh`):

- **Outbound queue is now bounded** (saboteur's must-fix; assessor and breaker raised it as should-fix). In `network.js`, `writer.next` now waits whenever the queue holds 64 or more frames. It is released as the drain makes room or when the session closes. This brings back the backpressure the writer had before this PR.
- **Inline `import()` type removed** (typist's must-fix). `OcapnCodec` now comes from the top-of-file `@import` in `session-queue.test.js`.
- **Frames no longer get stuck at the end of a drain** (should-fix from assessor, saboteur and breaker). `drain` now clears its `draining` flag in the same turn as its final empty-queue check, instead of in a later `.finally`. A frame queued in that gap now starts a new drain rather than waiting up to one heartbeat interval, or being dropped by `writer.return`.
- **Doc and naming fixes:**
  - The frame shape is named once, as `OutboundFrame`.
  - The `lastSentNonce` doc now says it counts writes the transport has completed.
  - The `writer.next` comment notes that transport errors now surface through the reader.
- **Pruner's trims:**
  - Removed the test and injector comments that only restated the code.
  - Fixed the stale `HEARTBEAT_INTERVAL` wording and cut the `writer.return` comment down to its useful clause.
  - Rewrote the PR body from about 783 words to about 435. The evidence-ledger markers and the Design, Successor and Acceptance lines are unchanged; the Phase 1/3/4/5 lines were shortened.
- **Tests:**
  - Added a backpressure test: 80 writes during a stall; some stay pending, and all arrive in order after resume.
  - Added a drain-gap test that queues the next frame at 0–15 turns after a held write is released. It fails on the old code ("frame 5 stranded after 4 turns") and passes with the fix.
  - The stall test now reads `lastSentNonce` only after a write is actually held, as saboteur asked.

**CI failure on the first push:** the stall-replay test failed on cover and both macOS test legs. It reported "no traffic from peer for 500ms". My new wait for a held write pushed the stall too close to the peer's 500 ms session timeout on slow runners. The third commit now holds the first data write instead of waiting for a heartbeat, and gives that test a 5000 ms session timeout.

**Local checks:** all 94 package tests pass, three runs in a row. `yarn lint` has no errors; its 6 warnings are all unused eslint-disable directives, none in code I changed. Prettier is clean.

**Not changed:** the comment-only findings: `writer.throw` skipping the queue, and a late write landing after a failure, which Phase 3 should look at. Per the job spec, I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3673922 cached reads)
- Output: 22172 tokens
- Cost: $1.9678803999999999
- Wall-clock: 4126s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
