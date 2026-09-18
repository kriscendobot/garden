---
title: The Bεtree — a write-optimized B+ tree with pivot-node write buffers, upsert messages, and copy-on-write-friendly block layout
source: "GEFS: A Good Enough File System (Ori Bernstein)"
source_kind: paper
source_authors: [Ori Bernstein]
source_year: 2023
source_venue: "Plan 9 file-system paper (orib.dev/gefs.pdf; IWP9 2023 inferred)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
topics: [file-systems, data-structures]
status: current
---

Abstract: The core data structure of GEFS is a **Bεtree**, a modification of a B+ tree that optimizes writes by adding a **write buffer to the pivot (inner) nodes**. Like a B-tree it has leaf nodes (keys and values) and pivot nodes (pointers to children); unlike a B-tree, the pivot nodes also carry a write buffer. It exposes a simple key-value API (point queries and range scans) plus an **upsert** operation: a mutation is not applied in place but inserted as a *message addressed to a key* into the root's write buffer, then flushed lazily down the tree toward the leaf that owns the key. Because a mutation is a message describing a change, updates can be performed *without reading the current value* (blind upserts), which lets GEFS batch many operations into one atomic root update and skip read-modify-write cycles that would otherwise touch distant regions of the tree. The Bεtree is what gives GEFS low write amplification under copy-on-write and its near-trivial snapshotting.

## Structure and the upsert protocol

A Bεtree consists of leaf nodes, which contain keys and values, and pivot nodes, which contain pointers to their children (either pivot nodes or leaf nodes) **and a write buffer**. It diverges from a traditional B-tree key-value store with the addition of an **upsert**: an operation that inserts a *modification message* into the tree, addressed to a key.

- **Insert.** The root node is copied, and the new message is inserted into its write buffer. When the write buffer is full, it is inspected and the number of messages directed to each child is counted; the child with the largest number of pending writes is picked as the **victim**, and the root's write buffer is flushed into it. This proceeds recursively down the tree until either an intermediate node has sufficient space in its write buffer, or the messages reach a leaf node, at which point the value in the leaf is updated.
- **Query.** The tree is walked as normal, *but the path to the leaf is recorded*. When a value is found, the write buffers along the path back to the root are inspected, and any messages that have not yet reached the leaves are applied to the final value read back.
- **Blind upserts.** Because mutations to the leaves are messages that *describe* a mutation, updates may be performed without inspecting the data at all. For example, when writing to a file, the modification time and QID version may be incremented without inspecting the current QID — a "new version" message may simply be upserted instead. This allows skipping read-modify-write cycles that access distant regions of the tree, in favor of a simple insertion into the root's write buffer. Because all upserts go into the root node, a number of operations may be upserted in a single update; as long as there is sufficient space in the root node's write buffer, the batch insert is **atomic**. Inserts, deletions, and mutations to existing data are all upserts.

## Block layout

For simplicity, GEFS makes all blocks the same size. This implies the Bεtree blocks are smaller than optimal and the disk blocks are larger than optimal, but the simplifications this allows in the block layer appear worthwhile.

Within a single block, the pivot keys are stored as **offsets to variable-width data**. The data itself is unsorted, but the offsets pointing to it are sorted. This allows O(1) access to keys and values given an index, or O(log n) access while searching, while still allowing variable-size keys and values.

To allow efficient copy-on-write operation, the Bεtree relaxes several of the balance properties of a B-tree: it allows a smaller amount of fill than would normally be required, and merges nodes with their siblings opportunistically. To prevent sideways pointers between sibling nodes (which would themselves need copy-on-write updates), the **fill levels are stored in the parent blocks** and updated when the child pointers are updated.

## Cross-reference (editorial, not in the source)

This is the sharpest point of comparison the maintainer asked for. The Bεtree buys low write amplification by **buffering messages high in the tree and flushing them lazily** — a *write-optimization* strategy. CASK's Rabin-chunked sorted structures (concept [[rabin-chunking]]; sections `cask--sorted-array-design--rabin-chunked-structure-and-stability`, `cask--dir-design-v2--goals-and-rabin-chunked-entries-tree`, `cask--parallel-arrays--rabin-bounded-sorted-indexes`) buy low *Merkle-tree disturbance* by a different mechanism: content-defined chunk boundaries so a local insert or delete re-hashes only O(log n) blocks and leaves distant chunks byte-identical, giving "a B-tree without rebalancing." dialog-db's **probabilistic B-trees (prolly trees)** (`dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments`) reach a deterministic content-addressed layout the same content-defined way. Where the Bεtree localizes *writes* (batching), the Rabin/prolly structures localize *change to the hash tree* (stable boundaries). Both relax classic B-tree balance, but for different payoffs — GEFS to make copy-on-write cheap, CASK/dialog-db to make content-addressed diffing and sync cheap. Notably, **GEFS does no content-defined chunking and no deduplication at all**; that absence is itself the interesting finding against CASK's Rabin approach (see [[betree]] and the snapshot/space-reclamation section).

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
