---
source: doc/design/blob-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 2
status: current
notes: The cask/blob content-defined chunked Merkle tree ("CAT"). Concretizes the blob leaf of merkle-tree-of-blocks and the CDC mechanism of rabin-chunking, and adds the internal-level CDC "anchor tree" that keeps higher-level groupings stable. The 1024+12 block format ties to cask--protocol / cask--readme--block-format.
---

> Abstract: The design of **cask/blob**, a content-defined chunked (CDC) Merkle tree ("CAT") tuned for CASK's 1KB blocks, whose goal is random access to byte offsets with stable chunk boundaries under insertions. It lays bytes onto go/cask's 1024-byte main content plus 12-byte metadata footer: a leaf block (height 0, numLinks 0) records exact occupied length in `dataLen` with zero padding the hash ignores, and an internal block (height > 0) holds k child hashes plus a compact 4-byte-per-entry subtree-size table, with fanout capped at k ≤ 28 by the block size. Leaves are cut by a rolling hash whose state is never reset at a boundary (so a local edit re-locks after a short distance), and the same CDC is applied at internal levels over concatenated child entries to form a stable "anchor tree" where changes stay local at every level. Random access is O(tree height) via the per-node size tables; the tree stores no global metadata, so the caller keeps the root hash, total size, and any chunking parameters.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [block-format-and-limits](../sections/cask--blob-design--block-format-and-limits.md) | content-addressed-storage | current |
| [content-defined-chunking-and-random-access](../sections/cask--blob-design--content-defined-chunking-and-random-access.md) | content-addressed-storage | current |

## Provenance

Source: [doc/design/blob-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/blob-design.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-25 (job `scholar-ingest-cask-12`, cycle 13).
