---
title: Concurrency Model and Lock Protocol
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

> Abstract: caskdbstore's single-owner-multiple-writer-multiple-reader concurrency model. Any number of writer processes append blocks to their own `journal/<pid>-<seq>.wal` files with no coordination. One **owner process** holds an exclusive `flock` on `.cask/lock` and is the sole party that writes `blocks`, `meta`, the index, and `root`; it consolidates WALs into the store, serializes CAS root swaps, and runs mark-and-sweep GC. Any number of reader processes `pread` from `blocks`, `meta`, and `root` at fixed offsets — safe without locks because those files are append-only between compactions and slots are immutable once written, so offset reads never race a mutation. This partitions writers (append-only, lock-free) from the owner (the only mutator of shared state) from readers (offset reads of immutable data), so the only serialization point is the single owner.

## Concurrency overview

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Writer 1   │     │   Writer 2   │     │   Writer N   │
│  (any proc)  │     │  (any proc)  │     │  (any proc)  │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │ append WAL         │ append WAL         │ append WAL
       ▼                    ▼                    ▼
  journal/              journal/              journal/
  pid1-0.wal            pid2-0.wal            pidN-0.wal
       │                    │                    │
       └────────────────────┼────────────────────┘
                            │ consume WALs
                            ▼
                   ┌────────────────┐
                   │  Owner Process │  ◄── holds .cask/lock
                   │  consolidate() │  WAL → blocks + meta + index
                   │  cas()         │  atomic root swap
                   │  collect()     │  mark-and-sweep GC
                   └────────┬───────┘
                            │
                   ┌────────┴───────┐
                   │   blocks file  │
                   │   meta file    │
                   │   index        │
                   │   root         │
                   └────────────────┘
                            │
       ┌────────────────────┼────────────────────┐
       │ pread               │ pread               │ pread
       ▼                    ▼                    ▼
   Reader 1             Reader 2             Reader N  (any proc)
```

## Lock Protocol

- The owner process holds an exclusive `flock` on `.cask/lock`.
- Only the owner writes to `blocks`, `meta`, `index`, and `root`.
- Writers only append to files in `journal/`.
- Readers only read `blocks`, `meta`, and `root` using `pread` (offset-based reads that don't require seek, safe for concurrent access to append-only files).

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
