---
title: SortedArray
source: packages/sorted-array/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/sorted-array` is a sorted collection of values ordered by a comparator, storing its values in an underlying array and using binary search plus ranged copies (via [swap](../swap)) to shift values for insertion and removal. It may contain duplicate or equivalent values (use `SortedSet`/`SortedArraySet` to enforce uniqueness); insertion is *stable* (equivalent values land at the end of their equivalence range, removal takes the first), and it mutates its underlying `array` through observable methods so property/map/ranged changes can be observed.

SortedArray is a sorted collection of values, ordered by a comparator. The sorted array stores values in an underlying array and uses a binary search and ranged copies ([swap](../swap)) to shift values for insertion and removal.

```
npm install @collections/sorted-array
```

A sorted array can contain duplicates or equivalent values. Use a SortedSet or SortedArraySet to enforce unique values.

**Stability.** Equivalent values will be inserted at the end of the range of equivalent values, and removing by value will take the first value of a range of equivalent values.

**Observability.** The SortedArray mutates its underlying `array` object using observable methods. Observing property, map, or ranged changes on the underlying `array` will work fine.

Source: [packages/sorted-array/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/sorted-array/README.md) at commit `4688abad`.
