---
title: Design — new conceptual model + OcapnNetwork interface
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, capability-security]
status: current
notes: The key API difference: `OcapnNetwork.connect(location): Promise<Session>` returns a **session** (authenticated, encrypted, CapTP-ready), not a raw connection. The current `NetLayer` returns a raw connection that CapTP then runs handshake over. Moving this boundary changes the trust story: the network is the trust boundary, not the transport. Connection hints (`ws:`, `tcp:`) encode transport choices within a network.
---

> Abstract: The new conceptual model is a four-layer hierarchy: **OCapN Core** → **Network** (e.g., `np` for OCapN-Noise, `tcp-testing-only` for test) → **Transport** (`ws:`, `tcp:`) → **Physical connection** (WebSocket, TCP socket). **Locator** designates a network (rename `transport` field → `network`). **Network** is responsible for session establishment, authentication, encryption; defines its own handshake; registered by network identifier. **Transport** is a byte-stream carrier used by a network; a network may support multiple. **Connection hints** like `ws:` or `tcp:` prefixed on an address tell the network which transport to use. The new **OcapnNetwork** interface has `identifier`, `location`, `connect(location): Promise<Session>`, and `shutdown()` — critically, `connect` returns a Session (authenticated, encrypted, CapTP-ready), not a raw Connection. The network owns the full lifecycle.

## Description of the Design

### New Conceptual Model

```
OCapN Core
  └── Network (e.g., "np" for OCapN-Noise, "tcp-testing-only" for test)
        └── Transport (e.g., "ws:", "tcp:")
              └── Physical connection (WebSocket, TCP socket, etc.)
```

- **Locator**: Designates a network. The `transport` field on `OcapnLocation` should be renamed to `network` (or a new `network` field added).
- **Network**: Responsible for session establishment, authentication, and encryption. Defines its own handshake protocol. Registered with OCapN by network identifier.
- **Transport**: A byte-stream carrier used by a network. A network may support multiple transports. Transports are a concern of the network, not of OCapN core.
- **Connection hints**: Encode transport information. A hint like `ws:` or `tcp:` prefixed on an address tells the network which transport to use for a particular connection attempt.

### `OcapnNetwork` interface

Define a new interface that each network must implement:

```js
/**
 * @typedef {object} OcapnNetwork
 * @property {string} identifier - Network identifier (e.g., 'np', 'tcp-testing-only')
 * @property {OcapnLocation} location - This node's location on this network
 * @property {(location: OcapnLocation) => Promise<Session>} connect
 *   Establish a session to a peer. The network handles transport selection,
 *   handshake, authentication, and encryption.
 * @property {() => void} shutdown
 */
```

The key difference from today's `NetLayer` is that `connect` returns a **session** (authenticated, encrypted, ready for CapTP), not a raw **connection** (unauthenticated byte stream). The network owns the full lifecycle from transport selection through session establishment.

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
