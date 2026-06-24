---
title: LruSet
source: packages/lru-set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/lru-set` is a Set-like collection with a bounded capacity that evicts the **least recently used** value to make room for new ones. It is the recency-eviction primitive of the cache family: `LruMap` is built on top of it, and it is the set-shaped counterpart to `LfuSet` (which evicts by frequency rather than recency).

LruSet is a Set-like collection that drops the least recently used value to make room for new values.

```
npm install @collections/lru-set
```

Source: [packages/lru-set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/lru-set/README.md) at commit `4688abad`.
