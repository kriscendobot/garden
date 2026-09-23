---
id: swap-to-end-allocation
aliases: ["swap-to-end", "swap to end", "swap-to-end allocation", "entities array", "coEntities", "free-list partition", "swap primitive", "co-index array", "caskallocator", "CaskAllocator"]
topics: [data-structures, content-addressed-storage]
status: current
---

# swap-to-end-allocation

An allocation discipline for fixed-capacity parallel-array tables. A single `entities` index array partitions slots into an **active** partition (positions `< length`) and a **free** partition (positions `>= length`); a co-index `coEntities` gives O(1) reverse lookup of where each slot sits. To allocate, take the slot at `entities[length]` and swap it into the active partition, then increment `length`. To free a slot, swap it to the boundary (`length-1`) and decrement `length`, so its storage becomes available again without shifting any other slot. The whole scheme rests on the `Swap(values, coValues, i, j)` primitive, which exchanges two index entries while restoring the invariant `coValues[values[i]] == i`. Because only indexes move and values keep stable slots, external references to a slot stay valid across allocations. The persistent form is `CaskAllocator`, where Alloc/Free each touch O(log n) nodes in the entities array (one swap) plus O(1) for the length field, leaving the values array untouched and so minimizing Merkle-tree disturbance.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--parallel-arrays--in-memory-pattern](../sections/cask--parallel-arrays--in-memory-pattern.md) | The entities/coEntities free-list partition, append-to-end alloc, swap-to-end free, and the Swap primitive. |
| [cask--parallel-arrays--persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | CaskAllocator: persistent free list, Alloc/Free touch O(log n) in entities only, values untouched. |
| [cask--dbstore-design--on-disk-file-formats](../sections/cask--dbstore-design--on-disk-file-formats.md) | The `alloc` flat file: the swap-to-end allocator persisted on disk at adaptive 1/2/4/8-byte width. |
| [cask--dbstore-design--implementation-plan-and-sizing](../sections/cask--dbstore-design--implementation-plan-and-sizing.md) | Slot Allocate/Free against the alloc file; rebuildable from meta if lost. |
| [cask--allocator-design--swap-to-end-allocator](../sections/cask--allocator-design--swap-to-end-allocator.md) | The canonical detailed spec: entities/coEntities root, the `entities[coEntities[i]] == i` invariants, Alloc/Free/IsAllocated, adaptive width. |
| [cask--allocator-design--session-table-composite](../sections/cask--allocator-design--session-table-composite.md) | The allocator as Links[0] of the sessiontable, providing the stable slot space the value columns and indexes share. |

## See also

- [[parallel-arrays-columnar]] — the columnar layout swap-to-end allocates within.
- [[cask-reducer-pattern]] — Alloc/Free are reducers returning a new root hash.
- [[merkle-tree-of-blocks]] — why touching only the entities array (not values) limits disturbance.
- [[gc-quarantine-store]] — caskdbstore's GC frees swept slots back into this allocator.
