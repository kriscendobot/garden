---
title: FastSet
source: packages/fast-set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/fast-set` is a Set-like collection backed by a hash dictionary with collision lists. Like FastMap, it forgoes insertion-order and iteration-order guarantees in exchange for fast membership testing, and is the unordered set primitive the ordered `Set` and `Map` use as their internal index alongside a `List` that carries the order.

FastSet is a Set-like collection backed by a hash dictionary with collision lists. Unlike the Set collection, the FastSet does not track order of insertion nor guarantee any iteration order.

```
npm install @collections/fast-set
```

Source: [packages/fast-set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/fast-set/README.md) at commit `4688abad`.
