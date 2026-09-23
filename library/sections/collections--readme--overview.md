---
title: Collections (overview)
source: README.md
source_repo: kriskowal/collections
source_commit: 63ac271fdff6c329a00fd33902907f1af686e948
source_date: 2017-10-15
source_authors: [Kris Kowal, Stuart Knightley]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `kriskowal/collections` is a library of JavaScript implementations of common data structures behind *idiomatic*, uniform interfaces. It is published as a multitude of separately versioned packages under the `@collections/*` scope (one package per structure or operator), recommends pinning to `^1`, and is the JavaScript-side companion to the reactive-binding library `frb` (both depend on the same generic collection-change-notification interface). Full prose docs historically lived at collectionsjs.com.

`collections` contains JavaScript implementations of common data structures with idiomatic interfaces. The repository is a monorepo that publishes a multitude of separately published packages under the `@collections/*` npm scope; consumers depend on the individual structures they need rather than a single bundle, and the project recommends pinning to version `^1`.

The defining design goal is the *idiomatic interface*: every collection exposes the same shape of API (`add`, `delete`, `has`, `get`, `forEach`, `map`, `filter`, `reduce`, `toArray`, content-change listeners, and so on) regardless of its underlying representation, so a `Set`, a `SortedSet`, and an `LruSet` are interchangeable at the call site. This uniformity is what lets the reactive-bindings library [frb](https://github.com/kriskowal/frb) observe any of them through one generic change-notification protocol (`addRangeChangeListener`, `addMapChangeListener`, `addOwnPropertyChangeListener`). The abstract `generic-collection`, `generic-map`, `generic-order`, and `generic-set` packages factor the shared method bodies that each concrete structure mixes in.

Source: [README.md](https://github.com/kriskowal/collections/blob/63ac271fdff6c329a00fd33902907f1af686e948/README.md) at commit `63ac271f`.
