---
id: gefs
aliases: ["GEFS", "Good Enough File System", "gefs9", "Plan 9 file system", "9p file system", "deadlist", "deadlist algorithm", "birth generation", "epoch-based reclamation", "snapshot tree", "qid namespace", "copy-on-write file system", "CWFS", "HJFS", "fossil venti"]
topics: [file-systems]
status: current
---

# gefs

**GEFS** is Ori Bernstein's copy-on-write file system for Plan 9: a traditional 9p interface over a forest of [[betree|Bεtrees]], prioritizing (in order) crash safety, corruption detection, simplicity, and fast snapshotting. All file-system state lives in a **single flat key-value store** — no directory structures or indirect blocks — using data keys (qid+offset → block), entry keys (dir-qid+name → stat), and up keys (dir-qid → parent). It is crash-safe *by construction*: data and metadata are copied on write with atomic commits, so a crash exposes the last synced commit rather than corruption; block pointers carry a hash for corruption detection; snapshots (every 5 s, immutable, human-labelled) replace archival dumps and are reclaimed with a ZFS-style **deadlist** algorithm keyed on per-block birth generations; a barrier-phased commit protocol and **epoch-based reclamation** give durability and lock-free reads. It aims to be "good enough for daily use," not optimal on every axis.

## Comparison with capability-oriented / content-addressed stores

This concept exists mainly to hold the cross-reference the maintainer asked for (request 2026-09-18). Answers to the ingest's guiding questions:

- **On-disk structure & chunking (Q1/Q2).** Merkelized copy-on-write Bεtree over fixed-size, disk-*located* blocks. Block pointers carry a hash for corruption detection, **not** as the block's identity — so there is **no content addressing and no deduplication**, unlike CASK ([[content-addressed-storage-backend]], [[cask-block-backbones]]), where the hash *is* the address and identical content dedups for free. GEFS also does **no content-defined chunking**; that absence is itself the finding against CASK's Rabin approach ([[rabin-chunking]]).
- **Snapshots & GC (Q3).** ZFS deadlists sharded by birth generation, merged on snapshot delete, no whole-disk scan; a base-snapshot concept keeps mutable branching from double-freeing. Compare CASK's snapshot GC with mandatory write quarantine (`cask--gc-concurrent-design--snapshot-gc-with-quarantine`) — same goal (reclaim without stopping the world or corrupting readers), different method.
- **Crash consistency (Q4).** Copy-on-write + a barrier-separated commit whose superblock write is the commit point, arena header/footer as mutual backups, block hashes for detection. The "never expose a root pointing at not-yet-durable data" invariant matches CASK's atomic-root-swap discipline.
- **VFS modeling & naming (Q5) — the difference to name.** GEFS resolves paths by **constructing keys** (concatenate a directory qid with the next name) inside **one ambient namespace**; any holder of the metadata tree can name and reach any file. Authority is *ambient over the namespace*. The garden models a VFS **capability-first**: Endo's [[formula-graph]] names durable objects by formula identity, pet names are per-agent bindings (not ambient paths), and attenuation hands out *narrowed* references — the read-only directory attenuation (`endojs/endo-but-for-bots#1304`) and ReadableBlob range attenuation (`#826`) give a holder read-but-not-write, or one byte range, with no way to widen by naming a sibling. **GEFS assumes ambient authority over a namespace; the garden assumes attenuable references.** CASK's cell capabilities ([[cask-entry-type-capability]]) pursue the same attenuable model on a content-addressed store.
- **Adoptable vs incompatible (Q6).** Adoptable by a capability store: the flat qid keyspace as a substrate, birth-generation deadlists, and epoch-based reader/writer reclamation are all capability-neutral machinery. Structurally incompatible: **resolution-by-key-construction** — exposing it directly would let any holder mint the key for any path and so hold ambient authority, defeating attenuation.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gefs/overview](../sections/papers--bernstein-gefs-good-enough-file-system-2023--overview.md) | Motivation (CWFS/HJFS/fossil), the four priorities, and the copy-on-write + Bεtree + snapshot + block-hash design summary. |
| [gefs/mapping-the-file-system-onto-betrees](../sections/papers--bernstein-gefs-good-enough-file-system-2023--mapping-the-file-system-onto-betrees.md) | The single flat key-value store: data/entry/up keys, qid-based path walking, range-scan directory listing — and the ambient-vs-attenuable difference. |
| [gefs/snapshots-and-deadlist-space-reclamation](../sections/papers--bernstein-gefs-good-enough-file-system-2023--snapshots-and-deadlist-space-reclamation.md) | Immutable snapshots + labels; ZFS deadlists with birth generations; base-snapshot fix for mutable branching. |
| [gefs/crash-safety-commit-protocol-and-concurrency](../sections/papers--bernstein-gefs-good-enough-file-system-2023--crash-safety-commit-protocol-and-concurrency.md) | Barrier-phased commit, arena header/footer two-phase commit, arena allocation, seven procs, epoch-based reclamation. |
| [gefs/on-disk-format](../sections/papers--bernstein-gefs-good-enough-file-system-2023--on-disk-format.md) | Superblocks, arena headers, allocation/deadlist logs, pivot/leaf blocks, key types, and message opcodes. |

## See also

- [[betree]] — the write-optimized tree GEFS is built on.
- [[content-addressed-storage-backend]] — dialog-db / CASK content addressing; GEFS is merkelized but *not* content-addressed (no dedup).
- [[rabin-chunking]] — content-defined chunking; GEFS deliberately does none.
- [[formula-graph]] — Endo's capability-first persistence and naming; the attenuable-reference counterpart to GEFS's ambient qid namespace.
- [[cask-entry-type-capability]] — CASK's move toward attenuable (read-only, path-scoped) references over a store.
