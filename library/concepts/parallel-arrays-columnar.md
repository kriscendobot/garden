---
id: parallel-arrays-columnar
aliases: ["parallel arrays", "columnar", "ECS", "entity component system", "structure of arrays", "SoA", "hashtreetouint", "adaptive width"]
topics: [content-addressed-storage, data-structures]
status: draft
---

# parallel-arrays-columnar

A data-layout pattern, borrowed from the Entity Component System (ECS) tradition, in which a record's fields are stored as flat, typed **columns** (one array per field) rather than as an array of structs, and indexes are kept as separate arrays of slot indexes. `kriskowal/cask` uses it both in memory and on disk: multiple orderings (a deadline min-heap and a priority min-heap) coexist over the same column data without copying values. The `sendbuffer` is the in-memory example (`enqueuedAt` / `deadlines` / `priorities` columns with co-indexed heaps); the persistent counterpart is the adaptive-width `hashtreetouint*` family, which picks the narrowest integer width that fits current capacity (uint8 for ≤255 entries up to uint64), minimizing how much of a Merkle tree changes when a single value updates.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | Typed columns plus co-indexed heaps; sendbuffer example; adaptive-width tries minimizing Merkle disturbance. |
| [cask--readme--package-taxonomy](../sections/cask--readme--package-taxonomy.md) | The `hashtreetouint8`…`hashtreetouint64` family and the parallel-array tables (`sessiontable`, `membertable`). |
| [cask--readme--priority-load-shedding](../sections/cask--readme--priority-load-shedding.md) | The priority heaps over the sendbuffer columns drive per-class load shedding. |

## See also

- [[content-addressed-block-store]] — the store the persistent columns live in.
- [[generic-collections]] — the array-of-objects-behind-one-interface alternative organizing principle.
