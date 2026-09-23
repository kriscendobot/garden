---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/daemon/src/networks/libp2p.js
source_line_range: 1-1049
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 450 chat-lane ingest. 1049-line
  packages/daemon/src/networks/libp2p.js, the libp2p
  network backend for the Endo daemon. One-hundred-and-
  fortieth consecutive non-garden source after the pivot
  (310-450). Ninety-eighth AUTHORED conformant single-body
  section doc in post-refactor era.

  Single most structurally interesting move: §the-named-
  deterministic-peerid-from-node-id-hash -- the daemon's
  existing 512-bit node ID hash is the seed for an Ed25519
  private key; the first 32 bytes become the libp2p
  private key via generateKeyPairFromSeed; the resulting
  peer ID is stable across restarts and directly derived
  from the daemon's canonical identity. No separate libp2p
  identity is generated.

  §The-named-configuration-via-source-constants-not-env
  -- make(powers, context) two-parameter form; no formula
  env; configuration is entirely in source constants
  (bootstrap nodes, STUN servers, protocol string) plus
  one capability call E(powers).getPeerInfo() for the
  node ID. Contrasts with tcp-netstring activation-time
  request and ws-relay install-time formula env.

  §The-named-peerid-in-pathname-not-hostname -- address
  scheme libp2p+captp0:///<peerId>?ma=... uses pathname
  (not hostname) because base58-encoded peer IDs are
  case-sensitive; URL hostname lowercasing would corrupt
  them. Explicit closure of the anticipated arc from cycle
  448's §the-named-node-id-as-url-hostname-in-relay-address.

  §The-named-adaptLibp2pStream-as-transport-normalization-
  adapter -- libp2p stream protocol differs from Node
  stream interface; adapter in libp2p-stream-adapter.js
  normalizes to reader/writer/closed triple before CapTP
  starts; same two-phase inbound (greeter) and outbound
  (gateway) pattern as tcp-netstring.

  §The-named-hint-first-dht-fallback-routing -- connect()
  tries multiaddr hints from URL query params first;
  falls back to DHT peer discovery via /p2p/<peerId>
  dial when all hints exhausted.

  §The-named-targeted-event-trace-via-set-gate --
  tracedRemotePeers Set gates peer:update logging; only
  actively-connected remote peers generate trace output;
  prevents DHT-discovery noise.

  §The-named-component-filtered-logger-adapter --
  libp2pLogger.forComponent(name) maps to console.log
  only for VERBOSE_COMPONENTS (seven high-signal names);
  configurable via ENDO_LIBP2P_VERBOSE_COMPONENTS env var.

  §The-named-cancelled-catch-as-shutdown-hook recurs
  (same shape as tcp-netstring cycle 446 and ws-relay
  cycle 448). §the-named-network-service-interface-contract
  recurs (Far with addresses/supports/connect).

  Closes eight citation arcs: cycle 449 (1, adjacent
  forward) + cycle 448 (2, peerid-in-pathname anticipated
  arc) + cycle 446 (3, make+context two-parameter shape)
  + cycle 445 (4, THREE-BACKEND LADDER COMPLETE) +
  cycle 392 (5, unconfined caplet install shape) +
  cycle 391 (6, daemon-lore module vocabulary) +
  cycle 321 (N, E()) + cycle 326 (N). Pushes citation-
  arc-closures-in-pivot to NINE-HUNDRED-AND-THIRTY-SIX
  (928 + 8 net new).
---

1049-line `packages/daemon/src/networks/libp2p.js` — the libp2p network backend for the Endo daemon. Closes the final rung of the three-backend connectivity ladder named in cycle 445 chat-reference: libp2p requires no open port and no self-hosted relay infrastructure; it discovers relay peers automatically via Circuit Relay v2 and uses WebRTC hole-punching for direct peer-to-peer connections, with Amino DHT bootstrapping for peer discovery. Chat-lane after cycle 449 designs-lane smallcaps.md. **Single most structurally interesting move**: §the-named-deterministic-peerid-from-node-id-hash — *`derivePrivateKey(nodeIdHex)` converts the daemon's existing 512-bit node ID hash into a deterministic Ed25519 libp2p private key; the first 32 bytes of the hex-decoded node ID become the Ed25519 seed; the resulting peer ID is stable across daemon restarts and directly derived from the daemon's canonical identity; no separate libp2p identity is generated.* §the-named-configuration-via-source-constants-not-env (`make(powers, context)` two-parameter form; no formula env; self-configuring via DHT; contrasts with tcp-netstring's activation-time request and ws-relay's install-time env). §the-named-peerid-in-pathname-not-hostname (`libp2p+captp0:///<peerId>?ma=...` uses pathname because base58 peer IDs are case-sensitive; URL hostnames are lowercased; closes the anticipated arc from cycle 448's node-id-as-url-hostname note). §the-named-adaptLibp2pStream-as-transport-normalization-adapter (libp2p stream to reader/writer/closed triple before CapTP; erases transport-layer deviation). §the-named-hint-first-dht-fallback-routing (`connect()` tries `ma` hints first; falls back to `/p2p/<peerId>` DHT dial). §the-named-targeted-event-trace-via-set-gate (`tracedRemotePeers` Set gates `peer:update` logging; prevents DHT-discovery noise). §the-named-component-filtered-logger-adapter (`libp2pLogger.forComponent(name)` maps to seven high-signal VERBOSE_COMPONENTS; configurable via `ENDO_LIBP2P_VERBOSE_COMPONENTS`). §the-named-cancelled-catch-as-shutdown-hook recurs. §the-named-network-service-interface-contract recurs (Far with addresses/supports/connect). Eight citation arcs closed; THREE-BACKEND CONNECTIVITY LADDER COMPLETE; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-THIRTY-SIX (928 + 8 net new).

## Section list

- [endo-but-for-bots--packages-daemon-src-networks-libp2p-js--deterministic-peerid-from-node-id-and-dht-plus-circuit-relay-nat-traversal-without-open-port](../sections/endo-but-for-bots--packages-daemon-src-networks-libp2p-js--deterministic-peerid-from-node-id-and-dht-plus-circuit-relay-nat-traversal-without-open-port.md)
