---
title: Overview and Background
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
notes: Lineage sibling of cask--cells--* and cask--cells-and-entries--*; the implementation-concrete (cell ID / cell table / CAS) view of the same cell/entry machinery the earlier docs framed abstractly (cap_token / cell_addr / value_hash). Co-current, not a supersession.
---

Abstract: A CASK directory entry has three fields (**name**, **type**, **hash**); the type tells the resolver how to interpret the hash and which operations are permitted. Today the type describes only the *content kind* (`TypeDir`, `TypeBlob`, `TypeExecBlob`, `TypeCompactBlob`, `TypeExecCompactBlob`, `TypeCell`), which conflates two concerns: what the content *is* and what you may *do* with it. `TypeCell` implicitly grants both read and write, so there is no way to express a read-only view of a cell or a directory entry that cannot be overwritten. This proposal separates the concerns by making the entry type the capability.

## Status

Proposal. This document describes how directory entry types encode capabilities: what the holder of a reference may do with the thing it names.

## Background

A directory entry has three fields: **name**, **type**, and **hash**. The type tells the resolver how to interpret the hash and what operations are permitted. Today the type describes only the *content kind*:

| Type | Value | Hash contains | Meaning |
|------|-------|---------------|---------|
| `TypeDir` | 0 | Content hash | Immutable directory |
| `TypeBlob` | 1 | Content hash | Immutable file |
| `TypeExecBlob` | 2 | Content hash | Executable file |
| `TypeCompactBlob` | 3 | Content hash | Compact blob |
| `TypeExecCompactBlob` | 4 | Content hash | Executable compact blob |
| `TypeCell` | 5 | Cell ID | Mutable reference (read + write) |

This conflates two concerns: what the content *is* and what you can *do* with it. The type `TypeCell` implicitly grants both read and write access. There is no way to express a read-only view of a cell, or a directory entry that cannot be overwritten. The rest of the document fixes this by treating the entry type as an object-capability facet over the underlying content (see [entry-type-is-the-capability](cask--cell-capabilities--entry-type-is-the-capability.md)).

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
