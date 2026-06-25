---
source: doc/design/sorted-array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: `sortedarray` (status PLANNED) — a persistent sorted array that uses content-defined chunking (Rabin fingerprinting) to localize Merkle-tree changes during insert and delete, getting B-tree query performance without the rebalance cascades a B-tree pays in a content-addressed store. The root links a `chunks_tree` (an `arraytree` of chunk hashes) and stores entry/key/chunk parameters; each chunk is a sorted run of fixed-size entries, and a Rabin boundary (content-defined, with min/max guards) gives the **stability property**: only the chunk around an edit re-chunks while distant chunks keep their hashes. Queries binary-search the tree then the chunk; mutations re-chunk locally; bulk edits reuse the caskarray Keep/Skip/Inject transform. The design picks **direct-to-store** mutation (Option B) over an in-memory buffer for syncability and reducer-pattern fit, and adds a wire protocol, **SDIF/SOPS** (Layer 2), that reconciles two peers' arrays by exchanging a minimal op-sequence diff — walking both chunk trees in parallel and loading only chunks whose hashes differ — with full/range/chunk diff modes, inspect-before-apply conflict handling, partial sync by key range, and Raft coexistence. Use cases: membership tables, pinned-root hash sets, and event-log indexes.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [rabin-chunked-structure-and-stability](../sections/cask--sorted-array-design--rabin-chunked-structure-and-stability.md) | data-structures, content-addressed-storage | current |
| [operations-transform-and-use-cases](../sections/cask--sorted-array-design--operations-transform-and-use-cases.md) | data-structures, content-addressed-storage | current |
| [sdif-sops-diff-sync-protocol](../sections/cask--sorted-array-design--sdif-sops-diff-sync-protocol.md) | data-structures, content-addressed-storage, networking | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-17 by Kris Kowal.
- Ingested cycle 11 (`scholar-ingest-cask-10`) in the array/columnar cluster. The Rabin-chunked structure is the standalone, fully-specified sibling of the inline Rabin-bounded sorted index sketched in `cask--parallel-arrays--rabin-bounded-sorted-indexes` and the caskdir v2 entries tree (`cask--dir-design-v2--goals-and-rabin-chunked-entries-tree`); all three are captured by [[rabin-chunking]]. Its transform is [[cask-operational-transform]] and its SDIF/SOPS sync is the wire form of that op stream. Implementation remains PLANNED as of the recorded commit.

Source: [doc/design/sorted-array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/sorted-array-design.md) at commit `cdb975d8`.
