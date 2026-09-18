# Topic: file-systems

> Abstract: Crash-safe on-disk file systems and the data structures beneath them — copy-on-write B+/Bεtrees, snapshots, deadlist and epoch-based space reclamation, block-hash corruption detection, and 9p/qid namespaces. Seeded 2026-09-18 from Ori Bernstein's **GEFS** paper (a Plan 9 file system layering a 9p interface over a forest of copy-on-write Bεtrees). This topic is the *file-system* neighbor of [content-addressed-storage](content-addressed-storage.md) (CASK's content-hash-addressed 1KB-block Merkle store) and [data-structures](data-structures.md) (the tree/index machinery), and it is deliberately kept distinct: GEFS is *merkelized but not content-addressed* (block pointers hash their target for corruption detection, but blocks live at disk locations and there is no deduplication or content-defined chunking), and it names files through an *ambient qid namespace* resolved by key construction rather than through the *attenuable capability references* the garden's own VFS modeling uses ([persistence](persistence.md), Endo's formula graph). The comparison — where GEFS agrees with, diverges from, or solves differently than CASK's Rabin-chunked structures, dialog-db's prolly trees, and Endo's capability-first naming — is the reason this material was ingested; it is concentrated in concepts [[betree]] and [[gefs]].

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [gefs/overview](../sections/papers--bernstein-gefs-good-enough-file-system-2023--overview.md) | GEFS paper | Motivation against CWFS/HJFS/fossil and the design summary: copy-on-write, atomic commits, Bεtrees, snapshots replacing dumps, block-hash corruption detection. |
| [gefs/betree-write-optimized-data-structure](../sections/papers--bernstein-gefs-good-enough-file-system-2023--betree-write-optimized-data-structure.md) | GEFS paper | The Bεtree: pivot-node write buffers, upsert messages, flush-to-victim, query-with-buffer-replay, blind upserts, copy-on-write-friendly block layout. |
| [gefs/mapping-the-file-system-onto-betrees](../sections/papers--bernstein-gefs-good-enough-file-system-2023--mapping-the-file-system-onto-betrees.md) | GEFS paper | A single flat key-value store (data/entry/up keys), qid-based path walking, range-scan directory listing — and the ambient-namespace-vs-attenuable-reference difference. |
| [gefs/snapshots-and-deadlist-space-reclamation](../sections/papers--bernstein-gefs-good-enough-file-system-2023--snapshots-and-deadlist-space-reclamation.md) | GEFS paper | Copy-on-write snapshots + labels; ZFS-style deadlists with birth generations; base-snapshot fix for mutable branching. |
| [gefs/crash-safety-commit-protocol-and-concurrency](../sections/papers--bernstein-gefs-good-enough-file-system-2023--crash-safety-commit-protocol-and-concurrency.md) | GEFS paper | Barrier-phased commit, arena header/footer two-phase commit, arena allocation, seven procs, epoch-based reclamation for lock-free reads. |
| [gefs/on-disk-format](../sections/papers--bernstein-gefs-good-enough-file-system-2023--on-disk-format.md) | GEFS paper | Superblocks, arena headers, allocation/deadlist logs, pivot/leaf blocks, key types, and upsert message opcodes. |

## See also

- [`content-addressed-storage`](content-addressed-storage.md): CASK's content-hash-addressed block store and dialog-db's prolly-tree storage — the content-addressed neighbor GEFS is compared against (GEFS does no content addressing, chunking, or dedup).
- [`data-structures`](data-structures.md): the tree/index machinery; the Bεtree is filed here too.
- [`persistence`](persistence.md): Endo's formula-graph value persistence — the capability-first naming model contrasted with GEFS's ambient qid namespace.
