---
title: Refactoring steps + affected files
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: After the refactor, OCapN core's responsibility shrinks to: routing (locator → network), CapTP session management (once the network delivers an authenticated session), and the message-level protocol (GC, descriptors, operations). The current `sendHandshake`/`receiveHandshake` become specifically the tcp-for-test network's handshake. Crossed-hellos resolution should move into the network too.
---

> Abstract: Four refactoring steps. **(1)** Introduce `OcapnNetwork` interface (see design-conceptual-model). **(2)** Rename `transport` → `network` in `OcapnLocation`; update Syrup codec in `packages/ocapn/src/codecs/components.js` and URI serialization in `packages/ocapn/src/client/util.js`. **(3)** Replace `netlayers` map with `networks` map in `packages/ocapn/src/client/index.js`: `registerNetlayer` → `registerNetwork`, and `establishSession` should call `network.connect(location)` instead of creating a raw connection + running a generic handshake. **(4)** Move handshake responsibility into networks: `packages/ocapn/src/client/handshake.js`'s `sendHandshake` / `receiveHandshake` become the tcp-for-test network's handshake; OCapN core stops mandating any specific handshake. Affected files: `client/{index, handshake, util, types}.js`, `codecs/components.js`, `netlayers/tcp-test-only.js`, all tests.

### Refactoring Steps

#### 1. Introduce `OcapnNetwork` interface

Define a new interface that each network must implement (see the design-conceptual-model section for the type signature).

#### 2. Rename `transport` to `network` in `OcapnLocation`

```js
// Before
{ type: 'ocapn-peer', designator: 'A', transport: 'tcp-testing-only', hints: { ... } }

// After
{ type: 'ocapn-peer', designator: 'A', network: 'tcp-testing-only', hints: { ... } }
```

Update the Syrup codec in `packages/ocapn/src/codecs/components.js` and the URI serialization in `packages/ocapn/src/client/util.js`.

#### 3. Replace `netlayers` map with `networks` map

In `packages/ocapn/src/client/index.js`:

- Rename `netlayers` → `networks`.
- `registerNetlayer(makeNetlayer)` → `registerNetwork(makeNetwork)`.
- `establishSession` should call `network.connect(location)` instead of creating a raw connection and then running a generic handshake.

#### 4. Move handshake responsibility into networks

The current `sendHandshake` / `receiveHandshake` in `packages/ocapn/src/client/handshake.js` becomes the handshake for the tcp-for-test network only. OCapN core should not mandate a specific handshake protocol.

The OCapN core's responsibility becomes:

- Routing: given a locator, find the right network.
- CapTP session management: once a network delivers an authenticated session, run CapTP over it.
- GC, descriptors, operations: the message-level protocol.

### Affected Files

| File | Change |
|------|--------|
| `packages/ocapn/src/client/index.js` | Replace netlayer registration with network registration |
| `packages/ocapn/src/client/handshake.js` | Extract into tcp-for-test; remove from core |
| `packages/ocapn/src/client/types.js` | New `OcapnNetwork` type; rename `NetLayer` |
| `packages/ocapn/src/codecs/components.js` | `transport` → `network` in OcapnLocation codec |
| `packages/ocapn/src/client/util.js` | Update URI serialization |
| `packages/ocapn/src/netlayers/tcp-test-only.js` | Adapt to new network interface |
| `packages/ocapn/test/` | Update all test utilities |

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
