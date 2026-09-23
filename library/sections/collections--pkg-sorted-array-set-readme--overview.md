---
title: SortedArraySet
source: packages/sorted-array-set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/sorted-array-set` is a sorted collection of *unique* values ordered by a comparator, built on `SortedArray` but enforcing uniqueness in its mutation methods. Owing to the compact allocation of arrays it outperforms `SortedSet` for collections of less than about 500 values. It is configurable via alternate `equals` (equivalence) and `compare` (order, may return zero for both equivalent and incomparable values), and inherits SortedArray's observable `array` mutations.

SortedArraySet is a sorted collection of unique values, ordered by a comparator. The SortedArraySet in turn uses a SortedArray, but enforces uniqueness with its mutation methods.

```
npm install @collections/sorted-array-set
```

**Performance.** Owing to the compact allocation of arrays, a SortedArraySet will perform faster than a SortedSet for collections of less than about 500 values.

**Configurability.** Provide an alternate `equals` and `compare` to alter the behavior of the set. The `equals` operator determines equivalence and `compare` determines order. The `compare` operator may return zero for both equivalent and incomparable values.

**Observability.** Since the SortedArraySet inherits SortedArray, it mutates the underlying `array` property using observable methods. Observing range, map, and property changes on that array will work normally.

Source: [packages/sorted-array-set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/sorted-array-set/README.md) at commit `4688abad`.
