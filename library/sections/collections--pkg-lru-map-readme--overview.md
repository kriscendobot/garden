---
title: LruMap
source: packages/lru-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/lru-map` is a Map-like collection backed by an `LruSet`: a bounded map that drops the **least recently used** entry to make room for new values. It is the map-shaped member of the recency-eviction cache family, composed from the `LruSet` primitive the same way the ordered `Map` is composed from `Set`.

LruMap is a Map-like collection backed by an LruSet, a set that drops the least recently used item to make room for new values.

```
npm install @collections/lru-map
```

Source: [packages/lru-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/lru-map/README.md) at commit `4688abad`.
