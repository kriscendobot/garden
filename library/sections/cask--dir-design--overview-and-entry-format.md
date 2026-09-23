---
title: Overview and Entry Format
source: doc/design/dir-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: caskdir gives content-addressable storage for directory structures. A directory is a Merkle tree whose leaf blocks hold **entries** mapping names to hashes. Each entry is a fixed header `Mode (2 bytes) | NameLen (2 bytes) | Name (variable)`; the entry's hash is not stored inline in the header but comes from the block's parallel **links array** (one link per entry, positionally aligned with the entries). This is the v1 "compact" layout (inline names packed into leaf `Bytes`), the format the `dir-benchmark` doc later calls `caskcompactdir` and finds the practical default at typical directory sizes.

## Overview

caskdir provides content-addressable storage for directory structures. Each directory is a Merkle tree where leaf blocks contain entries mapping names to hashes.

## Entry Format

Each entry in a directory block:

```
┌─────────────────────────────────────────────────────────┐
│ Mode (2 bytes) │ NameLen (2 bytes) │ Name (variable)   │
└─────────────────────────────────────────────────────────┘
```

The entry's hash comes from the block's links array (parallel to entries).

Source: [doc/design/dir-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design.md) at commit `cdb975d8`.
