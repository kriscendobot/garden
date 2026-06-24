---
title: LfuMap
source: packages/lfu-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/lfu-map` is a Map-like collection backed by an `LfuSet`: a bounded map that drops the **least frequently used** entry to make room for new values. It is the map-shaped member of the frequency-eviction cache family, composed from the `LfuSet` primitive.

LfuMap is a Map-like collection backed by an LfuSet, a set that drops the least frequently used item to make room for new values.

```
npm install @collections/lfu-map
```

Source: [packages/lfu-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/lfu-map/README.md) at commit `4688abad`.
