---
title: Future Structures (Sorted Array, Circular Linked List)
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
notes: Forward-looking sketches; the Rabin-chunked sorted array is detailed in doc/design/sorted-array-design.md (deferred to a follow-on cask ingest) and summarized in cask--parallel-arrays--rabin-bounded-sorted-indexes.
---

> Abstract: Two persistent structures the taxonomy anticipates. A **Rabin-chunked sorted array** uses content-defined chunking (Rabin fingerprinting) to localize Merkle-tree changes on insert/delete so rebalancing does not cascade like a B-tree; its root carries a `chunks_tree` (arraytree of chunk hashes), `count`, fixed `entry_size`, `key_size`, and chunk params (avg/min/max), supporting Has/Get/Insert/Delete/Range/ForEach/Transform, with use cases of membership tables (sorted by node_id), pinned-roots sets (sorted hashes), and time-series indexes (sorted by timestamp). A **circular doubly-linked list** (head index plus `next`/`prev` int-arrays that wrap) serves round-robin scheduling rings, LRU ordering, and any structure needing stable iteration order during modification, with InsertAfter/InsertBefore/Remove/MoveToFront/MoveToBack/Iterate.

## Sorted Array (Rabin-Chunked)

A sorted array using content-defined chunking (Rabin fingerprinting) to localize Merkle-tree changes during insertions and deletions. Unlike B-trees, rebalancing does not cascade through the tree. Detailed in `SORTED_ARRAY_DESIGN.md`.

Use cases: membership tables (sorted by node_id), pinned-roots set (sorted hashes), time-series indexes (sorted by timestamp).

```
SORTED_ARRAY_ROOT
 ├─► chunks_tree : arraytree of chunk hashes
 ├─► count       : total entries
 ├─► entry_size  : bytes per entry (fixed)
 ├─► key_size    : bytes used for sorting
 └─► chunk params: avg_chunk, min_chunk, max_chunk
```

Operations: Has, Get, Insert, Delete, Range, ForEach, Transform.

## Circular Linked List

A circular doubly-linked list for round-robin scheduling rings, LRU cache ordering, and any structure needing stable iteration order during modification.

```
LINKED_LIST_ROOT
 ├─► head : int64 (-1 if empty, or index of first element)
 ├─► next : int*array (next[i] = index after i, wraps to head)
 └─► prev : int*array (prev[i] = index before i, wraps to tail)
```

Operations: InsertAfter, InsertBefore, Remove, MoveToFront, MoveToBack, Iterate.

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
