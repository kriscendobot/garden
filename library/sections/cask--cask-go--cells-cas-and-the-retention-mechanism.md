---
title: Cell types, CAS, and the cell-as-retention mechanism
source: cask.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: cask.go
source_line_range: "237-320"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The mutable-reference layer in code — CASStore.CAS nonce/old/new semantics, the Cell interface, the load-bearing "a tree is retained while its root is some cell's value" claim, and the cell entry-type capability constants
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

> Abstract: The `CASStore`, `Cell`, and cell-entry-type definitions in `cask.go` are the **code-side statement of CASK's mutable-reference and retention model** (the design-doc framing is `cask-cell-bank` and `cask--cells--*`). `CASStore.CAS(ctx, nonce, address, old, new)` is compare-and-swap over a mutable reference: `nonce` is a **bearer token** authenticating the store identity, `address` selects the reference (the nonce itself = root, else a path into the tree), `old` is the expected value (**zero hash = create-if-absent**), and `new` is the desired value (**zero hash = delete-if-present**); it returns `(success, current, err)` where a nonce-auth failure gives `(false, ZeroHash, err)` and an `old` mismatch gives `(false, current, nil)` to allow retry. A `Cell` is a mutable reference holding one `Hash`, read with `Load` and swapped with `CompareAndSwap`. The **load-bearing retention claim**: *cells are the mechanism by which Merkle trees are retained* — a tree is reachable (not garbage-collected) as long as its root hash is the value of some cell, and updating a cell to a new root **atomically transfers retention** from the old tree to the new one. The entry-type constants split cell access into a capability lattice: `TypeCell`/`TypeCellRead` (the hash is a random cell ID resolved via the caskhead cell table) and `TypeCellPath`/`TypeCellPathRead` (the hash is the content hash of a cell-path descriptor scoping access to a subpath).

**`CASStore`** is a `Store` that supports compare-and-swap on mutable references, used for managing retention roots and other mutable state.

`CAS(ctx, nonce, address, old, new) (success bool, current Hash, err error)`:

- `nonce` — bearer token for authentication (store identity).
- `address` — the reference to modify (`nonce` = root, else a path into the tree).
- `old` — expected current value (**zero hash means create-if-absent**).
- `new` — desired new value (**zero hash means delete-if-present**).
- Returns `success` (true if `old` matched current), `current` (the actual value after the operation — equals `new` on success, equals the previous value on failure, zero if unauthorized), and `err` (non-nil for authorization or other failures).
- If nonce authentication fails: `(false, ZeroHash, error)`. If `old` does not match current: `(false, current, nil)` to allow retry.

`Nonce(ctx) (Hash, error)` returns the store's identity token (ZeroHash if none configured); `Head(ctx) (Hash, error)` returns the current head hash (ZeroHash if unset).

**`Cell`** is a mutable reference that supports compare-and-swap; it holds a single `Hash` value that can be atomically updated. Callers read the current value with `Load`, then attempt to swap it with `CompareAndSwap`; if the value changed since the read, the swap fails and returns the current value so the caller can retry.

> Cells are the mechanism by which Merkle trees are **retained**: a tree is reachable (and therefore not garbage-collected) as long as its root hash is the value of some cell. Updating a cell to point to a new tree root atomically transfers retention from the old tree to the new one.

`Cell` methods: `Load(ctx) (Hash, error)` (ZeroHash if never set); `CompareAndSwap(ctx, old, new_) (swapped bool, current Hash, err error)` returning `(true, new_, nil)` on success and `(false, current, nil)` when `old` did not match.

**Cell entry-type constants** (the capability lattice for cell references, alongside `TypeDir`/`TypeBlob`/`TypeExecBlob`/`TypeCompactBlob`/`TypeExecCompactBlob`):

- `TypeCell` (5) — mutable cell with read + write access; the `Hash` field is a **random cell ID**, not a content address, mapped to a current value via the cell table in caskhead.
- `TypeCellRead` (6) — read-only view of a cell; the `Hash` field is a cell ID, readable but not CAS-able.
- `TypeCellPath` (8) — read + write access scoped to a **subpath**; the `Hash` field is the content hash of a cell-path descriptor.
- `TypeCellPathRead` (9) — read-only access scoped to a subpath; the `Hash` field is the content hash of a cell-path descriptor.

The `IsCell`/`IsCellDirect`/`IsCellIndirect`/`IsCellWritable` predicates partition these: *direct* types (`TypeCell`, `TypeCellRead`) carry a cell ID; *indirect* types (`TypeCellPath`, `TypeCellPathRead`) carry a cell-path-descriptor hash; *writable* types (`TypeCell`, `TypeCellPath`) permit CAS. This is the in-code realization of the read/write/scoped-path capability facets the `cask-cell-facets` and `cask-cell-path-descriptor` design concepts elaborate.

Source: [cask.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/cask.go#L237-L320) at commit `cdb975d8`.
