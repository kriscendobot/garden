---
title: Missing Links and Safe Insertion Order
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

> Abstract: Why missing links are normal and the write discipline that keeps the collector from sweeping in-flight blocks. Large trees are written **top-to-bottom** (root first, then children), so when the root block is stored its links may point to children not yet present; a concurrent mark Loads the root, follows links, and fails on the not-yet-written children. The safe rule: never treat "Load failed" as garbage (it might be in flight), and only delete blocks that exist *and* are unreachable. The safe write order has three parts: (1) **pin the root before or as you store the root block** (add the root hash to the root set), (2) **store blocks top-to-bottom** so traversal only follows links to already-stored or not-yet-stored blocks, and (3) **avoid bottom-to-top without a pinned root**, since a child stored before its (unpinned) root is reachable from nothing and a GC pass could sweep it. The summary table: top-to-bottom + pin-when-root-stored is safe; bottom-to-top is safe only if the root block is stored before any GC runs, and unsafe if children are stored before the root.

## Why missing links appear

When inserting a large tree (e.g. a big blob or directory), the writer typically produces blocks in **top-to-bottom** order: root first, then its children, then their children, etc. So at the moment the root block is stored, its Links may point to child hashes whose blocks are **not yet stored**. A concurrent (or later) mark phase will Load the root, get its links, then try to Load each child; for children not yet written, Load will fail. Those hashes are "missing links" from the collector's perspective.

## Safe rule for the collector

- **Do not** treat "Load failed" as "this hash is garbage." It might be in flight.
- **Only** delete blocks that (1) exist in the store and (2) are not in the retained set (reachable from roots via successful Loads).

So a block not in the store is never deleted (there's nothing to delete). A block in the store is deleted only if it is not reachable from any root by following links through blocks that Load successfully. If a root points to a child that isn't in the store yet, the child is not in Retained; when the client later stores the child, the next mark will traverse to it (from the root) and add it to Retained, so the next sweep will not delete it.

## Order of insertion for writers

1. **Pin the root before or as you store the root block** — add the root hash to the root set (e.g. insert into cask/set) either before the first `Store(rootHash, rootBlock, ...)` or in the same logical "commit." Then any GC run will see that root as pinned and will Load it.
2. **Store blocks top-to-bottom** — after storing the root (and pinning it), store children, then their children. So whenever the collector traverses from a root, it will only follow links to blocks already stored (or not yet stored; in the latter case it does nothing for that link).
3. **Avoid bottom-to-top without a pinned root** — if you store a child block before the root block and do not yet have the root in the root set, the child is not reachable from any root; a GC run could mark nothing and then sweep the child away.

### Summary table

| Order              | Root pinned when?      | Result |
|--------------------|------------------------|--------|
| Top-to-bottom      | When root block stored | Safe: root retained; children retained as they appear. |
| Bottom-to-top      | Before any block       | Safe only if root block is stored before GC runs. |
| Bottom-to-top      | After children stored  | Unsafe: children may be swept before root is stored. |

So the **recommended** pattern for higher-level operations (blob write, directory write, etc.) is: build the tree (or stream it) and **store blocks in top-to-bottom order** (root first, then descendants); **pin the root** (add to root set) as soon as the root block is stored (or in the same transaction/batch); then store the rest of the tree, and the collector will retain new blocks as they become reachable from the root.

Source: [doc/design/store-gc-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/store-gc-design.md) at commit `cdb975d8`.
