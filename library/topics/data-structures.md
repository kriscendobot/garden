# Topic: data-structures

> Abstract: General-purpose data structures and the interfaces over them, as a cross-cutting concern independent of the capability-security corpus. Seeded 2026-06-24 from `kriskowal/collections` (JavaScript collections behind one idiomatic interface: maps, sets, lists, deques, heaps, sorted and LRU/LFU variants, plus the abstract mixins and generic operators that factor their shared behavior) and from `kriskowal/cask`'s columnar parallel-array pattern (values in flat typed columns, indexes as separate slot-index arrays, multiple orderings over one dataset). Distinct from `content-addressed-storage` (which is about persisting structures as Merkle trees of blocks) and from `patterns` (the @endo/patterns shape-matching language).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [collections--readme--overview](../sections/collections--readme--overview.md) | collections README | A library of JavaScript data structures behind idiomatic, uniform interfaces, published as many `@collections/*` packages; the companion the reactive-binding library frb observes. |
| [collections--readme--package-catalog](../sections/collections--readme--package-catalog.md) | collections README | The catalog of `@collections/*` packages: concrete collections, abstract mixins, generic operators, helpers. |
| [cask--readme--columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | cask README | Parallel-arrays / ECS pattern: typed columns plus co-indexed heaps; adaptive-width tries that minimize Merkle-tree disturbance. |
| [cask--readme--package-taxonomy](../sections/cask--readme--package-taxonomy.md) | cask README | CASK's package layers, from the trie backbones up through typed arrays, associative structures, and tables. |

## See also

- [`content-addressed-storage`](content-addressed-storage.md): persisting data structures as Merkle trees of fixed-size blocks (cask).
- [`reactive-bindings`](reactive-bindings.md): the frb library observes collections through the generic change-notification interface these structures implement.
- [`patterns`](patterns.md): the @endo/patterns shape-matching language over passable data.
