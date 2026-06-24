---
title: hashtree vs arraytree (Block Backbones)
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: The two internal tree backbones that every CASK block structure builds on. **`hashtree`** is a sparse, associative 32-way trie of fixed 4-level depth (20 bits of key space via 5 bits × 4 levels), keyed by arbitrary 32-bit hash values; most slots hold `ZeroHash`, it supports deletion with automatic node collapsing, and it backs the unpredictable-key structures `map` and `set`. **`arraytree`** is a dense, sequential 32-way tree of variable depth that grows with array length, keyed by contiguous indexes 0,1,2,…; leaves are fully packed, there is no deletion (append-only, set-in-place), and it backs `array` and the `uint*array`/`int*array` packages. The two differ in leaf storage and digit-extraction order: `array` stores hashes as Links in `cask.Model` nodes with little-endian length and LSB-first digits (`LoadRootLE`/`DigitLSB`); `uint*array` stores packed integer bytes in `cask.Block` leaves with big-endian length and MSB-first digits (`LoadRoot`/`Digit`), the latter preserved for backwards compatibility.

## hashtree (sparse, associative)

- Fixed 4-level depth (20 bits of key space via 5 bits × 4 levels).
- Keys are **arbitrary 32-bit hash values**.
- Sparse: most slots contain `ZeroHash`.
- Supports deletion with automatic node collapsing.
- Used for **associative** structures where keys are unpredictable (`map`, `set`).

## arraytree (dense, sequential)

- Variable depth that grows with array length.
- Keys are **sequential indexes** (0, 1, 2, …).
- Dense: leaves are fully packed up to the array length.
- No deletion support (append-only, set-in-place).
- Used for **sequential** structures where indexes are contiguous (`array`, `uint*array`, `int*array`).

## How array and uint*array share arraytree

Both use `arraytree` as the backbone but with different leaf storage:

- `array` stores hashes as **Links** in `cask.Model` nodes (32 hashes per leaf) via `StoreLinkLeaf`/`LoadLinkLeaf`.
- `uint*array` stores integers as **packed bytes** in `cask.Block` leaves via `StoreLeaf`/`LoadLeaf`.

For backwards compatibility with existing data:

- `array` uses **little-endian** length encoding and **LSB-first** digit extraction (`LoadRootLE`/`WriteRootLE`, `DigitLSB`).
- `uint*array` uses **big-endian** length encoding and **MSB-first** digit extraction (`LoadRoot`/`WriteRoot`, `Digit`).

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
