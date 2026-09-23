---
title: Cell References, Retention, and Snapshot Consistency
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

Abstract: A cell reference embedded in an immutable tree is a **weak** reference to a cell in the cell bank: the tree captures the structure (including the reference) but not the cell's current value. Locally a reference is just the 32-byte `cell_addr`; the distributed form (once cryptography lands) expands to `cell_addr` (the unguessable swiss number) plus `owner_pubkey` (the owning peer's ed25519 key) plus routing hints, consistent with CapTP/OCapN. The retention rule is the key asymmetry: the cell bank strongly retains each cell's value tree (it is the local GC root), but a tree's `cell_ref` does **not** retain a remote cell, so resolution can fail and cells are not transferrable across peers. Because the hash captures only shape, two snapshots with identical structure but different cell contents share a root hash; fully resolving a tree means chasing static hash links **and** performing dynamic cell lookups.

## Cell References in Trees

A cell reference in an immutable tree is a weak reference to a cell in the cell
bank. The tree captures the *structure* including cell references, but not their
current values.

### Simplified (Local-Only)

For now, cell references contain only the cell address:

```
cell_ref {
    cell_addr: 32 bytes  // lookup key into cell_map
}
```

### Future (Distributed)

When cryptography is in place (see CRYPTOGRAPHY.md), cell references expand to
include owner identity and routing hints, consistent with CapTP/OCapN:

```
cell_ref {
    cell_addr:    32 bytes  // unguessable random number (swiss number)
    owner_pubkey: 32 bytes  // ed25519 public key of owning peer
    hints:        variable  // connection/routing info
}
```

The cell_addr is the swiss number (unguessable, unforgeable).
The owner_pubkey identifies the vat/peer. Hints provide location/routing info.

## Retention Model

```
CELL BANK (strong refs, local authority, GC root)
    │
    │ cell.value_hash
    ▼
IMMUTABLE TREE (strong refs via hash links)
    │
    │ cell_ref (weak, cross-peer)
    ╳ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ▶ REMOTE CELL BANK
                              (different peer)
```

- **Cell bank retains cells' value trees** (strong, local GC root)
- **Tree cell_refs don't retain remote cells** (weak, advisory)
- **Remote cells may be gone**; resolution can fail
- **Cells are not transferrable**; bound to the owning peer

## Snapshot Consistency

Two snapshots with identical structure but different cell contents have the same
root hash. The hash captures the shape; cell lookups provide current content.

To fully resolve a tree:
1. Chase hash links (static, immutable)
2. Perform cell lookups (dynamic, mutable)

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
