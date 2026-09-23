---
title: Batch Operations and Collaborative-Document Example
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: How multiple cell operations compose into one atomic transaction, and a worked sharing example. `BATCH(root_cap, operations) -> (success, new_root_hash)` computes the new state for each operation, builds a single new root hash incorporating all changes, and performs **one CAS on the root hash** — so either all operations succeed or none do (if any individual CAS would fail on an old-hash mismatch, the whole batch fails). This gives transactional updates across multiple cells while preserving the **single-writer property at the root level**. The collaborative-document example shows the facet split in practice: a `doc_cell` whose read cap is shared with readers, write cap with editors, and observe cap with cache servers — readers fetch the current document hash, editors update via CAS (no lost updates), and cache servers get notified on change to invalidate or refresh.

## Batch operations

Multiple cell operations can be composed into an atomic batch:

```
BATCH(root_cap, operations) -> (success, new_root_hash)
```

A batch computes the new state for each operation, builds a new root hash incorporating all changes, performs a single CAS on the root hash, and either all operations succeed or none do. This enables transactional updates across multiple cells while maintaining the single-writer property at the root level.

```
batch operations:
  [
    WRITE(cell_a_write_cap, old_a, new_a),
    WRITE(cell_b_write_cap, old_b, new_b),
    ALLOC(root_cap),
  ]
```

If any individual CAS would fail (old hash mismatch), the entire batch fails and no changes are made.

## Example: collaborative document

```
ROOT
 └─► "cells"
      └─► doc_cell
           ├─► "read"    ──► (shared with readers)
           ├─► "write"   ──► (shared with editors)
           └─► "observe" ──► (shared with cache servers)
```

- Readers can fetch the current document hash.
- Editors can update the document (CAS ensures no lost updates).
- Cache servers get notified on changes, then invalidate/refresh.

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
