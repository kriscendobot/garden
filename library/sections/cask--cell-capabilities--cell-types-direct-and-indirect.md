---
title: Cell Types — Direct and Indirect; Summary Table
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: The four cell entry types in detail and the nine-type summary table. **Direct** types (`TypeCell` = 5, `TypeCellRead` = 6) carry the cell ID in the hash field; both expose the cell ID but not the content hash, so the cell table mediates access and read restriction is enforceable. `TypeCell` grants read + CAS + subpath write + removal; `TypeCellRead` grants resolve/load/list/walk/read but not CAS and not any write. **Indirect** types (`TypeCellPath` = 8, `TypeCellPathRead` = 9) carry a descriptor hash; the resolver loads the descriptor, reads the cell ID from the first leaf's link and the path from the CBOR data, looks up the cell table, navigates to the subpath, and performs the operation subject to the access level. `TypeCellPath` allows read+write at the subpath but no direct root CAS and nothing outside the subpath; `TypeCellPathRead` is the read-only subpath form. The summary table records, per type, the hash field, whether it hides content, and read/write access.

## Cell types — direct (hash = cell ID)

| Type | Value | Meaning |
|------|-------|---------|
| `TypeCell` | 5 | Read + write. Full access to the cell's root value. |
| `TypeCellRead` | 6 | Read only. Resolve the cell to its current value; cannot CAS. |

All direct cell types expose the cell ID but not the content hash. The cell table mediates access, making read restrictions enforceable.

**TypeCell (5), full access.** The existing type. The holder can read the cell's current value, compare-and-swap the cell's value to any new hash, write to subpaths under the cell's value tree (via `--to`), and be the target of `cask rm` (the entry can be removed from its parent).

**TypeCellRead (6), read only.** The holder can resolve the cell ID to its current value hash and load, list, walk, and read the content tree. The holder cannot CAS the cell's value or write to any path under the cell. This is an honest attenuation: the cell ID does not reveal the content hash, the resolver must look up the cell table to dereference it, and the entry type gates whether the resolver proceeds to mutation. CLI: read commands (`load`, `checkout`, `ls`, `state`, `at`) work normally; write commands (`store --to`, `checkin --to`, `cas`) fail when the path traverses a `TypeCellRead` entry.

## Cell types — indirect (hash = descriptor hash)

| Type | Value | Meaning |
|------|-------|---------|
| `TypeCellPath` | 8 | Read + write at the descriptor's path. |
| `TypeCellPathRead` | 9 | Read only at the descriptor's path. |

All indirect cell types expose the descriptor hash, which reveals the cell ID (as a link in the descriptor block) and the path segments (as CBOR data). But the cell ID does not reveal content: cell table access is still required. The read restriction is enforceable for the same reasons as direct cell types.

For all indirect types, the resolver:

1. Loads the cell path descriptor from the hash field.
2. Reads the cell ID from the first leaf's link and decodes the path segments from the CBOR data bytes.
3. Looks up the cell ID in the cell table to get the current value hash.
4. Navigates the value tree along the path segments.
5. Performs the operation at the resolved location, subject to the access level.

**TypeCellPath (8), read + write at subpath.** The holder can read content at the specified subpath, write content there (upsert entries, modify subtree), and remove entries there. The holder cannot CAS the cell's root value directly, nor read or write content outside the specified subpath. Concretely, if a descriptor encodes `[<photos-cell>, ["vacation"]]` and a directory entry `carol TypeCellPath <descriptor-hash>`, then `cask ls :carol` is allowed (lists `vacation`), `cask checkin new-pics --to :carol:new-pics` is allowed (upserts under `vacation`), `cask cas :carol OLD NEW` is an error (direct CAS not permitted through an indirect reference), and `cask ls :carol:..` is an error (`..` is never valid in CASK paths). The write is implemented as: load the cell's current value, navigate to the subpath, apply the modification, rebuild the path back to the cell's root, CAS the cell to the new root.

**TypeCellPathRead (9), read only at subpath.** Same as `TypeCellPath` but read-only: list and load at the subpath, no modification. Use case: grant read access to a specific subdirectory of a cell without exposing the rest of the tree (read access to `:project:docs` but not `:project:src`).

## Summary table

| Type | Value | Hash field | Hides content? | Read | Write |
|------|-------|------------|----------------|------|-------|
| `TypeDir` | 0 | content | no | yes | — |
| `TypeBlob` | 1 | content | no | yes | — |
| `TypeExecBlob` | 2 | content | no | yes | — |
| `TypeCompactBlob` | 3 | content | no | yes | — |
| `TypeExecCompactBlob` | 4 | content | no | yes | — |
| `TypeCell` | 5 | cell ID | yes | yes | yes |
| `TypeCellRead` | 6 | cell ID | yes | yes | no |
| `TypeCellPath` | 8 | descriptor | yes | at path | at path |
| `TypeCellPathRead` | 9 | descriptor | yes | at path | no |

"at path" means the operation is permitted only at the subpath encoded in the cell path descriptor. Content outside that subpath is not accessible. Every type in this table is honest about what it hides and what it permits: content-hash types never claim to restrict reads, cell types that restrict writes also grant reads (because CAS requires reading the current value), and read-only cell types genuinely prevent writes.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
