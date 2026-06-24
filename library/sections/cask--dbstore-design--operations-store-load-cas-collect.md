---
title: Operations — Store, Load, Consolidate, CAS, Collection
source: doc/design/dbstore-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: caskdbstore's five operations. **Store** (any process, lock-free): open/create a WAL file in `journal/`, append the 1068-byte entry, fsync — writers never touch the index or blocks file. **Load** (any process, lock-free): resolve the slot from the index, `pread` 1024 bytes from `blocks` and 12 from `meta`; reads are safe because the data files are append-only between compactions and slots are immutable once written. **Consolidate** (owner only): read each WAL file's entries, skip hashes already indexed, allocate a slot, write block+metadata, add the hash→slot mapping, fsync, delete consumed WALs. **CAS** (owner only): verify the nonce, compare `old` against the in-memory root, on match write the new root via temp+rename and update the in-memory variable, returning `(success, current, err)`; the `address` parameter is reserved for future sub-root CAS. **Collection** (owner only) is a mark-and-sweep that uses the WAL as a quarantine: activate the WAL (route Stores to it), DFS-mark from head into an on-disk `diskHashSet` (never needs to fit in memory), sweep by streaming the flushed hashmap and deleting unmarked blocks, then deactivate the WAL and consolidate — so the consolidated hashmap *is* the snapshot and no mark-set trie blocks pollute the store.

## Store (any process)

1. Open or create a WAL file in `journal/`.
2. Append the 1068-byte entry (hash + metadata + block).
3. Fsync the WAL file.
4. Return success.

Writers do not need the lock. They do not update the index or the blocks file. They only append to their own WAL file.

## Load (any process)

1. Compute the slot from the in-memory index (owner process), or scan the index file (reader process).
2. Read 1024 bytes from `blocks` at offset `slot * 1024`.
3. Read 12 bytes from `meta` at offset `slot * 12`.
4. Return the block and metadata.

Readers do not need the lock. Reads are safe because the blocks and meta files are append-only between compactions; slots, once written, are never modified (content-addressed); and during compaction the owner writes a new blocks/meta file and atomically swaps it in (rename). For non-owner readers needing the index, options are: the owner exposes a Unix domain socket serving Load requests; the index file is memory-mapped and readers use it directly; or readers rebuild their own index on open (expensive but simple). For the initial implementation, the owner process is the sole reader and writer; external access goes through the Unix domain socket.

## Consolidate (owner process only)

1. List WAL files in `journal/`.
2. For each WAL file, read entries sequentially.
3. For each entry: check if the hash is already in the index (skip if so); allocate a new slot (append to blocks and meta files); write the block data and metadata at the new slot offsets; add the hash → slot mapping to the in-memory index.
4. Fsync `blocks` and `meta`.
5. Delete consumed WAL files.

## CAS (owner process only)

```go
CAS(ctx, nonce, address, old, new Hash) (success bool, current Hash, err error)
```

1. Verify `nonce` matches the store's nonce. If not, return error.
2. Read the current root hash from the in-memory root variable.
3. If `old` != current root, return `(false, current, nil)`.
4. Write `new` to `root.tmp`, fsync, rename to `root`.
5. Update the in-memory root variable.
6. Return `(true, new, nil)`.

The `address` parameter is reserved for future use (sub-root CAS). For now, CAS only operates on the single root.

## Collection (owner process only)

GC is a mark-and-sweep using the WAL as a quarantine:

1. **Activate WAL**: Route all `Store()` calls to a WAL file.
2. **Mark**: DFS walk from head. Record each reachable hash in a temporary on-disk hash set (`diskHashSet` in `gc-scratch/`). The mark set never needs to fit in process memory.
3. **Sweep**: Flush the hashmap to disk, then stream it via `forEachKeyFromFile`. For each hash not in the mark set, write it to a delete list. Then walk the delete list and remove each block (free slot in allocator, remove from hashmap).
4. **Deactivate WAL**: Close the WAL writer and consolidate all WAL entries into the main store. Delete `gc-scratch/`.

The WAL quarantine ensures blocks written during GC are invisible to the sweep and are consolidated afterward. No snapshot file is needed — the consolidated hashmap is the snapshot. No mark-set trie blocks pollute the main store. Compaction (optional, deferred): write a new blocks/meta file containing only live slots, rebuild the index, atomically swap the new files in.

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
