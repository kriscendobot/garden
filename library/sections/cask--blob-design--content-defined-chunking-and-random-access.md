---
title: Content-Defined Chunking and Random Access
source: doc/design/blob-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: How `cask/blob` chooses chunk boundaries and serves byte-offset reads. Leaves are cut with a rolling hash (Rabin/buzhash-style) over a sliding window: a boundary is taken when the current chunk size is at least MinChunk **and** `(hash & (AvgChunk-1)) == 0`, **or** when the chunk reaches MaxChunk. The rolling-hash state is **not reset** at a boundary, which is what makes the CDC stability property hold: a local mutation perturbs chunking only near the edit and then "re-locks" after a short distance, so a content-addressed store re-hashes blocks near the edit rather than every block after it. To stop one inserted leaf from shifting all later parent groupings, the same CDC is applied at **internal levels**: the rolling hash is fed the concatenated child entries (`hash || size`), boundaries are honored only after a whole entry and once MinLinks is met, and MaxLinks is always enforced. This yields a stable "anchor tree" where changes stay local at every level. **Random access** to a byte offset is O(tree height): load the root and read its size table, find the child whose size range contains the offset, descend while subtracting preceding sizes, and at the leaf read `dataLen` and return the bytes. The tree stores no global metadata; the caller keeps the root hash, the total size (or sums the root size table), and any chunking parameters needed for reconstruction.

## Content-Defined Chunking (CDC)

Leaves are created with a rolling hash (Rabin/buzhash-style) over a sliding window. A boundary is created when:

- current chunk size >= MinChunk
- and (hash & (AvgChunk-1)) == 0
- or current chunk size >= MaxChunk

Rolling hash state is **not reset** at chunk boundaries. This is critical to the CDC stability property: a local mutation only perturbs chunking near the edit and then "re-locks" after a short distance.

## CDC at Higher Levels

To prevent a single inserted leaf from shifting all later parent groupings, cask/blob also applies CDC at internal levels:

- The rolling hash is fed the concatenated bytes of child entries (`hash || size`).
- Boundaries are only honored **after a whole entry** and once MinLinks is met.
- MaxLinks is always enforced.

This produces a stable "anchor tree" where changes remain local at every level.

## Random Access

Given a root hash, random access is O(tree height):

1. Load root, read size table.
2. Find the child whose size range contains the byte offset.
3. Descend, subtracting previous sizes.
4. At leaf, read `dataLen` and return bytes.

## Metadata and Root

cask/blob does not store global metadata inside the tree. The caller stores:

- root hash
- total size (or compute by summing root size table)
- chunking parameters if needed for reconstruction

Source: [doc/design/blob-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/blob-design.md) at commit `cdb975d8`.
