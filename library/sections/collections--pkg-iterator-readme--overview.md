---
title: Iterator
source: packages/iterator/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-09-26
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/iterator` provides a rich interface for lazy iteration built on the JavaScript iterator protocol. Its constructor *upgrades* any object that merely implements `next` into a feature-rich iterator with transformation methods (`map`, `filter`, `takeWhile`, `dropWhile`, ...), and it also exposes generator functions (`count`, `repeat`, `cycle`) that build common iterations from scratch.

Iterator provides a rich interface for iteration, based on the JavaScript iterator protocol.

```
npm install @collections/iterator
```

The Iterator constructor upgrades iterators that merely implement `next` into a feature-rich iterator with methods like `map`, `filter`, `takeWhile`, and `dropWhile`.

The iterator constructor also provides functions like `count`, `repeat`, and `cycle` for creating common iterations from scratch.

Source: [packages/iterator/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/iterator/README.md) at commit `4688abad`.
