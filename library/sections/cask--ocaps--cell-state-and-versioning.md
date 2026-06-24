---
title: Cell State and Monotonic Versioning
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: A cell's mutable state is a fixed-layout block holding one link (the current content hash) plus a **monotonic `uint64` version** that increments on every write. The version is updated **atomically with the content hash** during a CAS operation, which buys three properties at once: **ordering** (observers detect missed updates by gaps in the version sequence), **consistency** (a client can verify it holds the latest version), and **caching** (version numbers drive efficient cache invalidation). This is the per-cell counterpart to cells.md's `value_hash`, with the explicit version counter that cells.md left as an open question.

Each cell's state is stored in block storage:

```
CELL_STATE (fixed-layout block):
  Links:
    [0] content_hash      (32 bytes: current cell content)

  Bytes:
    version: uint64       (monotonic, increments on each write)
```

The version number is part of the cell state, updated atomically with the content hash during CAS operations. This enables:

- **Ordering**: observers can detect missed updates.
- **Consistency**: clients can verify they have the latest version.
- **Caching**: version numbers enable efficient cache invalidation.

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
