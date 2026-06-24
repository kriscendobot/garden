---
id: casknet-wire-protocol
aliases: ["casknet commands", "casknet wire protocol", "reversed response", "reversed command", "stor", "load", "rots", "casc", "csac", "gcgc", "cgcg", "init", "tini", "span_id", "command detection", "MetadataSize", "block metadata footer", "inner command format"]
topics: [networking]
status: current
---

# casknet-wire-protocol

casknet's command vocabulary and packet layout. Every wire command is a 4-byte code, and every response or acknowledgement is the request command **spelled backwards**: `init`/`tini` (session init), `stor`/`load`/`rots` (store a block / request a block / store-ack; the response to `load` is a `stor` carrying the block back), `casc`/`csac` (compare-and-swap a cell / its response), `gcgc`/`cgcg` (trigger GC / its result). The server tells packet types apart by the first 4 bytes: `"init"` (82 bytes) or `"tini"` (65 bytes) is a plaintext handshake, anything else is an encrypted data packet. Encrypted data packets are `session_id (32) || nonce (12) || ciphertext || Poly1305 tag (16)`, and the inner plaintext is a 4-byte command followed by command-specific fields (most carry an 8-byte `span_id` correlation ID). A STOR block carries a fixed 12-byte metadata footer (`cask.MetadataSize`: height uint64, numLinks 0-32, dataLen 0-1024, 1 reserved); a full 1024-byte block totals 1140 bytes, inside the 1500 MTU.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--net-session-init-design--command-vocabulary-and-detection](../sections/cask--net-session-init-design--command-vocabulary-and-detection.md) | The reversed-response command table and first-4-bytes packet detection. |
| [cask--net-session-init-design--inner-command-wire-formats](../sections/cask--net-session-init-design--inner-command-wire-formats.md) | Byte-exact LOAD/STOR/ROTS/CASC/CSAC/GCGC/CGCG layouts and packet sizes. |
| [cask--net-session-init-design--session-state-and-envelope](../sections/cask--net-session-init-design--session-state-and-envelope.md) | The AEAD envelope and counter-derived nonce. |
| [cask--net-crypto--primitives-threat-model-and-lifecycle](../sections/cask--net-crypto--primitives-threat-model-and-lifecycle.md) | The same command inventory from the crypto-doc side. |
| [cask--architecture--layers-0-1-block-transfer-and-session](../sections/cask--architecture--layers-0-1-block-transfer-and-session.md) | Layer 0/1 framing of the command set. |

## See also

- [[noise-ik-session-establishment]] — how the session the commands ride over is established and keyed.
- [[content-addressed-block-store]] — the 1KB block STOR/LOAD move.
- [[codel-send-buffer-shedding]] — TrafficClass on CASC and the priority scheduling of these packets.
