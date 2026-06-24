---
id: parallel-arrays-columnar
aliases: ["parallel arrays", "columnar", "ECS", "entity component system", "structure of arrays", "SoA", "hashtreetouint", "adaptive width", "index width tiers", "compact index representation", "schema hash", "table IDL", "value columns", "co-index", "CaskIndexedHeap", "directories as tables"]
topics: [content-addressed-storage, data-structures]
status: current
---

# parallel-arrays-columnar

A data-layout pattern, borrowed from the Entity Component System (ECS) tradition, in which a record's fields are stored as flat, typed **columns** (one array per field) rather than as an array of structs, and indexes are kept as separate arrays of slot indexes (with co-index arrays for O(1) reverse lookup). The governing invariant is *values stay in place; indexes move*, so multiple orderings (a deadline min-heap and a priority min-heap) coexist over the same column data without copying. `kriskowal/cask` uses it both in memory (`sendbuffer`/`recvbuffer`) and on disk: the persistent counterpart is a reducer-style family of structures (CaskHeap, CaskAllocator, CaskIndexedHeap, CaskLinkedList) over 32-way tries, plus the adaptive-width `hashtreetouint*` family that picks the narrowest integer width fitting current capacity (uint8 for ≤256 up to uint64), with hysteresis to avoid thrashing, minimizing how much of a Merkle tree changes when one value updates. Table roots are single blocks of positional links plus fixed-width metadata (a C-struct shape, cheaper than a caskmap), and a proposed schema-hash plus table-IDL layer makes such structures self-describing.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--parallel-arrays--in-memory-pattern](../sections/cask--parallel-arrays--in-memory-pattern.md) | Value columns, index and co-index arrays, values-stay-put invariant, swap-to-end alloc, heap/list indexes. |
| [cask--parallel-arrays--persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | The four persistent structures (CaskHeap/Allocator/IndexedHeap/LinkedList) as Merkle-minimal reducers. |
| [cask--parallel-arrays--compact-index-representation](../sections/cask--parallel-arrays--compact-index-representation.md) | Adaptive index width with hysteresis; positional-link table roots more compact than caskmap. |
| [cask--parallel-arrays--universal-tree-and-schema-hashes](../sections/cask--parallel-arrays--universal-tree-and-schema-hashes.md) | Schema hashes self-describe structures; directories-as-tables; one adaptive TreeNode schema. |
| [cask--parallel-arrays--table-idl-and-data-model](../sections/cask--parallel-arrays--table-idl-and-data-model.md) | The table IDL, JSON-like data model with inline/ref/auto, and auto-reindexing field updates. |
| [cask--readme--columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | README summary: typed columns plus co-indexed heaps; adaptive-width tries minimizing Merkle disturbance. |
| [cask--readme--package-taxonomy](../sections/cask--readme--package-taxonomy.md) | The `hashtreetouint8`…`hashtreetouint64` family and the parallel-array tables (`sessiontable`, `membertable`). |
| [cask--readme--priority-load-shedding](../sections/cask--readme--priority-load-shedding.md) | The priority heaps over the sendbuffer columns drive per-class load shedding. |
| [cask--package-taxonomy--design-patterns](../sections/cask--package-taxonomy--design-patterns.md) | The parallel-array pattern (value/index/co-index columns, swap-to-end) stated from the taxonomy. |
| [cask--package-taxonomy--package-categories](../sections/cask--package-taxonomy--package-categories.md) | Where the buffer, array, and table packages sit, and the adaptive `hashtreetouint*` widths. |

## See also

- [[swap-to-end-allocation]] — the allocation discipline within the columns.
- [[cask-reducer-pattern]] — every persistent operation over these columns is a reducer.
- [[content-addressed-block-store]] — the store the persistent columns live in.
- [[rabin-chunking]] — used by the Rabin-bounded sorted-index variant of these tables.
- [[generic-collections]] — the array-of-objects-behind-one-interface alternative organizing principle.
