---
source: doc/design/store-gc-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: A GC'd Store that wraps a backing `cask.Store`, tracks retained roots in a `cask/set` (keyed by a 32-bit projection of each 32-byte hash), and retains only blocks reachable from those roots. Mark follows Links through blocks that successfully Load and treats a failed Load as a normal **missing link** (in-flight, not garbage); sweep deletes only blocks that exist and are unreachable, enumerating stored hashes via a wrapper index, the backing store's List/Scan, or copy-forward. Because large trees are written top-to-bottom, writers must **pin the root when (or before) the root block is stored** and store top-to-bottom, else children can be swept before their root exists. The root set is itself a trie of blocks whose root must be retained — kept outside the collectable store or pinned via a fixed meta root.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [architecture-and-root-set-keying](../sections/cask--store-gc-design--architecture-and-root-set-keying.md) | content-addressed-storage | current |
| [mark-and-sweep](../sections/cask--store-gc-design--mark-and-sweep.md) | content-addressed-storage | current |
| [missing-links-and-insertion-order](../sections/cask--store-gc-design--missing-links-and-insertion-order.md) | content-addressed-storage | current |
| [higher-level-ops-and-root-set-retention](../sections/cask--store-gc-design--higher-level-ops-and-root-set-retention.md) | content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Part of the GC family ingested cycle 4 (`scholar-ingest-cask-3`). This is the elaboration of the pinned-roots regime (`cask--gc-and-retention--pinned-roots-hash-trie`) into a concrete store-wrapper + cask/set + mark/sweep design, with the missing-link / insertion-order discipline added.

Source: [doc/design/store-gc-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/store-gc-design.md) at commit `cdb975d8`.
