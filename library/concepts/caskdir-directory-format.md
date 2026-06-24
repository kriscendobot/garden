---
id: caskdir-directory-format
aliases: ["caskdir", "caskcompactdir", "compact directory format", "table directory format", "dir v2", "caskdir v2", "Rabin-chunked directory", "adaptive directory format", "directory benchmark", "byName index", "directory entry mode", "SchemaAdaptiveV0", "directories as Merkle trees", "compact vs table directory"]
topics: [content-addressed-storage, data-structures]
status: current
---

# caskdir-directory-format

CASK's on-disk directory: a content-addressed Merkle structure mapping entry **names** to `(mode, reference)` pairs (the mode a 2-byte category/subtype field, the reference a 32-byte content hash or cell address), with three design documents tracing one arc. **v1 (`dir-design`)** is the "compact" format: entries packed inline in a streaming Merkle tree (`caskio.Writer`), full-rebuild mutation, O(n) name lookup. Its future-work section posed the O(n) problem and listed four fixes. **v2 (`dir-design-v2`)** is a PLANNED design answering that with O(log n): first a Rabin-chunked sorted entries tree (min-key links, content-defined boundaries), then a *recommended* table-of-parallel-arrays layout (names/modes/values columns + a byName sortedarray index over an allocator). **The benchmark (`dir-benchmark`)** then built both (`caskcompactdir` vs `caskdir`-the-table) and measured the table 70x-326x larger and 40x-70,000x slower at 5-1,000 entries: the table's O(log n)/incremental advantages only pay off at very large directories. The empirical resolution is **adaptive, not a supersession**: compact stays the default; switch to table only above a high threshold (grow at N > 10,000, shrink at N < 5,000, 2:1 hysteresis) via a future `SchemaAdaptiveV0` root that records the active mode and delegates. So all three sources remain `status: current` — v1 is the practical default, v2 documents the large-directory escape hatch, and the benchmark is the verdict that keeps v1 in charge.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--dir-design--overview-and-entry-format](../sections/cask--dir-design--overview-and-entry-format.md) | v1: directory as a Merkle tree of name→hash entries; the inline compact entry format. |
| [cask--dir-design--directory-structure-and-operations](../sections/cask--dir-design--directory-structure-and-operations.md) | v1: root/branch/leaf tree and the Store/Load/List/Resolve operations. |
| [cask--dir-design--lookup-complexity-future-work](../sections/cask--dir-design--lookup-complexity-future-work.md) | v1: the O(n)-lookup limitation and four enumerated fixes (the origin of the arc). |
| [cask--dir-design-v2--goals-and-rabin-chunked-entries-tree](../sections/cask--dir-design-v2--goals-and-rabin-chunked-entries-tree.md) | v2: goals and the Rabin-chunked sorted entries tree with min-key links. |
| [cask--dir-design-v2--navigation-and-mutation-algorithms](../sections/cask--dir-design-v2--navigation-and-mutation-algorithms.md) | v2: O(log n) Lookup/Insert/Delete over the chunked tree. |
| [cask--dir-design-v2--migration-and-v1-comparison](../sections/cask--dir-design-v2--migration-and-v1-comparison.md) | v2: lazy v1→v2 migration, the comparison table, SDIF/SOPS sync. |
| [cask--dir-design-v2--table-with-parallel-arrays-alternative](../sections/cask--dir-design-v2--table-with-parallel-arrays-alternative.md) | v2: the recommended table-of-columns layout (later reversed by the benchmark). |
| [cask--dir-benchmark--compact-vs-table-implementations-and-storage](../sections/cask--dir-benchmark--compact-vs-table-implementations-and-storage.md) | benchmark: the two built formats and the 70x-326x storage gap. |
| [cask--dir-benchmark--speed-benchmarks](../sections/cask--dir-benchmark--speed-benchmarks.md) | benchmark: the 40x-70,000x speed gap across build/insert/delete/list. |
| [cask--dir-benchmark--analysis-and-adaptive-strategy](../sections/cask--dir-benchmark--analysis-and-adaptive-strategy.md) | benchmark: the verdict and the adaptive compact-default strategy. |

## See also

- [[cask-named-typed-pointer]] — the `name → (mode, reference)` triple that directory entries (and cells) share; the directory's mode field is its instance.
- [[parallel-arrays-columnar]] — the table layout v2 recommends and the benchmark measures; directories-as-tables realized and found costly at small sizes.
- [[rabin-chunking]] — the content-defined chunking the v2 entries tree uses for stable Merkle boundaries.
- [[cask-block-backbones]] — the arraytree the v2 entries tree and the table columns build on.
- [[content-addressed-block-store]] — the 1KB-block store directories are Merkle trees over.
- [[merkle-tree-of-blocks]] — the general tree shape a directory realizes.

## Common confusions

- **"v2 supersedes v1" is wrong.** A `dir-design-v2.md` filename suggests supersession, but the benchmark reversed v2's recommended table layout: the v1-lineage compact format is the practical default and only very large directories use the table. The arc resolves to an adaptive hybrid, not a replacement.
- **"table format" (`caskdir`) vs "compact format" (`caskcompactdir`).** Confusingly, the *table* approach got the canonical `caskdir` package name while the v1-lineage *compact* approach is `caskcompactdir`. The benchmark's "table" is v2's recommended layout; its "compact" is the v1 design.
- Distinct from the in-memory `sendbuffer`/`recvbuffer` parallel arrays ([[parallel-arrays-columnar]]): those are RAM-resident; this is the persisted directory structure.
