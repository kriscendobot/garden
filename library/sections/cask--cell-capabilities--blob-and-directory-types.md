---
title: Blob and Directory Types
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: The content-hash entry types and why none of them admit a read restriction. All four blob types (`TypeBlob`, `TypeExecBlob`, `TypeCompactBlob`, `TypeExecCompactBlob`) and the single directory type (`TypeDir`) expose the content hash, so read access cannot be restricted: the hash is the content. The only way to restrict read access to a directory is to put it behind a cell, because the cell indirection hides the content hash. Grant `TypeCellRead` to consumers who should see the full content; for consumers who should see only a manifest, store a separate blob of names and types (not content hashes) and grant access to that. The cell is the access-control boundary.

## Blob types

| Type | Value | Meaning |
|------|-------|---------|
| `TypeBlob` | 1 | Regular file. Read content, replace entry, remove entry. |
| `TypeExecBlob` | 2 | Executable file. Same as `TypeBlob` but marks the file as executable on checkout. |
| `TypeCompactBlob` | 3 | Compact blob. Alternate storage format; same access as `TypeBlob`. |
| `TypeExecCompactBlob` | 4 | Executable compact blob. |

All blob types expose the content hash. Read access cannot be restricted: the hash is the content. No meaningful attenuation is possible.

## Directory types

| Type | Value | Meaning |
|------|-------|---------|
| `TypeDir` | 0 | Directory. List, resolve children, replace entry, remove entry. |

Directory types expose the content hash. Read access cannot be restricted.

**How to restrict read access to a directory**: Put the directory behind a cell. The cell indirection hides the content hash. Grant `TypeCellRead` for consumers who should see the full content. For consumers who should only see a manifest, store a separate blob containing only names and types (not content hashes) and grant access to that. The cell is the access control boundary.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
