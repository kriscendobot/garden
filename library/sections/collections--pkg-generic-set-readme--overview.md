---
title: GenericSet mixin
source: packages/generic-set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/generic-set` is the abstract mixin for sets. A concrete set supplies `add`, `addEach`, `has`, `delete`, and `constructClone`; from those primitives the mixin derives the set-algebra surface: `union`, `intersection`, `difference`, `symmetricDifference`, `equals`, `contains`, `remove`, and `toggle`. It is the set-shaped sibling of `generic-collection`, supplying the operations that only make sense for unique-membership structures.

The GenericSet is an abstract implementation of many common methods of sets.

The set implementation must provide `add`, `addEach`, `has`, `delete`, and `constructClone`. Based on these implementations, the GenericSet provides `union`, `intersection`, `difference`, `symmetricDifference`, `equals`, `contains`, `remove`, and `toggle`.

```
npm install @collections/generic-set
```

Source: [packages/generic-set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/generic-set/README.md) at commit `4688abad`.
