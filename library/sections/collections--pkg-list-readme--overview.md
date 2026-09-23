---
title: List structure
source: packages/list/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/list` is a circular doubly-linked list with a head node. Linked lists are well suited to fast insertion and removal of nodes (and runs of nodes) at any position, but poorly suited to random access and search. It is the order-tracking substrate that `Set` and `Map` build on, and (via `generic-order`) it is comparable by iteration order.

List is an implementation of a circular linked list with a head node. Linked lists are well-suited for fast insertion and removal of nodes (and lists of nodes) at any position within the list, but poorly suited for random access and search.

```
npm install @collections/list
```

Source: [packages/list/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/list/README.md) at commit `4688abad`.
