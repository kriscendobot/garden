---
title: Package Categories
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: CASK's package set organized into seven categories. **Block structures** (user-facing persistent structures): typed arrays (`array` of 32-byte hashes, `uint8array`..`uint64array`, `int8array`..`int64array`, `bigintarray`), associative structures (`map`, `set`), byte sequences (`blob`, `compactblob`), directories (`dir`, `compactdir`), the `allocator`, the adaptive-width `hashtreetouint8/16/32/64` sparse maps, `indexheap`, `sessiontable`, `head` (package `caskhead`), and `membertable`. **Block backbones** (`*tree`): `hashtree` (sparse 32-way trie for `map`/`set`) and `arraytree` (dense 32-way tree for the typed arrays). **Go utilities** (`go/*`, no CASK dependency): `go/heap`, `go/swap`, `go/jot`, `go/repeat`, `go/typeuint64`, `go/raft`. **Buffers** (`*buffer`): `sendbuffer`, `recvbuffer`. **Stores** (`*store`, implement `cask.Store`): `memstore`, `diskstore`, `dbstore`, `tempstore`, `collectorstore`, `diskcollectorstore`. **Network/transport**: `net` (casknet), `sock` (casksock), `memnet`. **Telemetry/testing**: `tel`, `storetest`.

## Block Structures (user-facing)

High-level persistent data structures that users interact with directly.

| Package | Description |
|---------|-------------|
| `array` | Array of 32-byte hashes, stored as Links in Model nodes |
| `uint8array`..`uint64array` | Dense arrays of uint values, packed in Block bytes |
| `int8array`..`int64array` | Dense arrays of int values, packed in Block bytes |
| `bigintarray` | Arbitrary-precision integers with adaptive width and overflow |
| `map` | Key-value map (32-bit key hash → 32-byte value hash) |
| `set` | Membership set (32-bit key hashes) |
| `blob` / `compactblob` | Byte sequences (sparse tree-structured / compact single-block) |
| `dir` / `compactdir` | Directories (sparse / compact single-block) |
| `allocator` | Swap-to-end index allocator with stable indexes |
| `hashtreetouint8/16/32/64` | Sparse hash-keyed map from uint32 to uintN (adaptive index) |
| `indexheap` | Min-heap over indexes with external value comparison |
| `sessiontable` | Session table with key lookup and expiration heap |
| `head` | Server head structure (v0: schema version + session table); package `caskhead` |
| `membertable` | Member set (node_id → presence) for session gating |

### Adaptive index width (hashtreetouint8/16/32/64)

The `hashtreetouint*` packages share the same 4-level, 32-way trie layout; only the leaf value width and sentinel differ. Use the narrowest width that fits the capacity so byKey indexes (sessiontable, membertable) use less storage per leaf.

| Width | Package | Max storable index | Leaf bytes |
|-------|---------|--------------------|------------|
| uint8 | hashtreetouint8 | 254 | 32 |
| uint16 | hashtreetouint16 | 65534 | 64 |
| uint32 | hashtreetouint32 | 2^32−1 | 128 |
| uint64 | hashtreetouint64 | 2^64−1 | 256 |

Choose by expected capacity: ≤255 → uint8, ≤65535 → uint16, ≤4B → uint32, else uint64.

## Go Utilities (`go/*`)

General-purpose Go helpers with no CASK dependency, living in the CASK tree but usable anywhere: `go/heap` (heap-fix on parallel slices), `go/swap` (swap-to-end allocation), `go/jot` (iota-like slice init), `go/repeat` (repeated-value slice init), `go/typeuint64` (type-safe uint64 wrapper), `go/raft` (Raft consensus). These use simple names without the `cask` prefix.

## Buffers (`*buffer`)

Stateful in-memory tables using parallel arrays for efficient indexing; they demonstrate the parallel-array pattern the persistent structures emulate. `sendbuffer` (outbound, deadline/priority heaps), `recvbuffer` (inbound, priority-based eviction).

## Stores (`*store`)

Block storage backends implementing the `cask.Store` interface: `memstore` (in-memory, testing), `diskstore` (one file per block), `dbstore` (flat files, persistent indexes, content-addressed, mark-sweep GC), `tempstore`, `collectorstore` (GC-aware quarantine wrapper), `diskcollectorstore`.

## Network, Transport, Telemetry

`net` (casknet: encrypted UDP, PSK/Noise sessions, AEAD, RTT, retries, CoDel), `sock` (casksock: plaintext Unix domain socket, local CLI↔daemon), `memnet` (in-memory simulator). `tel` (telemetry spans), `storetest` (shared Store test harness).

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
