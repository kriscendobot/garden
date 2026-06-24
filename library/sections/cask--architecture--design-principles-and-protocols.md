---
title: Design Principles and the Two Protocols
source: doc/design/architecture.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
---

> Abstract: CASK Protocol v2 is organized as five stacked layers under six design principles (layered design, minimal complications, decentralization first, security by default, efficiency via memcopy-friendly formats, flexibility for session-based and sessionless modes). CASK ships two protocols that share no command vocabulary: **casknet** (`cask/net`), encrypted UDP for inter-node traffic where every data command rides inside an AEAD envelope and only the `init`/`tini` handshake is plaintext; and **casksock** (`cask/sock`), a plaintext Unix-domain-socket protocol for local CLI-to-daemon traffic protected by filesystem permissions. The layered model below describes the inter-node (casknet) protocol only.

## Design Principles

1. **Layered Design**: each layer builds on the previous, adding capabilities without breaking lower layers.
2. **Minimal Complications**: add complexity only when a use case needs it.
3. **Decentralization First**: prefer peer-to-peer and distributed solutions over centralized ones.
4. **Security by Default**: encryption and authentication at the appropriate layers.
5. **Efficiency**: memcopy-friendly formats, efficient sampling, minimal translation overhead.
6. **Flexibility**: support both session-based and sessionless protocols.

## Two Protocols

CASK has two independent protocols that share no command vocabulary:

- **casknet** (`cask/net`): encrypted UDP for inter-node communication. All data commands are inside an AEAD envelope; only the `init`/`tini` handshake is plaintext.
- **casksock** (`cask/sock`): plaintext Unix domain socket for local CLI-to-daemon communication, protected by filesystem permissions.

The layered architecture describes the inter-node (casknet) protocol.

## Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 4: Orchestration (Consensus, Routing, Sharding)        │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: RPC & Request Routing (Load Balancing, Shedding)   │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: Merkle Tree & File System (Tree Operations, GC)    │
├─────────────────────────────────────────────────────────────┤
│ Layer 1: Session & Security (PSK, AEAD Encryption, Auth)    │
├─────────────────────────────────────────────────────────────┤
│ Layer 0: Block Transfer (STOE/LODE)                         │
└─────────────────────────────────────────────────────────────┘
```

Each layer is optional. A system implements only the layers it needs; higher layers do not break lower ones, and unavailable layers degrade gracefully. The minimal viable protocol is Layer 0 (LOAD/STOR) plus basic session establishment (Layer 1 INIT) plus tree sync (Layer 2 TREE SYNC); encryption, RPC, and orchestration are progressive enhancements added as required.

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.
