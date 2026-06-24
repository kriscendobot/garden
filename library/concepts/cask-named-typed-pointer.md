---
id: cask-named-typed-pointer
aliases: ["named typed pointer", "name mode reference", "cells and entries", "caskdir mode field", "directory entry", "cell record", "mode category subtype", "2-byte mode", "uniform resolution walk", "entry triple"]
topics: [content-addressed-storage, capability-security]
status: current
---

# cask-named-typed-pointer

The single design idea behind both CASK directory entries and stand-alone cells: a **named, typed pointer**, the triple `name → (mode, reference)`. The **name** is how you ask for it (a byte-string path component in a directory, a `cap_token` in the cell bank); the **mode** is a 2-byte category/subtype field saying what kind of thing it is (`0x00` immutable blob/dir/symlink, `0x01` cell, `0x02` map, `0x03` set); the **reference** is always a fixed 32 bytes, a content hash when immutable or a `cell_addr` when a cell. Five through-lines make the shared shape pay off: mode is interpretation metadata (read it before chasing the reference, avoiding a round-trip), the reference's fixed 32-byte width means the storage format never changes with the mode, cells and entries compose and nest arbitrarily, resolution is a uniform mode-driven walk that needs no advance knowledge of mutability, and GC distinguishes them (immutable references are strong and retaining, cell references are weak and merely naming). Giving cell records a mode turns the cell bank into a typed key-value store (`cap_token → cell_addr → (value_hash, mode)`) supporting typed listing, strict-mode validation, and uniform tooling; the recommendation is that a cell's mode is set at allocation and immutable. Directories organize these pointers by human-readable name; the cell bank organizes them by cryptographic name.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--cells-and-entries--common-shape-name-mode-reference](../sections/cask--cells-and-entries--common-shape-name-mode-reference.md) | The name→(mode,reference) triple shared by cells and directory entries. |
| [cask--cells-and-entries--standalone-cells-and-cell-record](../sections/cask--cells-and-entries--standalone-cells-and-cell-record.md) | Stand-alone cell and the proposed mode-bearing cell_record. |
| [cask--cells-and-entries--directory-entries](../sections/cask--cells-and-entries--directory-entries.md) | The {name, mode, hash} entry; hash field as content hash or cell_addr. |
| [cask--cells-and-entries--through-lines](../sections/cask--cells-and-entries--through-lines.md) | The five through-lines justifying the shared shape. |
| [cask--cells-and-entries--typed-cell-bank-and-summary](../sections/cask--cells-and-entries--typed-cell-bank-and-summary.md) | Typed cell bank, allocation-time-immutable mode, the comparison summary. |
| [cask--cells--caskdir-mode-field](../sections/cask--cells--caskdir-mode-field.md) | The 2-byte category/subtype mode encoding this pointer uses. |
| [cask--dir-design--mode-field](../sections/cask--dir-design--mode-field.md) | The directory-side statement of the 2-byte category/subtype mode (immutable/cell/map/set). |
| [cask--dir-design--cell-reference-entries](../sections/cask--dir-design--cell-reference-entries.md) | When mode category is 0x01, the entry's reference is a 32-byte cell address resolved through the cell bank. |

## See also

- [[caskdir-directory-format]] — the directory format whose entries are these named typed pointers.
- [[cask-cell-bank]] — the mutable side of the pointer (cells); this concept is the shape both cells and entries share.
- [[content-addressed-block-store]] — the immutable side the reference may point into.
