---
title: The Common Shape
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

Abstract: Stand-alone cells and directory entries share one shape, the triple `name → (mode, reference)`. The **name** is how you ask for it (a byte string in a directory, a capability token in the cell bank, a path component in a URL); the **mode** says what kind of thing it is (immutable blob, directory, cell, map, set); the **reference** says where to find it (a content hash for immutable data, a cell address for mutable data). A directory entry is this triple stored in a sorted collection keyed by name; a stand-alone cell is the same triple where the name is a capability token and the reference is a mutable pointer. This shared triple is the organizing idea of the whole `cells-and-entries.md` document.

## The Common Shape

Both cells and directory entries answer the same question: "given a name, what
kind of thing is it, and where do I find it?"

```
name  → (mode, reference)
```

- **name**: How you ask for it. A byte string in a directory, a capability token
  in the cell bank, a path component in a URL.
- **mode**: What kind of thing it is. Immutable blob, directory, cell, map, set.
- **reference**: Where to find it. A content hash for immutable data, a cell
  address for mutable data.

A directory entry is this triple stored in a sorted collection keyed by name. A
stand-alone cell is this triple where the name is a capability token and the
reference is a mutable pointer.

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8`.
