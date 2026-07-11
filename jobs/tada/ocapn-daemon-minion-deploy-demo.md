Everything is complete, verified, and durable. Final summary:

## Completion report

**Goal delivered:** a working M3+M4 demonstration — an OCapN-Noise service running under systemd on **minion.town** (EC2 `i-0380cd68b90020fad`, aarch64, node v22) serving OCapN over **WebSocket+Noise+CBOR**, dialed by a **local peer** from a garden container over `wss://minion.town/ocapn`, with a capability round-tripping. Reproducible via a committed script + captured transcript.

**End-to-end path proven:** local peer → Caddy TLS 443 → loopback WS `127.0.0.1:8930` → Noise IK mutual auth → CBOR → OCapN sturdyref → capability invoke. Result line: `RESULT {"ok":true,"swissnum":"greeter","nodeId":"810b996c…","reply":"Hello, the local peer! …"}`.

**How it was built/deployed:**
- Cloned `endojs/endo-but-for-bots @ claude/endo-daemon-ocapn-ws-FkmHO` (the WS-transport branch, already landed) to `/opt/endo` via public HTTPS; `corepack yarn install` (yarn 4.13.0, pnpm linker, ~50s, **no native build** — the Noise WASM ships prebuilt in-tree, so aarch64 needs nothing special).
- **systemd unit** `endo-ocapn-daemon.service` (enabled + active): `WorkingDirectory=/opt/endo/packages/daemon`, `ExecStart=/usr/local/bin/node demo/ocapn-ws-server.mjs /opt/endo/ocapn-demo-location.json`, `DEMO_HOST=127.0.0.1 DEMO_PORT=8930`.
- **Caddy route** (exact): `handle /ocapn* { reverse_proxy 127.0.0.1:8930 }` folded *into* the existing `minion.town, www.minion.town { … }` site block in `/etc/caddy/conf.d/minion-town.caddy` (a `handle`, not a second site block — Caddy rejects duplicate addresses). **Not** behind oauth2-proxy `forward_auth`. `caddy validate` passed before `systemctl reload caddy`; backup at `minion-town.caddy.bak-ocapn`. `caddy`/`oauth2-proxy`/`minion-mcp` untouched.
- **wss URL:** `wss://minion.town/ocapn`.

**Key mechanism / code gap routed around:** the daemon advertises its loopback bind (`ws://127.0.0.1:8930`), but the peer reaches it only via `wss://minion.town/ocapn`. There is no config to make the daemon advertise a public URL, so the client rewrites just the `ws:url` transport hint — the Noise handshake authenticates the location **designator** (server's static key), which is independent of the transport URL. Validated: wrong hint + no override fails; override succeeds.

**Tentative choice (per "prefer tentative progress over delay"):** the systemd unit runs a standalone service using the *same* `@endo/ocapn-noise` + `@endo/ocapn` WS+Noise+CBOR session/locator/sturdyref machinery as the daemon's `src/networks/ocapn.js`, minus the pet-store/agent/gateway lifecycle — the smallest default that proves the whole transport path without the daemon-lifecycle plumbing (background `endo`, unix socket, `@nets/ocapn` install, live-address extraction). The README documents the exact steps to promote it to the full `@nets/ocapn` Pet Daemon bootstrap (`endo-bootstrap` swissnum); the Caddy route and client are unchanged.

**What changed / landed:** `packages/daemon/demo/minion-town/` (server, client, systemd unit, Caddy snippet, repeatable `run-demo.sh`, `ssm.sh`, README, transcript) committed and pushed to the WS branch (`endojs/endo-but-for-bots`, commit `b08e8b696d`). No daemon source fixes were needed. Updated the `ocapn-over-noise-goal` memory (M3/M4 now demonstrated).

**Host state:** left running (maintainer intends to run the daemon on minion.town). Maintainer notified via the bus; offered two quick follow-ups — (a) promote to the full Pet Daemon bootstrap, (b) land the Caddy route durably in the `kriscendobot/minion.town` repo.

**Follow-ups (open):** M5 (route `endo://` dials through `@nets/ocapn` + forked two-daemon invite/accept over tcp and ws); optional promotion to the real Pet Daemon bootstrap and durable Caddy route — both awaiting maintainer's call.
