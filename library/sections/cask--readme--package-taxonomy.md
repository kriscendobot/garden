---
title: CASK package taxonomy (shape)
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, networking, data-structures]
status: current
---

> Abstract: The shape of CASK's Go package layout, captured per the conventions' "shape, not content" rule for upstream meta-tables (the exact package list changes at upstream's cadence; this captures the taxonomy and the layering, not a per-package transcription). Packages are grouped into eleven layers from the foundational block type up through stores, buffers, and transport, with a separate `go/` shelf of CASK-independent utilities. The grouping is itself the lesson: every higher structure is built from the same `arraytree` / `hashtree` trie backbones over 1KB blocks, and the in-memory network buffers reuse the same columnar parallel-array pattern the persistent tables use.

CASK's Go packages are organized into layers. The README enumerates each package with its Go import name and a one-line description; this section captures the taxonomy (query upstream's README for the current exact package list and descriptions):

- **Foundation** — `cask` (Block, Hash, Store interface, Model), `tel` (telemetry spans), `io` (streaming reader/writer over block Merkle trees).
- **Tree backbones** — `arraytree` (dense 32-way trie keyed by sequential index, variable depth), `hashtree` (sparse 32-way trie keyed by uint32 hash, fixed 4-level depth). Application code rarely imports these directly; they are the storage structure under the data-structure packages.
- **Typed arrays** — `array` (32 hashes/leaf) plus `uint8array`…`int64array` (1024 down to 128 values per leaf by width) and `bigintarray` (adaptive width). Dense arrays backed by `arraytree`.
- **Associative structures** — `map`, `set`, and the `hashtreetouint8`…`hashtreetouint64` family (uint32 key → fixed-width value), backed by `hashtree`. The `hashtreetouint*` family shares one trie layout differing only in leaf value width; tables migrate upward as capacity grows.
- **Compound structures** — `allocator` (swap-to-end index allocator with stable slots), `indexheap` (persistent min-heap over slot indexes), `blob` (Rabin-chunked byte streams), `compactblob`, `dir` (name-ordered directory trees), `compactdir`.
- **Tables** — `sessiontable`, `membertable`: persistent parallel-array tables combining allocator, typed-array columns, hash-trie indexes, and heap indexes into a single root block.
- **Server head** — `head` (top-level head block: schema, sessions root, membership root).
- **Stores** (implementations of the `cask.Store` interface) — `memstore`, `tempstore` (deadline eviction), `diskstore` (one-file-per-block), `dbstore` (flat-file with persistent indexes + mark-sweep GC), `collectorstore` (GC-aware wrapper), `diskcollectorstore`.
- **Buffers** — `sendbuffer` (deadline + priority heaps, CoDel shedding), `recvbuffer` (priority-based eviction). In-memory parallel-array tables for network I/O scheduling.
- **Network and transport** — `net` (casknet: encrypted UDP, Noise IK, AEAD, RTT, retransmission), `sock` (casksock: plaintext Unix socket), `memnet` (in-memory network for testing).
- **Testing and utilities** — `storetest` (reusable `cask.Store` test harness), `test` (shared helpers), `cmd` (the `cask` CLI).
- **`go/` utilities** (general-purpose, no CASK dependency) — `go/heap`, `go/swap`, `go/jot`, `go/repeat`, `go/typeuint64`, `go/raft` (Raft consensus, designed, not yet integrated).

Further design reading lives under `doc/design/` (status, architecture, package-taxonomy, parallel-arrays, trace, dbstore-design, and the net/gc design docs), deferred to a follow-on `scholar-ingest-cask` job.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
