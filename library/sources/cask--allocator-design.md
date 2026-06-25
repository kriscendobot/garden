---
source: doc/design/allocator-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The index allocation and lookup structures that build a session table (and similar columnar tables) on the content-addressed store, all marked IMPLEMENTED under `borkshop/cask/`. **`allocator`** is the persistent swap-to-end allocator: a `length`/`capacity`/`indexWidth` root over `entities` and `coEntities` adaptive-width uint arrays, handing out stable logical indexes where `Free` only swaps the freed index to the boundary so no other slot moves (the canonical detailed source for [[swap-to-end-allocation]]). **`hashtreetouint64`** is a `hashtree` variant whose leaves pack 32 × uint64 values, with the adaptive `hashtreetouint8/16/32/64` family choosing the narrowest width fitting capacity. **`indexheap`** is a min-heap over logical indexes whose comparison values live in a separate column reached via a `getValue` callback, decoupling heap order from value storage. **`sessiontable`** composes all three plus value columns (keys/expiry/data) into one root, exposing Create/Lookup/Get/Update/Delete/PopExpired, with the expiry heap ordering on the `expiry` column through the callback. The same composite shape generalizes to a membertable and a generic table.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [swap-to-end-allocator](../sections/cask--allocator-design--swap-to-end-allocator.md) | data-structures, content-addressed-storage | current |
| [hashtreetouint-and-index-heap](../sections/cask--allocator-design--hashtreetouint-and-index-heap.md) | data-structures, content-addressed-storage | current |
| [session-table-composite](../sections/cask--allocator-design--session-table-composite.md) | data-structures, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-17 by Kris Kowal.
- Ingested cycle 11 (`scholar-ingest-cask-10`) in the array/columnar cluster. This is the in-depth specification of the in-memory allocator/heap pieces named more briefly in `cask--parallel-arrays--persistent-structures-as-reducers` ([[cask-reducer-pattern]]); the swap-to-end allocator here is the same structure as the on-disk `alloc` file in `cask--dbstore-design--on-disk-file-formats`. The hashtreetouint* family files under [[cask-block-backbones]].

Source: [doc/design/allocator-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/allocator-design.md) at commit `cdb975d8`.
