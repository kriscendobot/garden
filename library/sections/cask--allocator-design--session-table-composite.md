---
title: Session Table Composite Structure
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

> Abstract: The `sessiontable` (IMPLEMENTED) ties the allocator, the hash-to-index tree, the index heap, and a set of value columns into one composite root, realizing the full columnar parallel-array table on disk. Its root links the allocator (the stable logical-index space), a `keyIndex` (`hashtreetouint64` mapping a key hash → logical index), an `expiryHeap` (`indexheap` ordered by expiry), and the value columns indexed by logical index: `keys` (array of 32-byte session keys), `expiry` (uint64array of timestamps), `data` (array of session-data hashes), plus more columns as needed. `Create` allocates a slot and writes key/expiry/data, returning the logical index; `Lookup` resolves a key hash to its index; `Get` reads a session by index; `Update` modifies data and/or expiry (fixing the heap); `Delete` removes by index; `PopExpired(now)` pops the most-expired session if it has expired. The whole structure composes the three primitive structures plus typed columns, and the heap's `getValue` callback reads the `expiry` column so expiration ordering rides on a column the heap does not own. All four pieces — allocator, hashtreetouint64, indexheap, sessiontable — are marked implemented under `borkshop/cask/`; the design notes the same shape generalizes to a `membertable` and a generic `table`.

## Part 4: session table (composite structure)

Combines allocator + hash-to-index + heap + value columns into one root:

```
SESSION_TABLE_ROOT
 ├─► Links[0]     : allocator root
 ├─► Links[1]     : keyIndex root (hashtreetouint64: key_hash → logical_index)
 ├─► Links[2]     : expiryHeap root
 │   ── Value Columns (indexed by logical index) ──
 ├─► Links[3]     : keys   (array of 32-byte session keys)
 ├─► Links[4]     : expiry (uint64array of timestamps)
 ├─► Links[5]     : data   (array of session data hashes)
 └─► ...          : more columns as needed
```

## Operations

- **`Create(root, key Hash, expiry uint64, data Hash) → (uint64, Hash)`** — allocate a slot, store key/expiry/data, return the logical index.
- **`Lookup(root, keyHash uint32) → (uint64, bool)`** — find the logical index by key hash.
- **`Get(root, index uint64) → (key Hash, expiry uint64, data Hash)`** — read a session by index.
- **`Update(root, index, data Hash, newExpiry uint64) → Hash`** — modify session data and/or expiry (fixing the heap at the index's position).
- **`Delete(root, index uint64) → Hash`** — remove a session by index.
- **`PopExpired(root, now uint64) → (index uint64, newRoot Hash, expired bool)`** — remove the most-expired session if it has expired.

## Implementation status

All four pieces are implemented under `borkshop/cask/`:

1. **allocator** — swap-to-end index allocator with entities/coEntities, adaptive width; `New, Alloc, Free, IsAllocated, Len, Cap, ForEach, AllocatedIndices`.
2. **hashtreetouint64** — 4-level, 32-way trie mapping uint32 keys to uint64 values, `MaxUint64` sentinel; `Get, Set, Delete, Len, ForEach`.
3. **indexheap** — min-heap over indexes with external value comparison via callback, adaptive width; `New, Push, Pop, Peek, Fix, Remove, Contains`.
4. **sessiontable** — composite of allocator + hash-to-index + heap + value columns; columns key (Hash), expiry (uint64), data (Hash); indexes byKey (`hashtreetouint64`) and byExpiry (`indexheap`); `New, Create, Lookup, Get, Update, Delete, PeekExpired, PopExpired, ForEach, Len`.

The heap's `getValue` callback reads the `expiry` column, so expiration ordering rides on a value column the heap does not own. The design notes the same composite shape generalizes to a `membertable` and a generic `table`.

Source: [doc/design/allocator-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/allocator-design.md) at commit `cdb975d8`.
