role: builder

# Build: wire the WebSocket transport into the daemon's OCapN-Noise netlayer (PR #340)

**Repo:** `endojs/endo-but-for-bots`. **Base branch:** `claude/endo-daemon-ocapn-FkmHO`
(the draft **PR #340** daemon↔OCapN-Noise integration; base `llm`). Build on a fresh
branch stacked on `claude/endo-daemon-ocapn-FkmHO` — **not** on `llm`. Keep it a draft;
no upstream ferry.

## Why

PR #340 adds `packages/daemon/src/networks/ocapn.js` — an `EndoNetwork` over
`makeOcapn`+`makeOcapnNoiseNetwork({codec: cborCodec})` — but it is **TCP-only**
(`makeTcpTransport`, protocol `ocapn+noise+tcp`). We need the daemon to also **serve and
dial over WebSocket+Noise**, because the target deployment host (minion.town) only exposes
443/WS. The `@endo/ocapn-noise` WS transport is already landed and listener-capable.

Independently verified (scratch harness): `@endo/ocapn-noise` round-trips an OCapN
capability between two processes over BOTH real WS and real TCP+CBOR, and Crossed
Hellos + reverse peer auth hold on both. So this is daemon-side wiring, not new protocol.

## Task

1. **Add the WS transport to `packages/daemon/src/networks/ocapn.js`.**
   - Import `makeWebSocketTransport` from `@endo/ocapn-noise/transport/ws`
     (`packages/ocapn-noise/src/transports/ws-node.js` — `scheme:'ws'`, `connect({url})`,
     `listen(handler)` via `WebSocketServer`, advertises `hints:{ url:'ws://host:port' }`).
   - The daemon must **supply `WebSocket`/`WebSocketServer` powers** — the current caplet
     does not thread them in. Add them to the daemon powers the same way other Node
     capabilities are injected (mirror how `ws-relay`/`setup-ws-relay` obtains `ws`), and
     pass them into the transport. Do not import `ws` ambiently in confined code.
   - Register it alongside the TCP transport (`network.addTransport(wsTransport)`), gated
     on config so a daemon can enable TCP, WS, or both.
   - Add a **`ws-listen-addr`** stored address parallel to the TCP `ocapn-listen-addr`
     (~`ocapn.js:49`).
   - Add an **`ocapn+noise+ws`** address-protocol variant parallel to `ocapn+noise+tcp`
     (~`ocapn.js:165`), carrying `{ 'ws:url':'ws://…' }` hints. Implement the URL
     parse/format (the TCP path's IPv6-bracketing host/port logic is TCP-shaped — write the
     ws analogue). The noise network already emits `ws:`-prefixed aggregated hints
     (`packages/ocapn-noise/src/network.js:453-461`), so `addresses()` can read them.
   - Make `supports()` / `addresses()` / `connect()` handle the `ws` protocol as well as
     `tcp`. Serving is generic: `makeOcapn`'s inbound path
     (`packages/ocapn/src/client/index.js:664-706`) consumes `network.inboundSessions`, and
     the WS transport's `listen` feeds it — so once a listen-capable transport is added,
     inbound WS sessions serve the `EndoOcapnBootstrap` with no extra plumbing.
   - `setup-ocapn.js` installs the net at `@nets/ocapn`; extend its config surface for the
     WS listen address if needed.

2. **Extend the in-process suite to WS.** PR #340 ships `_multiplayer-suite.js` +
   `invite-retention-ocapn.test.js` running invite/accept/value-exchange/partition/restart/
   three-party over `ocapn+noise+tcp`. **Parameterize the suite over BOTH
   `ocapn+noise+tcp` and `ocapn+noise+ws`** so invite/accept over Noise+WS+CBOR is proven
   in-process. Keep the TCP runs green.

## Constraints / done

- Follow `AGENTS.md`: `// @ts-check` on every `.js`, `harden` all exports, ses-ava tests,
  `yarn lint` (harden-exports, no-underscore-dangle) + `yarn lint:types` clean in
  `packages/daemon` (and `yarn build:types:gen` if daemon deps change). The Noise WASM
  ships in-tree (`packages/ocapn-noise/gen/ocapn-noise.wasm`) — no Rust build.
- Do **not** regress the TCP path. Do **not** attempt the forked two-daemon test here
  (that's the next milestone) — in-process WS coverage is the deliverable.
- **Deliverable:** the stacked branch with the WS wiring + ws-parameterized suite passing,
  and a completion report summarizing the diff, the exact new address/hint format, the
  powers you threaded in, and anything you had to route around. Do not open/comment on any
  PR/issue.
