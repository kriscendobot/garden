---
title: CASK (overview)
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

> Abstract: CASK is a content-addressed block store written in Go where **every block is exactly 1KB**. That single constraint is the foundation of the whole system: it unifies storage and transport under one Merkle-tree structure, lets each block travel as one UDP datagram inside the Ethernet MTU, and makes garbage collection content-agnostic. CASK is both an educational experiment and a working system; it revisits decades of networking and database assumptions by asking what happens when you build from the block up.

CASK is a content-addressed block store where every block is exactly 1KB. This constraint is the foundation of the entire system: it unifies storage and transport under a single Merkle-tree structure, permits block-at-a-time UDP transfer within the Ethernet MTU, and makes garbage collection content-agnostic.

CASK is written in Go and is both an educational experiment and a working system. The project revisits assumptions baked into decades of networking and database design by asking: what happens when you build from the block up?

It is a working system today, with an encrypted UDP transport, a persistent flat-file block store, Rabin-chunked blobs, directories, arrays, maps, sets, session management, membership gating, and mark-sweep garbage collection. Higher layers (consensus via Raft, sharding, CRDTs, object capabilities) are designed but not yet implemented.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
