---
title: BigInt Array Operations, Thresholds, and Complexity
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

> Abstract: The mutation surface, width thresholds, signed-integer handling, and cost analysis of the adaptive `BigIntArray`. `Get` reads the packed value, dereferencing the overflow blob when it sees the sentinel; `Set` packs inline if the value fits, else expands the width or stores to overflow, always fixing the heap; `Append`/`Pop` grow/shrink the length and push/pop the heap; `Swap` exchanges two values and their coheap entries; `Remove` swaps the target with the last element, pops the heap, fixes the swapped-in entry, and may shrink width. The width-threshold table reserves one value per width as the overflow sentinel and sets shrink thresholds at half the next-smaller maximum (the hysteresis): width 1 max 254, width 2 max 65534 shrink-at 127, width 4 max 2^32−2 shrink-at 32767, width 8 max 2^64−2 shrink-at 2^31−1, width 0 unlimited shrink-at 2^63−1. Signed support uses `int8/16/32/64array` with two's complement (no zigzag), `math.MinInt64` as the int64 sentinel, and a sign-byte + big-endian magnitude overflow blob format (single block up to ~900 bytes, full `caskcompactblob` tree beyond). Costs: Get/Set/Append/Remove are O(log n) in the typical and overflow cases; a width change is O(n) but amortized rare by hysteresis (O(log W) changes per element lifetime), and Merkle impact is O(log n) blocks per single value change versus O(n / values_per_leaf) per width change. A pure-overflow mode (skip adaptive width, store all values as blob hashes) trades storage efficiency for simplicity. Implementation phases 0-3 (signed arrays, fixed-width-with-overflow, max-heap tracking, automatic width adaptation) are all DONE; five open questions remain (heap granularity, lazy rebuilding, compression, sparse overflow, signed magnitude tracking).

## Operations

- **`Get(index) → BigInt`**: read `Values.Get(index)`; if it equals the sentinel, decode the blob at `Overflow.Get(index)`; otherwise return the packed value.
- **`Set(index, value) → newRoot`**: if it fits the current width, set inline (clearing any prior overflow) and fix the heap; if it fits uint64 and width should expand, rebuild at the larger width and set; otherwise mark the sentinel and store the value as a blob in overflow; always fix the heap.
- **`Append(value) → newRoot`**: `index = Length`; `Set(index, value)`; `Length++`; push the heap.
- **`Pop() → (newRoot, value)`**: read `Get(Length−1)`; `Length--` (reset all arrays to ZeroHash if empty); pop the heap; return the value.
- **`Swap(i, j) → newRoot`**: exchange the two values via Set, then swap their coheap entries (heap property is preserved by the swap).
- **`Remove(index) → newRoot`**: swap the target with the last element, swap their heap entries, `Length--`, pop the heap (removing the now-last entry), fix the heap at the swapped-in entry, then maybe shrink width.

## Width thresholds

| Width | Max value | Shrink threshold |
|---|---|---|
| 1 | 254* | N/A |
| 2 | 65534* | 127 |
| 4 | 2^32−2* | 32767 |
| 8 | 2^64−2* | 2^31−1 |
| 0 | unlimited | 2^63−1 |

\*One value reserved as the overflow sentinel; shrink thresholds are half the next-smaller width's maximum (the hysteresis band).

## Signed integers and overflow blob format

With `int8/16/32/64array`, signed integers are stored directly via two's complement (Go's native signed types, no zigzag encoding). For BigInt arrays: use `int64array` as the base (−2^63 to 2^63−1 directly), only values outside int64 range need overflow, the sentinel is `math.MinInt64`, and the overflow blob is a sign byte (0 positive, 1 negative) followed by the big-endian magnitude. Values up to ~900 bytes fit a single CASK block; larger values use a full `caskcompactblob` tree.

## Complexity and Merkle impact

| Operation | Typical | With overflow | Width change |
|---|---|---|---|
| Get | O(log n) | O(log n) | N/A |
| Set | O(log n) | O(log n) | O(n) |
| Append | O(log n) | O(log n) | O(n) |
| Remove | O(log n) | O(log n) | O(n) |

Width changes are amortized O(1) thanks to hysteresis (each element can trigger only O(log W) width changes over its lifetime, W = number of width levels). Merkle impact: a single value change modifies O(log n) blocks; a width change modifies O(n / values_per_leaf) blocks, kept rare by hysteresis.

## Alternative and phases

A **pure-overflow mode** skips adaptive width entirely (root links `overflow_hash` = CaskArray of blob hashes, plus a length), trading storage efficiency for simplicity and predictable performance, for use cases where values are expected to be large or highly variable.

Implementation phases, all marked DONE: **Phase 0** signed arrays (`int8/16/32/64array`, two's complement); **Phase 1** fixed-width with overflow (adaptive width int8 → int16/32/64, overflow for beyond-int64, `math.MinIntX` sentinels); **Phase 2** max-heap tracking (indexes ordered by magnitude, coheap O(1) reverse lookup, `Compact()` using an O(1) heap peek, heap fixed on every Set/Append, adaptive index width with the 256/65536/2^32 widen and 127/32767/2^31 hysteresis shrink boundaries); **Phase 3** automatic width adaptation (expand on Set/Append over current width, explicit `Compact()` to shrink, shrink when max magnitude ≤ half the current width's max).

Five open questions remain: heap granularity (exact max vs bucketing by magnitude to reduce churn), lazy rebuilding (defer width changes to a compact operation), compression (run-length / dictionary within leaves for repeated values), sparse overflow (a map instead of a parallel array when few values overflow), and magnitude tracking for signed (absolute magnitude vs signed extremes).

Source: [doc/design/bigint-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/bigint-design.md) at commit `cdb975d8`.
