---
title: Swap-to-End Allocator
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

> Abstract: The persistent allocator (`borkshop/cask/allocator`, IMPLEMENTED) that hands out **stable logical indexes** for session tables and similar columnar structures, applying the same swap-to-end pattern `sendbuffer` uses in memory. The root block stores `length` (allocated count), `capacity` (total slots), and a 1-byte `indexWidth`, and links two adaptive-width uint arrays: `entities` (positions `0..length−1` hold allocated logical indexes, `length..capacity−1` hold free ones) and `coEntities` (reverse map: `coEntities[logicalIndex]` = that index's position in `entities`). The invariants are `entities[coEntities[i]] == i` and `coEntities[entities[p]] == p` for all valid i, p, with logical index i allocated iff `coEntities[i] < length`. `Alloc` expands capacity if full, takes `entities[length]`, increments length, and returns the index. `Free` swaps the freed index to the boundary `length−1` (exchanging entries in both `entities` and `coEntities`) and decrements length, so no other slot moves and external references to allocated slots stay valid. `IsAllocated`, `Len`, `Cap`, and `ForEach` round out the surface. The two index arrays use **adaptive width** keyed to capacity (≤255 → uint8, ≤65535 → uint16, ≤2^32−1 → uint32, else uint64), widening automatically at each boundary; shrinking is optional via explicit `Compact()`. This is the canonical detailed source for [[swap-to-end-allocation]].

## Why an allocator

A session table needs four things: **stable indexes** (allocated slots do not move until freed), **key lookup** (32-byte key → index), an **expiration heap** (remove expired sessions efficiently), and **parallel columns** (multiple value arrays sharing one index space). Part 1 is the allocator that provides the stable index space; the hash-to-index tree, the heap, and the composite table build on it.

## Structure

The allocator manages a pool of logical indexes with the swap-to-end pattern (the same one `sendbuffer` uses for its entities/coEntities in memory):

```
ALLOCATOR_ROOT
 ├─► Bytes[0:8]   : length (number of allocated slots)
 ├─► Bytes[8:16]  : capacity (total slots)
 ├─► Bytes[16]    : indexWidth (1, 2, 4, or 8 bytes)
 ├─► Links[0]     : entities (adaptive-width uint array)
 │                  entities[0..length-1]        = allocated logical indexes
 │                  entities[length..capacity-1] = free logical indexes
 └─► Links[1]     : coEntities (adaptive-width uint array)
                    coEntities[logicalIndex] = physical position in entities
```

**Invariants**:

- `entities[coEntities[i]] == i` for all `i < capacity`.
- `coEntities[entities[p]] == p` for all `p < capacity`.
- Logical index `i` is allocated iff `coEntities[i] < length`.

## Operations

- **`New(ctx, store) → Hash`** — empty allocator.
- **`Alloc(ctx, store, root) → (logicalIndex uint64, newRoot Hash)`** — if `length == capacity`, expand (append to `entities` and `coEntities`); take `index = entities[length]`; `length++`; return the index.
- **`Free(ctx, store, root, logicalIndex) → newRoot`** — `physicalPos = coEntities[logicalIndex]` (error if `>= length`, meaning not allocated); `lastPhysical = length − 1`; `lastLogical = entities[lastPhysical]`; swap in `entities` (`entities[physicalPos] = lastLogical`, `entities[lastPhysical] = logicalIndex`); update `coEntities` (`coEntities[lastLogical] = physicalPos`, `coEntities[logicalIndex] = lastPhysical`); `length--`.
- **`IsAllocated`** — `coEntities[logicalIndex] < length`.
- **`Len`** / **`Cap`** — allocated count / total capacity.
- **`ForEach(fn)`** — `for i in 0..length-1 { fn(entities[i]) }`.

Because freeing only swaps the freed index to the boundary and decrements length, no other slot moves; values stored in parallel columns keep stable slots and external references remain valid across allocations.

## Adaptive index width

`entities` and `coEntities` use a width keyed to capacity: ≤255 → uint8 (1 byte), ≤65535 → uint16 (2 bytes), ≤2^32−1 → uint32 (4 bytes), larger → uint64 (8 bytes). Width expands automatically when capacity grows past a boundary. Shrinking can be done via an explicit `Compact()` but is optional. The implemented package (`borkshop/cask/allocator`) exposes `New, Alloc, Free, IsAllocated, Len, Cap, ForEach, AllocatedIndices`.

Source: [doc/design/allocator-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/allocator-design.md) at commit `cdb975d8`.
