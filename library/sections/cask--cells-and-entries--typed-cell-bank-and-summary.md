---
title: Implications for the Cell Bank, and Summary
source: doc/design/cells-and-entries.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: Giving cell records a mode turns the cell bank into a **typed key-value store** (`cap_token → cell_addr → (value_hash, mode)`), which enables typed listing (enumerate all cells of a given mode), optional strict-mode validation (reject a write whose `value_hash` does not match the declared mode), and uniform "show me what this is" tooling across directory entries and cell-bank entries. The recommendation is that mode is **set at allocation time and does not change** (simpler and safer than a mutable mode). The summary table contrasts directory entry versus stand-alone cell across name, mode, reference, storage, mutability, GC role, and resolution, and states the thesis: the shared name/mode/reference shape is a single design idea, a named, typed pointer, that directories organize by human name and the cell bank organizes by cryptographic name.

## Implications for the Cell Bank

If cell records gain a mode field, the cell bank becomes a typed key-value
store:

```
cap_token → cell_addr → (value_hash, mode)
```

This enables:

- **Typed listing**: Enumerate all cells of a given mode (e.g., all
  directory-valued cells).
- **Validation**: Reject writes where the new value_hash doesn't match the cell's
  declared mode (optional, strict mode).
- **Uniform tooling**: The same "show me what this thing is" logic works for
  directory entries and cell bank entries.

The mode could be set at allocation time and be immutable for the life of the
cell, or it could be mutable (allowing a cell to change from pointing to a blob
to pointing to a directory).
The immutable option is simpler and safer; the mutable option is more flexible.

Recommendation: mode is set at allocation time and does not change.

## Summary

| Property        | Directory Entry          | Stand-Alone Cell           |
|-----------------|--------------------------|----------------------------|
| Name            | Byte string (path)       | cap_token (32-byte secret) |
| Mode            | 2-byte category/subtype  | 2-byte category/subtype    |
| Reference       | 32-byte hash or cell_addr| 32-byte value_hash         |
| Stored in       | Directory tree           | Cell bank (cell_map)       |
| Mutability      | Immutable (tree rebuild) | Mutable (CAS on cell)      |
| GC role         | Strong ref (immutable) or weak ref (cell) | Strong ref (GC root) |
| Resolution      | Load from block store    | Lookup in cell bank        |

The shared shape -- name, mode, reference -- is not a coincidence. It reflects a
single design idea: a named, typed pointer. Directories organize these pointers
into hierarchies with human-readable names. The cell bank organizes them into a
flat namespace with cryptographic names. Both are collections of the same kind
of thing.

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8`.
