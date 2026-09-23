---
title: Snapshots and deadlist space reclamation — copy-on-write snapshots, ZFS-style deadlists, birth generations, and the base-snapshot fix for mutable branching
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

Abstract: Because the Bεtree is copy-on-write, a snapshot would be trivial if blocks were never reclaimed (just save the current root once its blocks are synced) — but GEFS snapshots every 5 seconds, so it must reclaim space. It rejects whole-disk garbage collection (HAMMER-style) and reference counting (BTRFS-style) as too expensive, and borrows ZFS's **deadlist** algorithm instead: each block pointer carries a **birth generation**, and blocks freed within a snapshot go on that snapshot's deadlist; when a snapshot is deleted, its deadlist merges into the descendant's and blocks born after the previous snapshot are freed. Deadlists are **sharded by birth generation** so only lists consisting wholly of must-free blocks are scanned. Because GEFS also lets users take *mutable* snapshots off any label — breaking the single-linear-history assumption and risking double frees — each snapshot records a **base** (the first snapshot in its timeline); blocks born before the base are not owned by the snapshot, and their cleanup is left to the base. Snapshots are immutable once taken, referred to by a unique integer id, and labelled with human-readable strings (at most one *mutable* label each).

## Snapshots

Each GEFS snapshot is referred to by a unique integer id and is fully immutable once taken. Snapshots are labelled with a human-readable string; when marked mutable, the labels move to new snapshots as the file system is written to and synced. A snapshot may be referred to by 0 or 1 *mutable* labels, along with as many immutable labels as desired.

If there were no space reclamation, snapshots would be trivial: the tree is copy-on-write, so as long as blocks are never reclaimed it would suffice to save the current root once all its blocks were synced to disk. But because snapshots are taken every 5 seconds, disk space would be used uncomfortably quickly, so reclamation is required.

## Why not GC or refcounting

Several options were considered. **Garbage collection** in the style of HAMMER requires scanning the entire disk to find unreferenced blocks — scheduled performance degradations, and in the limit the bandwidth spent scanning approaches the bandwidth spent on metadata updates. **Reference counting** in the style of BTRFS implies a large number of scattered writes to maintain the counts. Both have significant downsides.

## The deadlist algorithm (from ZFS)

The algorithm is based on using **deadlists** to track blocks that became free within a snapshot. If snapshots are immutable, a block may not be freed as long as a snapshot exists, so block lifetimes are contiguous. When freeing a block there are two cases: either the block was born within the pending snapshot and died within it, or it was born in a previous snapshot and was killed by the pending snapshot.

The crudest implementation would walk the entire tree at deletion time, comparing each block's birth generation against the previous and subsequent snapshots — slow, because it involves full tree walks of multiple snapshots and may walk many blocks that are not freed. GEFS does better by tracking blocks to delete *as they are deleted*: when a block is deleted, if its birth time is newer than the previous snapshot it can be freed immediately; otherwise it goes on the current snapshot's deadlist. When a snapshot is deleted, its deadlist is merged with the next snapshot's deadlist, and all blocks on the deadlist born after the previous snapshot are freed.

One further optimization makes deletions extremely fast: the deadlists are **sharded by birth generation**. When a snapshot is deleted, all its deadlists are appended to the descendant snapshot, and any deadlists with a birth time after the deleted snapshot in the descendant may be reclaimed. With this approach, the only lists that must be scanned are the ones consisting wholly of blocks that must be freed. The disadvantage is that appending to the deadlists may need more random writes, because in the worst case deleted blocks are scattered across many generations — though in practice most bulk deletions touch files written in a small number of generations.

## Mutable snapshots and the base

All of the above assumes a single, linear history of snapshots. But GEFS lets users take **mutable snapshots off of any label**, which breaks the assumption: two different mutable labels may kill the same block, leading to double frees. GEFS handles this by adding a **base** to each snapshot — the first snapshot in a snapshot timeline. Any blocks born before the base are not considered owned by the snapshot, and no record of their demise is made in that snapshot; the cleanup is left to the snapshot that was used as the base.

The information about snapshots, deadlists, and labels is stored in a **separate snapshot tree**, which can never be snapshotted itself. It is also a copy-on-write Bεtree, but one where blocks are reclaimed immediately; it is kept consistent by syncing both the root of the snapshot tree and the freelists at the same time. The snapshot tree stores **snapshot keys** (numeric id → tree root: block pointer, generation, previous snapshot, refcount, height), **label keys** (human-readable string → snapshot id), and **dead keys** (snapshot id + deadlist generation → head/tail pointers of a deadlist).

## Cross-reference (editorial, not in the source)

CASK's snapshot GC (section `cask--gc-concurrent-design--snapshot-gc-with-quarantine`, concept-adjacent `cask--gc-and-retention--*`) solves a related problem — reclaiming content-addressed blocks safely under concurrent mutation — with a **snapshot + mandatory write quarantine** (a CollectorStore with a primary and a quarantine store, mark/sweep against pinned roots). GEFS's deadlist is a *different shape*: instead of mark-and-sweep over a retention graph, it maintains, per snapshot, an explicit list of blocks that died in that snapshot, keyed by birth generation, and reclaims purely by merging lists on snapshot deletion — no whole-disk scan. The two share the goal (reclaim without stopping the world and without corrupting a concurrent reader) but differ in method: CASK quarantines writes during a GC epoch; GEFS defers freeing until snapshot deletion and uses birth-generation bookkeeping so the free set is known without a scan. GEFS's epoch-based reclamation for *reader/writer* safety (in the commit-protocol section) is the closer analogue to CASK's quarantine epochs.

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
