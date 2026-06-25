---
title: Adaptive-Width BigInt Array with Overflow
source: doc/design/bigint-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: A `BigIntArray` that stores arbitrary-precision integers compactly by adapting its storage width to the values actually present, built on the parallel-arrays pattern. It targets values that are usually small but occasionally large (file sizes, timestamps), grow over time (counters), or have unknown bounds. The root block links a `values` array (packed integers at the current `field_width`), an `overflow` array (CaskArray of blob hashes for values exceeding the width), a `max_heap` and `max_coheap` (a heap of indexes ordered by value magnitude with O(1) reverse lookup), and stores `length`, `field_width` (1, 2, 4, 8, or 0 for pure-overflow mode), and a `flags` byte (signed/unsigned). A value that fits the current width is packed inline; one that does not stores `MAX_VALUE` as a sentinel in `values` and the actual value as a compact blob in `overflow` at the same index. Width adapts with **hysteresis**: on store, if a value exceeds the current width the array rebuilds at the next width (clearing overflow entries that now fit); shrinking happens only when the heap's max drops below half the smaller width's maximum (the hysteresis band) so width changes are rare. The max heap is what makes shrink-decisions O(1): it always knows the current maximum magnitude, and it is fixed on every Set and Append. This is a worked instance of [[parallel-arrays-columnar]] where one column (values) is itself width-adaptive and a second column (overflow) catches the tail.

## Motivation

Fixed-width integer arrays (`intarray`) are efficient when all values fit the chosen width, but many use cases have values that are usually small but occasionally large (file sizes, timestamps), grow over time (counters, sequence numbers), or have unknown bounds at creation. A BigInt array should use minimal storage for small values, expand automatically when larger values arrive, contract when large values are removed, and fall back to arbitrary precision for truly large values.

## Parallel-array structure

```
BigIntArray Root Block:
  Links[0]: values_hash      # CaskArray of value representations
  Links[1]: overflow_hash    # CaskArray of overflow blobs (values > 64 bits)
  Links[2]: max_heap_hash    # Heap index tracking largest values
  Links[3]: max_coheap_hash  # Co-index for the max heap
  Bytes[0:8]: length         # Number of elements
  Bytes[8]:   field_width    # 1, 2, 4, 8, or 0 (overflow mode)
  Bytes[9]:   flags          # Signed/unsigned, etc.
```

For `field_width` 1/2/4/8, the values array stores packed integers at that width, and values that do not fit go to the overflow array with a sentinel in the values array. For `field_width` 0 (pure overflow mode), all values are compact blobs and the values array stores indexes into the overflow array.

## Sentinel values and overflow

When a value exceeds the current field width, store `MAX_VALUE` (e.g., `0xFF` for uint8) as the sentinel in the values array and the actual value in the overflow array at the same index. The overflow array is a `caskarray` of hashes pointing to `caskcompactblob` blobs.

## Width adaptation with hysteresis

The max heap tracks which indexes hold the largest values, giving O(1) lookup of the current maximum.

**Width increase** (when storing a value):
```
if value > max_for_current_width:
    if value fits in next_width:
        rebuild values array at next_width
        clear overflow entries that now fit
    else:
        store in overflow, mark sentinel in values
```

**Width decrease** (hysteresis):
```
max_value = peek max heap
if max_value < threshold_for_smaller_width:   # threshold = max_for_smaller_width / 2
    rebuild values array at smaller_width
```

The hysteresis band (shrink only below half the smaller width's maximum) keeps width changes rare; each element can trigger only O(log W) width changes over its lifetime.

## Heap for maximum tracking

The max heap maintains indexes sorted by value magnitude:

```go
type BigIntArray struct {
    Values     intarray.Root  // Packed integers at current width
    Overflow   array.Root     // Hashes to compact blobs for large values
    MaxHeap    intarray.Root  // Heap of indexes, ordered by value
    MaxCoHeap  intarray.Root  // Reverse mapping: index -> heap position
    Length     uint64
    FieldWidth uint8          // 1, 2, 4, 8, or 0
}
```

When a value changes: update it in Values (or Overflow), Fix the heap at the index's position (via MaxCoHeap lookup), then check whether width adaptation is needed. The heap is the structure that makes the shrink decision O(1) instead of an O(n) scan for the current maximum.

Source: [doc/design/bigint-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/bigint-design.md) at commit `cdb975d8`.
