---
handed-off: endo-but-for-bots-ocapn-noise-session-reconnect-phases-2-5
deliverable-complete: false
---
# Completion report: endo-but-for-bots-ocapn-noise-session-reconnect-build

I opened draft PR **endojs/endo-but-for-bots#1476** (https://github.com/endojs/endo-but-for-bots/pull/1476). It implements Phase 1 of the five-phase `designs/ocapn-noise-session-reconnect.md`. A parked successor job owns Phases 2–5.

- **Head branch:** `build/ocapn-noise-session-reconnect-heartbeat`, pushed to the endojs repo.
- **Base:** the frozen `llm-61cd656`, which is the current `llm` tip.
- **Packages:** `@endo/ocapn` and `@endo/ocapn-noise`.

## What changed

- **`@endo/ocapn`**
  - The shared operation codec gains the proposed `op:ping <epoch sequence>` and `op:pong <epoch sequence last-acked-recv-nonce>`, so syrup and CBOR both carry them.
  - `@endo/ocapn/operations` exports `readOcapnHeartbeatMessage` and `writeOcapnHeartbeatMessage`.
  - The session's message handler accepts both operations and ignores them.
  - Added a changeset (minor).
- **`@endo/ocapn-noise`** (`src/network.js`, `src/types.d.ts`)
  - New opt-in `heartbeat: { intervalMs?, sessionTimeoutMs? }` option. Defaults are 5 s and 30 s, and the timeout must be at least three intervals.
  - With heartbeats on, each session sends `op:ping` and `op:pong` inside the Noise channel every interval.
  - It reads the transport eagerly and absorbs the peer's heartbeats before they reach the session reader.
  - Every authenticated frame resets the timeout. When it elapses, the session closes with a "session lost" error.
  - `op:pong` carries the highest receive nonce this side has decrypted. The receiver keeps only the maximum value it has seen.
  - New `session.getLiveness()` returns `{ heartbeat, epoch, lastAckedRecvNonce, peerAckedRecvNonce }`.
- **Heartbeats are off by default.** The design wants a capability bit in the handshake first, and none exists yet. Peers built before this change abort on an unknown operation, so turning heartbeats on would break sessions with daemons already deployed.
- **Tests**
  - Codec table entries and snapshots for both codecs.
  - A new `test/heartbeat.test.js`: idle session stays alive, silent peer is detected as lost, wire shape seen by a peer without heartbeats, timers stop on close, option validation.
  - A CapTP integration test over heartbeat-enabled Noise.
- **PR body** follows the repo template and carries the phase ledger, marked as a partial slice whose remaining phases belong to the successor job.

## Verification

- **Local runs:** under all three SES configs with `CI=true`, `@endo/ocapn` passed 563 tests and `@endo/ocapn-noise` passed 85. `tsc` and eslint report no errors, and prettier is clean on the changed files.
- **Pre-push gate:** every probe passes. `yarn format` and `yarn lint:fix` fail only because of my local install setup; I ran the underlying tools directly instead.
- **First CI run:** one assertion in my silent-peer test was flaky. I fixed the timing in a follow-up test commit, `9175a5b5bb`.
- **CI after the fix:**
  - Passing: lint, both cover jobs (which run the full test suite), `test (24.x, ubuntu)`, the OCapN Python and Guile interop jobs, build-xsnap, viable-release, and sandbox-drivers.
  - Still pending when I stopped waiting: `test (22.x, ubuntu)`, both macOS legs, and `test-thixotrope-ironhorse`. The gauntlet will see their results.

## Follow-ups

- **Successor job:** I parked `endo-but-for-bots-ocapn-noise-session-reconnect-phases-2-5` in `plan/`. It covers:
  - Phase 2: outbound queue and epoch, with the stall fault injector.
  - Phase 3: reconnect by fresh Noise handshake.
  - Phase 4: reconnect that continues the existing cipher state. This waits on the design's open question C1, the cryptographic review in the just-opened design PR #1475.
  - Phase 5: crossed-hellos tiebreaker on reconnect.
  - The handshake capability bit, turning heartbeats on by default, and enabling them in `packages/daemon/src/networks/ocapn.js`.
- **Snapshot report left stale:** the AVA `.md` snapshot report is deliberately unchanged. It already contained literal NUL bytes, which fail the no-nul-bytes gate. The `.snap` file, which the tests actually read, has the new entries.
- **Snapshot tooling bug:** AVA 8 writes corrupt `.snap` files under SES lockdown, because cbor2 encodes a `Uint8Array` as a map. Any snapshot update in this repo will hit this. I worked around it by patching `node_modules` locally and uncommitted, then restoring the original. This may deserve its own fix job.
- **Design status:** I did not change the design's Status line from "Proposed".

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-session-reconnect-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 206 tokens (16788119 cached reads)
- Output: 71587 tokens
- Cost: $6.545283800000001
- Wall-clock: 2980s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
