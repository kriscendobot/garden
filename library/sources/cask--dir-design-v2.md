---
source: doc/design/dir-design-v2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 4
status: current
notes: A PLANNED design (status PLANNED in source) answering v1's O(n)-lookup limit. NOT a clean supersession of v1: its recommended "table" layout was empirically reversed by dir-benchmark, which keeps the v1-lineage compact format as the default. The Rabin-chunked design, navigation algorithms, and O(log n) motivation remain valid for very large directories. See concept caskdir-directory-format.
---

The next-generation caskdir design, addressing v1's O(n) lookup with O(log n) navigation. Presents two layouts: a Rabin-chunked sorted entries tree (internal nodes interleaving child-hash and min-key-hash links, content-defined chunk boundaries over the name hash) with its Lookup/Insert/Delete algorithms, and the v1-comparison plus lazy migration (v1 and v2 roots are structurally distinguishable; write path always produces v2) and SDIF/SOPS sync shared with sorted arrays. The document's *recommended* alternative is a table of parallel arrays (names/modes/values columns + a byName sortedarray index over an allocator, with adaptive slot width), proposed as the v2 decision because it reuses CASK's emerging table patterns. That recommendation was later reversed empirically by `dir-benchmark`.

| Section | Topics | Status |
|---------|--------|--------|
| [goals-and-rabin-chunked-entries-tree](../sections/cask--dir-design-v2--goals-and-rabin-chunked-entries-tree.md) | content-addressed-storage, data-structures | current |
| [navigation-and-mutation-algorithms](../sections/cask--dir-design-v2--navigation-and-mutation-algorithms.md) | data-structures, content-addressed-storage | current |
| [migration-and-v1-comparison](../sections/cask--dir-design-v2--migration-and-v1-comparison.md) | content-addressed-storage | current |
| [table-with-parallel-arrays-alternative](../sections/cask--dir-design-v2--table-with-parallel-arrays-alternative.md) | data-structures, content-addressed-storage | current |
