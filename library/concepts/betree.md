---
id: betree
aliases: ["Bεtree", "Be-tree", "B-epsilon tree", "Bepsilon tree", "write-optimized B-tree", "write buffer B-tree", "pivot write buffer", "upsert message tree", "message-oriented B-tree", "BetrFS tree"]
topics: [file-systems, data-structures]
status: current
---

# betree

A **Bεtree** is a write-optimized variant of a B+ tree that adds a **write buffer to every pivot (inner) node**. Mutations are not applied in place but inserted as **messages addressed to a key** (an *upsert*) into the root's write buffer, then flushed lazily down the tree: when a node's buffer fills, the child receiving the most pending messages is picked as the victim and the buffer is flushed into it, recursing until a message reaches the leaf that owns its key. Queries walk to the leaf as normal but replay any not-yet-flushed messages found in the buffers along the path. Because a message *describes* a change, GEFS can perform blind upserts (increment a file's version/mtime without reading the current value) and batch many operations into one atomic root update, which is what gives it low write amplification under copy-on-write and a nearly trivial snapshot implementation. GEFS relaxes classic B-tree balance (lower fill, opportunistic sibling merges, fill levels stored in the parent) to keep copy-on-write cheap. The structure originates in the Bender/Farach-Colton line of work and the BetrFS file system; GEFS is the Plan 9 realization.

## Comparison with the library's other tree/index structures

The Bεtree is the "write-optimization by buffering" point in a design space the library already covers from the "content-addressed diffing" side:

- **Rabin-chunked sorted structures ([[rabin-chunking]], [[cask-block-backbones]]).** CASK gets "a B-tree without rebalancing" by choosing chunk boundaries with a rolling hash, so a local edit re-hashes only O(log n) blocks and distant chunks stay byte-identical. That localizes *change to the Merkle tree*; the Bεtree localizes *write work* by batching. GEFS does **no** content-defined chunking and **no** dedup — the shapes are complementary, not the same trick.
- **Probabilistic B-trees / prolly trees (`dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments`).** Like Rabin chunking, these pick node boundaries deterministically from content so replicas hold byte-identical trees and diff-based sync moves only differing subtrees. Again: content-addressed-layout localization, not write-buffer batching.
- **Both buy the same headline (efficient point + range queries with cheap incremental change) by opposite means:** the Bεtree by deferring and coalescing writes high in the tree; the Rabin/prolly structures by making the on-disk layout a deterministic function of content.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gefs/betree-write-optimized-data-structure](../sections/papers--bernstein-gefs-good-enough-file-system-2023--betree-write-optimized-data-structure.md) | The Bεtree in full: pivot write buffers, upsert messages, flush-to-victim, query-with-buffer-replay, blind upserts, and the copy-on-write-friendly block layout. |
| [gefs/overview](../sections/papers--bernstein-gefs-good-enough-file-system-2023--overview.md) | Why the Bεtree is GEFS's core: low write amplification under copy-on-write and near-trivial snapshotting. |
| [gefs/on-disk-format](../sections/papers--bernstein-gefs-good-enough-file-system-2023--on-disk-format.md) | The pivot/leaf on-disk encoding: sorted offset table, packed keys/pointers, and the buffered-message region. |

## See also

- [[gefs]] — the file system built on a forest of these trees.
- [[rabin-chunking]] — CASK's content-defined chunking; the contrasting "localize the Merkle change" strategy.
- [[cask-block-backbones]] — CASK's hashtree/arraytree backbones, a sibling family of block-structured trees.
- [[content-addressed-storage-backend]] — dialog-db's prolly-tree-backed content-addressed storage.
