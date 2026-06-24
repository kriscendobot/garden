---
title: FastMap
source: packages/fast-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/fast-map` is a Map-like collection backed by a hash dictionary with collision lists (separate chaining). Unlike the order-preserving `Map`/`Set`, FastMap tracks neither insertion order nor any guaranteed iteration order — it trades ordering for the cheapest possible keyed lookup, and is the indexing engine the ordered `Map` and `Set` compose internally for their membership test.

FastMap is a Map-like collection backed by a hash dictionary with collision lists. Unlike the Set collection, the FastMap does not track order of insertion nor guarantee any iteration order.

```
npm install @collections/fast-map
```

Source: [packages/fast-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/fast-map/README.md) at commit `4688abad`.
