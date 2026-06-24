---
title: Compact vs Table Implementations and Storage Cost
source: doc/design/dir-benchmark.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The two directory implementations actually built and measured, and their storage cost. **Compact (`caskcompactdir`)** packs entries inline in a streaming Merkle tree built with `caskio.Writer`: one link (32 bytes) plus 4 header bytes plus the name length per entry, serialized in sorted order, mutation requiring a full rebuild. This is the v1-lineage format. **Table (`caskdir`)** is a versioned parallel-array table using `caskallocator`, `caskcompactblob` (names), `caskuint16array` (types), `caskarray` (content hashes), and `casksortedindex` (O(log n) lookup by name), supporting incremental Set/Delete without rebuild. This is the v2 table realization. On **storage (block count)**, the table format is 70x-326x larger than compact across 5-1000 entries, because each entry is spread across five separate tree structures, each creating its own block path; compact packs ~27 entries per 1KB block. On **incremental insert cost (new blocks)**, both are O(log n), but the table format produces ~14-17 new blocks regardless of size (five trees + root, each depth O(log n)) versus compact's 1-3 (content-addressing shares all but the affected leaf/branch path).

## Implementations

**Compact (`caskcompactdir`):** entries packed inline in a streaming Merkle tree built with `caskio.Writer`. Each entry is one link (32 bytes) + 4 header bytes + the name. The whole directory is serialized in sorted order; mutation requires a full rebuild.

**Table (`caskdir`):** a versioned parallel-array table using `caskallocator`, `caskcompactblob` for names, `caskuint16array` for types, `caskarray` for content hashes, and `casksortedindex` for O(log n) lookup by name. Supports incremental Set and Delete without rebuilding.

## Storage Size (Block Count)

Measured with `dir/bench_test.go` `TestStorageSize`. Each entry uses a 14-character name and a deterministic 32-byte hash.

| Entries | Compact | Table | Ratio |
|---------|---------|-------|-------|
| 5 | 1 | 70 | 70x |
| 10 | 1 | 140 | 140x |
| 20 | 1 | 280 | 280x |
| 50 | 4 | 740 | 185x |
| 100 | 6 | 1,544 | 257x |
| 200 | 11 | 3,150 | 286x |
| 500 | 26 | 8,478 | 326x |
| 1,000 | 71 | 17,002 | 240x |

The compact format packs roughly 27 entries per 1KB block (32 + 4 + 14 = 50 bytes per entry, ~20 entries per block, plus tree overhead). The table format stores each entry across five separate tree structures (allocator, names, types, hashes, sorted index), each of which creates its own path of blocks.

## Incremental Insert Cost (New Blocks)

Measured with `TestIncrementalBlockCost`: new blocks created by inserting one entry into a directory of size N.

| Entries | Compact | Table |
|---------|---------|-------|
| 5 | 1 | 14 |
| 10 | 1 | 14 |
| 20 | 3 | 14 |
| 50 | 2 | 16 |
| 100 | 2 | 16 |
| 200 | 2 | 16 |
| 500 | 2 | 16 |
| 1,000 | 3 | 17 |

The compact format rebuilds the whole directory but shares most blocks with the previous version through content-addressing (only the final leaf and any affected branch nodes differ). The table format touches a fixed number of tree paths (allocator, names, types, hashes, sorted index, root), each of depth O(log n), producing ~14-17 new blocks regardless of size. Both are O(log n) new blocks per mutation, but the table format has a ~5-8x higher constant factor from maintaining five parallel tree structures.

Source: [doc/design/dir-benchmark.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-benchmark.md) at commit `cdb975d8`.
