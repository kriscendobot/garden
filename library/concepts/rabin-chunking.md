---
id: rabin-chunking
aliases: ["Rabin fingerprint", "Rabin chunking", "content-defined chunking", "rolling hash", "chunker", "blob chunking"]
topics: [content-addressed-storage]
status: draft
---

# rabin-chunking

Content-defined chunking: splitting a byte stream into blocks at boundaries chosen by a **rolling hash** (a Rabin fingerprint) of a sliding window, rather than at fixed byte offsets. Because boundaries follow content, inserting or deleting bytes in the middle of a stream shifts only the affected chunk's boundary, so a content-addressed store re-hashes O(log n) blocks rather than every block after the edit point. `kriskowal/cask` uses it in the `blob` package (`blob/chunker.go`) to store large byte streams as Merkle trees of 1KB blocks whose leaves are chosen this way.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | Blobs split byte streams with a Rabin-fingerprint rolling hash so mid-file edits invalidate O(log n) blocks. |

## See also

- [[merkle-tree-of-blocks]] — the tree blob leaves hang from.
- [[content-addressed-block-store]] — why localized invalidation matters for a content-addressed store.
