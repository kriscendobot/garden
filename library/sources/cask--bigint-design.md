---
source: doc/design/bigint-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: `BigIntArray` — arbitrary-precision integer arrays that adapt storage width to the values actually stored, built on the parallel-arrays pattern. The root links a width-adaptive `values` column, an `overflow` column (CaskArray of compact-blob hashes for values exceeding the width), and a max heap + coheap of indexes ordered by magnitude, plus `length`, `field_width` (1/2/4/8 or 0 for pure-overflow mode), and a signed/unsigned `flags` byte. A fitting value packs inline; an oversized value stores a sentinel in `values` and the real value as an overflow blob at the same index. Width grows on store when a value exceeds the current width and shrinks only below half the smaller width's maximum (hysteresis), with the max heap giving O(1) knowledge of the current maximum so shrink decisions skip an O(n) scan. Signed values use `int8/16/32/64array` two's complement (no zigzag) with a sign-byte + big-endian magnitude overflow format. Get/Set/Append/Remove are O(log n); width changes are O(n) but rare (O(log W) per element lifetime). Implementation phases 0-3 (signed arrays, fixed-width-with-overflow, max-heap tracking, automatic adaptation) are DONE; a pure-overflow mode and five open questions are noted.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [adaptive-width-with-overflow](../sections/cask--bigint-design--adaptive-width-with-overflow.md) | data-structures, content-addressed-storage | current |
| [operations-and-complexity](../sections/cask--bigint-design--operations-and-complexity.md) | data-structures, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-17 by Kris Kowal.
- Ingested cycle 11 (`scholar-ingest-cask-10`) in the array/columnar cluster. A worked instance of [[parallel-arrays-columnar]] with a width-adaptive value column and an overflow tail column; the max heap + coheap is the same in-memory pattern the allocator and sessiontable use ([[swap-to-end-allocation]]). The adaptive index width for heap/coheap reuses [[cask-block-backbones]]'s hashtreetouint* width tiers.

Source: [doc/design/bigint-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/bigint-design.md) at commit `cdb975d8`.
