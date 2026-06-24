---
title: Goals and Directory Layout
source: doc/design/dbstore-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: `caskdbstore` is a `cask.CASStore` backed by a small fixed set of flat files in a `.cask` directory, indexing and managing blocks on disk with CASK's own block-structure techniques. Its six goals: keep all blocks in a few flat files (not one file per block); atomic root-hash replacement via CAS; multiple concurrent lock-free readers; multiple concurrent writers staging blocks independently; a single owner process holding an exclusive lock that consolidates staged blocks, runs GC, and serves CAS; and reuse of CASK's content-addressed indexing patterns (allocator, hash-trie index). The `.cask` directory holds a `lock` (flock held by the owner), a 32-byte `root` (current root hash, rewritten via temp+rename), a 32-byte `nonce` (store identity for CAS auth), an append-only `blocks` data file, a parallel `meta` file (12 bytes/slot), an `alloc` swap-to-end allocator, a `hashmap` open-addressing hash→slot table, a `journal/` WAL staging directory (`<pid>-<seq>.wal`), and a transient `gc-scratch/` directory used during collection.

A `cask.CASStore` backed by flat files in a `.cask` directory, using techniques from CASK's own block-based data structures to index and manage blocks on disk.

## Goals

1. All blocks in a small number of flat files (not one file per block).
2. Atomic root hash replacement via CAS.
3. Multiple concurrent readers without locks.
4. Multiple concurrent writers can stage blocks independently.
5. A single owner process holds an exclusive lock and consolidates staged blocks, runs GC, and serves CAS operations.
6. Borrow CASK's own indexing patterns: content-addressed blocks, allocator, hash-trie index.

## Directory Layout

```
.cask/
  lock                  # flock, held by owner process
  root                  # 32 bytes: current root hash (atomic write via rename)
  nonce                 # 32 bytes: store identity token
  blocks                # block data file (append-only between compactions)
  meta                  # metadata file (parallel to blocks, 12 bytes per slot)
  alloc                 # persistent swap-to-end allocator (adaptive width)
  hashmap               # persistent open-addressing hash table (hash → slot)
  journal/              # WAL staging directory
    <pid>-<seq>.wal     # write-ahead log files (during GC or from writers)
  gc-scratch/           # temporary directory during GC (deleted after)
    markset             # on-disk hash set of reachable hashes
    delete              # flat file of hashes to delete
```

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
