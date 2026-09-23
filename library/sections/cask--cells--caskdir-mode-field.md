---
title: Extended caskdir Mode Field
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

Abstract: To accommodate cell references and the new collection types, the caskdir entry **mode** field grows from 1 byte to 2 bytes, split into a high-byte **category** and a low-byte **subtype**. Categories: `0x00` immutable content types (the legacy blob/dir/symlink, now the subtype space), `0x01` cell references (local vs future remote), `0x02` maps (caskmap), `0x03` sets (caskset), with `0x04-0xFF` reserved. This is the same encoding `cells-and-entries.md` shows applied to stand-alone cell records, so directory entries and cell records share one mode vocabulary.

## Extended caskdir Mode Field

The mode field expands from 1 byte to 2 bytes to accommodate new entry types:

```
mode (2 bytes):
  high byte: category
    0x00 = immutable content types (legacy)
    0x01 = cell references
    0x02 = maps
    0x03 = sets
    0x04-0xFF = reserved

  low byte: subtype within category
    for 0x00: 0=blob, 1=dir, 2=symlink, ...
    for 0x01: 0=local cell, 1=remote cell (future), ...
    for 0x02: 0=caskmap, ...
    for 0x03: 0=caskset, ...
```

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
