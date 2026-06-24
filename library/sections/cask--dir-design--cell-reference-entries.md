---
title: Cell Reference Entries
source: doc/design/dir-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

> Abstract: When a directory entry's mode category is `0x01` (Cell), the entry's "hash" link is not a content hash but a 32-byte **cell address**. Resolution is two-step: look up the `cell_addr` in the cell bank to get the current `value_hash`, then load that hash from the block store. This is what lets an immutable directory tree name a mutable target without breaking content addressing: the directory link stays fixed (the cell address) while the value behind it changes. The full cell model lives in `cells.md` / the cells-and-entries design.

## Cell Reference Entries

When mode category is `0x01` (Cell), the entry's "hash" field contains a cell address instead of a content hash:

```
Entry {
    Hash: cell_addr (32 bytes)  // NOT a content hash
    Mode: 0x0100 (LocalCell)
    Name: "mutable-file"
}
```

Resolution requires looking up `cell_addr` in the cell bank to get the current `value_hash`, then loading that hash from the block store.

See the cells design (`CELLS.md`) for the full cell model.

Source: [doc/design/dir-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design.md) at commit `cdb975d8`.
