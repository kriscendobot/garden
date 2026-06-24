---
title: Implementation Plan, Slot Allocation, Root Atomicity, Sizing, and Comparison
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

> Abstract: caskdbstore's four-phase rollout and its physical-storage specifics. **Phase 1 (implemented)**: single-process owner store, no WAL or socket, blocks written directly, persistent on-disk alloc + hashmap indexes; sufficient for tests, a single-process server, and CLI tools. **Phase 2 (implemented)**: WAL-based staging used during GC — when GC is active `Store()` routes to a WAL, providing a natural quarantine, and the GC exploits the WAL as an epoch boundary so it needs no snapshot files, no mark-set trie blocks in the store, no salted-hashing multi-pass convergence, and no temporary delete-list files; the `diskHashSet` is a file-backed Robin-Hood hash set that never loads its full table into memory. **Phase 3**: a Unix-domain-socket server on `.cask/cask.sock` serving Store/Load/CAS. **Phase 4**: periodic compaction to reclaim freed slots. Slot allocation uses the swap-to-end `alloc` file (rebuildable from `meta` if lost); root atomicity is write-temp-then-rename. Sizing at 1024+12 bytes/block: 1M blocks ≈ 1 GB blocks + 12 MB meta + ~4 MB alloc + ~48 MB hashmap (~64 bytes overhead/block). Versus diskstore: 6 fixed files instead of 2N, pread-at-offset instead of open+ReadAll, flock+WAL concurrency, persistent hash-table index, built-in GC and CAS, at the cost of loading alloc+hashmap at startup.

## Phase 1: Single-Process Store (Implemented)

A `cask.CASStore` where the caller is the owner. No WAL, no Unix socket. Blocks go directly into the blocks/meta files. Indexes are persistent on disk via the alloc and hashmap files. Sufficient for testing, a single-process server, and CLI tools that open the store, perform operations, and close it.

```go
type Store struct {
    dir     string
    blocksF *os.File       // blocks file, open for read/write
    metaF   *os.File       // meta file, open for read/write
    lockF   *os.File       // lock file, held with flock
    alloc   *allocFile     // persistent swap-to-end allocator
    hashmap *hashmapFile   // persistent hash → slot table
    root    cask.Hash      // current root hash
    nonce   cask.Hash      // store identity
    mu      sync.RWMutex   // protects in-memory state
}
```

Interface: `Store`, `Load`, `CAS`, `Nonce`, `Head`, `List`, `Delete`, `Sync`, `Close`.

## Phase 2: WAL-Based Staging (Implemented)

The journal directory and WAL-based staging are used during garbage collection. When GC is active, `Store()` calls are routed to a WAL file instead of the main store — a natural quarantine: blocks written during GC are invisible to the sweep (which only sees the consolidated hashmap), and after the sweep the WAL is consolidated back into the main store. The WAL also enables future multi-process writes.

**GC with WAL** exploits the WAL as an epoch boundary: (1) **Activate WAL** — route Stores to a WAL; (2) **Mark** — DFS from head through the consolidated store, recording each visited hash in an on-disk `diskHashSet` so the mark set never needs to fit in memory; (3) **Sweep** — stream the main hashmap from disk and delete each hash not in the mark set; (4) **Deactivate WAL** — close the writer and consolidate WAL entries back. This eliminates the need for snapshot files (the consolidated hashmap *is* the snapshot), mark-set trie blocks in the main store (no pollution), salted hashing / multi-pass convergence (exact mark set), and temporary delete-list files (deletes happen directly).

**diskHashSet**: a file-backed open-addressing hash set for `cask.Hash` keys that, unlike `hashmapFile`, never loads the full table into memory — all `Has`/`Put` operations go directly to disk via `ReadAt`/`WriteAt`. Layout: `[tableSizePow:4, count:4, buckets:T*32]`. Robin Hood linear probing; resizes by streaming the old file into a double-size new file; created in `gc-scratch/` and deleted after GC.

## Phase 3: Unix Domain Socket Server

The owner listens on `.cask/cask.sock` and serves Store requests (consolidate immediately or batch), Load requests (serve from index), and CAS requests (serialize through owner).

## Phase 4: Compaction

Periodic compaction to reclaim space from freed slots by rewriting the blocks and meta files.

## Slot Allocation

Slot allocation uses the persistent `alloc` file (swap-to-end pattern): **Allocate** returns `entities[length]` and increments length (grow by appending if `length == capacity`); **Free** swaps the freed slot to `entities[length-1]` and decrements length. Both update the alloc file in place. The alloc file is the authoritative source of truth for which slots are allocated; if lost or corrupt, it can be rebuilt from the meta file (scan for non-zero metadata = allocated, zero = free).

## Root Atomicity

The root file is updated via write-to-temp-then-rename:

```go
func (s *Store) writeRoot(h cask.Hash) error {
    tmp := filepath.Join(s.dir, "root.tmp")
    if err := os.WriteFile(tmp, h[:], 0644); err != nil { return err }
    if err := fsyncFile(tmp); err != nil { return err }
    return os.Rename(tmp, filepath.Join(s.dir, "root"))
}
```

This ensures readers always see either the old or the new root, never a partial write.

## Sizing

At 1024 bytes per block + 12 bytes per metadata: 1 million blocks = ~1 GB blocks file + ~12 MB meta file; alloc file ~4 MB (1M slots × 4-byte width + 9-byte header); hashmap file ~48 MB (~1.33M buckets at load factor 0.75 × 36 bytes); total overhead per block ~64 bytes (alloc + hashmap + meta), vs 40 bytes for an in-memory map; WAL entry (Phase 2) 1068 bytes, so a 1000-entry WAL file ≈ 1 MB.

## Comparison with diskstore

| Aspect | diskstore | dbstore |
|--------|-----------|---------|
| Files per block | 2 (block + .meta) | 0 (shared files) |
| Total files | 2N | 6 fixed |
| Open for read | Open + ReadAll | pread at offset |
| Concurrency | File-level rename atomicity | flock + WAL |
| Index | Directory listing | Persistent hash table |
| GC | External (CollectibleStore) | Built-in mark-sweep |
| CAS | Not supported | Built-in |
| Startup cost | None (lazy) | Load alloc + hashmap files |

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
