---
title: Speed Benchmarks
source: doc/design/dir-benchmark.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: Wall-clock benchmarks (ns/op, Intel Core i9-9880H) for the compact and table directory formats across four operations. The headline: the table format is slower at every tested size, dramatically so for build-from-scratch. **Build from scratch** is 228x slower at 5 entries growing to 69,999x slower at 1,000 (compact is O(n log n) sort + O(n) serialize; the table does O(n) Sets each O(log n) across five trees, growing super-linearly as the trees deepen). **Single insert** is 88x-159x slower (compact rebuilds in a tiny memcpy-like O(n) pass; each table Set does O(log n) tree ops but every op pays SHA-256 hashing + block marshalling + store round-trips). **Single delete** is 40x-60x slower (smaller gap because delete avoids some allocation/name-storage overhead). **List all** is 41x-187x slower (compact reads sequential blocks and decodes inline; the table does four separate tree lookups per entry: sorted index, then name, type, hash). The per-operation constant factor (~50 microseconds per tree op) dominates at all tested sizes.

## Build from Scratch (ns/op)

| Entries | Compact | Table | Ratio |
|---------|---------|-------|-------|
| 5 | 2,460 | 560,481 | 228x |
| 10 | 3,618 | 1,718,169 | 475x |
| 20 | 6,090 | 6,079,244 | 998x |
| 50 | 15,702 | 40,209,303 | 2,561x |
| 100 | 28,266 | 190,668,165 | 6,746x |
| 200 | 56,783 | 797,912,916 | 14,052x |
| 500 | 152,528 | 5,151,082,349 | 33,771x |
| 1,000 | 308,862 | 21,620,239,229 | 69,999x |

Compact is O(n log n) sort + O(n) serialize. The table is O(n) Sets, each O(log n) tree ops across five structures with high constant factors; build cost grows super-linearly because each successive Set traverses increasingly deep trees.

## Single Insert into Existing Directory (ns/op)

| Entries | Compact | Table | Ratio |
|---------|---------|-------|-------|
| 5 | 2,310 | 229,073 | 99x |
| 10 | 3,340 | 459,604 | 138x |
| 20 | 6,785 | 596,557 | 88x |
| 50 | 16,405 | 2,087,376 | 127x |
| 100 | 29,813 | 4,729,076 | 159x |
| 200 | 61,005 | 9,486,969 | 156x |
| 500 | 146,645 | 23,139,799 | 158x |
| 1,000 | 306,453 | 46,831,264 | 153x |

Compact rebuilds the entire directory (O(n)) but with a tiny constant factor (a single memcpy-like pass over sorted entries). The table does O(log n) tree ops per Set, but each involves SHA-256 hashing, block marshalling, and store round-trips; the per-operation overhead dominates.

## Single Delete from Existing Directory (ns/op)

| Entries | Compact | Table | Ratio |
|---------|---------|-------|-------|
| 5 | 2,076 | 95,098 | 46x |
| 10 | 3,493 | 139,056 | 40x |
| 20 | 5,942 | 238,319 | 40x |
| 50 | 16,470 | 682,122 | 41x |
| 100 | 31,828 | 1,607,540 | 50x |
| 200 | 59,709 | 2,994,270 | 50x |
| 500 | 145,985 | 7,701,378 | 53x |
| 1,000 | 325,646 | 19,456,296 | 60x |

The table delete benchmark includes a Set + Delete pair (re-insert then delete) to measure a repeatable delete. The 40-60x gap is smaller than insert because the delete path avoids some allocation and name-storage overhead.

## List All Entries (ns/op)

| Entries | Compact | Table | Ratio |
|---------|---------|-------|-------|
| 5 | 635 | 25,918 | 41x |
| 10 | 745 | 58,695 | 79x |
| 20 | 804 | 115,616 | 144x |
| 50 | 2,694 | 413,167 | 153x |
| 100 | 4,982 | 839,083 | 168x |
| 200 | 8,751 | 1,504,429 | 172x |
| 500 | 20,292 | 3,516,630 | 173x |
| 1,000 | 47,337 | 8,846,222 | 187x |

Compact reads sequential blocks and decodes inline entries. The table must traverse the sorted index, then for each entry load the name from a compactblob, the type from a uint16array, and the hash from an array: four separate tree lookups per entry.

Source: [doc/design/dir-benchmark.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-benchmark.md) at commit `cdb975d8`.
