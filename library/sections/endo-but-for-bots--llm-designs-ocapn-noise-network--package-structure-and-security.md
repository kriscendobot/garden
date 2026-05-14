---
title: Package structure + dependencies + security / scaling / test / compatibility / upgrade
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, repository-governance]
status: current
notes: The 65535-16=65519 byte limit on encrypted messages (ChaCha20-Poly1305 with 16-byte auth tag) is a hard upper bound on a single Noise-framed message — larger OCapN messages must be chunked. This is a load-bearing constraint that any consumer of @endo/ocapn-noise must respect. The cross-network test (np vs tcp-for-test) is the canonical "incompatible handshakes don't accidentally connect" assertion.
---

> Abstract: **Package structure**: `packages/ocapn-noise/` (existing; bindings unchanged), `packages/ocapn-noise-network/` (new; the network impl), `packages/ocapn-noise-ws/` and `packages/ocapn-noise-tcp/` (new transport plugins). Plugins could be subdirectories if separate packages feel over-modularized. **Affected packages**: `ocapn-noise` (no changes), three new packages, `packages/ocapn` (must support the new OcapnNetwork interface). **Dependencies**: ocapn-network-transport-separation (the OcapnNetwork interface); ocapn-tcp-for-test-extraction (moves op:start-session out of core). **Security**: Noise XX provides strong forward secrecy + mutual auth (significant improvement over tcp-for-test). **Hard limit**: encrypted messages max 65535-16 = **65519 bytes** (ChaCha20-Poly1305 with 16-byte auth tag) — larger OCapN messages must be chunked. WSS/TLS is defense-in-depth but not required. Intended-responder-key prefix on SYN prevents misdirected connections. **Scaling**: each transport listener is a separate server socket; Noise adds 3 round-trips (comparable to TLS); ChaCha20-Poly1305 overhead is minimal. **Test plan**: unit (mock transport), integration (two peers over TCP, two over WS, peer-with-both-transports vs peer-with-one), cross-network rejection (np ↛ tcp-for-test). **Compatibility**: new network, no existing wire compat. `"np"` must be registered with the OCapN spec group. **Upgrade**: daemon needs a new formula type/config to enable OCapN-Noise; tcp-for-test peers cannot communicate with OCapN-Noise peers, requires both-side migration.

### Package Structure

```
packages/
  ocapn-noise/          # Existing: Noise Protocol bindings (WASM + JS)
    src/bindings.js     # Handshake state machine, encrypt/decrypt
  ocapn-noise-network/  # New: OCapN-Noise network implementation
    src/
      network.js        # makeOcapnNoiseNetwork
      transport.js      # Transport plugin interface
  ocapn-noise-ws/       # New: WebSocket transport plugin
    src/index.js
  ocapn-noise-tcp/      # New: TCP + netstring transport plugin
    src/index.js
```

Alternatively, the transport plugins could be subdirectories of `ocapn-noise-network` if separate packages feel like over-modularization.

### Affected Packages

- `packages/ocapn-noise` — no changes (bindings are consumed as-is)
- `packages/ocapn-noise-network` (new) — network implementation
- `packages/ocapn-noise-ws` (new) — WebSocket transport
- `packages/ocapn-noise-tcp` (new) — TCP transport using `@endo/netstring`
- `packages/ocapn` — must support the `OcapnNetwork` interface (from network-transport-separation work item)

### Dependencies

- **ocapn-network-transport-separation** — provides the `OcapnNetwork` interface and registration mechanism.
- **ocapn-tcp-for-test-extraction** — moves `op:start-session` out of core so OCapN-Noise doesn't inherit it.

## Security Considerations

- The Noise Protocol (XX pattern) provides strong forward secrecy and mutual authentication. This is a significant security improvement over tcp-for-test.
- Encrypted messages have a max size of 65535 - 16 = 65519 bytes (ChaCha20-Poly1305 with 16-byte auth tag). Larger OCapN messages must be chunked. This limit should be documented.
- Transport-level security (e.g., WSS/TLS for WebSocket) is defense-in-depth but not required — Noise provides its own encryption layer.
- The intended-responder-key prefix on SYN prevents misdirected connections.

## Scaling Considerations

- Each transport listener is a separate server socket. Running multiple transports multiplies the number of listening ports.
- The Noise handshake adds 3 round-trips (SYN, SYNACK, ACK) before CapTP messages can flow. This is comparable to TLS.
- Encryption/decryption overhead is minimal (ChaCha20-Poly1305 is fast).

## Test Plan

- Unit test: `makeOcapnNoiseNetwork` with a mock transport completes the handshake and returns encrypted sessions.
- Integration test: two OCapN-Noise peers connect over TCP transport, exchange CapTP messages.
- Integration test: two OCapN-Noise peers connect over WebSocket transport.
- Integration test: peer with both transports connects to peer with only one.
- Cross-network test: OCapN-Noise peer cannot connect to tcp-for-test peer (different network identifiers, incompatible handshakes).

## Compatibility Considerations

- This is a new network. No existing wire compatibility to maintain.
- The `"np"` network identifier must be registered with the OCapN spec group.
- The Noise handshake byte format is already defined in `packages/ocapn-noise/src/bindings.js` and should be stable.

## Upgrade Considerations

- The daemon will need a new formula type or configuration to enable the OCapN-Noise network alongside or instead of the existing loopback/test networks.
- Peers using tcp-for-test cannot communicate with peers using OCapN-Noise. Migration requires both sides to upgrade.

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
