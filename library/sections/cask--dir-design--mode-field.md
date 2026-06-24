---
title: Mode Field
source: doc/design/dir-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
notes: The 2-byte category/subtype mode encoding is the same field generalized in cells-and-entries (see concept cask-named-typed-pointer); this section is the directory-side statement of it.
---

> Abstract: The directory entry's mode is a 16-bit value encoding the entry type. The current/legacy modes are flat constants (`NoMode=1`, `FileMode=2`, `DirMode=3`, `ExecMode=4`). The planned extension reinterprets the field as **High Byte (Category) | Low Byte (Subtype)**: category `0x00` immutable hash-addressed content (file/dir/exec/symlink), `0x01` cell references (mutable, capability-addressed), `0x02` maps (caskmap), `0x03` sets (caskset), `0x04-0xFF` reserved. Legacy values 1-4 fall under category `0x00` but do not align perfectly with the new subtype numbering (migration strategy TBD). This is the directory-side instance of the `name → (mode, reference)` named-typed-pointer shape that cells share.

## Mode Field (2 bytes)

The mode field is a 16-bit value encoding the entry type.

### Current Modes (Legacy)

```go
const (
    NoMode   Mode = 1  // absent/invalid
    FileMode Mode = 2  // regular file (blob)
    DirMode  Mode = 3  // directory (caskdir)
    ExecMode Mode = 4  // executable file (blob)
)
```

### Extended Mode Categories (Planned)

The 2-byte mode field will be interpreted as:

```
┌─────────────────────────────────────────────────────────┐
│ High Byte (Category)    │ Low Byte (Subtype)           │
└─────────────────────────────────────────────────────────┘
```

**Categories:**

| High Byte | Category          | Description                         |
|-----------|-------------------|-------------------------------------|
| 0x00      | Immutable content | Legacy types, hash-addressed        |
| 0x01      | Cell references   | Mutable cells, capability-addressed |
| 0x02      | Maps              | Key-value structures (caskmap)      |
| 0x03      | Sets              | Unordered collections (caskset)     |
| 0x04-0xFF | Reserved          | Future use                          |

**Subtypes for 0x00 (Immutable):** `0x00` NoMode (invalid/absent), `0x01` File (caskblob), `0x02` Dir (caskdir), `0x03` Exec (caskblob), `0x04` Symlink (target in data), `0x05-0xFF` reserved.

**Subtypes for 0x01 (Cells):** `0x00` LocalCell (cell on this peer), `0x01` RemoteCell (cell on another peer, future), `0x02-0xFF` reserved.

**Subtypes for 0x02 (Maps):** `0x00` HashMap (caskmap), `0x01` SortedMap (future), `0x02-0xFF` reserved.

**Subtypes for 0x03 (Sets):** `0x00` HashSet (caskset), `0x01` SortedSet (future), `0x02-0xFF` reserved.

### Backward Compatibility

Legacy modes (1-4) fall in the 0x00 category:

| Legacy Value | New Encoding | Category:Subtype |
|--------------|--------------|------------------|
| 1 (NoMode)   | 0x0000       | Immutable:NoMode |
| 2 (FileMode) | 0x0001       | Immutable:File   |
| 3 (DirMode)  | 0x0002       | Immutable:Dir    |
| 4 (ExecMode) | 0x0003       | Immutable:Exec   |

Note: The legacy values do not align perfectly. Migration strategy TBD.

Source: [doc/design/dir-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design.md) at commit `cdb975d8`.
