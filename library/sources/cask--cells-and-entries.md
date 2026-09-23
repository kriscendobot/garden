---
source: doc/design/cells-and-entries.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
notes: The unifying design behind cells.md and the caskdir directory entry. Introduces the cask-named-typed-pointer concept (the shared name/mode/reference shape). Lineage sibling of cells.md.
---

> Abstract: The common design of stand-alone cells and directory entries, two structures that share one shape, the triple `name → (mode, reference)`. The **name** is how you ask for it (byte string, capability token, path component); the **mode** is what kind of thing it is (immutable blob, directory, cell, map, set); the **reference** is where to find it (a content hash or a cell address), always a fixed 32 bytes. A **stand-alone cell** lives in the cell bank with `cap_token` as name and `value_hash` as content; the proposal adds a 2-byte mode to the `cell_record`, reusing the directory entry's category/subtype encoding so the cell bank becomes a typed key-value store. A **directory entry** (`{name, mode, hash}`) reads its 32-byte field as a content hash when immutable or a `cell_addr` when a cell. Five **through-lines** justify the shared shape: mode is interpretation metadata, the reference is always 32 bytes, cells and entries compose and nest, resolution is a uniform mode-driven walk, and GC treats immutable references as strong (retaining) while cell references are weak (naming but not retaining). The recommendation: cell mode is set at allocation and immutable. The thesis: a named, typed pointer organized by human name in directories and by cryptographic name in the cell bank.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [common-shape-name-mode-reference](../sections/cask--cells-and-entries--common-shape-name-mode-reference.md) | content-addressed-storage, capability-security | current |
| [standalone-cells-and-cell-record](../sections/cask--cells-and-entries--standalone-cells-and-cell-record.md) | content-addressed-storage, capability-security | current |
| [directory-entries](../sections/cask--cells-and-entries--directory-entries.md) | content-addressed-storage | current |
| [through-lines](../sections/cask--cells-and-entries--through-lines.md) | content-addressed-storage, data-structures | current |
| [typed-cell-bank-and-summary](../sections/cask--cells-and-entries--typed-cell-bank-and-summary.md) | content-addressed-storage, capability-security | current |

## Provenance

Source: [doc/design/cells-and-entries.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells-and-entries.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-24 (job `scholar-ingest-cask-5`).
