---
id: gc-quarantine-store
aliases: ["GC quarantine", "quarantine store", "CollectorStore", "CollectibleStore", "collectorstore", "diskcollectorstore", "mark and sweep", "mark-and-sweep", "snapshot GC", "install-after-store", "root swap", "RootRef", "quarantine flush", "WAL quarantine", "diskHashSet", "mark set", "retained set", "RetainSet", "content-agnostic GC", "pinned roots", "missing link", "copy-forward", "cask GC", "garbage collection"]
topics: [content-addressed-storage]
status: current
---

# gc-quarantine-store

CASK's family of designs for garbage-collecting a content-addressed block store **concurrently with writes** by quarantining new writes during the collection pass. The shared shape: take a single **root snapshot** at GC start, **mark** every block reachable from that root by following each block's Links (a failed Load is a normal *missing link*, treated as in-flight, never as garbage), **sweep** every stored block not in the retained set, and route all writes made *during* GC into a **quarantine** that is flushed into the primary store only after the sweep — so a block written after the snapshot is never swept. The governing safety rule is **install-after-store**: a new root may be published only after all blocks reachable from it are fully stored (including the quarantine flush). CASK realizes the quarantine two ways: an **in-memory CollectorStore** wrapping a primary plus a quarantine store (e.g. diskstore + memstore; the `collectorstore`/`diskcollectorstore` packages), and a **WAL quarantine** in caskdbstore where `Store()` is routed to a write-ahead log during GC and the consolidated hashmap *is* the snapshot. The mark set itself can spill to disk (`diskHashSet`) so it never needs to fit in memory and never pollutes the main store. This is the storage-side counterpart of the README's "content-agnostic GC" claim: because each block's link structure lives in its metadata, the collector walks the retention graph without parsing block content.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--gc-and-retention--overview-and-two-regimes](../sections/cask--gc-and-retention--overview-and-two-regimes.md) | The two retention regimes (pinned roots vs deadline) GC operates over. |
| [cask--gc-and-retention--pinned-roots-hash-trie](../sections/cask--gc-and-retention--pinned-roots-hash-trie.md) | Roots in a hash-trie; mark-from-roots + sweep-unreachable; snapshot+chain optimization. |
| [cask--gc-concurrent-design--snapshot-gc-with-quarantine](../sections/cask--gc-concurrent-design--snapshot-gc-with-quarantine.md) | The CollectorStore (primary + quarantine) data model and the snapshot/mark/sweep/flush algorithm. |
| [cask--gc-concurrent-design--concurrency-invariants-and-root-swaps](../sections/cask--gc-concurrent-design--concurrency-invariants-and-root-swaps.md) | The seven invariants (install-after-store, snapshot safety, epoch monotonicity, quarantine visibility). |
| [cask--gc-concurrent-design--proposed-tests](../sections/cask--gc-concurrent-design--proposed-tests.md) | Tests asserting retention under concurrent root swaps across blob/dir/array. |
| [cask--store-gc-design--mark-and-sweep](../sections/cask--store-gc-design--mark-and-sweep.md) | Mark (Links via successful Loads) + sweep; index/List/copy-forward enumeration. |
| [cask--store-gc-design--missing-links-and-insertion-order](../sections/cask--store-gc-design--missing-links-and-insertion-order.md) | Why "Load failed" ≠ garbage; pin-root-when-stored + top-to-bottom write order. |
| [cask--store-gc-design--higher-level-ops-and-root-set-retention](../sections/cask--store-gc-design--higher-level-ops-and-root-set-retention.md) | Blob/dir write order; multi-root pins; how the root set retains itself (meta root). |
| [cask--dbstore-design--operations-store-load-cas-collect](../sections/cask--dbstore-design--operations-store-load-cas-collect.md) | The WAL-as-quarantine mark-and-sweep with an on-disk diskHashSet mark set. |
| [cask--readme--content-agnostic-gc](../sections/cask--readme--content-agnostic-gc.md) | GC walks the retention graph from pinned roots using only block metadata. |

## See also

- [[content-addressed-block-store]] — the store whose blocks this GC collects.
- [[swap-to-end-allocation]] — the allocator caskdbstore frees swept slots back into.
- [[merkle-tree-of-blocks]] — the link structure mark traverses.
- [[cask-reducer-pattern]] — root swaps produce new root hashes the snapshot reads atomically.

## Common confusions

- **Two quarantine realizations, one pattern.** The in-memory `CollectorStore` (primary + quarantine store, `gc-concurrent-design.md`) and caskdbstore's WAL quarantine (`dbstore-design.md`) are the same install-after-store idea at different layers; do not read them as competing designs.
- **A failed Load is not garbage.** Because large trees are written top-to-bottom, the mark phase routinely fails to Load not-yet-written children. Sweep only ever deletes blocks that *exist* and are unreachable; missing blocks are simply skipped.
