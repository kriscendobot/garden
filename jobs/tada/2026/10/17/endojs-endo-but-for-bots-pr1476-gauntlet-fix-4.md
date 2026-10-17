## Fix round 4 for endojs/endo-but-for-bots#1476: done, CI green

I applied the round-4 panel's must-fix items and most of its should-fix items, and pushed one follow-up commit, `6ef59e4f32`. CI on the new head is green: 35 of 35 checks passed and `ci-wait-merge` returned 0.

**What changed in the code:**
- **Archivist must-fix:** the comment on the empty `op:ping`/`op:pong` handlers in `packages/ocapn/src/client/ocapn.js` was wrong. It now says the network absorbs heartbeats only when `heartbeat` is on; when it is off, they reach the session and are ignored.
- **Archivist should-fix:** the README sentence "the session reader skips heartbeat frames" now applies only "when `heartbeat` is set".
- **Archivist comment:** added JSDoc for `getLiveness()` and for the `SessionLiveness.heartbeat` and `epoch` fields in `types.d.ts`.
- **Pruner:**
  - The README no longer lists each `SessionLiveness` field; it points to the type instead.
  - The README no longer repeats the default timeout, which the type's JSDoc already states.
  - Removed the redundant clause from the `op:ping` comment in the codec test table.
- **Prover should-fix:** the "heartbeats keep an idle session alive" test now keeps a read pending on both sides during the idle wait, so the liveness timeout actually runs and the test checks something real.

**What changed in the PR body:**
- **Pruner:** I cut it down. The Description is now one line plus the "review `src/network.js` most closely" pointer. The ledger lines for Phases 2–5 are shorter, but the `garden-phase-evidence-ledger:v1` markers are kept. The Documentation and Testing sections are now one line each.
- **Decomplector:** the body now says why heartbeats are needed at all: a clean disconnect already reaches the reader, so they exist only to detect a peer that goes silent. It also explains why the timeout runs only while a read is pending: if the consumer stops reading, a timer that always runs would wrongly declare a live peer lost.

**Checks:** all 93 `@endo/ocapn-noise` tests pass, the `@endo/ocapn` codec tests pass (56), and Prettier is clean.

**Not done, left for panel-5 or the maintainer:**
- Decomplector should-fix #3: `isHeartbeatFrame` reads each frame's label once and then `absorbHeartbeat` parses the frame again.
- Decomplector comment-only items: `countNonces` and the reconnect-only `epoch`/`sequence` fields.
- Pruner #5, the repeated nonce comments in the heartbeat tests: the two that remain each sit beside an assertion they explain, so I left them.
- Whether to adopt `op:ping`/`op:pong` as protocol operations is still the maintainer's call (they are marked "proposed, pending OCapN-org review").

My first attempt at the CI wait was stopped by the harness's 10-minute limit on background commands. I reran it detached and waited for it to finish; the green result comes from that rerun.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1547962 cached reads)
- Output: 8958 tokens
- Cost: $1.0248884
- Wall-clock: 2109s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
