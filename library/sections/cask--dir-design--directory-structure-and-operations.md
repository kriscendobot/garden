---
title: Directory Structure and Operations
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

> Abstract: A v1 directory is a Merkle tree built with `caskio.Writer`: a root over branch blocks over leaf blocks (height 0). Leaf blocks carry a links array (one hash or cell address per entry) plus packed entry metadata in `Data` (mode, namelen, name); branch blocks carry child-block hashes and otherwise-empty data (or boundary keys for future search optimization). Four operations: `Store(ctx, store, fs, path, opts...) → Hash` writes a filesystem tree as blocks, `Load(ctx, store, fs, path, hash)` reconstructs one, `List(ctx, store, hash) → []Entry` returns a directory's entries non-recursively, and `Resolve(ctx, store, hash, path) → Entry` walks a path through nested directories.

## Directory Structure

Directories are Merkle trees built with `caskio.Writer`:

```
         ┌──────────┐
         │   root   │ height > 0
         └────┬─────┘
       ┌──────┴──────┐
       ▼             ▼
  ┌────────┐    ┌────────┐
  │ branch │    │ branch │ height > 0
  └───┬────┘    └───┬────┘
      │             │
      ▼             ▼
  ┌────────┐    ┌────────┐
  │  leaf  │    │  leaf  │ height = 0
  └────────┘    └────────┘
```

Leaf blocks contain a **Links array** (hashes or cell addresses for each entry) and **Data** (packed entry metadata: mode, namelen, name). Branch blocks contain a **Links array** of child-block hashes and empty data (or boundary keys for search optimization).

## Operations

```go
// Reads a filesystem directory tree and writes it as blocks; returns the root hash.
func Store(ctx, store, fs, path, opts...) (Hash, error)

// Reads blocks and reconstructs a filesystem directory tree.
func Load(ctx, store, fs, path, hash) error

// Returns all entries in a directory (non-recursive).
func List(ctx, store, hash) ([]Entry, error)

// Traverses a path through nested directories to find an entry.
func Resolve(ctx, store, hash, path) (Entry, error)
```

Source: [doc/design/dir-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design.md) at commit `cdb975d8`.
