---
source: doc/design/dir-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
notes: The v1 ("compact") caskdir format. Remains the practical default per dir-benchmark; not superseded by dir-design-v2. Its O(n)-lookup open question is the origin of the design arc captured in concept caskdir-directory-format.
---

The original caskdir design: content-addressable storage for directory structures as Merkle trees whose leaves hold name→hash entries. Covers the entry format (a `Mode | NameLen | Name` header with the hash in the block's parallel links array), the 2-byte category/subtype mode field (immutable / cell / map / set), cell-reference entries (the hash link holds a 32-byte cell address resolved through the cell bank), the root/branch/leaf tree structure and the Store/Load/List/Resolve operations, and the future-work section that poses the O(n)-lookup limitation and enumerates four fixes. This is the v1-lineage "compact" format the benchmark doc calls `caskcompactdir`.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-entry-format](../sections/cask--dir-design--overview-and-entry-format.md) | content-addressed-storage | current |
| [mode-field](../sections/cask--dir-design--mode-field.md) | content-addressed-storage, capability-security | current |
| [cell-reference-entries](../sections/cask--dir-design--cell-reference-entries.md) | content-addressed-storage, capability-security | current |
| [directory-structure-and-operations](../sections/cask--dir-design--directory-structure-and-operations.md) | content-addressed-storage | current |
| [lookup-complexity-future-work](../sections/cask--dir-design--lookup-complexity-future-work.md) | content-addressed-storage, data-structures | current |
