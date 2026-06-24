---
id: rabin-chunking
aliases: ["Rabin fingerprint", "Rabin chunking", "content-defined chunking", "rolling hash", "chunker", "blob chunking", "rabin_sorted", "Rabin-bounded sorted index", "content-defined index boundaries"]
topics: [content-addressed-storage, data-structures]
status: current
---

# rabin-chunking

Content-defined chunking: splitting a byte stream into blocks at boundaries chosen by a **rolling hash** (a Rabin fingerprint) of a sliding window, rather than at fixed byte offsets. Because boundaries follow content, inserting or deleting bytes in the middle of a stream shifts only the affected chunk's boundary, so a content-addressed store re-hashes O(log n) blocks rather than every block after the edit point. `kriskowal/cask` uses it in the `blob` package (`blob/chunker.go`) to store large byte streams as Merkle trees of 1KB blocks whose leaves are chosen this way. The same content-defined-boundary trick is reused for **sorted indexes**: serializing (key, slot) records and Rabin-chunking them yields a sorted index with B-tree query performance but no rebalancing, because a local insert or delete re-chunks only the affected region while the deterministic boundaries preserve the reducer property.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | Blobs split byte streams with a Rabin-fingerprint rolling hash so mid-file edits invalidate O(log n) blocks. |
| [cask--parallel-arrays--rabin-bounded-sorted-indexes](../sections/cask--parallel-arrays--rabin-bounded-sorted-indexes.md) | Rabin-chunked (key, slot) records give B-tree queries without rebalancing; local re-chunk, no cascade. |

## See also

- [[merkle-tree-of-blocks]] — the tree blob leaves hang from.
- [[parallel-arrays-columnar]] — the table whose sorted indexes can be Rabin-bounded.
- [[cask-reducer-pattern]] — deterministic Rabin boundaries keep index transforms reducer-pure.
- [[content-addressed-block-store]] — why localized invalidation matters for a content-addressed store.
