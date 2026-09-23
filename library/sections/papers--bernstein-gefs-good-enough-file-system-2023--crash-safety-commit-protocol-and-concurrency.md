---
title: Crash safety, the multi-phase snapshot commit protocol, arena allocation, and epoch-based reclamation for lock-free reads
source: "GEFS: A Good Enough File System (Ori Bernstein)"
source_kind: paper
source_authors: [Ori Bernstein]
source_year: 2023
source_venue: "Plan 9 file-system paper (orib.dev/gefs.pdf; IWP9 2023 inferred)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
topics: [file-systems]
status: current
---

Abstract: GEFS gets crash safety by construction from copy-on-write plus a carefully phased **snapshot commit protocol**: copy-on-write is necessary but not sufficient once blocks are reused, because a block allocated before a sync must not be freed until the next sync completes. Corruption from bad media or programmer error is caught because block pointers carry a hash of what they point at. The commit protocol runs asynchronous phases separated by **barriers** — update the snap tree, prepare arenas/superblocks with a per-arena allocation-log generation entry, commit arena headers, commit the superblock (the write that actually commits the new snapshots), commit arena footers (headers and footers back each other up as a two-phase commit), wait for durability, then clean up deadlists. A crash at any phase either leaves the last superblock's reachable data untouched or falls back cleanly between arena headers and footers; the only bad outcome is a leaked-space window, never corruption. Blocks are allocated from **arenas** via an in-memory AVL tree replayed from an on-disk allocation log, round-robined by block type for sequentiality. GEFS runs as **seven proc types** with unidirectional dataflow, and uses **epoch-based reclamation** so writers and readers never block each other.

## Crash safety and corruption detection

To achieve crash safety without a great deal of complexity, copy-on-write is important but not sufficient. If blocks were never freed, a copy-on-write data structure would be naturally crash safe; with block reuse, additional care is needed. A block allocated before a sync must not be freed until the next sync has completed, because the previous sync may still refer to it, and overwriting it may have unpleasant effects. As a result the snap tree has a **deadlist** for blocks freed within a snapshot; every free within a snapshot goes there, and after a snapshot is taken the deadlist is cleaned up. The freeing becomes durable only after the commit being synced, so shutdown must iterate commits until no more deadlists are freed.

Corruption is detected because block pointers contain a hash of the data they point at: if the underlying medium returns corrupted data, or a programmer error writes garbage to disk, it is caught (often early), reported, and the damaged data may then be recovered from backups, RAID restoration, or other means.

## The snapshot commit protocol (phases)

1. A **barrier** is inserted to guarantee that all in-flight writes land before the snap updates. Then the snap tree is updated to point to the most recent version of the dirty mutable snaps.
2. Once the snapshots are updated, the contents of the arenas and superblocks are known and prepared in memory for syncing. A generation entry is inserted into the allocation log for each arena, so that if we crash before the superblock reaches disk, log replay will discard operations from after the commit. Tree mutation may resume at this point.
3. The arena headers prepared earlier are committed, and a barrier is inserted after they are synced.
4. The superblock prepared earlier is enqueued — this is the write that commits the updated snapshots. If we crash after the superblock is flushed, the arena footers will not match the superblock, and the arena headers will be used. A barrier is inserted after the superblock is enqueued.
5. After the superblock is enqueued, the arena footers are enqueued. This is the two-phase commit that lets arena headers and footers act as backups of each other.
6. Once all data is enqueued, we wait for everything in flight to hit disk; then everything is known committed and the snapshot is up to date. The only remaining work is to reclaim space.
7. Finally, once the commit is known durable, the deadlists are cleaned up and the space is made reusable; the freed blocks become durable on disk at the next commit.

All operations in the protocol are handled asynchronously; the only requirement for a consistent view is that the barriers are respected, up until the last stage where blocks crossing a sync boundary are freed — so the sync is lightweight. Reasoning about crashes: a crash during phases 1–3 leaves any data reachable from the superblock untouched, so previous commits are sound. Phase 3 is the first to modify data reachable from the superblock: if we crash there, the arena-header pointers in the superblock will not match the on-disk headers and GEFS refuses to load them, falling back to the not-yet-modified arena footers; the converse holds once step 4 completes (headers match, footers do not). Between phases 4 and 7 there is a window where the inter-commit deadlists are emptied but not yet processed — a crash there **corrupts no data but leaks space**.

## Block allocation and arenas

Blocks are allocated from **arenas**. Within an arena, allocations are stored in a linked list of blocks read at initialization; the blocks contain a **journal of free/allocate operations**. On startup GEFS replays this log, storing the available regions in an in-memory **AVL tree**; as it runs it appends to the free-space log and occasionally compresses it, collapsing adjacent free/used blocks into larger regions. Because copy-on-write makes metadata blocks get allocated and deallocated rapidly, and drives (even SSDs) care about sequential access, GEFS makes a best-effort attempt to keep data sequential: it selects the arena via **round robin, offset by block type**. If the round-robin counter is 10 and there are 7 arenas, data blocks (type 0) come from arena 3 `((10+0)%7)`, pivot blocks (type 1) from arena 4, leaf blocks (type 2) from arena 5. The counter is incremented every few thousand block writes to balance writes across arenas; if an arena is full, GEFS simply advances to the next.

## Process structure and epoch-based reclamation

GEFS is implemented in a multiprocess manner, with seven proc types: **cons, task, srv (dispatch), sweeper, mutator, reader, syncer**. Reader, syncer, and dispatch procs may be replicated freely; there may be only one mutator, sweeper, task, or cons proc at a time. A dispatch proc dispatches 9p messages to the appropriate worker: read-only messages to one of multiple readers, write messages to the mutator, which modifies the in-memory representation and sends dirty blocks to the syncers, whose job is simply to write blocks back to disk asynchronously. The admin/task proc processes ctl messages and handles syncing; long-running operations (e.g. removing very large files, which inserts many messages) are split off to the sweeper so they do not block other writers. Because the tree is shared, sweeper and mutator do not work in parallel — they hold the mutator lock. Dataflow is unidirectional, and any block that has made it out of the mutating processes is immutable, which makes consistency easy to reason about.

Because the file system is copy-on-write, as long as blocks are not reclaimed while a reader is accessing the tree, writes need not block reads. But if a block is freed within the same snapshot, a naive implementation would let a reader observe a corrupt block, so block reclamation must be deferred until all readers are done. The mechanism is **epoch-based reclamation**: when a proc starts operating on the tree, it enters an epoch by atomically taking the current global epoch and setting its local epoch, with an active bit set. As the mutator frees blocks, instead of making them reusable immediately, it puts them on the **limbo list** for its current generation. When a proc finishes, it clears the active bit; when the mutator leaves the current epoch it also attempts to advance the global epoch, looping over all worker epochs to check whether any are active in an old epoch — if the old epoch is empty, it is safe to advance and clear the old epoch's limbo list. If the old epoch is not empty, cleanup is deferred; if a reader stalls for a very long time this can accumulate garbage, so GEFS applies **back pressure to writers** when the limbo list gets too large. This lets GEFS avoid contention between reads and writes with no locking between them beyond what the 9p implementation requires (there is still contention on the FID table, block cache, and other in-memory structures).

## Cross-reference (editorial, not in the source)

The epoch-based reclamation here is the direct analogue of CASK's concurrent snapshot GC (`cask--gc-concurrent-design--concurrency-invariants-and-root-swaps`): both defer freeing a block until no reader can still observe it, GEFS via global-epoch limbo lists, CASK via a snapshot + quarantine with a set of concurrency invariants. The two-phase arena header/footer commit and the "superblock write is the commit point" discipline are a file-system-level echo of the atomic-root-swap idea CASK uses (a single CAS on the root hash makes a batch of mutations visible atomically — `cask--ocaps--batch-operations-and-example`). GEFS reaches durability with barriers and paired header/footer backups rather than a WAL-as-quarantine (`cask--dbstore-design--operations-store-load-cas-collect`), but the invariant is the same: never expose a root that points at data not yet durable.

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
