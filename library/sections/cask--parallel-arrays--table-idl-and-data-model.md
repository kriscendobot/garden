---
title: Table IDL and Data Model
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: A table IDL that captures rows, columns, and indexes as first-class concepts and generates the reindexing code. The data model is JSON-like but with precise numeric types (int8…int64, uint8…uint64, bigint, float32/64), bytes/string, composites (array/map/struct), and three reference modes: `inline<T>` (embedded in the parent block), `ref<T>` (hash pointer to a separate block), and `auto<T, threshold>` (inline if small, ref if large — the key type, with a per-column byte threshold). A table declares `field`s and `index`es (`heap(min|max, field)`, `hash(field)`, `btree(field[, field2])`, `list(field)`, `splay(field)`); the compiler generates `Add`/`Remove`, per-field `Get`/`Set`, and index-appropriate query methods, with the crucial property that **`SetF` automatically updates every index that depends on field F**. Field widths are not declared — they adapt to observed data with hysteresis (a uint64 column storing only 0..255 uses 1 byte), so the IDL declares semantics while storage tracks actual data.

## Data Model

Primitives: `null`, `bool`, the signed/unsigned integer families, `bigint` (arbitrary precision), `float32`/`float64`, `bytes`, `string` (UTF-8). Composites: `array<T>`, `map<K,V>`, `struct{...}`. Reference types:

- `inline<T>` — embedded directly in the parent block.
- `ref<T>` — a hash pointer to a separate block.
- `auto<T>` (or `auto<T, threshold>`) — inline if ≤ threshold bytes, else ref; the column tracks which representation each row uses. The threshold is configurable per column.

## Table IDL Syntax

```idl
table SendBuffer {
  field enqueuedAt: uint64;
  field deadline:   uint64;
  field priority:   uint64;
  field payload:    auto<bytes, 1024>;

  index minEnqueued: heap(min, enqueuedAt);
  index minDeadline: heap(min, deadline);
  index minPriority: heap(min, priority);
  // Allocation (entities/coEntities) is implicit.
}
```

Index types and their generated machinery: `heap(min|max, field)` (O(1) top, O(log n) update — generates heap+coHeap), `hash(field)` (O(1) lookup), `btree(field[, field2])` (O(log n) lookup, range queries, ordered iteration, composite keys), `list(field)` (O(1) move-to-front/back for LRU — generates next+prev), `splay(field)` (O(log n) amortized, adapts to access patterns).

## Generated Operations

For fields F1, F2, … and indexes I1, I2, …, the IDL generates `Add`/`Remove`, `GetF1`/`SetF1` per field, and index queries (`I1Top`/`I1Pop` for heaps, `I1Lookup` for hash, `I1Range` for btree, `I1First`/`I1Last` for list). **The key insight: `SetF1` automatically updates all indexes that depend on F1** — the generated code knows which indexes reference which fields.

## Field Width Adaptation

Field widths adapt to data rather than being declared. A `uint64` column storing values in 0..255 uses 1 byte; one reaching 2³²−1 uses 4 bytes; a `string` column inlines while all values are < 32 bytes and spills to ref when some grow larger. **Grow** when a value exceeds the current width's range; **shrink** when all values fit half the width (hysteresis). The IDL therefore declares semantic types while storage tracks observed range per column (`min_value`/`max_value` in the column descriptor).

The document closes with open questions: composite-index expression, computed/derived fields, constraints (uniqueness, foreign keys), migration expression across schema versions, and whether multi-table atomic transactions belong in the IDL or a higher layer.

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
