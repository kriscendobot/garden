---
title: Garbage Collection
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: Cell GC has three faces. **Cell bank GC**: the cell bank is the GC root, cells are retained as long as they exist in the cell map, and deleting a cell removes it from the cell map plus all its capability mappings, after which its value tree becomes unreachable and is collected by normal GC. **Value tree GC**: when a cell's `value_hash` changes, the old value tree may become unreachable and is collected by normal mark-sweep unless referenced elsewhere, while the new tree is retained via the cell. **Cell reference GC**: cell references in trees are weak and do not prevent cell collection, so a reference to a deleted cell fails at resolution time rather than at GC time.

## Garbage Collection

### Cell Bank GC

The cell bank is the GC root. Cells are retained as long as they exist in the
cell_map. When a cell is deleted:

1. Remove from cell_map
2. Remove all capability mappings from capability_map
3. The value tree becomes unreachable (collected by normal GC)

### Value Tree GC

When a cell's value_hash changes:

1. Old value tree may become unreachable
2. Normal mark-sweep GC collects it (unless referenced elsewhere)
3. New value tree is retained via the cell

### Cell Reference GC

Cell references in trees are weak. They don't prevent cell collection. If a
referenced cell is deleted, resolution fails at runtime.

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
