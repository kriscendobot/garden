---
title: Compact Index Representation
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: Because parallel-array indexes are themselves arrays of integers pointing into other arrays, CASK stores them at the narrowest width that fits current capacity: 1 byte (≤256), 2 bytes (≤65,536), 4 bytes (≤2³²), 8 bytes (2⁶⁴). For a 256-element heap this is an 8× saving (256 vs 2048 bytes). The width is derived from capacity and stored once in the structure root (`index_width: uint8`), not per block. Resizing uses **hysteresis** to avoid thrashing at boundaries: grow when length exceeds capacity, but shrink only when length falls below half capacity. A resize rewrites all index arrays at the new width — O(n), but rare (at most log₂(max_size) times). The table root is itself a single CASK block with a fixed layout: positional links (column-array hashes, position defined by the structure schema like C-struct field offsets) followed by fixed-width big-endian metadata (`length`, `capacity`, `index_width`) — more compact than a caskmap because no keys are stored. Use caskmap only for dynamic keys or extensible schemas.

## Index Width Tiers and Hysteresis

| Index width | Max capacity | Bytes/index |
|-------------|--------------|-------------|
| 1 byte | 256 | 1 |
| 2 bytes | 65,536 | 2 |
| 4 bytes | 4,294,967,296 | 4 |
| 8 bytes | 2^64 | 8 |

`indexWidthFromCapacity` switches on capacity to derive the width. **Grow** when `length > capacity` at a boundary; **shrink** when `length < capacity/2` (the differing thresholds are the hysteresis that prevents oscillation). `maybeResize` checks both directions and, on grow, errors if doubling the width would exceed 8 bytes ("capacity exceeded").

## Block Layout Implications

With 1-byte indexes a single 1024-byte block holds 1024 index elements (vs 128 with 8-byte indexes), so small structures (< 256 elements) often fit in one block per array, minimizing tree depth and I/O. Index arrays use a packed encoding: 992 bytes payload per block holds 992 indexes at 1-byte width down to 124 at 8-byte width, with link 0 pointing at the next block. The width lives in the structure root, so all blocks in one index array share it.

## Root Node Structure

The root of a parallel-array table is a single block: positional links (one per column, position defined by the schema) followed by fixed-width big-endian bytes for `length`, `capacity`, `index_width`, and any additional metadata. This is analogous to a C struct — fields at fixed offsets, no field names stored — and is more compact than a caskmap, which would require trie traversal and stored string keys to find each field.

```
PRIORITY_QUEUE_ROOT (single block):
  Links (position-indexed):
    [0] deadlines_array_hash    [1] priorities_array_hash
    [2] heap_array_hash         [3] coHeap_array_hash
    [4] entities_array_hash     [5] coEntities_array_hash
  Bytes (fixed-width, big-endian):
    [0..7] length   [8..15] capacity   [16] index_width
```

Operations that may resize (such as `Put`) fold `maybeResize` into the reducer, so the same input always yields the same output including any resize — preserving the reducer property.

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
