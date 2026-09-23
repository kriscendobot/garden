---
title: CASK Local Protocol (cask/sock) — flow, reliability, flow control, security
source: doc/design/protocol.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

## Abstract

casksock's store/load flow, error handling, and the reliability and flow-control machinery layered on top, plus its security posture. Store is reliable: the sender retransmits `stor` until an `ackn` arrives or the request context expires. `ackn` batches emit when 32 hashes are pending or a hold-back timeout (bounded by the RTT estimate) expires. The send queue is paced by CoDel-style sojourn-time detection (defer, do not drop, when queue sojourn exceeds target), and ACKs share the data send queue but get priority boosted by the average priority of the blocks they acknowledge. Security rests on the local-Unix-socket transport (filesystem-permission-gated) plus SHA-256 hash validation of every block; the protocol itself carries no authentication or encryption.

## Protocol flow

**Storing a block.** (1) Client sends `stor` with cohort, span, ttlms, hash, metadata, and block data. (2) Server stores the block in its content-address store. (3) Server sends an `ackn` for stored blocks (batched).

**Loading a block.** (1) Client sends `load` with the requested hash. (2) Server looks up the block. (3) If found, server responds with a `stor` carrying the block. (4) If not found, no response is sent.

## Error handling

- Messages shorter than 4 bytes are considered corrupt and ignored.
- Unknown command strings are ignored.
- Missing blocks result in no response to `load` requests.
- Network errors are logged but do not affect protocol state.
- `ackn` batches acknowledge up to 32 hashes; oversized batches are rejected.

## Implementation notes

- The protocol uses a 1500-byte buffer to accommodate Ethernet MTU.
- Blocks are validated by computing their SHA-256 hash and comparing with the provided hash.
- The server maintains a mapping of remote addresses to peers for response routing.
- All hashes are SHA-256 (32 bytes); all numeric fields are big-endian.

## Reliability and flow control (implementation)

- `stor` delivery is reliable: the sender retransmits until it receives an `ackn` or the request context expires.
- `ackn` batches are emitted when either 32 hashes are pending or a hold-back timeout expires. The timeout is derived from the sender/receiver RTT estimate and bounded to avoid exceeding RTT.
- The send queue is paced using CoDel-style sojourn-time detection: when queue sojourn exceeds target for an interval, sending is deferred (paced) instead of dropping. (Same CoDel borrowing as the casknet send buffer; see `[[codel-send-buffer-shedding]]`.)
- ACKs share the same send queue as data packets, but their priority is boosted based on the average priority of the acknowledged blocks.

## Security considerations

- This protocol is plaintext and provides no authentication or encryption. It is only used over a local Unix domain socket, protected by filesystem permissions.
- Hash validation ensures block integrity.
- For the encrypted inter-node protocol, see the casknet crypto design (`cask--net-crypto--*`).

Source: [doc/design/protocol.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol.md) at commit `cdb975d8`.
