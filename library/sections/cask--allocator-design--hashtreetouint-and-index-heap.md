---
title: hashtreetouint64 and the Decoupled Index Heap
source: doc/design/allocator-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: Two structures the session table composes over the allocator. **`hashtreetouint64`** (IMPLEMENTED) is a `hashtree` variant: the same 4-level, 32-way trie keyed by a uint32, but leaf nodes pack 32 × uint64 values into Bytes instead of holding 32-byte hash Links. It exposes `Get(key) → (uint64, bool)`, `Set`, `Delete`, with `math.MaxUint64` as the "not present" sentinel (so valid indexes must be < MaxUint64). The adaptive-width family `hashtreetouint8/16/32/64` shares the trie layout and differs only in leaf value width and sentinel; a byKey index uses the narrowest width that fits capacity (≤255 → uint8, ≤65535 → uint16, ≤4B → uint32, else uint64) to shrink leaf size at small capacity. **`indexheap`** (IMPLEMENTED) is a min-heap over logical indexes whose comparison values live in a *separate* parallel array, reached through a `getValue` callback — this decouples the heap structure from value storage, so the heap can order sessions by expiry timestamp held in another column. Its root links `heap` (heap position → logical index) and `coheap` (logical index → heap position) as adaptive-width arrays, and it exposes `Push`, `Pop`, `Peek`, `Fix` (restore the heap after a value changes), and `Remove`. The callback indirection is what lets one heap reorder against a column it does not own.

## Part 2: hash-to-index tree (hashtreetouint64)

A variant of `hashtree` that stores uint64 indexes instead of 32-byte hashes. It uses the same 4-level, 32-way trie, but leaf nodes pack values into Bytes:

```
Internal nodes (levels 0-2): same as hashtree
  Links[0..31]: child node hashes

Leaf nodes (level 3):
  Bytes[0..255]: 32 × uint64 values (big-endian)
  Links: empty
```

Operations: `Get(ctx, store, root, key uint32) → (uint64, bool)`, `Set(ctx, store, root, key, value) → Hash`, `Delete(ctx, store, root, key) → Hash`. The **sentinel** for "not present" in the packed array is `math.MaxUint64`, so valid indexes must be `< MaxUint64` (not a practical limit).

**Adaptive width**: `hashtreetouint8/16/32/64` share the trie layout; leaf value width and sentinel differ. Use the narrowest width that fits capacity (≤255 → uint8, ≤65535 → uint16, ≤4B → uint32, else uint64). Sessiontable and membertable use these for their byKey index to reduce leaf size when capacity is small. (See [[cask-block-backbones]] for the shared trie backbone and the full width table.)

## Part 3: index heap

A min-heap over indexes with comparison values stored in a separate array — used for expiration tracking:

```
INDEX_HEAP_ROOT
 ├─► Bytes[0:8]   : length
 ├─► Bytes[8]     : indexWidth
 ├─► Links[0]     : heap   (adaptive-width uint array; heap[i] = logical index at position i)
 └─► Links[1]     : coheap (adaptive-width uint array; coheap[logicalIndex] = heap position)
```

Operations take a `getValue func(uint64) (uint64, error)` callback that retrieves the comparison value (e.g., an expiry timestamp) from a parallel array, keeping the heap structure **decoupled** from value storage:

- `Push(root, logicalIndex, getValue) → Hash`
- `Pop(root, getValue) → (uint64, Hash)` — remove and return the min index.
- `Peek(root) → uint64` — min index without removing.
- `Fix(root, logicalIndex, getValue) → Hash` — restore the heap property after a value change.
- `Remove(root, logicalIndex, getValue) → Hash`.

The implemented package (`borkshop/cask/indexheap`) adds adaptive width for the heap/coheap arrays and a `Contains` query. The callback indirection is the key design move: the heap reorders against a value column it does not own, so the same heap can track expiry held in a separate `expiry` array.

Source: [doc/design/allocator-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/allocator-design.md) at commit `cdb975d8`.
