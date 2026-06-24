---
source: doc/design/gc-concurrent-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: A concurrency-safe garbage collector for single-root CASK stores that tolerates atomic root swaps mid-GC. It takes one root snapshot `Rs` at GC start, marks everything reachable from `Rs`, sweeps the rest, and flushes a **mandatory quarantine** (all writes during GC go to a quarantine store, flushed only after the sweep) so a post-snapshot block is never swept. Safety rests on seven invariants — root atomicity, install-after-store, snapshot GC safety, operation stability, epoch monotonicity, link integrity, quarantine visibility — and the `CollectorStore` wrapper (primary + quarantine, e.g. diskstore + memstore). GC passes are mutually exclusive and idempotent via a shared completion channel; the idiomatic-Go API is `Collect(ctx, root) <-chan struct{}`. A test plan validates the invariants across blob, dir, and array structures.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [snapshot-gc-with-quarantine](../sections/cask--gc-concurrent-design--snapshot-gc-with-quarantine.md) | content-addressed-storage | current |
| [concurrency-invariants-and-root-swaps](../sections/cask--gc-concurrent-design--concurrency-invariants-and-root-swaps.md) | content-addressed-storage | current |
| [proposed-tests](../sections/cask--gc-concurrent-design--proposed-tests.md) | content-addressed-storage, testing | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Part of the GC family ingested cycle 4 (`scholar-ingest-cask-3`). The `CollectorStore`/quarantine pattern here is the in-memory-quarantine sibling of the WAL-quarantine GC in `cask--dbstore-design--operations-store-load-cas-collect`. Both are captured by the [[gc-quarantine-store]] concept.

Source: [doc/design/gc-concurrent-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-concurrent-design.md) at commit `cdb975d8`.
