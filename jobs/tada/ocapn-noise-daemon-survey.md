Inbox is empty. Here is my completion report.

---

# Survey: Does the Pet Daemon speak OCapN-over-Noise? (endojs/endo-but-for-bots @ `llm`)

**Bottom line:** On the `llm` branch, the Pet Daemon does **not** speak OCapN-over-Noise at all. Its remote peer edge is entirely the legacy `@endo/captp`-over-netlayer stack. The OCapN-Noise netlayer, its CBOR codec, and both the TCP and WS transports **are landed** (as sibling packages), but the **daemon integration is unmerged** — it exists only as **draft PR #340** (TCP-only) and gap-probe **draft PR #262**.

## 1. Daemon ↔ noise netlayer — NOT wired on `llm`

`grep -rn "ocapn-noise|makeOcapnNoiseNetwork|@endo/ocapn"` across all of `packages/daemon/` (src + package.json) returns **zero hits**. `makeOcapnNoiseNetwork` is referenced only inside `packages/ocapn-noise/**` and `packages/ocapn/src/client/index.js:664` — never the daemon or CLI.

What the daemon uses instead — pluggable `EndoNetwork` caplets under `packages/daemon/src/networks/`, each running **`@endo/captp`** (`connection.js:4`, `makeMessageCapTP` at `connection.js:96`), not OCapN:
- **tcp-netstring** — `networks/tcp-netstring.js`, protocol `tcp+netstring+json+captp0` (line 19). Netstring-framed CapTP over TCP.
- **ws-relay** — `networks/ws-relay.js`, protocol `ws-relay+captp0` (line 42); default relay `wss://endo-relay.fly.dev` (`setup-ws-relay.js:30`).
- **iroh** — `networks/iroh.js` (optional `@number0/iroh`).
- **loopback** — `networks/loopback.js` (in-process only).

**Registration model** = a formula **directory** (`@nets`), not a plugin API. A setup caplet installs the module via `makeUnconfined` and `move`s it into `@nets/<name>` (e.g. `setup-tcp.js:34-39`). The daemon discovers them by listing that directory: `getAllNetworks` (`daemon.js:5778-5786`), aggregates locators via `getAllNetworkAddresses` (`daemon.js:5788-5804`). Dial path: `makePeer`→`getRemoteGatewayViaNetwork` (`daemon.js:5812-5917`) calls `E(network).supports(protocol)` then `E(network).connect(address, ctx)`. Accept path: `localGreeter.hello(...)` (`daemon.js:1456-1477`). The netlayer contract is `EndoNetwork = { supports, addresses, connect }` (`types.d.ts:1230-1234`).

## 2. Invite/accept workflow (landed, transport-agnostic-by-opacity)

CLI: `invite.js:7-14` prints the inviter's **locator string** to stdout; `accept.js:15-27` reads a locator string from **stdin**. Out-of-band copy/paste is the pairing channel.

Agent side (`host.js`): `invite` (1578-1604) creates a durable `invitation` formula; `accept` (1610-1710) `parseLocator`s the string, reads `from`/`fromNode` query params, builds `peerInfo = { node, addresses: hints }`, calls `addPeerInfo`, then calls back `E(invitation).accept(handleLocator, guestLeaf)` with **its own** host addresses as hints. The invitation exo's `locate`/`accept` live in `daemon.js:6082-6199`. It's a **two-way locator exchange**; both sides end up calling `addPeerInfo({node, addresses})`.

**Wire format** — the `endo://` locator (`locator.js:16-44`):
```
endo://{peerKey}/{formulaNumber}@{hint1}@{hint2}?type=invitation&from={h}&fromNode={n}
```
`peerKey` = 64-hex Ed25519 `NodeNumber`; path components after the formula number are **connection hints** = opaque transport-prefixed URL strings (`ConnectionHint = string`, `types.d.ts:41`), e.g. `tcp+netstring+json+captp0://host:port`. Reconstituted in memory as `PeerInfo { node, addresses[] }` (`types.d.ts:1224-1228`). The invitation formula itself stores **no** addresses — they're fetched live from `getPeerInfo()` at `locate()` time.

**Distance from `OcapnLocation`** (`ocapn/src/codecs/components.js:29-37`: `{ type:'ocapn-peer', designator, transport|network, hints: false|Record }`): **moderate, mostly a re-encoding.** Both carry "identity + transport hints." Mismatches: (a) Endo folds transport into each hint-string prefix and mixes transports in one flat array; OcapnLocation has a single `network` selector + a **keyed** hints table (`{'ws:url':…}` / `{'tcp:host':…,'tcp:port':…}`). (b) OcapnLocation has no `formulaNumber`/`from`/`fromNode` — those invitation-layer fields must ride *alongside* it. (c) `node` is a real crypto key; `designator` is an opaque string that must hold the same key. **There is no parser** today that splits an Endo hint string into a `{network, hints{}}` structure — hints are routed purely by `network.supports(addressString)` prefix matching.

**Any existing invite/accept-over-noise path?** No — zero daemon↔ocapn wiring on `llm`. But the seam is clean: `EndoNetwork.connect` is the extension point, and because `ConnectionHint` is an opaque string, a `ocapn+noise+…://…` hint already flows through `getPeerInfo`/`addPeerInfo`/locator unchanged.

## 3. Landed vs in-flight

**Landed (merged, on `llm`):**
- **#137** (merged 2026-05-08) — noise IK netlayer, consolidating #111 (CBOR codec) + #112 (Noise IK) + #113 (transport tests). This is why `@endo/ocapn-noise` (network + `./transport/tcp` + `./transport/ws`) and `@endo/ocapn/cbor` all exist on `llm`.
- **#361** (merged 2026-05-25) — ported the tcp-syrup netlayer test to `makeOcapn`.
- Iroh transport for the *legacy* CapTP daemon: #446/#465/#479 (unrelated to OCapN-Noise).

Confirmed on `llm`: `packages/ocapn-noise/src/transports/{tcp.js, ws-node.js}` both exist. **`ws-node.js` supports a full listener** — `makeWebSocketTransport` exposes `scheme:'ws'`, `connect`, and `listen` (via `WebSocketServer`), advertising `hints:{ url:'ws://host:port' }` (`ws-node.js:137-220`). The codec is chosen at the network level (`makeOcapnNoiseNetwork({codec})`), independent of transport, so WS+CBOR and TCP+CBOR are both already possible at the netlayer.

**In-flight (draft, NOT on `llm`):**
- **PR #340** `claude/endo-daemon-ocapn-FkmHO` (draft, base `llm`, updated 2026-05-28) — **the primary daemon integration.** Phase 1 of `designs/daemon-ocapn-external-connectivity.md`. Adds `packages/daemon/src/networks/ocapn.js` (334 lines) — an `EndoNetwork`-conforming OCapN-Noise transport (`addresses`/`supports`/`connect`), address protocol `ocapn+noise+tcp`, embedding `makeOcapn` over `makeOcapnNoiseNetwork({codec: cborCodec})` with **`makeTcpTransport` only** (line ~165). Publishes an `EndoOcapnBootstrap` exo at swissnum `endo-bootstrap`; dials by enlivening the peer bootstrap and running the existing `hello` handshake on top. `setup-ocapn.js` installs it at `@nets/ocapn`. **Serving works** via `makeOcapn`'s inbound path (`ocapn/src/client/index.js:664-706` consumes `network.inboundSessions`) + the TCP transport's `listen`. Notably it also adds `_multiplayer-suite.js` + `invite-retention-ocapn.test.js`, running the **full invite/accept/value-exchange/partition/restart/three-party** suite over `@nets/ocapn` — i.e. **invite/accept over Noise+TCP+CBOR is already prototyped and tested in-process** in this PR, despite the PR body listing the forked-two-daemon test as out of scope.
- **PR #262** `feat/ocapn-daemon-integration` (draft, base `design/ocapn-daemon-integration` = issue #138) — a **gap-revealing skeleton** (`per-agent @transports`) whose deliverable is a gap log, not a feature.
- Related design/branch material: `design/daemon-ocapn-external-connectivity` (the #340 design), `designs/ocapn-daemon-integration.md` (#138), `designs/daemon-agent-network-identity.md`, `designs/ocapn-network-transport-separation.md`, and the gateway OCapN-WS PRs (#577 `/ocapn-cbor-np` path scheme, #392 WS handler) — gateway-side, not daemon-side.

README milestone tracker (`designs/README.md:685`): `ocapn-noise-network` = **Complete**; `daemon-agent-network-identity` = **Not Started**. M4 exit criterion is literally "two Endo daemons connect securely over OCapN-Noise."

## 4. Gap analysis for milestones 4 & 5

**(a) Pet Daemon serves OCapN over WebSocket+Noise with a listener:**
1. **WS transport not wired into the daemon.** PR #340's `networks/ocapn.js` hard-codes `makeTcpTransport` only. Missing: `import { makeWebSocketTransport } from '@endo/ocapn-noise/transport/ws'`, register it via `network.addTransport(...)` (needs a Node `ws` `WebSocketServer` injected — the daemon must supply `WebSocketServer`/`WebSocket` powers, which the current caplet does not thread in), and a `ws-listen-addr`-style stored address parallel to `ocapn-listen-addr` (line 49). The netlayer + `makeOcapn` inbound-session serving already handle "listen + serve bootstrap" generically once a `listen`-capable transport is added, so this is mostly wiring, not new protocol.
2. **Address/hint encoding for `ws`.** The `ocapn+noise+tcp` protocol string and the IPv6-bracketing URL logic in `ocapn.js` are TCP-shaped; need an `ocapn+noise+ws` variant carrying `{ 'ws:url': 'ws://…' }` hints (the noise network already emits `ws:`-prefixed aggregated hints via `network.js:453-461`).
3. **All of this is unmerged** — PR #340 itself must land first (it's draft on `llm`), and it's TCP-only.

**(b) Two Pet Daemons via invite/accept over Noise on both transports:**
1. **Invite/accept over the ocapn network is prototyped but only in-process and only TCP** (PR #340's multiplayer suite). No **forked two-daemon** integration test exists (PR #340 body flags it as belonging to a later phase), and **no WS run** of the suite exists.
2. **`endo://` peer traffic is not routed through `@nets/ocapn`.** PR #340 registers the transport but (per its own "out of scope") does **not** route real peer dials through it or retire `tcp-netstring.js`. The daemon still picks a netlayer by `supports(addressString)` prefix; an invitation's hints today carry `tcp+netstring+json+captp0://…`, not `ocapn+noise+…`, so `getPeerInfo`/`locate` must be taught to advertise the ocapn hints for the invite/accept path to select the noise netlayer.
3. **Node identity binding is unbuilt (explicit gap).** PR #340 defers "bind the OCapN signing key to the daemon agent's `@keypair` so the OCapN session identity matches the node number in `endo://` locators" (design `daemon-agent-network-identity`, README = Not Started). Until then the Noise key and the daemon `NodeNumber`/`designator` are distinct identities — the bootstrap does a cross-checked node-id *report* as a stopgap. Invite/accept mutual authentication over Noise depends on closing this.
4. **Locator↔OcapnLocation adapter absent.** Per §2, there is no parser turning opaque hint strings into `{network, hints{}}` and no place carrying `from`/`fromNode` alongside an OcapnLocation. Either keep the `endo://`+opaque-hint scheme (PR #340's approach — noise hints ride as an opaque `ocapn+noise+…` address, cheapest) or introduce a real OcapnLocation-carrying invitation (larger change).
5. **Design-level open items** surfaced by PR #262's gap log: the local-agent loopback distinguisher (`isLocalKey` vs string locators), `listenPolicy` enum enforcement site, and per-agent `@transports` semantics — relevant if milestone 5 is scoped to the multi-agent `#138` design rather than the simpler daemon-level `#340` design.

**Recommended starting point for the builder:** build milestones 4 & 5 **on top of PR #340's `claude/endo-daemon-ocapn-FkmHO` branch** (not `llm`), since it already delivers the `@nets/ocapn` netlayer, the `EndoOcapnBootstrap`, CBOR framing, and a passing in-process invite/accept suite over Noise+TCP. The concrete deltas are: add the WS transport wiring (+ `WebSocketServer` powers) for M4, and add a forked-two-daemon invite/accept integration test parameterized over both `ocapn+noise+tcp` and `ocapn+noise+ws` for M5 — while deciding whether to also close the `daemon-agent-network-identity` keypair binding (needed for true mutual auth) or defer it as PR #340 does.

*(Read-only survey; no code, PRs, issues, or branches were modified.)*
