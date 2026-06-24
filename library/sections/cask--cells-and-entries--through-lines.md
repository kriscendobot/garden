---
title: The Through-Lines
source: doc/design/cells-and-entries.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

Abstract: Five through-lines justify the shared cell-and-entry shape. (1) **Mode is interpretation metadata**: in both, the mode tells you how to read the reference without loading it, avoiding a round-trip. (2) **The reference is always 32 bytes**: content hash or cell address, fixed size, so the storage format (a parallel-array column, a block link slot, a struct field) does not change with the mode. (3) **Cells and entries compose**: a directory entry can point to a cell and a cell can point to a directory, nesting arbitrarily, with each cell independently mutable so an inner update does not change an outer directory's hash. (4) **Resolution is a uniform walk**: look up the name, read the mode, follow the hash if immutable or do a cell-bank lookup then follow if a cell, recurse; the resolver needs no advance knowledge of which components are mutable. (5) **GC treats them differently**: an immutable reference is retained by reachability (mark-sweep), but a cell reference is weak (the cell bank is the strong root), so a directory entry pointing to a hash *retains* the data while one pointing to a cell merely *names* it.

## The Through-Lines

### 1. Mode is interpretation metadata

In both cells and entries, the mode tells you how to interpret the reference
without loading the referenced data. This avoids a round-trip: you know whether
to expect a blob, a directory, or a cell before you chase the hash.

### 2. The reference is always 32 bytes

Whether it is a content hash (immutable) or a cell address (mutable), the
reference is a fixed-size 32-byte value. This means the storage format does not
change based on the mode category. The same column in a parallel-array table,
the same link slot in a block, the same field in a struct -- all hold 32 bytes
regardless of what they point to.

### 3. Cells and entries compose

A directory entry can point to a cell (mode 0x0100).
A cell can point to a directory (mode 0x0002).
These nest arbitrarily:

```
directory
  └─ "config" (mode 0x0100, cell)
       └─ cell_addr → value_hash
            └─ directory
                 ├─ "db.toml" (mode 0x0001, file)
                 └─ "secrets" (mode 0x0100, cell)
                      └─ cell_addr → value_hash
                           └─ ...
```

Each cell is independently mutable. Updating the inner cell does not change the
outer directory's hash. The directory captures structure; cells provide
mutability within that structure.

### 4. Resolution is a uniform walk

Resolving a path through a tree of entries and cells follows one rule:

1. Look up the name in the current directory.
2. Read the mode.
3. If immutable (0x00): follow the hash into the block store.
4. If cell (0x01): look up the cell_addr in the cell bank to get the current
   value_hash, then follow that hash.
5. Recurse with the remaining path.

The resolver does not need to know in advance whether a path component is
mutable or immutable. The mode at each step tells it what to do.

### 5. GC treats them differently

Despite the uniform shape, garbage collection distinguishes them:

- **Immutable references** (mode 0x00): retained by reachability from a GC root
  through hash links. Standard mark-sweep.
- **Cell references** (mode 0x01): the directory entry is a weak reference to the
  cell. The cell bank is the strong root. If a cell is deleted from the cell bank,
  directory entries pointing to it become dangling. Resolution fails at runtime,
  not at GC time.

This is the key asymmetry: a directory entry that points to a hash *retains* the
data. A directory entry that points to a cell *names* the data but does not
retain it.

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8`.
