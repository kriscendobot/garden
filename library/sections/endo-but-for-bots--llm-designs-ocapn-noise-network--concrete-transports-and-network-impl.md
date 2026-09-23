---
title: Concrete transports (ws + tcp) + makeOcapnNoiseNetwork implementation
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, streams]
status: current
notes: The asymmetry between ws and tcp framing: WebSocket already provides message boundaries (no extra framing); TCP needs `@endo/netstring` for the post-handshake encrypted-message phase only. The handshake phase is fixed-length (SYN 164b, SYNACK 193b, ACK 64b) so netstring is not needed there. This is a key implementation detail for anyone porting another transport plugin.
---

> Abstract: **WebSocket transport** (`ocapn-noise-websocket`): browser-compatible WebSocket API; Noise handshake bytes are binary WebSocket messages; each encrypted OCapN message is one WebSocket binary frame; **no additional framing** because WebSocket provides message boundaries. **TCP transport** (`ocapn-noise-tcp`): Node.js `net` module; handshake bytes are raw TCP; **encrypted OCapN messages framed with `@endo/netstring`** because TCP has no message boundaries. The handshake phase uses fixed-length messages (SYN 164b, SYNACK 193b, ACK 64b — see `packages/ocapn-noise/src/bindings.js`) so netstring is only needed post-handshake. **`makeOcapnNoiseNetwork({signingKeys, transports, handlers})`**: generate/accept Ed25519 keys; register transport plugins; start listeners; return a hardened `OcapnNetwork` with `identifier: 'np'`, `location: {type, network: 'np', designator, hints}`, `connect(remoteLocation)` that selects transport from hints, opens byte stream, runs Noise XX handshake as initiator (SYN+SYNACK+ACK), obtains encrypt/decrypt, returns a `NetworkSession`, and `shutdown()` that closes all listeners and connections.

### Concrete Transport Implementations

#### `ocapn-noise-websocket`

- Uses the WebSocket API (browser-compatible).
- Noise handshake bytes are sent as binary WebSocket messages.
- Each encrypted OCapN message is a single WebSocket binary frame.
- No additional framing needed — WebSocket provides message boundaries.

#### `ocapn-noise-tcp`

- Uses Node.js `net` module.
- Noise handshake bytes are sent as raw TCP.
- Encrypted OCapN messages are framed with **netstrings** (`@endo/netstring`) to provide message boundaries over the TCP byte stream.
- The handshake phase uses fixed-length messages (SYN: 164 bytes, SYNACK: 193 bytes, ACK: 64 bytes per `packages/ocapn-noise/src/bindings.js`) so netstring framing is only needed for the post-handshake encrypted message phase.

### Network Implementation

```js
const makeOcapnNoiseNetwork = async ({ signingKeys, transports, handlers }) => {
  // 1. Generate or accept Ed25519 signing keys
  // 2. Register transport plugins
  // 3. Start listeners on all transports
  // 4. Return OcapnNetwork interface

  return harden({
    identifier: 'np',
    location: { type: 'ocapn-peer', network: 'np', designator, hints },

    async connect(remoteLocation) {
      // a. Select transport from remote hints
      // b. Open byte stream via transport.connect(hints)
      // c. Run Noise XX handshake as initiator:
      //    - Write SYN (prefixed with intended responder key)
      //    - Read SYNACK, validate responder identity
      //    - Write ACK
      // d. Obtain encrypt/decrypt functions from completed handshake
      // e. Return NetworkSession with encrypted write/read
    },

    shutdown() { /* close all listeners and connections */ },
  });
};
```

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
