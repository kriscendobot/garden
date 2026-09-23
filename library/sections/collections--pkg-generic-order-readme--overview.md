---
title: GenericOrder mixin
source: packages/generic-order/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/generic-order` is the abstract mixin for *ordered* collections (like List). Because an ordered collection has a deterministic iteration order, it is comparable: the mixin provides `equals` and `compare` whose results depend on walking the two collections in iteration order. This is the ordered counterpart to the set-oriented and map-oriented mixins, and is what makes lists (and other order-bearing structures) participate in the library's generic `equals` / `compare` operators.

The GenericOrder is an abstract implementation for ordered collections like List. Ordered collections are comparable, so the implementation provides `equals` and `compare` that depend on the deterministic iteration order of the collection.

```
npm install @collections/generic-order
```

Source: [packages/generic-order/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/generic-order/README.md) at commit `4688abad`.
