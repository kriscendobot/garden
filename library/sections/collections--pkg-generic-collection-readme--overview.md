---
title: GenericCollection mixin
source: packages/generic-collection/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/generic-collection` is the abstract mixin at the base of the idiomatic-collection interface. A concrete structure supplies a small set of *primitive* operations (`constructClone`, `reduce`, `add`, `delete`, `one`, and optionally `contentCompare` for ordered collections); from those, the mixin derives the large *idiomatic* surface (`addEach`, `deleteEach`, `forEach`, `map`, `filter`, `enumerate`, `group`, `every`, `some`, `toArray`, `toObject`, `min`, `max`, `sum`, `average`, `concat`, `flatten`, `zip`, `join`, `sorted`, `reversed`, `clone`, `only`). This primitives-in / derived-methods-out factoring is how every `@collections/*` structure presents the same API regardless of its internal representation.

The GenericCollection is an abstract implementation of many common methods of collections.

The generic collection's methods depend on the implementation to provide `constructClone`, `reduce`, `add`, `delete`, and `one` methods, and optionally a `contentCompare` method for ordered collections. From these methods the generic collection derives:

`addEach`, `deleteEach`, `forEach`, `map`, `filter`, `enumerate`, `group`, `every`, `some`, `toArray`, `toObject`, `min`, `max`, `sum`, `average`, `concat`, `flatten`, `zip`, `join`, `sorted`, `reversed`, `clone`, and `only`.

This is the central design move of the library: a new structure becomes idiomatic by mixing in `generic-collection` (and, as applicable, `generic-map`, `generic-order`, or `generic-set`) and implementing only its primitive operations. Everything else comes for free, and stays uniform across structures.

```
npm install @collections/generic-collection
```

Source: [packages/generic-collection/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/generic-collection/README.md) at commit `4688abad`.
