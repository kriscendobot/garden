---
title: Higher-Level Operations and Root-Set Retention
source: doc/design/store-gc-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: How blob/dir writers, multi-root references, and the root set itself fit the GC'd store, plus the recursive question of who retains the root set. Blob writers (which may emit leaves-first) must either emit root-first or buffer the whole tree and write top-to-bottom, pinning the root when the root block is written; directory writes follow the same store-root-first-then-children discipline. Multi-root applications ("main", "draft", "backup") keep each as a separate cask/set entry; pinning adds the root hash, unpinning removes it so the next mark drops its subtree. The **store-tree-then-pin-root** step should be atomic (or the set updated immediately after the root block is stored), else a GC between the two could sweep the just-stored-but-unpinned root. Finally, the root set is itself a trie of CASK blocks with its own root hash that must be retained: either keep the root set **outside the collectable backing store** (in memory or a separate non-GC'd store, the simplest approach), or store it inside and define a fixed **meta root** that the collector always retains so the set's trie is never swept.

## Blob write (e.g. cask/blob)

Blob writes typically produce a chain or tree of blocks; the "root" is the last block (or the single block for small blobs). Today the writer may produce blocks in any order (e.g. leaves first, then internal nodes). To work safely with the GC store:

- **Option 1**: Change the writer to emit blocks **root-first** (e.g. internal nodes before leaves, root last so it's stored last — but then "pin when root is stored" is natural). Or emit in an order that guarantees the root is stored first (e.g. depth-first from root).
- **Option 2**: Buffer the whole tree in memory (or temp store), then write blocks in top-to-bottom order and pin the root when the root block is written. This avoids changing the blob writer's internal order but uses more memory.

So blob (and similar) writers should either emit blocks in an order where the root is stored first and then pin the root, or buffer and write in that order.

## Directory write (e.g. cask/dir)

Same idea: the directory tree has a root block. Store the root first (or ensure it's stored and pinned before children are visible to GC), then store children. Directory construction should follow top-to-bottom store order and pin the root when stored.

## Multi-root / named references

If the application keeps multiple roots (e.g. "main", "draft", "backup"), each is a separate entry in the root set. Pinning a new root means: (1) the root block (and ideally its subtree) is stored, (2) add that root hash to the root set. Unpinning removes it from the root set; the next mark will not traverse from it, and unreachable blocks will be swept.

## Atomicity of "store tree + pin root"

Ideally "store root block" and "add root to root set" are atomic (or the root set is updated immediately after the root block is stored). Otherwise a GC run could happen after the root block is stored but before the root is added to the set; the root would not be retained and could be swept. So the wrapper or a higher layer should either update the root set in the same operation as storing the root block, or ensure GC never runs between "store root" and "pin root" (e.g. single-threaded writer, or a short critical section).

## Root-set storage and its own retention

The root set (cask/set) is a trie stored as CASK blocks in some store, so the root set has a **root hash** (the trie root) that must itself be retained; otherwise the collector could sweep the blocks that make up the set. Options:

- **Fixed "meta" root**: A well-known root (a reserved hash, or a file/slot in the backing store) is always considered pinned; the root set's root hash is stored there (or the root set lives in a namespace the collector never sweeps). The collector either does not sweep blocks that are part of the root set's trie, or the root set's root is stored outside the collectable store.
- **Bootstrap**: The root set's root hash is the only "meta" root; the collector always retains it and traverses from it (and from user roots stored inside the set). This implies the root set trie is stored in the same backing store and the meta root is fixed.

A simple approach: the **wrapper** maintains the root set in memory (or in a separate small store that is not GC'd); the backing store is the one we sweep, so the root set's blocks are external and need no retention inside the backing store. Alternatively, the root set is stored in the backing store and a **meta root** (a single block whose hash is stored in a fixed place) is always included in the mark, so the root set trie is always retained.

## Summary

- **Store wrapper** + **root set (cask/set)** + **mark/sweep** gives a GC'd store that retains only blocks reachable from pinned roots.
- **Mark** traverses from roots via Load and Links; **Load failure** (missing link) is normal during top-to-bottom insertion — we do not add that hash to retained and we do not delete it.
- **Sweep** deletes every stored block whose hash is not in the retained set; requires a way to list stored hashes (index, List, or copy-forward).
- **Writers** should store trees **top-to-bottom** and **pin the root** when (or before) the root block is stored.
- **Higher-level** operations (blob, dir) should emit/store blocks in root-first (or top-to-bottom) order and pin the root as part of the write.
- **Root set retention**: either keep the root set outside the collectable store, or retain it via a fixed meta root.

Source: [doc/design/store-gc-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/store-gc-design.md) at commit `cdb975d8`.
