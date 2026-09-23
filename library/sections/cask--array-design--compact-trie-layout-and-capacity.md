---
title: Compact 32-Way Trie Layout and Capacity
source: doc/design/array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: How `caskarray` stores a long array of 32-byte block hashes in the smallest possible CASK-block trie. A CASK block is 1024 content bytes; a `cask.Hash` is 32 bytes; exactly 32 hashes fill one block (32 × 32 = 1024, numLinks=32, bytesSize=0). So every node is one block of 32 slots: a **leaf** (height 0) holds 32 value hashes, an **internal** node (height > 0) holds 32 child-block hashes, and the only thing distinguishing them is the **height in metadata** — one block layout, maximum compaction, no mixed nodes. An array index `i` reaches its leaf by writing `leafIndex = i / 32` in base 32 and following those digits (least significant first) from the root; the slot within the leaf is `i % 32`. Capacity for depth D (root at level D, leaves at level 0) is `32^(D+1)`: D=0 → 32 elements, D=1 → 1024, D=2 → 32K, D=3 → ~1M. The **array root** is a separate single block whose link 0 is the trie root and whose 8 bytes hold the length as uint64, so `Len` and `Get` need no extra structure. This is the `arraytree` backbone the columnar parallel-array tables build on.

## Block layout and capacity

A CASK block holds 1024 content bytes; each `cask.Hash` is 32 bytes, so **32 hashes fit exactly in one block** (32 × 32 = 1024) with no bytes left (numLinks=32, bytesSize=0). The smallest, most compact node is therefore one block of 32 slots, each slot either a link to a child block (internal node) or a value hash (leaf). The structure is a **uniform 32-way trie**: every node is one block with 32 slots; internal nodes use slots as child pointers, leaves use slots as array values. There are no mixed nodes and no partial blocks (the last leaf still stores 32 slots, using the array length to mark which are valid).

## Node types and height

- **Leaf** (height 0): 32 slots, each a value hash (array element). Stored in the same Links area as internal nodes; distinguished by metadata height.
- **Internal** (height > 0): 32 slots, each the hash of a child block (sub-trie). Children are internal (height − 1) or leaf (height 0).

A single block layout (32 links, 0 bytes) serves both; the **height field in metadata** tells whether slots are child hashes or value hashes. No extra format, maximum compaction.

## Indexing and capacity

Array index `i` is in `[0, length)`. The leaf index is `leafIndex = i / 32`; the slot within the leaf is `slot = i % 32`. To reach the leaf, write `leafIndex` in base 32 (digits `d0, d1, d2, …`, `d0` least significant) and follow slot `d0` from the root, `d1` from that child, and so on until a leaf is reached.

Capacity with depth D (root at level D, leaves at level 0) is `32^(D+1)`:

| Depth D | Capacity |
|---|---|
| 0 (root is a leaf) | 32 |
| 1 | 1024 |
| 2 | 32K |
| 3 | ~1M |

This is as compact as possible: minimum height for a given capacity, 32 slots per block, no wasted space.

## Array root and length

The array root is a separate single block (its hash is the "array root"):

- **Link 0**: hash of the trie root block (the 32-way trie of elements).
- **Bytes**: 8 bytes, the length as uint64 (fixed endianness for the format).

So numLinks=1, bytesSize=8. Opening an array loads the root, recovering the trie-root hash and the length; all operations use these. `Len` returns the stored length with no trie walk; `Get(i)` bounds-checks `i < length`, traverses by the base-32 digits of `leafIndex`, and returns the hash at `slot = i % 32`. An empty array has trie root = ZeroHash (or a canonical empty block) and length 0; the last leaf may be underfull (unused slots ZeroHash), but reads never go past length. The 32-slot block load/store helper is shared with `hashtree`; only the interpretation (child vs value) and the index-to-path mapping differ.

Source: [doc/design/array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/array-design.md) at commit `cdb975d8`.
