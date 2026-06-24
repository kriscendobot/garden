---
title: Cell Path Descriptor Format
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

Abstract: The on-the-block layout of a cell path descriptor, the immutable Merkle tree whose content hash appears in an indirect cell entry's hash field. It is structurally identical to a compactblob except that the first leaf has exactly one link. The **first leaf block** reserves 32 bytes for the cell ID as `Links[0]` and uses the remaining 992 bytes for the start of the CBOR data; subsequent leaves have the full 1024 bytes. The CBOR payload is a single array of text strings, one per path segment (so segment names may contain any bytes, including colons and slashes, with no escape convention). The cell ID is stored as a **block link, not in the CBOR data**, for one reason: retention. By placing it in the link slot, the GC mark phase discovers it when walking the descriptor's Merkle tree and keeps the cell alive; buried in CBOR it would be invisible to GC.

A cell path descriptor is a Merkle tree whose first leaf block carries the cell ID as a link, followed by CBOR-encoded path data. It is structurally identical to a compactblob except that the first leaf has exactly one link.

### Block layout

**First leaf block** (height 0):

```
Links[0]: cell_id (32 bytes)
Bytes:    CBOR data (start of path encoding, up to 992 bytes)
```

**Subsequent leaf blocks** (height 0, if the CBOR data exceeds 992 bytes):

```
Links:    (none)
Bytes:    CBOR data (continuation)
```

**Interior blocks** (height > 0): Standard Merkle tree nodes linking to children, same as compactblob.

The first leaf reserves 32 bytes for the cell ID link, leaving 992 bytes for the start of the CBOR data. Subsequent leaves have the full 1024 bytes available, same as compactblob. In practice, descriptors are small: a cell ID plus a few path segments fits easily in a single block.

### CBOR payload

The CBOR data (spanning the bytes of all leaf blocks) encodes a single CBOR array of text strings, the path segments:

```
CBOR array(*tstr) — path segments
```

The cell ID is *not* part of the CBOR data. It is stored as a block link in the first leaf, where it participates in the Merkle tree and is visible to GC.

For example, a descriptor granting access to the `vacation` subtree encodes as a single leaf block:

```
First leaf:
  Links[0]: <cell-id>            -- 32 bytes
  Bytes:    81                    -- CBOR array(1)
              68 76616361 74696f6e  -- tstr(8): "vacation"
```

A deeper path like `photos` → `albums` → `summer`:

```
First leaf:
  Links[0]: <cell-id>            -- 32 bytes
  Bytes:    83                    -- CBOR array(3)
              66 70686f746f73     -- tstr(6): "photos"
              66 616c62756d73     -- tstr(6): "albums"
              66 73756d6d6572     -- tstr(6): "summer"
```

Path segments are individual strings in the CBOR array. This avoids the need for an escape convention: segment names may contain any bytes, including colons, slashes, or other characters that would require escaping in a delimited format.

The descriptor's content hash (the root of its Merkle tree) is what appears in the directory entry's hash field. The descriptor is retained by the directory entry (strong reference, same as any content hash). The path array may be empty (`80`, CBOR array of length 0), which is equivalent to a direct reference (though direct types should be used instead).

### Why a link instead of CBOR bytes?

The cell ID is stored as a block link rather than embedded in the CBOR data for one reason: **retention**. The descriptor must keep the cell alive. A cell is eligible for garbage collection if no reachable block links to it. By placing the cell ID in the link slot of the first leaf, the GC mark phase discovers it as a cell reference when walking the Merkle tree, and retains the cell. If the cell ID were buried in the CBOR data, GC would not see it, and the cell could be collected while descriptors still reference it.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
