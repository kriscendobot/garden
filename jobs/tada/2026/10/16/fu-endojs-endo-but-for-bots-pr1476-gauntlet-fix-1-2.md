**PR #1476: should-fix items from the gauntlet fix round, done**

The branch `build/ocapn-noise-session-reconnect-heartbeat` now ends at `bf0d59985`, which is pushed.

Two of the four items were already on the branch when I picked up the job. Commit 293af88cc, from the earlier fix round, already had:
- **Bounded `inbound` queue:** heartbeat reading pauses once 64 frames are waiting for the consumer (`MAX_INBOUND_QUEUED_FRAMES`). The test "a slow consumer pauses the read-ahead without losing the session" covers it.
- **Acked nonce checked against what this side sent:** a counter of sent frames was added next to the received one. An `op:pong` is recorded only if `lastAckedRecvNonce < getSentCount()`, so it can't acknowledge a nonce this side never used. The test "an op:pong acknowledging an unsent nonce is ignored" covers it.

I read both, they are correct, and I left them as they were.

My new commit `bf0d59985` does the other two:
- **Heartbeat helpers typed:** `packages/ocapn/src/codecs/operations.js` now defines `OcapnPingMessage`, `OcapnPongMessage` and their union `OcapnHeartbeatMessage`. `readOcapnHeartbeatMessage` and `writeOcapnHeartbeatMessage` use these instead of `any`. In `network.js`, the heartbeat handler (`absorbHeartbeat`) uses the new type instead of its own inline one, and checks `type === 'op:pong'` before reading `lastAckedRecvNonce`. That check replaced the old `!== undefined` test.
- **Rename:** `peerAckedRecvNonce` is now `peerLastAckedRecvNonce` in `types.d.ts`, `network.js` and `heartbeat.test.js`. This was the reviewer's first suggestion, and the name now matches the `op:pong` field it stores. Neither the changeset, the README nor the PR body used the old name.

**Checks, all run locally:**
- `@endo/ocapn-noise`: all 92 tests pass. `yarn lint` (type check and eslint) shows 0 errors, plus 6 warnings in files this commit doesn't touch.
- `@endo/ocapn`: the type check passes, eslint is clean on `operations.js`, and all 56 tests in `operations.test.js` pass.

**Follow-ups:** none from this job. The panel's comment-only naming notes are still open and optional: renaming `absorbHeartbeat` to something like `handleInboundHeartbeat`, and a clearer name for the wrapped `decrypt` in the nonce counter.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1476-gauntlet-fix-1-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1373486 cached reads)
- Output: 8499 tokens
- Cost: $0.9878772000000002
- Wall-clock: 441s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
