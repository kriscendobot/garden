---
handed-off: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
deliverable-complete: false
---
Phase 2 is built and up as a draft PR. Phases 3 to 5 and the capability bit are not built; I handed them to a new successor job, `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`, which is posted in `jobs/todo/` on the board.

**Phase 2: draft PR endojs/endo-but-for-bots#1478**
- Head is `build/ocapn-noise-session-queue`. It is stacked on the Phase 1 PR #1476, against a frozen copy of that PR's head, `build/ocapn-noise-session-reconnect-heartbeat-9175a5b` (`ensure-pr.sh` won't open a PR on a moving base).
- `packages/ocapn-noise/src/network.js`, only for sessions with heartbeats on:
  - Each session now has a queue of outgoing messages that the connection hasn't taken yet. Messages are encrypted only when sent, so the queue isn't tied to one connection's keys, which is what Phase 3's reconnect needs to resend it.
  - `writer.next` resolves as soon as the session accepts the message, so a stalled connection no longer blocks the caller.
  - While the connection is stalled, at most one ping/pong pair waits in the queue, and the pong's nonce acknowledgement is filled in when it is actually sent.
  - A write held for less than `SESSION_TIMEOUT` is a stall: the queue sends in order once it clears. A write held for `SESSION_TIMEOUT` is loss, and the session fails with "transport write stalled…; session lost".
  - `writer.return` sends whatever is queued before closing the stream.
  - `getLiveness()` now also reports `lastSentNonce` and `queuedFrames`.
- Sessions without heartbeats work exactly as before.
- The epoch stays 0 in this PR, because there is still one connection per session; Phase 3 is what advances it.
- `test/_stall-injector.js` is the stall simulator the design asks for. `test/session-queue.test.js` covers, with both codecs:
  - writes during a stall pile up and arrive in order afterwards;
  - a stall longer than the timeout is detected as loss on both sides;
  - a stuck write counts as loss even while the peer is still heard;
  - `writer.return` sends the queue first;
  - sessions without heartbeats are unchanged.
- **Local checks:** all 91 `@endo/ocapn-noise` tests pass under the lockdown, unsafe and endo test configurations. The package `tsc`, the repo-root `tsc -p tsconfig.json` and eslint report no errors.
- I did not wait for CI on #1478. A PR whose base is a branch other than `llm` may not trigger every workflow.
- The PR's phase-and-evidence ledger reads: Phase 1 and Phase 2 satisfied, Phases 3 and 5 not started, Phase 4 deferred, overall "orchestrated slice" with the successor named.

**Phase 1 PR #1476:** I updated its ledger to show Phase 2 as satisfied at #1478, and changed its named successor to the new job.

**Handed off to `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`**, stacked on #1478:
- **Phase 3:** reconnect with a fresh Noise handshake, advancing the epoch, resending the queue, and settling it when the hard timeout runs out.
- **Phase 4:** stays blocked until the maintainer settles Open question C1 and the cryptographic review in #1475.
- **Phase 5:** the crossed-hellos tiebreaker.
- **Capability bit:** after it lands, heartbeats can default on, plus the daemon wiring in `packages/daemon/src/networks/ocapn.js`.
- **Final step:** when everything has evidence, it marks the ledgers on #1476 and #1478 as deliverable.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-session-reconnect-phases-2-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2758761 cached reads)
- Output: 25809 tokens
- Cost: $1.8433722000000001
- Wall-clock: 436s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
