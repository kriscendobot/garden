---
source: doc/design/dbstore-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: `caskdbstore` — a `cask.CASStore` that keeps all blocks in a small fixed set of flat files under `.cask/` (blocks, parallel meta, swap-to-end alloc, Robin-Hood hashmap, root, nonce, plus a WAL journal), reusing CASK's own content-addressed indexing on disk. It supports atomic root CAS, lock-free `pread` readers, lock-free WAL-appending writers, and a single flock-holding owner that consolidates WALs, serializes CAS, and runs a mark-and-sweep GC that uses the WAL as a quarantine and an on-disk `diskHashSet` mark set (so neither needs to fit in memory and no mark-set blocks pollute the store). Phases 1–2 (single-process store + WAL staging/GC) are implemented; phases 3–4 (Unix-socket server, compaction) are planned. Compared with diskstore: 6 fixed files vs 2N, pread-at-offset vs open+ReadAll, built-in GC and CAS, at the cost of a persistent index loaded at startup.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [goals-and-directory-layout](../sections/cask--dbstore-design--goals-and-directory-layout.md) | content-addressed-storage | current |
| [on-disk-file-formats](../sections/cask--dbstore-design--on-disk-file-formats.md) | content-addressed-storage, data-structures | current |
| [operations-store-load-cas-collect](../sections/cask--dbstore-design--operations-store-load-cas-collect.md) | content-addressed-storage | current |
| [concurrency-model-and-lock-protocol](../sections/cask--dbstore-design--concurrency-model-and-lock-protocol.md) | content-addressed-storage | current |
| [implementation-plan-and-sizing](../sections/cask--dbstore-design--implementation-plan-and-sizing.md) | content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Ingested cycle 4 (`scholar-ingest-cask-3`) alongside the GC family. The persistent `alloc` file is the on-disk form of [[swap-to-end-allocation]]; the WAL-quarantine GC is the on-disk sibling of the in-memory `CollectorStore` quarantine in `cask--gc-concurrent-design--snapshot-gc-with-quarantine` (both captured by [[gc-quarantine-store]]).

Source: [doc/design/dbstore-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dbstore-design.md) at commit `cdb975d8`.
