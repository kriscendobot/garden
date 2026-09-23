---
title: Map structure
source: packages/map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/map` is a collection of `{key, value}` entries indexed by key and iterated in order of least-to-most recently *added* key (insertion order, not access order). Implementation: a Set of `{key, value}` entries indexed by key; that Set in turn uses a List to track insertion order and a FastSet to index the list nodes. The map's `hash`, `equals`, and `getDefault` operators are overridable for alternate indexing. The README advises favoring the native `Map` unless the extended collection interface is needed.

Map is a collection of `{key, value}` entries indexed by key, iterated in order of least to most recently added key.

The map uses a Set of `{key, value}` entries, indexed by key. The Set, in turn, uses a List of entries to track the order of insertion, and a FastSet to index nodes of the list.

**Configurability.** You can override the map's `hash`, `equals`, and `getDefault` operators for alternate indexing. Favor the native implementation of `Map` if you do not need the extended collection.

```
npm install @collections/map
```

Source: [packages/map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/map/README.md) at commit `4688abad`.
