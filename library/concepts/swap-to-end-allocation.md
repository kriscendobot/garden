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

## See also

- [[parallel-arrays-columnar]] — the columnar layout swap-to-end allocates within.
- [[cask-reducer-pattern]] — Alloc/Free are reducers returning a new root hash.
- [[merkle-tree-of-blocks]] — why touching only the entities array (not values) limits disturbance.
