---
title: Design Patterns (Reducer and Parallel Arrays)
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
notes: Reference-shaped summary of the two patterns that doc/design/parallel-arrays.md covers in depth; soft-flag cross-overlap, not contradiction.
---

> Abstract: The two cross-cutting patterns every CASK package follows. **Reducer pattern**: all CASK mutations are functions `(root_hash, args) → new_root_hash`; the store is append-only, so "mutation" creates new blocks rather than modifying existing ones, and the new root hash names the new state. **Parallel arrays**: in-memory structures (`sendbuffer`, `recvbuffer`) keep multiple slices where index `i` across every slice refers to the same logical entity, enabling value columns (entity attributes), index arrays (orderings such as priority-heap order), co-index arrays (reverse mappings for O(1) lookup), and swap-to-end allocation/deallocation without moving data. The persistent structures (`uint*array`, future `table` types) translate the same pattern to block storage using `arraytree` as the backbone.

## Reducer Pattern

All CASK mutations follow the reducer shape:

```
(root_hash, args) → new_root_hash
```

Functions take a root hash and return a new root hash. The store is append-only; "mutation" creates new blocks rather than modifying existing ones.

## Parallel Arrays

In-memory structures like `sendbuffer` and `recvbuffer` use parallel arrays: multiple slices where index `i` in each slice refers to the same logical entity. The pattern enables:

- **Value columns**: store entity attributes.
- **Index arrays**: maintain orderings (e.g. heap order by priority).
- **Co-index arrays**: reverse mappings for O(1) lookup.
- **Swap-to-end**: efficient allocation/deallocation without moving data.

The persistent CASK structures (`uint*array`, future `table` types) translate this pattern to block storage using `arraytree` as the backbone.

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
