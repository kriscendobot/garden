---
title: Block Format and Limits
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

Abstract: How `cask/blob` (the content-defined chunked Merkle tree, "CAT") lays bytes onto go/cask's 1024-byte main content plus 12-byte metadata footer (height:8, numLinks:1, dataLen:2, reserved:1; `cask.MetadataSize`). The block's role is read straight from its metadata. A **leaf block** has `height = 0`, `numLinks = 0`, and a `dataLen` recording the exact occupied byte count: bytes are `data[0:dataLen]` followed by zero padding to 1024, and because the block hash covers only the occupied portion, trailing zeros do not affect the hash while `dataLen` preserves the exact length through round-trips (including data that genuinely ends in zero bytes). Max leaf data is 1024 bytes. An **internal block** has `height > 0` and `numLinks = k` child hashes, with the `bytes` area holding a compact size table of `k` 4-byte big-endian entries where entry `i` is the total byte length of child `i`'s subtree (leaf data only, not padding). The fanout cap follows from the block size: `32*k (links) + 4*k (sizes) <= 1024`, so `k <= 28`. Per-entry subtree size is a uint32 (4 GiB max).

## Block Format (go/cask)

go/cask stores blocks with:

- **Main content**: 1024 bytes shared by links + bytes.
- **Metadata**: 12-byte footer stored separately (height:8, numLinks:1, dataLen:2, reserved:1). See `cask.MetadataSize`.

cask/blob uses this format exactly. The structure is determined by metadata:

### Leaf block (height = 0)

- **numLinks = 0**
- **dataLen** in metadata records the exact number of data bytes.
- **bytes**: data[0:dataLen], followed by zero padding to fill 1024 bytes.

The block hash covers only the occupied portion (links + dataLen bytes), so trailing zeros do not affect the hash. The `dataLen` field in metadata preserves the exact data length through round-trips, including data with trailing zero bytes.

**Max data per leaf**: 1024 bytes.

### Internal block (height > 0)

- **numLinks = k (1..28)**
- **links**: k child hashes
- **bytes**: k 4-byte big-endian size entries

The `bytes` area is a compact size table; entry `i` is the total byte length of child `i`'s subtree (leaf data length, not including leaf prefix/padding).

Max fanout is constrained by the block size:

```
32*k (links) + 4*k (sizes) <= 1024  ->  k <= 28
```

## Limits

- Max leaf data length: 1024 bytes
- Max child links per internal node: 28
- Max subtree size per entry: uint32 (4 GiB)

Source: [doc/design/blob-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/blob-design.md) at commit `cdb975d8`.
