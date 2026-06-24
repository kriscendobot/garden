---
id: generic-collection-mixin-protocol
aliases: ["generic-collection", "generic-map", "generic-order", "generic-set", "collection mixin", "primitives in derived methods out", "constructClone", "idiomatic collection interface", "addEach", "abstract collection"]
topics: [data-structures]
status: draft
---

# generic-collection-mixin-protocol

The factoring that makes every `kriskowal/collections` structure expose the same idiomatic API. A concrete structure implements only a small set of *primitive* operations; an abstract mixin package derives the large *idiomatic* surface from them. Four mixins cover the shapes: `generic-collection` (base: primitives `constructClone`, `reduce`, `add`, `delete`, `one`, optional `contentCompare`; derives `addEach`, `map`, `filter`, `forEach`, `toArray`, `min`/`max`/`sum`/`average`, `concat`, `flatten`, `zip`, `sorted`, `reversed`, `clone`, and more), `generic-set` (primitives `add`/`addEach`/`has`/`delete`/`constructClone`; derives the set algebra `union`/`intersection`/`difference`/`symmetricDifference`/`toggle`), `generic-map` (a map as a set of `{key, value}` items keyed by key; derives the map surface from a `store` set, with `getDefault` override and implicit observability), and `generic-order` (ordered collections; derives `equals`/`compare` from deterministic iteration order). A new structure becomes idiomatic by mixing in the relevant package and implementing its primitives only.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--pkg-generic-collection-readme--overview](../sections/collections--pkg-generic-collection-readme--overview.md) | Base mixin: primitives-in / derived-methods-out; the full derived method list. |
| [collections--pkg-generic-set-readme--overview](../sections/collections--pkg-generic-set-readme--overview.md) | Set mixin: derives set algebra from five primitives. |
| [collections--pkg-generic-map-readme--overview](../sections/collections--pkg-generic-map-readme--overview.md) | Map mixin: map as a set of keyed items; `getDefault`; implicit observability. |
| [collections--pkg-generic-order-readme--overview](../sections/collections--pkg-generic-order-readme--overview.md) | Order mixin: `equals`/`compare` from iteration order. |

## See also

- [[generic-collections]] — the library this protocol structures.
- [[generic-order-comparison-protocol]] — the `compare`/`equals` operators the `generic-order` mixin plugs structures into.
- [[content-change-listener]] — the observability interface every generic map (and any observed structure) implements.
