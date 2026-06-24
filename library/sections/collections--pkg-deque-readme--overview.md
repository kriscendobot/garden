---
title: Deque structure
source: packages/deque/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/deque` is a double-ended queue (pronounced "deck") backed by a *circular buffer*. It features the array-shaped methods `push`, `pop`, `shift`, and `unshift`, which all tend to be fast (amortized constant time at both ends, unlike `Array.prototype.shift`/`unshift` which are linear). Based on Petka Antonov's deque implementation.

A deque is a double-ended queue, pronounced like "deck". This implementation uses a circular buffer. Deques feature the array methods `push`, `pop`, `shift`, and `unshift`, which tend to be fast.

```
npm install @collections/deque
```

Based on the [deque implementation by Petka Antonov](https://github.com/petkaantonov/deque/blob/master/js/deque.js).

Source: [packages/deque/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/deque/README.md) at commit `4688abad`.
