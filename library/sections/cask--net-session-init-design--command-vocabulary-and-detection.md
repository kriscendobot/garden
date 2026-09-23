---
title: Command Vocabulary and Packet Detection
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The casknet command vocabulary and how the UDP server tells a handshake packet from a data packet. Every wire command is a 4-byte code, and every response/ack is the request command **reversed**: `init`/`tini` (session init request/response), `stor` (store a block, also the response to `load`), `load` (request a block), `rots` (store ack, mirror of `stor`), `casc`/`csac` (compare-and-swap cell request/response), `gcgc`/`cgcg` (collect request/response). The response to `load` is a `stor`: the server stores the requested block back to the requester. The server detects packet type by the first 4 bytes: matching `"init"` (82 bytes) or `"tini"` (65 bytes) marks a plaintext handshake; anything else is an encrypted data packet (session_id + nonce + AEAD ciphertext). The local Unix-domain-socket protocol (`cask/sock`) is separate and shares no command vocabulary.

## Command Vocabulary

| Wire code | Direction | Name | Description |
|-----------|-----------|------|-------------|
| `init` | C→S | Init | Session initialization request |
| `tini` | S→C | Init response | Session initialization response (mirror) |
| `stor` | C↔S | Store | Store a block (also used as load response) |
| `load` | C→S | Load | Request a block by hash |
| `rots` | S→C | Store ack | Acknowledge received blocks (mirror of `stor`) |
| `casc` | C→S | Compare-and-swap | CAS cell request |
| `csac` | S→C | CAS response | Compare-and-swap response (mirror of `casc`) |
| `gcgc` | C→S | Collect | Trigger garbage collection |
| `cgcg` | S→C | Collect response | GC result (mirror of `gcgc`) |

The naming convention: every response/ack is the request command reversed. The response to `load` is a `stor` — the server stores the block back to the requester. For the local Unix domain socket protocol (`cask/sock`), see `PROTOCOL.md`.

## Command Detection

The UDP server distinguishes two packet types by the first 4 bytes:

1. **Plaintext handshake**: `init` (82 bytes) and `tini` (65 bytes).
2. **Encrypted data**: everything else (session_id + nonce + AEAD ciphertext).

If the first 4 bytes match `"init"` or `"tini"`, the packet is a plaintext handshake; otherwise it is an encrypted data packet.

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
