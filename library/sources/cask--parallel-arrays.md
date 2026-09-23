---
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 6
status: current
---

> Abstract: CASK's deepest single design document, on the **parallel-arrays** pattern that runs through the codebase. It develops the pattern from in-memory buffers (typed value columns, index arrays, co-index arrays; values stay in place while indexes move; swap-to-end allocation; heap and linked-list indexes) into persistent CASK structures expressed as **reducers** `(state_hash, args) → new_state_hash` that minimize Merkle-tree disturbance (CaskHeap, CaskAllocator, CaskIndexedHeap, CaskLinkedList over 32-way tries). It then covers compact adaptive-width index storage with hysteresis and positional-link table roots; a schema-hash self-description scheme and a CASK IDL that unifies directories and blobs under one adaptive `TreeNode`; the table IDL and JSON-like data model with `inline`/`ref`/`auto` references and auto-reindexing on field updates; and a Rabin-bounded sorted-index design that gets B-tree query performance without rebalancing by reusing content-defined chunking. This is the canonical source for the columnar/ECS pattern the README only sketches.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [in-memory-pattern](../sections/cask--parallel-arrays--in-memory-pattern.md) | data-structures | current |
| [persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | data-structures, content-addressed-storage | current |
| [compact-index-representation](../sections/cask--parallel-arrays--compact-index-representation.md) | data-structures, content-addressed-storage | current |
| [universal-tree-and-schema-hashes](../sections/cask--parallel-arrays--universal-tree-and-schema-hashes.md) | content-addressed-storage, data-structures | current |
| [table-idl-and-data-model](../sections/cask--parallel-arrays--table-idl-and-data-model.md) | data-structures | current |
| [rabin-bounded-sorted-indexes](../sections/cask--parallel-arrays--rabin-bounded-sorted-indexes.md) | data-structures, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- This document is the in-depth treatment of the `columnar-ecs-design` material the cask README summarizes; the README's `cask--readme--columnar-ecs-design` section is a reference-shaped summary, and these six sections are the background-shaped detail. The two are cross-referenced, not contradictory (soft overlap per `conventions.md`).

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
