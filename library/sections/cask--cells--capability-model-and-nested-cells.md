---
title: Capability Model and Nested Cells
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: Cell capabilities are unguessable 32-byte values; whoever generates them controls the namespace, and a NONCE-as-bearer-token pattern guards allocation. Allocation is hierarchical (a tree of authority): the parent capability holder allocates new cells, mutation requires the capability, and reading may be open or gated. The three operations are `ALLOC(parent_cap) -> (cell_cap, cell_addr)`, `WRITE(cell_cap, cell_addr, value_hash)`, and `READ(cell_addr) -> value_hash`. Key rotation runs entirely through the capability map: generate a new token, map both old and new to the same `cell_addr`, migrate clients, then drop the old token (the `cell_addr` stays stable throughout). Because a cell's `value_hash` can root a tree that contains further cell references, cells nest recursively (`cell A → tree → cell B → tree → cell C → ...`); each cell is independently mutable, so updating an inner cell does not change an outer cell's `value_hash` unless the outer tree is rebuilt.

## Capability Model

### Allocation

Capabilities are unguessable 32-byte values. Whoever generates them controls the
namespace. The NONCE-as-bearer-token pattern guards allocation.

- Parent capability holder allocates new cells
- Allocation is hierarchical (tree of authority)
- Mutation requires capability
- Reading may be open or gated (TBD)

### Operations

```
ALLOC(parent_cap) -> (cell_cap, cell_addr)
    Parent capability holder allocates a new cell.
    Returns capability to mutate and address to read.

WRITE(cell_cap, cell_addr, value_hash) -> error
    Write new value to cell. Capability is authorization.

READ(cell_addr) -> value_hash
    Read current value. May require read capability (TBD).
```

### Key Rotation

Handled by the capability_map:

1. Generate new cap_token
2. Map both old and new tokens to same cell_addr
3. Migrate clients to new token
4. Remove old token mapping

During migration, both tokens work. The cell_addr remains stable.

## Nested Cells

A cell's value_hash can root a tree that contains more cell references. This
gives recursive mutable structure:

```
cell A ──► tree ──► cell B ──► tree ──► cell C ──► ...
```

Each cell is independently mutable. Updating cell C doesn't affect cell A's
value_hash (unless A's tree is rebuilt to point to a new snapshot).

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
