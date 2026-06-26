---
id: casknet-wire-protocol
aliases: ["casknet commands", "casknet wire protocol", "reversed response", "reversed command", "stor", "load", "rots", "casc", "csac", "gcgc", "cgcg", "init", "tini", "mass", "ssam", "weigh command", "span_id", "command detection", "MetadataSize", "block metadata footer", "inner command format", "SessionManager", "initPacketSize", "tiniPacketSize", "buildInitPacket", "buildStorePlaintext", "command constants", "casknet packet size"]
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
| [cask--net-crypto-go--command-constants-and-mirror-convention](../sections/cask--net-crypto-go--command-constants-and-mirror-convention.md) | **Implementation source-of-truth**: the eleven command constants, the reversed-response convention, status codes, and the Noise-IK packet sizes (176 / 121). Adds the `mass`/`ssam` weigh pair the design table predates. |
| [cask--net-crypto-go--command-plaintext-wire-layouts](../sections/cask--net-crypto-go--command-plaintext-wire-layouts.md) | **Implementation source-of-truth**: the byte-exact build/parse layouts of every command plaintext, including the weigh pair and the error-string tail on cgcg/ssam. |

## See also

- [[noise-ik-session-establishment]] — how the session the commands ride over is established and keyed.
- [[content-addressed-block-store]] — the 1KB block STOR/LOAD move.
- [[codel-send-buffer-shedding]] — TrafficClass on CASC and the priority scheduling of these packets.

## Common confusions

- **Handshake packet sizes (176 / 121 vs ~144 / ~89 vs 82 / 65).** Three numbers circulate for the init / tini sizes. The running implementation (`net/crypto.go`) uses `initPacketSize` = **176** and `tiniPacketSize` = **121** — use these. The `~144 / ~89` figures in the [[noise-ik-session-establishment]] abstract are the design doc's approximations (the ~144 understates init by omitting the encrypted ed25519-key blob). The **82 / 65** figures in this concept's abstract above are the **superseded PSK-era** detection minimums, not the Noise-IK sizes. The abstract's 82 / 65 predate the Noise-IK ingest and should be read as historical.
- **buildInitPacket layout comment lags.** Within `net/crypto.go`, `buildInitPacket`'s layout comment describes a 144-byte init that omits the ed25519-key blob, while the `initPacketSize` const (and `net/noise.go`) say 176 with the blob. The const is authoritative; the layout comment is a candidate upstream comment-fix. See [cask--net-crypto-go--command-plaintext-wire-layouts](../sections/cask--net-crypto-go--command-plaintext-wire-layouts.md) § Comment-vs-code note.
