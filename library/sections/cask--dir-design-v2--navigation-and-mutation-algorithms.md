---
title: Navigation and Mutation Algorithms
source: doc/design/dir-design-v2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: The lookup, insert, and delete algorithms over the v2 Rabin-chunked entries tree. **Lookup(name)** computes `name_hash = SHA256(name)`, descends from the root binary-searching min-key blocks at each internal node (`min_key ≤ name < next_min_key`), then binary-searches the target chunk; complexity O(log n) node loads + O(log c) within-chunk. A modest LRU cache over the small, frequently-reused min-key and name blocks sharply reduces loads after the first lookup. **Insert** navigates to the insertion point, inserts maintaining sort order, re-chunks if the chunk exceeds max_chunk (split at Rabin boundaries), then updates the tree path to the root; only chunks near the insertion point change, so distant internal nodes keep their hashes. **Delete** navigates, removes, re-chunks if the chunk falls below min_chunk (merge with a neighbor and re-apply Rabin boundaries), then updates the path. Both return a new root hash.

## Lookup(name) → (Entry, bool)

```
1. Compute name_hash = SHA256(name)
2. Navigate tree from root:
   a. Load internal node
   b. For each min_key_hash: if cached, compare cached key to name; else load key block, cache, compare
   c. Binary search to find child where min_key ≤ name < next_min_key
   d. Descend to child; repeat until reaching a chunk
3. At chunk:
   a. Binary search entries by loading name hashes and comparing
   b. If found, return entry (hash, mode, name); else return (_, false)
```

**Complexity**: O(log n) node loads + O(log c) within-chunk search. **Caching**: min-key blocks and name blocks are small and frequently reused; a modest LRU cache dramatically reduces loads after the first lookup.

## Insert(name, hash, mode) → new_root

```
1. Navigate to find insertion point (as in Lookup)
2. Load target chunk
3. Insert entry maintaining sort order
4. Re-chunk if needed:
   a. If chunk exceeds max_chunk, split at Rabin boundaries
   b. Compute new min-keys for resulting chunks
5. Update tree path: for each affected internal node, update child hash and min-key; propagate to root
6. Return new root hash
```

**Locality**: only chunks near the insertion point are affected; distant chunks retain their hashes, so distant internal nodes are unchanged.

## Delete(name) → new_root

```
1. Navigate to find entry (as in Lookup)
2. If not found, return current root (no change)
3. Load target chunk; remove entry
4. Re-chunk if needed:
   a. If chunk falls below min_chunk, merge with neighbor
   b. Re-apply Rabin boundaries to merged region
5. Update tree path (as in Insert)
6. Return new root hash
```

Source: [doc/design/dir-design-v2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design-v2.md) at commit `cdb975d8`.
