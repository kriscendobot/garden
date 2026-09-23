---
title: Cell Bank Structure
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: The cell bank is the GC root for all mutable state, built from two `caskmap` maps. The **capability map** maps a 32-byte unguessable bearer token (`cap_token`) to a stable 32-byte cell identifier (`cell_addr`); mapping several tokens to one `cell_addr` is how key rotation works during a migration window. The **cell map** maps `cell_addr` to the current `value_hash`, which roots an immutable tree. The split is what gives a cell a stable identity (the `cell_addr` never changes) that is separable from both its secret authorization (the rotatable `cap_token`) and its current content (the mutable `value_hash`).

## Cell Bank Structure

The cell bank is the GC root for mutable state. It consists of two maps:

```
ROOT
 │
 ├─► capability_map (caskmap)
 │     cap_token (32) ──► cell_addr (32)
 │
 └─► cell_map (caskmap)
       cell_addr (32) ──► value_hash (32)
```

### Capability Map

Maps secret capability tokens to cell addresses.

- **cap_token**: 32-byte unguessable random number. Bearer token for mutation.
- **cell_addr**: 32-byte stable cell identifier.

Supports key rotation by mapping multiple tokens to the same cell_addr during
migration windows. Old and new capabilities temporarily coexist.

### Cell Map

Maps cell addresses to current value hashes.

- **cell_addr**: Stable identifier, doesn't change when content changes.
- **value_hash**: Hash of current cell value (roots an immutable tree).

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
