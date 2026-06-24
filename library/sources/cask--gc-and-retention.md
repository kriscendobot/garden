---
source: doc/design/gc-and-retention.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: CASK's two coexisting block-retention regimes. **Pinned (roots)** is on-disk: retain every block reachable from a set of root hashes held in a persistent hash-trie, collected by mark (traverse from roots) plus sweep (delete unreachable), optionally optimized with a snapshot-plus-chain-of-operations to avoid full re-traversal. **Deadline-based (ephemeral)** is in-memory: retain until a Unix-ns deadline using a min-heap keyed by deadline (the recvbuffer / tempstore-collector pattern), evicting once `now_ns >= deadline_ns`, with no reachability notion. Long-lived content uses pinned; secure-transport sessions and temporary blocks use ephemeral. This is the foundational retention doc the concurrent-GC, store-GC, and dbstore designs build on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-two-regimes](../sections/cask--gc-and-retention--overview-and-two-regimes.md) | content-addressed-storage | current |
| [pinned-roots-hash-trie](../sections/cask--gc-and-retention--pinned-roots-hash-trie.md) | content-addressed-storage | current |
| [deadline-based-ephemeral-retention](../sections/cask--gc-and-retention--deadline-based-ephemeral-retention.md) | content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Part of the GC family ingested cycle 4 (`scholar-ingest-cask-3`) alongside `gc-concurrent-design.md`, `store-gc-design.md`, and `dbstore-design.md`.

Source: [doc/design/gc-and-retention.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-and-retention.md) at commit `cdb975d8`.
