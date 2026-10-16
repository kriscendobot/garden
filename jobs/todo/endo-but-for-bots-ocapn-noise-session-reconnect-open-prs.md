---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Open the three session-reconnect PRs on endojs/endo-but-for-bots

Handoff from job `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`, which ran on host oros-studio-garden-ce242c49. That host's bot PAT gets a 403 on endojs PR creation. The code is finished and pushed. Your **only** task is to open three stacked DRAFT pull requests with `scripts/jobs/gardening/ensure-pr.sh`, using the exact bodies below. **Do not change any code.**

Branches (all pushed to endojs/endo-but-for-bots; each frozen base is already pushed):

| PR | ensure-pr base key | head | base branch |
|---|---|---|---|
| Phase 3 | `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-phase-3` | `build/ocapn-noise-session-reconnect-rekey` (4d8b59b6e) | `build/ocapn-noise-session-queue-2a16357` (frozen Phase 2 #1478 head) |
| Phase 5 | `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-phase-5` | `build/ocapn-noise-session-reconnect-crossed-hellos` (9376e7e05) | `build/ocapn-noise-session-reconnect-rekey-4d8b59b` |
| Heartbeat capability + daemon | `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-heartbeat-capability` | `build/ocapn-noise-heartbeat-capability` (9cc41693a) | `build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e` |

Procedure:
1. Get a project checkout: `P=$(scripts/jobs/ensure-project-worktree.sh endo-but-for-bots-ocapn-noise-session-reconnect-open-prs endojs/endo-but-for-bots build/ocapn-noise-heartbeat-capability | tail -1)`. Run ensure-pr.sh with cwd = $P, because the phase-evidence gate resolves `designs/*.md` from cwd.
2. For each row, write the matching body below to a file, then run `scripts/jobs/gardening/ensure-pr.sh <base key> endojs/endo-but-for-bots <head> <base branch> --title "<title>" --body-file <file>`. Open them in order (Phase 3, then Phase 5, then capability). After opening, edit each later body so the generic "the Phase 3 PR" / "the Phase 5 PR" references name the real PR numbers.
   - Phase 3 title: `feat(ocapn,ocapn-noise): transparent session reconnect with Rekey (session-reconnect Phase 3)`
   - Phase 5 title: `feat(ocapn-noise): crossed-hellos tiebreaker on reconnect (session-reconnect Phase 5)`
   - Capability title: `feat(ocapn-noise,daemon): negotiate heartbeats by capability bit and default them on`
3. Do **not** move #1476 or #1478 ledgers to `deliverable`. Phase 4 (Resume) is deferred on Open question C1, which the maintainer has not settled. That ledger update waits for C1.
4. In your report, list the three PR URLs.

----- BODY: Phase 3 -----
Refs: #252, #1476, #1478

## Description

This is Phase 3 of `designs/ocapn-noise-session-reconnect.md` (on `llm`; design PR #252), stacked on the Phase 2 PR #1478 (base: the frozen Phase 2 head `build/ocapn-noise-session-queue-2a16357`). A session whose transport instance is lost now reconnects on a fresh transport instance with a fresh Noise IK handshake (Rekey), and the CapTP layer sees one continuous session.

**`@endo/ocapn`** (`src/codecs/operations.js`)
- Adds two proposed session-control records, pending OCapN-org review, as a family separate from the CapTP operations (the network consumes them; they never reach a session):
  - `<op:session-hello features epoch session received>`: `features` is a bitset of what the sender supports (bit 0 heartbeat, bit 1 reconnect). `epoch` is 0 to open a session, or the next epoch of the session being resumed. `session` is the 32-byte Noise transcript hash of the session's opening handshake. `received` counts the session frames the sender has delivered so far.
  - `<op:session-end epoch>`: a deliberate close, so the peer does not take the end of the stream for loss.

**`@endo/ocapn-noise`** (`src/network.js`)
- Every transport instance exchanges `op:session-hello` right after `op:start-session`. The initiator sends first. The responder checks the hello and then answers it.
- New option `makeOcapnNoiseNetwork({ heartbeat, reconnect })`, where `reconnect` is `true` or `{ backoffInitialMs = 250, backoffMaxMs = 30_000, hardTimeoutMs = 600_000 }` (the § 5 defaults). Reconnect requires heartbeat, and a session uses it only when both hellos advertise it.
- On loss (liveness timeout, write stall past `SESSION_TIMEOUT`, or transport end or error without `op:session-end`), the session keeps its queue and drops the dead instance. The side that opened the session redials with exponential backoff, using a fresh handshake whose hello names the session and `epoch + 1`. The other side waits. Phase 5 lets either side dial. The responder finds the session by peer key and checks the session token and epoch. It answers with its own hello and moves the session onto the new instance. If the responder does not hold that session (it restarted, or it closed), it answers with an epoch-0 refusal and the dialer aborts at once rather than waiting out the hard timeout.
- Exactly-once replay without CapTP dedup: frames handed to an instance are kept until the peer's `op:pong` acknowledges their nonce. On reconnect, each hello carries `received`, and each side replays only the frames past that point, in order, ahead of anything queued during the gap. The design's § 4 asks the CapTP receiver to dedupe replays. Counting delivered frames at the network layer makes that unnecessary: no frame is delivered twice.
- Nonces never repeat: each instance has new CipherStates from its own handshake, so nonces restart under a new key (Option Rekey). Epoch-tagged control frames from an older epoch are dropped, and frames that straggle in on an abandoned instance are never delivered.
- § 5 terminal semantics: if no instance is up within `SESSION_HARD_TIMEOUT`, the session aborts. Its reader rejects with `session aborted; not reconnected within <n>ms`, which the CapTP layer handles as its existing abort path (rejecting pending answers). In the last `RECONNECT_BACKOFF_MAX` of the budget, `writer.next` rejects immediately (fail-fast).
- A fresh (epoch 0) handshake from a peer whose session with us is waiting to reconnect means the peer lost that session. The old session aborts and the new one proceeds. Against a session that is still attached, a fresh handshake is refused, as a late crossed hello was before.
- `getLiveness()` adds `reconnect`, `reconnecting`, and `unackedFrames`, and `epoch` now advances.

`test/_loss-injector.js` is the transport-loss fault injector. It partitions every stream a transport has opened or accepted so far: writes resolve but are lost, and reads never yield again. Streams opened afterwards work, and a test can refuse new connections to hold a partition open.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in every codec plus heartbeat liveness, #1476
Phase 2: satisfied | session outbound queue + stall fault injector, #1478 (this PR's base)
Phase 3: satisfied | reconnect with Rekey: a partitioned session reconnects on a fresh handshake, the epoch advances, frames written into the partition arrive exactly once and in order on both sides, across successive reconnects, with both codecs (`packages/ocapn-noise/test/reconnect.test.js`); a CapTP call made into the partition is answered once on the new instance (`packages/ocapn-noise/test/integration.test.js`); hard-timeout abort, fail-fast writes, refusal by a peer that dropped the session, and graceful close without reconnect
Phase 4: deferred | reconnect with Resume; gated on Open question C1 and the cryptographic review (#1475), not settled by the maintainer
Phase 5: not-started | crossed-hellos tiebreaker on reconnect; stacked follow-up PR from the same job
Acceptance: partial | the design's reconnect, nonce-monotonicity (by Rekey), replay-idempotence, stale-epoch, cross-session RESUME refusal, and hard-timeout tests hold; crossed-hellos belongs to Phase 5
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- No `(key, nonce)` reuse: every transport instance gets its own Noise IK handshake and CipherStates (Option Rekey). Nothing continues a CipherState across instances.
- A reconnect is authenticated exactly like a new session: Noise IK with both static keys, plus the channel-bound `op:start-session` exchange. The `op:session-hello` that names the session travels inside the new handshake's encrypted channel. Because the session token is the opening handshake's transcript hash, a hello captured from one session cannot resume another (the responder also requires the same peer key and `epoch + 1`).
- An authenticated peer can only resume its own session with us. A refusal costs it the session it asked to resume, nothing else.
- Replay buffer: unacknowledged frames stay in memory until an `op:pong` covers them, so the buffer is bounded by about one heartbeat interval of traffic while connected, or by what the local side writes during a reconnect. The peer cannot grow it.
- The responder's pre-authentication DoS cap still applies to reconnect handshakes. The early "late crossed hello" refusal is relaxed only for a peer that holds a resumable session, because only the post-handshake hello can tell a reconnect apart.

### Scaling Considerations

Per session: one backoff timer and one hard-timeout timer while reconnecting, and one array of unacknowledged frames, trimmed on every `op:pong`. A reconnect costs one Noise IK handshake (two messages) plus the identity and hello exchange.

### Documentation Considerations

`ReconnectOptions` and the new `SessionLiveness` fields are documented in `packages/ocapn-noise/src/types.d.ts`. A changeset covers the new `@endo/ocapn/operations` exports. `@endo/ocapn-noise` is private.

### Testing Considerations

`packages/ocapn-noise/test/reconnect.test.js` (cbor and syrup where the codec matters) covers transparent reconnect with exactly-once, in-order replay both ways; three successive reconnects; `SESSION_HARD_TIMEOUT` abort on both sides with refused redials; fail-fast writes near the end of the budget; refusal by a peer that dropped the session; graceful close without reconnect; a peer without reconnect keeping the Phase 2 loss semantics; and option validation. `test/integration.test.js` adds a CapTP round trip across a partition. Existing heartbeat and queue tests now account for the hello taking send nonce 1.

Local results: `@endo/ocapn-noise` passed 102 tests under each of the lockdown, unsafe, and endo configs, and `@endo/ocapn` passed 563. The intermittent `ENOENT .cache/ava/import-from-project.mjs` worker errors seen locally come from the concurrent ses-ava configs sharing the ava cache, and every affected file passes when run alone. `yarn lint` in `packages/ocapn-noise` reports no errors.

### Compatibility Considerations

This changes the OCapN-Noise wire exchange. Every transport instance now carries an `op:session-hello` after `op:start-session`, so OCapN-Noise peers must run this version or later. The design's Compatibility section scopes the amendment to OCapN-Noise peers that adopted the proposal. Reconnect stays opt-in, and without it a lost instance ends the session exactly as in Phase 2.

### Upgrade Considerations

The hello's `features` bitset is the capability field that § Upgrade Considerations asks for. Honoring the heartbeat bit (so heartbeats can default on) and the daemon wiring follow in a stacked PR from the same job.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

----- BODY: Phase 5 -----
Refs: #252, #1476, #1478

## Description

This is Phase 5 of `designs/ocapn-noise-session-reconnect.md` (on `llm`; design PR #252), stacked on the Phase 3 reconnect-with-Rekey PR (base: the frozen Phase 3 head `build/ocapn-noise-session-reconnect-rekey-4d8b59b`). It adds the crossed-hellos tiebreaker for reconnect.

**`@endo/ocapn-noise`** (`src/network.js`)
- Either side redials. In Phase 3 only the side that opened the session redialed. Now both sides of a reconnect-capable session redial when they lose the transport instance, so a session also recovers when only the accepting side can reach the other.
- Tiebreaker (§ 3): each side compares the two x25519 ephemerals of the handshake that opened the session (the initiator's `e` from the SYN and the responder's `e` from the SYNACK), as 32-byte big-endian integers. The greater side initiates the new transport instance and the lesser side responds. Both sides compute the same answer without exchanging anything. The per-session ephemeral, not the long-term Ed25519 key, means no peer is biased toward one role across sessions.
- Procedure: when a side whose own reconnect dial is in flight, and which wins the tiebreaker, receives the peer's crossed dial, it closes that dial without an answer. The peer treats this as an ordinary failed attempt, never as a refusal. The losing side accepts the inbound dial and discards its own dial when that lands. Exactly one transport instance survives, and the epoch advances by one.
- Convergence: a dial for an epoch the session has already reached (the losing half of a crossed pair, or a dial whose answer was lost) is closed unanswered. A dial for a later epoch is accepted as is, so a dialer that missed an earlier answer still converges. A dial that returns after the session has moved on is discarded and redialed for the next epoch if the session is still waiting.

The loss fault injector (`test/_loss-injector.js`) gains `delayConnects` (holds every dial in flight so that two near-simultaneous redials cross), `refuseOutbound`, and `getOpenStreams`.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in every codec plus heartbeat liveness, #1476
Phase 2: satisfied | session outbound queue + stall fault injector, #1478
Phase 3: satisfied | reconnect with Rekey, the Phase 3 PR (this PR's base)
Phase 4: deferred | reconnect with Resume; gated on Open question C1 and the cryptographic review (#1475), not settled by the maintainer
Phase 5: satisfied | crossed-hellos tiebreaker: both sides partitioned at once, with every dial held in flight, converge on exactly one transport instance (one open stream seen from each end), agree on the epoch, and deliver frames exactly once, in both codecs (`packages/ocapn-noise/test/reconnect.test.js`, "crossed hellos on reconnect converge on one transport instance"); the side that accepted the session reconnects it when the other cannot dial out
Acceptance: partial | the design's crossed-hellos test holds; Resume (Phase 4) is deferred on C1
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- The tiebreaker input is already exchanged in the Noise IK handshake, and the comparison leaks nothing new. It uses the per-session ephemerals, as § 3 specifies (Open question P3 still asks whether a transcript-based value is preferable).
- A crossed dial is closed without an answer, never with a refusal, so the tiebreaker cannot make a peer abort a session it still holds.
- Every reconnect is still a full Noise IK handshake (Rekey), so no `(key, nonce)` pair is ever reused.

### Scaling Considerations

At most one extra handshake per crossed reconnect, which is closed as soon as its hello is read. The session also keeps one boolean for whether a dial is in flight.

### Documentation Considerations

The `ReconnectOptions` doc in `src/types.d.ts` still describes the opener redialing. This PR's behavior (either side redials) is covered in the commit and here. No public API change.

### Testing Considerations

`packages/ocapn-noise/test/reconnect.test.js` adds two tests. The crossed-hellos test (cbor and syrup) partitions both sides at once and delays every dial so the two redials cross. It asserts that both sides dialed, that exactly one stream survives seen from each end, that both sides agree on the epoch, and that frames are delivered exactly once afterwards. A debug-instrumented local run confirmed that the winning side drops the peer's crossed dial. The second test has the accepting side reconnect when the opener cannot dial out. The suite passed six consecutive local runs. Local results: `@endo/ocapn-noise` passed 105 tests per config (lockdown, unsafe, endo), apart from the shared-ava-cache `ENOENT import-from-project.mjs` worker error, which does not reproduce when the affected file runs alone. `yarn lint` reports no errors.

### Compatibility Considerations

Same wire format as the Phase 3 PR. The only behavior change is that the accepting side now also redials.

### Upgrade Considerations

None beyond the Phase 3 PR.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

----- BODY: Heartbeat capability -----
Refs: #252, #1476, #1478

## Description

This PR completes `designs/ocapn-noise-session-reconnect.md` § Upgrade Considerations. It is stacked on the Phase 5 crossed-hellos PR (base: the frozen Phase 5 head `build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e`). It adds the heartbeat capability bit, turns heartbeats on by default, and wires the daemon to use them.

**`@endo/ocapn-noise`** (`src/network.js`)
- Bit 0 of the `op:session-hello` `features` bitset (introduced in the Phase 3 PR) is the heartbeat capability. A session runs heartbeats only when both hellos advertise the bit. Otherwise it behaves as before the amendment: no `op:ping` or `op:pong` is sent and nothing times out. A peer that does not take part therefore never receives a frame it does not expect.
- With that negotiation in place, heartbeats default on: `makeOcapnNoiseNetwork({ codec })` runs them at the § 5 defaults (5 s interval, 30 s session timeout), and `heartbeat: false` opts out. Reconnect stays opt-in (`reconnect: true` or options).

**`@endo/daemon`** (`src/networks/ocapn.js`)
- The daemon's OCapN-Noise network passes `heartbeat: {}` explicitly, so a dead peer is detected within `SESSION_TIMEOUT` instead of when TCP gives up.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in every codec plus heartbeat liveness, #1476
Phase 2: satisfied | session outbound queue + stall fault injector, #1478
Phase 3: satisfied | reconnect with Rekey, the Phase 3 PR
Phase 4: deferred | reconnect with Resume; gated on Open question C1 and the cryptographic review (#1475), not settled by the maintainer
Phase 5: satisfied | crossed-hellos tiebreaker, the Phase 5 PR (this PR's base)
Acceptance: partial | Upgrade Considerations: heartbeats are negotiated by capability bit and on by default (`packages/ocapn-noise/test/heartbeat.test.js`: "heartbeats are on by default", "a peer without heartbeats receives no heartbeat frames"); the daemon's OCapN tests pass with heartbeats on (`packages/daemon/test/networks-ocapn.test.js`, 9 tests); Resume (Phase 4) remains deferred on C1
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

The capability bit travels inside the Noise channel, in the hello exchanged after the authenticated `op:start-session`, so an on-path attacker cannot strip it. Turning heartbeats on adds no authority. It adds traffic inside the existing session: one ping/pong pair per side every 5 s.

### Scaling Considerations

Each session with heartbeats on costs one interval timer and one liveness timer, plus two small encrypted frames per side every 5 s. That is negligible for daemon session counts.

### Documentation Considerations

`HeartbeatOptions` and `SessionLiveness.heartbeat` in `packages/ocapn-noise/src/types.d.ts` now describe the default and the negotiation. `@endo/ocapn-noise` and `@endo/daemon` are private, so there is no changeset.

### Testing Considerations

`test/heartbeat.test.js` covers the default and the negotiation: a heartbeat side paired with a `heartbeat: false` peer runs no heartbeat, never takes the peer's silence for loss, and still carries data. The silent-peer test now models the crash with a very slow peer heartbeat, since the peer is no longer heartbeat-free by default. Tests that exercise the direct-write path pass `heartbeat: false`. Local results: `@endo/ocapn-noise` passed 106 tests per config, apart from the shared-ava-cache `ENOENT` worker error, which does not reproduce when the affected file runs alone. `packages/daemon/test/networks-ocapn.test.js` passed 9 of 9. Lint reports no errors.

### Compatibility Considerations

Callers that never passed `heartbeat` now get heartbeats, but only toward peers that advertise them too, so there is no wire surprise for a peer that opted out. Code that relied on `writer.next` resolving on the transport write must pass `heartbeat: false`, because heartbeat sessions resolve once a frame is accepted into the session queue (Phase 2).

### Upgrade Considerations

Every peer must run the Phase 3 wire (the hello exchange). Among such peers, heartbeats switch on only when both advertise them, which is the default-on behavior with fallback that § Upgrade Considerations asks for.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODIES -----
