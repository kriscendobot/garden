---
title: Stand-Alone Cells and the Proposed Cell Record
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

Abstract: A stand-alone cell is a named mutable reference that lives in the cell bank outside any directory: the `cap_token` is the name (a secret bearer token), the `cell_addr` is a stable identity, and the `value_hash` is the current content. Today no mode is stored, because cell-bank cells are implicitly "mutable reference to an immutable tree." The proposal adds a 2-byte mode to a `cell_record` (`{value_hash: 32 bytes, mode: 2 bytes}`), reusing the exact category/subtype encoding directory entries already use (`0x00` immutable, `0x01` cell, `0x02` map, `0x03` set). This is not a new encoding; it is the same mode field applied to a new context, letting a reader interpret a cell's `value_hash` without first loading it.

## Stand-Alone Cells

A stand-alone cell is a named mutable reference that exists outside any
directory. It lives in the cell bank:

```
capability_map:  cap_token  → cell_addr
cell_map:        cell_addr  → value_hash
```

The cap_token is the name (a secret bearer token).
The cell_addr is a stable identity. The value_hash is the current content. There
is no mode stored today because cells in the cell bank are implicitly "mutable
reference to an immutable tree."

But cells could benefit from a mode. Consider:

- A cell whose value is a blob (mode 0x0001).
- A cell whose value is a directory (mode 0x0002).
- A cell whose value is another cell bank (mode 0x0100).
- A cell whose value is a map (mode 0x0200).

Knowing the mode tells you how to interpret the value_hash without loading it
first. This is the same role mode plays in a directory entry.

### Proposed Cell Record

```
cell_map:  cell_addr → cell_record

cell_record {
    value_hash : 32 bytes   // current content (hash of immutable tree)
    mode       : 2 bytes    // same mode encoding as directory entries
}
```

The mode uses the same category/subtype encoding from caskdir:

| High Byte | Category  | Meaning for a cell                        |
|-----------|-----------|-------------------------------------------|
| 0x00      | Immutable | Cell points to a blob, dir, exec, symlink |
| 0x01      | Cell      | Cell points to another cell (indirection) |
| 0x02      | Map       | Cell points to a caskmap                  |
| 0x03      | Set       | Cell points to a caskset                  |

This is not a new encoding. It is the same 2-byte mode field that directory
entries already use, applied to a new context.

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8`.
