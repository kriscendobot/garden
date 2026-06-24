---
title: CASK Local Protocol (cask/sock) — transport and message types
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

`cask/sock` (casksock) is CASK's plaintext, unencrypted protocol over a local Unix domain stream socket at `.cask/cask.sock` (relative to the store directory), used for CLI-to-daemon communication. It is trusted because it is reachable only on the local machine and gated by filesystem permissions; the encrypted inter-node UDP protocol is a separate concern (`net/CRYPTO.md`, `net/SESSION_INIT_DESIGN.md`). The command set is twelve 4-byte ASCII codes split client-to-server (`stor`, `load`, `casw`, `coll`, `head`, `nonc`, `stop`) and server-to-client (`ackn`, `casr`, `colr`, `hedr`, `nncr`, `eror`). This section captures the transport and the command inventory; the wire layouts and flow are in the sibling sections.

## Transport

- **Protocol**: Unix domain socket (stream).
- **Socket Path**: `.cask/cask.sock` (relative to the store directory).

It is plaintext and unencrypted: the protocol is trusted because it is only accessible on the local machine. For the encrypted inter-node UDP protocol, see the casknet crypto and session-init designs.

## Message types

| Command | Direction | Description |
|---------|-----------|-------------|
| `stor`  | C→S       | Store a block |
| `load`  | C→S       | Request a block |
| `ackn`  | S→C       | Acknowledge stored blocks (batched) |
| `casw`  | C→S       | Compare-and-swap write |
| `casr`  | S→C       | CAS response |
| `coll`  | C→S       | Trigger garbage collection |
| `colr`  | S→C       | GC result |
| `head`  | C→S       | Request current HEAD hash |
| `hedr`  | S→C       | HEAD response |
| `nonc`  | C→S       | Request store nonce |
| `nncr`  | S→C       | Nonce response |
| `stop`  | C→S       | Shutdown daemon |
| `eror`  | S→C       | Error response |

The local protocol uses lowercase 4-byte command codes. (The never-implemented v2 proposal would have used uppercase forms over UDP; see `cask--protocol2--changes-from-v1-and-layered-vision`.) The encrypted inter-node casknet protocol that was actually built uses the reversed-response convention (`stor`/`rots`) documented in `cask--net-session-init-design--command-vocabulary-and-detection`.

Source: [doc/design/protocol.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol.md) at commit `cdb975d8`.
