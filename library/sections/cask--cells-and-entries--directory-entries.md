---
title: Directory Entries
source: doc/design/cells-and-entries.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: A directory entry maps a variable-length name to a 32-byte reference with a 2-byte mode (`{name, mode, hash}`). The mode category decides how to read the reference field: when the category is `0x00` (immutable) the `hash` field is a content hash; when the category is `0x01` (cell) the same field holds a `cell_addr` instead, and resolution requires a cell-bank lookup to recover the current `value_hash`. The field is fixed at 32 bytes regardless of which it holds, so the entry layout does not change with the mode.

## Directory Entries

A directory entry maps a name to a reference with a mode:

```
entry {
    name  : variable bytes   // human-readable name
    mode  : 2 bytes          // category/subtype
    hash  : 32 bytes         // content hash or cell address
}
```

When the mode category is 0x00 (immutable), the hash is a content hash. When the
mode category is 0x01 (cell), the hash field holds a cell_addr instead.
Resolution requires a cell bank lookup to get the current value_hash.

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8`.
