---
title: MiniMap
source: packages/mini-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/mini-map` implements a subset of the ECMAScript-6 `Map` tuned to perform well enough for *very small* collections without wasting space — a good-enough Map for cases where a full Map is almost always overkill. Keys may be objects. It supports `has`, `get`, `set`, `delete`, and `clear`, and its constructor takes no arguments. It is the memo structure `equals` uses internally for cycle detection.

The mini map implements a subset of the ECMAScript 6 Map that performs well enough for very small collections. This implementation exists for a good-enough approximation of a Map that doesn't waste much space even if an alternative is almost always used in practice. Keys may be objects. Supports `has`, `get`, `set`, `delete`, and `clear`. The `MiniMap` constructor supports no arguments.

```
npm install @collections/mini-map
```

```js
var map = new Map();
var key = {};
expect(map.has(key)).toBe(false);
map.set(key, 10);
expect(map.get(key)).toBe(10);
expect(map.has(key)).toBe(true);
map.delete(key);
expect(map.has(key)).toBe(false);
map.clear();
```

Source: [packages/mini-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/mini-map/README.md) at commit `4688abad`.
