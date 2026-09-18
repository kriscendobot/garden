---
title: Motivation and design goals — a crash-safe, corruption-detecting, simple, fast snapshotting 9p file system
source: "GEFS: A Good Enough File System (Ori Bernstein)"
source_kind: paper
source_authors: [Ori Bernstein]
source_year: 2023
source_venue: "Plan 9 file-system paper published at orib.dev/gefs.pdf; venue/year inferred as IWP9 2023 (see source-index provenance — the title did not extract from the glyph-encoded PDF)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
topics: [file-systems]
status: current
---

Abstract: GEFS is a file system built for Plan 9 that aims — *in that priority order* — to be crash-safe, corruption-detecting, simple, and fast at snapshotting, by exposing a traditional 9p file-system interface on top of a forest of copy-on-write Bεtrees. It does not try to be optimal on every axis, only "good enough for daily use." The design is a reaction to the existing Plan 9 disk file systems (CWFS, HJFS, fossil), each of which fails at least one of: crash safety, space reclamation when the disk fills, corruption detection, or O(1)/O(log n) directory lookup. GEFS gets crash safety by construction: data and metadata are copied on write with atomic commits, so a crash before the superblocks are updated simply exposes the last synced commit — some recent data may be lost, but no corruption occurs. This is the reference orientation section; the mechanism sections (Bεtree, file-system mapping, snapshots, commit protocol, on-disk format) follow.

## The problems with the existing Plan 9 file systems

Plan 9 has several general-purpose disk file systems, and all of them leave much to be desired. On power loss the file systems may get corrupted. Partial disk failure is not caught by the file system, and reads may silently return incorrect data. They tend to require a large, unshrinkable disk for archival dumps, and behave poorly when the disk fills. Additionally, all of them perform O(n) scans to look up files in directories when walking to a file, which causes poor performance in large directories.

- **CWFS** (the default on 9front) has proven performant and reliable, but is not crash safe. The root file system can be recovered from the dump, but that is inconvenient and can lead to a large amount of lost data. It has no way to reclaim space from the dump, and due to its age carries a lot of historical baggage and complexity.
- **HJFS** (a newer experimental 9front system) is extremely simple — fewer lines of code than any other on-disk option — and does not separate dump storage from cache storage, allowing full use of small disks. However, it is extremely slow, not crash safe, and lacks consistency-check and recovery mechanisms.
- **fossil** (the default on 9legacy) is large and complicated. It uses soft-updates for crash safety, an approach that has worked poorly in practice for the BSD file systems. Bugs can be fixed as they are found, but simplicity requires a rethink of the on-disk data structures. Even after all that complexity, the fossil+venti system provides no way to recover space when the disk fills.

## What GEFS does instead

The data and metadata are copied on write, with atomic commits. This happens by construction, with fewer subtle ordering requirements than soft updates. If the file server crashes before the superblocks are updated, the next mount sees the last commit that was synced to disk — some data may be lost, but no corruption will occur. Because of the use of an indexed data structure, directories do not suffer from O(n) lookups, solving a long-standing performance issue with large directories.

The file system is based around a relatively novel data structure, the **Bεtree** — a write-optimized variant of a B+ tree that plays particularly nicely with copy-on-write semantics, greatly reducing the write amplification seen with traditional copy-on-write B-trees. The reduced write amplification lets GEFS get away with a nearly trivial implementation of snapshotting. As a result of that choice, archival dumps are replaced with **snapshots**, which may be deleted at any time, allowing the data within a snapshot to be reclaimed for reuse. To enable this, each block pointer contains a **birth generation**, and blocks are reclaimed using a **deadlist algorithm inspired by ZFS**. Block pointers also contain a **hash of the data they point at**, so corruption returned by the underlying storage medium — or garbage written by a programmer error — is detected via block hashes and reported early, and the damaged data may then be recovered from backups, RAID restoration, or other means.

The paper's thesis is that by selecting a suitable core data structure, a large amount of complexity elsewhere in the file system falls away: being able to atomically update multiple attributes in the Bεtree, making the core data structure safely traversable without locks, and having a simple, unified set of operations makes everything else simpler.

## Cross-reference (editorial, not in the source)

GEFS occupies the same "durable on-disk structure whose shape buys correctness elsewhere" design space as `kriskowal/cask` (content-addressed 1KB-block Merkle store; topic [[content-addressed-storage]]) and dialog-db's prolly-tree storage, but reaches it from the opposite direction. CASK makes *content hash* the identity of every block and unifies storage, transport, and GC around that; GEFS keeps blocks at fixed **disk locations** and layers a *merkelized* copy-on-write B-tree over them (block pointers carry a hash for corruption detection, not for content addressing or deduplication). The comparison is drawn out in concept [[gefs]] and [[betree]].

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
