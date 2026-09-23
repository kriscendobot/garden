---
title: LfuSet
source: packages/lfu-set/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/lfu-set` is a Set-like collection with a bounded capacity that evicts the **least frequently used** value to make room for new ones. It is the frequency-eviction primitive of the cache family — the counterpart to `LruSet`, which evicts by recency — and underlies `LfuMap`.

LfuSet is a Set-like collection that drops the least frequently used value to make room for new values.

```
npm install @collections/lfu-set
```

Source: [packages/lfu-set/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/lfu-set/README.md) at commit `4688abad`.
