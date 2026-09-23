---
title: SortedArrayMap
source: packages/sorted-array-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/sorted-array-map` is a sorted collection of `{key, value}` entries ordered by a key comparator, built on a `SortedArraySet` of entries. Owing to the compact allocation of arrays it outperforms `SortedMap` for maps of less than about 500 entries. It is configurable via alternate `equals`, `compare`, and `getDefault` (the behavior of `get` on an absent key), and — because it wraps a SortedArraySet over a SortedArray — its underlying `array` mutates through observable methods, so the coming and going of `Entry` objects can be observed.

SortedArrayMap is a sorted collection of `{key, value}` entries, ordered by a key comparator. The SortedArrayMap in turn uses a SortedArraySet.

```
npm install @collections/sorted-array-map
```

**Performance.** Owing to the compact allocation of arrays, a SortedArrayMap will perform faster than a SortedMap for maps of less than about 500 entries.

**Observability.** Since the SortedArrayMap contains a SortedArraySet (`store`) and the SortedArraySet inherits SortedArray, it mutates the underlying `array` property using observable methods. Observing range, map, and property changes on that array will work normally, observing the coming and going of the map `Entry` objects.

**Configurability.** Provide an alternate `equals`, `compare`, and `getDefault` to alter the behavior of the map. The `equals` operator determines equivalence and `compare` determines order. The `compare` operator may return zero for both equivalent and incomparable values. `getDefault` determines the behavior of `get` given an absent key.

Source: [packages/sorted-array-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/sorted-array-map/README.md) at commit `4688abad`.
