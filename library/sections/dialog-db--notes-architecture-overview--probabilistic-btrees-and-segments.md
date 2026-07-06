---
title: Probabilistic B-Trees and segments
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [content-addressed-storage, local-first-sync]
status: current
---

> Abstract: DialogDB stores data in **Probabilistic B-Trees** ([Prolly Trees]) — a deterministic, content-addressed tree whose structure is a function of its data, not of insertion order. The same data always produces the same tree; nodes are addressed by the hash of their content; only modified subtrees need to be synchronized; and distributed instances can efficiently merge. The lowest layer is **segments**: content-addressed, immutable, serialized-and-compressed data chunks that each hold multiple facts. Content-addressing plus deterministic layout is what makes change detection cheap (diff two roots, fetch only the differing subtrees) and caching invalidation-free.

DialogDB employs **Probabilistic B-Trees** (Prolly Trees) for a deterministic, content-addressed tree structure:

- **Deterministic layout**: the same data always produces the same tree structure regardless of insertion order.
- **Content-addressed nodes**: nodes are addressed by the hash of their content.
- **Efficient change detection**: only modified subtrees need to be synchronized.
- **Mergeable structure**: distributed instances can efficiently merge changes.

The lowest layer consists of **segments**, which are:

- **Content-addressed blobs**: each segment is identified by its content hash.
- **Immutable data chunks**: once created, segments never change.
- **Serialized and compressed**: efficiently packed for storage and transfer.
- **Self-contained data units**: each can contain multiple facts.

The deterministic-layout property is the key that unlocks efficient synchronization: two replicas that hold the same facts hold byte-identical trees, so a diff of their roots isolates exactly the subtrees that differ, and only those are transferred. This is the same content-addressed-Merkle-tree strategy `kriskowal/cask` uses for its 1KB-block store, applied here to a B-tree tuned for ordered key ranges rather than a fixed block size.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.

[Prolly Trees]: https://docs.canvas.xyz/blog/2023-05-04-merklizing-the-key-value-store.html
