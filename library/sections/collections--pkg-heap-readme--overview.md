---
title: Heap structure
source: packages/heap/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/heap` provides fast access to the highest value it contains; adding and removing values takes time proportional to the logarithm of the size. It is not totally ordered, and is backed by a binary search tree laid out in an array. The heap is a *max heap* by default; inverting the comparator (composing `compare` with negation) yields a min heap.

A heap provides fast access to the highest value it contains. Adding and removing values takes time proportional to the logarithm of its size. A heap is not totally ordered and is backed by a binary search tree laid out in an array.

The heap is a max heap by default. Inverting the comparator produces a min heap.

```js
var heap = new Heap([], equals, compose(compare, neg));
```

```
npm install @collections/heap
```

Source: [packages/heap/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/heap/README.md) at commit `4688abad`.
