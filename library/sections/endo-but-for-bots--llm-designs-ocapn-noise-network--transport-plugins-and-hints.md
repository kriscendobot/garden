---
title: Transport plugin architecture + connection-hint format
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
notes: The `OcapnNoiseTransport` interface is the network-internal transport-plugin contract — not the same as the OcapnNetwork interface from ntsep. The scheme-prefixed hint format (`ws:host`, `ws:port`, `tcp:host`, `tcp:port`) lets a single locator express which transport(s) to try. When multiple match, preference order is configurable.
---

> Abstract: **Transport plugin interface** (`OcapnNoiseTransport`): `scheme` (e.g., `'ws'`, `'tcp'`), `connect(hints): Promise<ByteStream>` for outgoing, `listen(opts): Promise<TransportListener>` for incoming, and `shutdown()`. **ByteStream** carries `write(bytes)`, `end()`, `incoming: AsyncIterable<Uint8Array>`. **Hint format**: keys are scheme-prefixed (`ws:host`, `ws:port`, `tcp:host`, `tcp:port`); the network iterates available transports and selects one matching the prefixes. When multiple match, try in configurable preference order.

### Transport Plugin Architecture

A transport plugin provides a way to establish a bidirectional byte stream. The network uses that byte stream to run the Noise Protocol handshake and subsequent encrypted messaging.

```js
/**
 * @typedef {object} OcapnNoiseTransport
 * @property {string} scheme - Transport scheme (e.g., 'ws', 'tcp')
 * @property {(hints: Record<string, string>) => Promise<ByteStream>} connect
 *   Open an outgoing byte stream to a peer using transport-specific hints.
 * @property {(options: ListenOptions) => Promise<TransportListener>} listen
 *   Start listening for incoming byte stream connections.
 * @property {() => void} shutdown
 */

/**
 * @typedef {object} ByteStream
 * @property {(bytes: Uint8Array) => void} write
 * @property {() => void} end
 * @property {AsyncIterable<Uint8Array>} incoming
 */
```

### Transport Hint Format

Connection hints encode transport information with a scheme prefix:

| Hint Key | Example Value | Meaning |
|----------|---------------|---------|
| `ws:host` | `example.com` | WebSocket host |
| `ws:port` | `443` | WebSocket port |
| `tcp:host` | `127.0.0.1` | TCP host |
| `tcp:port` | `9000` | TCP port |

When connecting, the network iterates available transports and selects one matching the hint prefixes. If multiple transports match, try them in order (preference configurable).

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
