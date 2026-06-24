---
title: On-Disk File Formats — blocks, meta, alloc, hashmap, root, nonce, WAL
source: doc/design/dbstore-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The byte-exact on-disk formats of caskdbstore's flat files. **blocks** is fixed 1024-byte records; slot `i` at `[i*1024, (i+1)*1024)`; unused slots zeroed. **meta** is parallel 12-byte records `[height:8, numLinks:1, dataLen:2, reserved:1]` matching `cask.MetadataSize`. **alloc** is a persistent swap-to-end allocator with adaptive integer width (1/2/4/8 bytes), header `[width:1, capacity:W, length:W]` then a `capacity`-element permutation where `entities[0..length)` are allocated and `entities[length..capacity)` are free; allocate returns `entities[length]` and increments length, free swaps the freed index to `entities[length-1]` and decrements. **hashmap** is a persistent open-addressing Robin-Hood table mapping `cask.Hash`→slot at adaptive width, probe key = first 8 bytes of the hash as uint64 BE, grow at >3/4 load and shrink at <1/4 (min 16 buckets), width tracking the allocator. **root** is 32 bytes updated atomically (write `root.tmp`, fsync, rename; readers read without locking). **nonce** is a 32-byte identity token for CAS auth. **journal/\*.wal** entries are 1068 bytes (`hash:32, metadata:12, block:1024`), named `<pid>-<seq>.wal`, appended by any writer and consumed only by the owner.

## blocks

A flat file of fixed-size 1024-byte records. Slot `i` occupies bytes `[i*1024, (i+1)*1024)`. Unused slots contain all zeros.

## meta

A flat file of fixed-size 12-byte records, parallel to `blocks`. Slot `i` occupies bytes `[i*12, (i+1)*12)`. Contains `[height:8, numLinks:1, dataLen:2, reserved:1]` matching `cask.MetadataSize`.

## alloc

A persistent swap-to-end allocator using adaptive integer width, mirroring `caskallocator` but stored as a flat file.

```
Offset  Size     Field
0       1        width (1, 2, 4, or 8 bytes per index)
1       W        capacity (total slots)
1+W     W        length (number of allocated slots)
1+2W    C*W      entities[0..capacity) — the permutation array
```

Total file size: `1 + 2*W + capacity*W` bytes. Invariants: `entities[0..length)` contains the allocated slot indexes; `entities[length..capacity)` contains the free slot indexes; every integer in `[0, capacity)` appears exactly once; width grows when capacity exceeds the current width's max value. Allocation returns `entities[length]` and increments length. Deallocation swaps the freed index to `entities[length-1]` and decrements length.

## hashmap

A persistent open-addressing hash table using Robin Hood linear probing, mapping `cask.Hash` (32 bytes) to slot indexes at adaptive integer width.

```
Offset  Size        Field
0       1           width (1, 2, 4, or 8 bytes per slot value)
1       4           tableSizePow (log2 of table size, uint32 BE)
5       4           count (number of occupied buckets, uint32 BE)
9       T*(32+W)    buckets[0..tableSize)
```

Each bucket is `(32 + W)` bytes: 32 bytes hash key (all zeros = empty bucket) + W bytes slot index. Resize policy: grow (double) when `count > tableSize * 3/4`; shrink (halve) when `count < tableSize * 1/4` and `tableSize > 16`; minimum 16 buckets. Probe key: first 8 bytes of the hash interpreted as uint64 BE, masked to table size. Robin Hood probing ensures low variance in probe chain lengths. The slot width tracks the allocator's width; when the allocator widens, the hash map is rewritten at the new width.

## root

A 32-byte file containing the current root hash. Updated atomically: write to `root.tmp`, fsync, rename to `root`. Readers open and read this file without locking.

## nonce

A 32-byte file containing the store's identity token, generated once on first initialization. Used for CAS authentication.

## journal/*.wal

Write-ahead log files created by any process that wants to stage blocks. Each WAL entry is 1068 bytes:

```
Offset  Size    Field
0       32      hash (SHA-256)
32      12      metadata (height:8, numLinks:1, dataLen:2, reserved:1)
44      1024    block data
```

WAL files are named `<pid>-<seq>.wal` where `pid` is the writer's process ID and `seq` is a monotonic counter. Writers append entries and fsync. The owner process consumes WAL files during consolidation. Multiple writers can create WAL files concurrently without coordination; the owner is the sole consumer.

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
