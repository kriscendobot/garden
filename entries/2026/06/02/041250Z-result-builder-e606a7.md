---
ts: 2026-06-02T04:12:50Z
kind: result
role: builder
worktree: dispatches/builder--e606a7
repo: endojs/endo-but-for-bots
project: endo
---

Phase 4 of the gateway-package stack landed as PR
[endojs/endo-but-for-bots#392](https://github.com/endojs/endo-but-for-bots/pull/392)
(DRAFT, base `design/gateway-package-phase-3`, head
`design/gateway-package-phase-4`).
Implements Feature 8 of `designs/gateway-package.md`: the
`OcapnWebSocketHandler` semantic core for `/ocapn-cbor-np`
WebSocket termination.

The handler accepts an upgraded WebSocket as a
`{ reader, writer }` byte-stream pair, reads the first frame,
extracts the 32-byte intended-responder Ed25519 public key from
the prefixed-SYN's cleartext prefix, looks up the registration
that owns the key in the bootstrap's table (from #388 / phase 2),
and hands the stream pair off to the registered daemon's
`handleOcapnSession` exo method.
The gateway does not terminate Noise; encryption and peer
authentication run end-to-end between the dialing peer and the
registered daemon.
This matches the design's "the gateway opens a proxy channel to
that target on receipt of the SYN, then pumps frames in both
directions without inspecting them" contract.

The Node-bound HTTP listener that performs the WS upgrade is
deferred to a follow-on PR (alongside the Feature 4 UDS listener),
mirroring phase 2's discipline of landing the bootstrap exo
without owning the platform listener.
Until then, embedders that already own an HTTP server feed the
handler directly via `gateway.getOcapnHandler()`.

Files:

- `packages/gateway/src/ocapn-ws.js` (new, 481 lines).
- `packages/gateway/test/ocapn-ws.test.js` (new, 568 lines).
- `packages/gateway/src/bootstrap.js`:
  `lookupRegistrationByPublicKey` on the in-process backplane.
- `packages/gateway/src/config.js`: `ocapnWebSocket -> udsBootstrap`
  dependency in the validator.
- `packages/gateway/index.js`: `getOcapnHandler()` accessor on the
  Gateway exo, symmetric with `getAdmin()`.
- `packages/gateway/package.json`: `@endo/stream` dependency added
  (and a separate `chore: Update yarn.lock` commit).
- `packages/gateway/README.md`: phase-4 status, surface, deferred
  list.
- `packages/gateway/test/gateway.test.js`: existing
  udsBootstrap-off regression updated to also turn off
  ocapnWebSocket (per the new dependency).

Architectural choices documented in the PR body:

- The gateway is a frame-level proxy (the design's design
  decision; the handler implements it).
- `handleOcapnSession` is the new daemon-side exo method the
  gateway calls into.
  The design's `UserDaemon` interface (Feature 4) does not yet
  name it; the handler treats the registered exo as opaque with
  a single method.
  A future design revision can name the method in the interface
  table.
- The first frame is replayed verbatim to the daemon so the
  downstream Noise responder sees the unmodified prefixed-SYN.
- Daemon takes precedence over relayTarget in registration entries
  (regression-tested).
- Streams handed across the CapTP boundary are `Far`-tagged.
- The intended-responder prefix is copied into a fresh
  `Uint8Array` for the lookup key (defends against WS adapter
  buffer recycling).
- Every negative branch closes the stream pair and returns.

Tests: 18 new tests pass; full gateway suite at 171 tests
(153 pre-existing + 18 new).
Regression evidence verified by ad-hoc saboteur edits on the
short-frame check (broken length-check → test hangs) and the
lookup path (broken lookup → observed.reader is undefined →
truthy assert fails).

Lint and tsc clean on the gateway package.
`yarn format` reformatted only the gateway files I touched plus a
pre-existing `packages/hex-test/package.json` cosmetic fix that I
reverted (out of scope for this PR).

The chain continues with cleaner → judge (barrister panel) →
fixer (if needed) → un-draft. The orchestrator dispatches the
next stage.

Self-improvement: discovered three small wrinkles worth surfacing.
(1) `@endo/stream`'s `makePipe()` returns `[writer, reader]` but
both endpoints are symmetric Stream-shaped objects; the variable
names "writer" and "reader" describe the *role* the caller plays,
not a type-level distinction.
A first-time consumer of the API would benefit from a one-line
note in `packages/stream/README.md` § Symmetric pipe endpoints
naming the convention.
(2) The OCapN-Noise `transport/ws` (`packages/ocapn-noise/src/transports/ws-node.js`)
implements a per-connection WS adapter that converts each binary
WS frame into a `Uint8Array` chunk via a `makeQueue`-backed
reader/writer pair.
The same shape is what Phase 4's gateway handler would receive
from a Node HTTP server's upgrade callback, so the Phase 5
follow-on (Node HTTP listener) can crib directly from
`adaptWebSocket` rather than reinventing it.
The cross-reference is worth a line in the gateway's
`src/ocapn-ws.js` JSDoc when the follow-on lands.
(3) Streams that cross a CapTP boundary as exo-method arguments
must be `Far`-tagged; the `@endo/stream` factories return plain
harden'd records that fail `@endo/marshal`'s passable-style check
("Remotables must be explicitly declared").
The friction is small but bit me twice during this build; a note
in `packages/stream/README.md` § Crossing CapTP would save the
next builder the same loop.
The pattern lands in this PR's `src/ocapn-ws.js` as `prependFrame`
and the per-connection `farWriter` wrapper.
