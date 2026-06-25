---
title: In-memory block layout and the 12-byte metadata footer
source: cask.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: cask.go
source_line_range: "35-75"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The concrete byte layout — 1024-byte body of links+bytes plus a separate 12-byte metadata footer (height, numLinks, dataLen, reserved); 1036 total
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The second half of the `cask.go` package header pins the **concrete byte layout** that the `Block`, `BlockWithMetadata`, and metadata-accessor types realize. A block body is **1024 bytes**: `links` (`32 * numLinks` bytes, variable, at the start) followed by `bytes` (`dataLen` bytes, after the links). Metadata is a **separate 12-byte footer**: `height` (offset 0, uint64 big-endian, the Merkle tier), `numLinks` (offset 8, one byte, 0–32), `dataLen` (offset 9, uint16 big-endian, 0–1024), and `reserved` (offset 11, padding for future use). Total block size is up to **1036 bytes** (1024 body + 12 metadata). The split is deliberate: the first 1024 bytes can be written directly where a 1024-byte block would be stored, with the 12 metadata bytes stored elsewhere if needed. This is the on-the-wire and in-storage shape behind the design docs' "block format" sections.

**In-memory layout.** A block is laid out with links and bytes in the first 1024 bytes, followed by a 12-byte metadata footer stored separately:

```
links:32*numLinks  (variable, at start)
bytes:dataLen bytes (variable, after links)
```

**Metadata layout** (12 bytes, stored separately from the block body):

```
height:8   (offset 0, uint64 big-endian, Merkle tree tier)
numLinks:1 (offset 8, 0-32)
dataLen:2  (offset 9, uint16 big-endian, 0-1024)
reserved:1 (offset 11, padding for future use)
```

Total block size is up to **1036 bytes** (1024 body + 12 metadata). The first 1024 bytes can be written directly where a 1024-byte block would be stored, with the remaining 12 bytes stored elsewhere if needed.

The package constants name these sizes and the footer offsets directly:

- `HashSize = 32` (a SHA-256 hash), `BlockSize = 1024` (main content area), `MetadataSize = 12` (footer), `MaxBlockSize = 1036` (body + footer).
- Footer offsets: `metaOffsetHeight = 0`, `metaOffsetNumLinks = 8`, `metaOffsetDataLen = 9`, `metaOffsetReserved = 11`.

The accessor functions (`Height`/`SetHeight`, `NumLinks`/`SetNumLinks`, `DataLen`/`SetDataLen`) read and write these fields out of the 12-byte metadata slice; the metadata footer travels with the block as a `[]byte` parameter rather than being embedded in the 1024-byte body, which is what lets the body be stored byte-for-byte where a plain 1024-byte block would go. A block's hash covers only the **occupied** portion (`numLinks * 32 + dataLen`), not the full 1024 bytes — see `Block.Size` and `Block.Hash`.

Source: [cask.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/cask.go#L35-L75) at commit `cdb975d8`.
