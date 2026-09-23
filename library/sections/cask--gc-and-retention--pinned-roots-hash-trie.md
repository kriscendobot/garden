---
title: Pinned Content — Roots, Hash-Trie, and Snapshot+Chain
source: doc/design/gc-and-retention.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The on-disk pinned-retention regime. The set of root hashes is held in a **hash-trie** (HAMT) keyed by the 32-byte root hashes themselves: add/remove roots are O(log n), the structure is persistent so a "current" view shares most of the tree across updates, and iteration walks the trie. "Pinned" means exactly "in this trie"; nothing else is pinned by structure alone. The **retained set** is *not* held by the trie — it is computed on demand by graph traversal: a **mark** phase loads each root, follows its block's Links transitively, and marks every reachable hash, after which a **sweep** phase deletes any stored block that was not marked. To avoid recomputing the full retained set every GC, retention can be modeled as a last snapshot plus a chain of operations (roots pinned/unpinned, new blocks stored) that is periodically merged into a new snapshot; the trie remains the source of truth for what is pinned while the snapshot+chain is an on-disk optimization.

## Goal

Retain every block that is reachable from at least one **root** hash. Roots are "pinned" by the application (e.g. current head of a tree, named references). Unreachable blocks may be garbage-collected.

## Root set: hash-trie

We need a structure that stores the set of root hashes (add / remove / membership), supports efficient iteration over roots when computing the retained set, and handles a changing set of roots without copying the whole structure. A **hash-trie** (e.g. HAMT — hash array mapped trie) is a good fit:

- Keys are root hashes (32 bytes); no separate key type.
- Add and remove roots are O(log n) in the number of roots.
- Structure is persistent/functional: updates share most of the tree, so we can keep a "current" view and update it as roots are pinned or unpinned.
- Iteration over all roots is straightforward (walk the trie).

So the **top-level** structure is a hash-trie whose keys are the root hashes. "Pinned" = in this trie. Nothing else in the CAS is considered pinned by structure alone; retention is derived from this set.

## Retained set

**Retained** = union over all roots of the transitive closure of "reachable from this root": for each root hash, Load the block, get its Links, recurse on each link; leaves (blocks with no links) end the recursion. So we need a **mark** phase: from the current root set, traverse the graph (using the Store's Load and each block's Links) and mark every hash reached. Then a **sweep** phase deletes any block that exists in the store but is not marked. Sweep requires either a way to **list** all stored hashes (e.g. diskstore scans the block directory, or we maintain an index of all stored hashes), or a different strategy (e.g. copy-forward: only write retained blocks to a new location, then swap).

The hash-trie does **not** hold the retained set; it holds only the roots. The retained set is computed by graph traversal from those roots whenever we run GC.

## Snapshot + chain of operations (on-disk)

To avoid recomputing the full retained set from scratch on every GC, retention can be modeled as a **last snapshot** (a representation of the retained set, or of the root set plus some cached reachability, at the time of the last full GC) plus a **chain of operations since then** (new roots pinned, roots unpinned, new blocks stored). Periodically — when the chain gets long, or on a timer — we **update the tree**: recompute retained from the current root set (or merge the chain into the snapshot); that becomes the new snapshot and the chain resets. Between full updates, incremental work can mark new blocks reachable from existing retained or from new roots without a full traversal. This keeps full traversals rare while still allowing the root set to change. The hash-trie for roots is the source of truth for "what is pinned"; the snapshot + chain is an optimization for on-disk GC.

Source: [doc/design/gc-and-retention.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-and-retention.md) at commit `cdb975d8`.
