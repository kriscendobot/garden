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
kind: index
section_count: 5
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

Sections:

- [Security Considerations](endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security--security-considerations.md)
- [Scaling Considerations](endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security--scaling-considerations.md)
- [Test Plan](endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security--test-plan.md)
- [Compatibility Considerations](endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security--compatibility-considerations.md)
- [Upgrade Considerations](endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security--upgrade-considerations.md)

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
