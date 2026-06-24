---
ts: 2026-06-03T05:09:00Z
kind: result
role: builder
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--57e6ca/project
---

Phase 11a of the Endo Gateway stack (#343) lands: HTTP listener
wire-up. DRAFT PR [#413](https://github.com/endojs/endo-but-for-bots/pull/413)
opens against phase-10 head (`design/gateway-package-phase-10`).
Branch: `design/gateway-package-phase-11`.

## What ships

- `packages/gateway/src/http-listener.js`: portable Node HTTP
  listener exo. Binds via `node:http.createServer` on the
  gateway's `BindAddress`, routes `/git/<rest>` to
  `GitHttpHandler`, consults `AppsNameHub` by Host header on
  every other path (501 with `X-Endo-Weblet-Formula` on hit,
  404 on miss; CAS fetch is Phase 11b's). On `upgrade`,
  delegates to a `wsUpgrade` adapter and feeds the resulting
  `{reader, writer}` stream pair to
  `OcapnWebSocketHandler.handleConnection`. `whenBound()`
  surfaces the OS-assigned port for `:0` binds. `start()` /
  `stop()` are idempotent; `stop()` drains in-flight requests.
- `packages/gateway/src/node-ws-upgrade.js`: Node-side WS
  upgrade adapter using the `ws` package
  (`WebSocketServer({noServer: true})`). Exports
  `makeNodeWsUpgrade()` and `streamPairFromWebSocket()`. Kept
  in a separate module so the portable core never imports
  `ws`; embedders running under non-Node hosts supply their
  own adapter.
- `packages/gateway/index.js`: `start()` now binds the HTTP
  listener when `enableFeatures.httpListener` is on; `stop()`
  closes it before the Familiar publisher cleanup. The
  Familiar publish path reads the resolved port from the
  listener's `whenBound()` for the `:0` case.
- `packages/gateway/src/config.js` + `types.d.ts`: new
  `httpListener` feature toggle, defaulted to **off** during
  the phased rollout. The Phase 11 follow-on flips the default
  once every in-tree embedder migrates.
- `packages/gateway/types.d.ts`: new typedefs `HttpListener`,
  `HttpListenerBoundAddress`, `WsUpgradeAdapter`,
  `WsUpgradeContext`.
- `packages/gateway/package.json`: adds `ws ^8.18.0` runtime
  dep and `@types/ws ^8.18.1` dev dep (only used by the Node
  adapter module).

## Tests

`packages/gateway/test/http-listener.test.js`: 16 new tests
covering bind/port surface, path routing (unknown 404, `/git`,
host-header weblet 501, miss 404), X-Forwarded threading
(trusted + untrusted), WS upgrade dispatch via stub adapter,
non-OCapN upgrade path 404, lifecycle (start/stop
idempotence, stop refuses new connections), end-to-end
`makeGateway` with the listener toggle on, and a real `git`
CLI push round-trip through the listener with bearer auth.

Full gateway suite: 471 tests pass (455 pre-existing + 16
new). All but the WS upgrade test pass deterministically; the
WS upgrade test uses a stub adapter to short-circuit the real
`ws` handshake and assert the listener feeds the
`{reader, writer}` pair to the configured `OcapnWebSocketHandler`.

## Notable design choices

- **`httpListener` toggle defaults off.** Flipping it on by
  default would break every pre-Phase-11 test that constructs
  a gateway and calls `start()` without supplying a `wsUpgrade`
  adapter. The phased-rollout posture matches how the rest of
  the stack (Phases 4 / 6 / 9 toggles) opted in.
- **`ws` is a runtime dep, but only the Node adapter imports
  it.** The portable listener consumes a `wsUpgrade` adapter
  shape; the Node-side adapter lives in `node-ws-upgrade.js`
  alongside `node-crypto-powers.js` and
  `node-familiar-publish-powers.js`. Embedders under Endor or
  a browser bundle skip the Node module entirely.
- **WS upgrade context is not hardened.** The listener hands
  the adapter the live `IncomingMessage` and `Socket` so it
  can run the WS handshake; SES would deep-freeze the socket
  and break Node's internal `_eventsCount` mutation. Comment
  in the listener documents the rationale.
- **Host-header weblet path returns 501, not the static
  asset.** The CAS fetch from the daemon's `fetchContentTree`
  is out of scope for 11a (Phase 11b lands it). The 501 carries
  the resolved `X-Endo-Weblet-Formula` header so a daemon-side
  prototype can observe routing without pretending to serve
  content.
- **No frozen-base branch.** The dispatch said "Open DRAFT PR
  against `design/gateway-package-phase-10` (stacking
  convention)" and the rest of the gateway phase stack
  (`phase-2` -> `phase-10`) uses plain stacking, not the
  frozen-base discipline. Followed the in-tree pattern.

## What's next

- Phase 11b: AppsNameHub host-header lookup actually serves the
  weblet contentRoot from the daemon's CAS (or the user
  daemon's SSR handler on a miss). Needs the
  `UserDaemon.fetchContentTree` exo and the daemon-side CAS
  wire.
- Phase 11a follow-on: flip `enableFeatures.httpListener` to
  default-on, migrate the daemon's existing `web-server-node.js`
  callers, retire the override.

Self-improvement: nothing this time.
