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
| [cask--dir-design-v2--goals-and-rabin-chunked-entries-tree](../sections/cask--dir-design-v2--goals-and-rabin-chunked-entries-tree.md) | caskdir v2's entries tree: name-sorted entries with Rabin boundaries over the 32-byte name hash. |
| [cask--dir-design-v2--navigation-and-mutation-algorithms](../sections/cask--dir-design-v2--navigation-and-mutation-algorithms.md) | Insert/Delete re-chunk only the affected region at Rabin boundaries, keeping distant blocks unchanged. |

## See also

- [[caskdir-directory-format]] — the directory whose v2 entries tree is Rabin-chunked.
- [[merkle-tree-of-blocks]] — the tree blob leaves hang from.
- [[parallel-arrays-columnar]] — the table whose sorted indexes can be Rabin-bounded.
- [[cask-reducer-pattern]] — deterministic Rabin boundaries keep index transforms reducer-pure.
- [[content-addressed-block-store]] — why localized invalidation matters for a content-addressed store.
