---
title: Columnar, ECS-inspired design
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: CASK's in-memory and on-disk structures use a **parallel-arrays** pattern borrowed from the Entity Component System (ECS) tradition: values live in flat, typed columns and indexes are separate arrays of slot indexes, so multiple orderings (a deadline heap and a priority heap) coexist over the same data without copying values. The `sendbuffer` is the concrete in-memory example (parallel `enqueuedAt`/`deadlines`/`priorities` columns with co-indexed min-heaps). The pattern translates directly to persistent storage: the adaptive-width `hashtreetouint*` packages pick the narrowest integer width that fits current capacity, minimizing Merkle-tree disturbance when one value changes.

In-memory structures use a **parallel arrays** pattern borrowed from the Entity Component System (ECS) tradition: values live in flat, typed columns and indexes are separate arrays of slot indexes. Multiple orderings (heaps for deadlines, heaps for priorities) coexist over the same data without copying values.

The `sendbuffer` is a concrete example: it maintains parallel `enqueuedAt`, `deadlines`, and `priorities` columns alongside co-indexed min-heaps, enabling O(log n) enqueue, dequeue-by-priority, and eviction of expired entries.

This pattern translates directly to persistent storage. The adaptive-width `hashtreetouint*` packages choose the narrowest integer width that fits the current capacity (uint8 for ≤255 entries, up to uint64), minimizing Merkle tree disturbance when a single value changes (see the `parallel-arrays` design doc).

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
