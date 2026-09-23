---
title: Mark and Sweep
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

> Abstract: The two-phase collection over a wrapped backing store. **Mark** starts from the root set and computes `Retained` = the set of hashes reachable by following Links through blocks that successfully Load: for each root, Load it (skip if Load fails — we cannot traverse from it), add to Retained, then recurse into each link, again adding only links whose block Loads. A link whose Load **fails** is the **missing-link** case — not added to Retained and not deleted, because we only consider for deletion blocks that actually exist in the store. **Sweep** then enumerates all stored hashes and deletes every block not in Retained. Enumerating stored hashes is done one of three ways: **Option A** the wrapper maintains an index of all hashes ever stored (requires being the sole writer and persisting/rebuilding the index); **Option B** the backing store supports List/Scan (e.g. diskstore walks the directory); or **Option C** copy-forward — don't delete; copy each retained block to a fresh store and swap, touching only retained blocks at the cost of extra space.

## Mark: traversing from roots

**Input**: root set (hashes considered pinned), backing store.

1. **Retained** = empty set of `cask.Hash`.
2. For each root hash **R** in the root set:
   - If R is already in Retained, skip.
   - **Load(R)** from the backing store. If Load **fails** (e.g. not found, context deadline): do **not** add R to Retained (we can't traverse from it); continue to the next root.
   - Add R to Retained.
   - For each link **L** in the block's Links:
     - If L is already in Retained, skip.
     - **Load(L)** from the backing store. If Load **fails**: **do not add L to Retained.** This is the **missing link** case — the block referenced by L is not in the store yet (e.g. tree being written top-to-bottom). We do not treat L as retained, but we also do not delete L (we only consider for deletion blocks that *exist* in the store). So no action.
     - If Load succeeds, add L to Retained and recurse (process L's block's links).
3. Return Retained.

So **retained** = the set of hashes reachable from some root by following links, where every step uses a block that successfully Loads. Any hash that is a link from a retained block but whose Load failed is **not** in Retained; such a hash might be "in flight" (will be stored later) or truly missing.

## Sweep: deleting unreachable blocks

**Input**: Retained set (from Mark), backing store, and a way to enumerate **all hashes currently in the store**.

1. For each hash **H** in the set of stored hashes:
   - If H is in Retained, do nothing.
   - Else **delete** the block for H from the backing store (and remove H from the stored-hash index if maintained).

We only delete blocks that (1) exist in the store and (2) are not in the retained set. We never delete a block "because it's missing"; we only delete blocks we can see and that are unreachable.

### Enumerating stored hashes

- **Option A**: The wrapper maintains an **index** of all hashes ever stored. On every `Store(hash, ...)`, add hash to the index; on Sweep, delete from the backing store and remove from the index. This requires the wrapper to own the only writer to the backing store and to persist the index (or rebuild it by scanning).
- **Option B**: The backing store supports **List** or **Scan** (e.g. diskstore can walk the directory). Then Sweep enumerates stored hashes by listing the store. No index in the wrapper.
- **Option C**: **Copy-forward** — Don't delete. Instead, create a new store; for each root, traverse the retained set and copy each retained block to the new store; then swap the new store for the old. No need to list all blocks; only retained blocks are touched. Downside: requires space for the new store and a way to swap.

Source: [doc/design/store-gc-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/store-gc-design.md) at commit `cdb975d8`.
