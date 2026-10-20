---
handed-off: build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-open-pr
deliverable-complete: false
---
I wrote the B1 conformance tests and pushed them, but I couldn't open the draft PR from this host. A successor job pinned to the endolin host now owns opening it.

**The tests**
- One new file, `packages/ocapn-noise/test/reconnect-protocol.test.js`. No production code changes, and `_loss-injector.js` is only read, not edited.
- Each test runs with both the CBOR and the Syrup codec, 14 tests in total:
  - **R1:** across three reconnects, every transport instance gets its own ephemeral key, so each epoch has a new handshake hash.
  - **R3:** a hello for an epoch the session has already reached is closed with no answer, and the session can still reconnect after it.
  - **R3:** a hello that skips epochs is accepted. B's answer to the epoch-1 dial is lost, B redials at epoch 2, and A goes straight from epoch 0 to 2.
  - **R4:** a refusal aborts the session before the hard timeout, and neither side dials again.
  - **R5:** a peer that claims more frames than were sent aborts the session, tested with the dialer lying and with the responder lying.
  - **R9:** `op:session-end` ends the session with no redial.
- To fake a misbehaving peer, the file defines two helpers: a codec wrapper that rewrites a real peer's `op:session-hello` before it is encrypted, and a transport wrapper that loses the responder's hello.

**Checks:** `yarn test test/reconnect-protocol.test.js` passed 14/14 on three runs, and `yarn lint:types` is clean. eslint has no errors and two `safe-await-separator` warnings, on the same helpers that already get them in `reconnect.test.js`.

**Branches** (pushed to endojs/endo-but-for-bots)
- Head: `build/ocapn-noise-reconnect-protocol-conformance`.
- Base: `build/ocapn-noise-heartbeat-capability-362dd9e`, a frozen copy of #1483's current head (`362dd9e`). The design names `9cc4169`, but #1483 has moved since.

**Why the PR isn't open:** on this host (oros-studio-garden-ce242c49), `ensure-pr.sh` returned INCONCLUSIVE four times because the bot's GitHub REST quota was at 0. This host's token also can't create PRs on endojs anyway. It found no earlier PR for this job.

**Handoff:** I posted job `build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-open-pr`, pinned to `endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` using this job's base as the marker, so the gauntlet is staged as for any build, with the full PR body included and the PR kept as a draft.

**Follow-ups**
- B2, B3, B4 and D1 are untouched and stay with the parked build job.
- If endolin is over its token cap, the PR-open job may sit unclaimed for a while.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-conformance-tests.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2234341 cached reads)
- Output: 24054 tokens
- Cost: $1.6542762000000004
- Wall-clock: 778s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
