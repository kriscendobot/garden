---
title: Set structure
source: packages/set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/set` is a collection of unique values iterated in order of least-to-most recently inserted equivalent value (insertion order). Implementation: a List of values tracks insertion order, and a FastSet indexes the list nodes. The set's `hash` and `equals` operators are overridable for alternate indexing. The README advises favoring the native `Set` unless the extended collection interface is needed. This is the order-preserving counterpart to FastSet (which guarantees no iteration order).

Set is a collection of unique values, in order of least to most recently inserted equivalent value.

The Set uses a List of values to track the order of insertion, and a FastSet to index nodes of the list. You can override the set's `hash` and `equals` operators for alternate indexing. Favor the native implementation of `Set` if you do not need the extended collection.

```
npm install @collections/set
```

Source: [packages/set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/set/README.md) at commit `4688abad`.
