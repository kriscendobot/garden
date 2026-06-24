---
title: Overview and the Two Retention Regimes
source: doc/design/gc-and-retention.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: CASK retains blocks under two independent regimes that coexist in different stores with different eviction policies. **Pinned (roots)** is on-disk: retain every block reachable from a set of root hashes, managed by a top-level hash-trie so the root set updates cheaply, with GC implemented as mark (traverse from roots) plus sweep (delete unreachable). **Deadline-based (ephemeral)** is in-memory: retain until a Unix-nanosecond deadline, then evict, with no notion of reachability — a min-heap keyed by deadline keeps the next-to-expire at the top. Long-lived content uses the pinned system; secure-transport sessions and temporary blocks use the ephemeral system. Both regimes assume a capable eviction path so the protocol and storage layers can rely on retention rules rather than holding data indefinitely.

## Overview

Blocks may be retained for different reasons. CASK describes two retention regimes and how they fit together:

1. **Pinned (roots)** — On-disk; retain all blocks reachable from a set of root hashes. Managed by a top-level structure (hash-trie) for efficient updates when the set of roots changes. Optionally modeled as a snapshot plus a chain of operations, with periodic tree updates.

2. **Deadline-based (ephemeral)** — In-memory; retain until a deadline, then evict. Used for secure sessions, temporary blocks, etc. Backed by a heap (e.g. recvbuffer) keyed by deadline so the next-to-expire is always at the top.

The two systems are independent: different stores (disk vs memory), different eviction policies. The secure-transport sessions use the ephemeral system; long-lived content uses the pinned system.

## Summary

| Aspect            | Pinned (roots)                      | Ephemeral (deadline)                 |
|-------------------|-------------------------------------|--------------------------------------|
| **Retention rule** | Reachable from a root              | Retain until deadline                |
| **Structure**      | Hash-trie of root hashes           | Min-heap by deadline                 |
| **Store**          | On-disk CAS                        | In-memory (or dedicated ephemeral)   |
| **GC**             | Mark from roots, sweep unreachable | Pop from heap when deadline passed   |
| **Optional**       | Snapshot + chain of ops for on-disk | —                                   |

Both systems assume a **capable eviction path**: for pinned, we must be able to delete or reclaim blocks that are no longer retained; for ephemeral, we must be able to remove entries when their deadline has passed. The protocol and storage layers can then rely on these retention rules to avoid holding data indefinitely.

Source: [doc/design/gc-and-retention.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-and-retention.md) at commit `cdb975d8`.
