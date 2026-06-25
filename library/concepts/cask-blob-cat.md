---
id: cask-blob-cat
aliases: ["cask/blob", "cask blob", "blob-design", "content-addressed tree", "CAT", "content-defined chunked Merkle tree", "anchor tree", "CDC at higher levels", "internal-level chunking", "MinChunk", "MaxChunk", "AvgChunk", "MinLinks", "MaxLinks", "size table", "subtree size table", "blob random access", "blob leaf block", "blob internal block", "28-way fanout"]
topics: [content-addressed-storage]
status: current
---

# cask-blob-cat

CASK's **content-defined chunked (CDC) Merkle tree** for large byte streams (the `cask/blob` package, "CAT"), tuned for the 1KB block so that random access to a byte offset is O(tree height) and chunk boundaries stay stable under mid-stream insertions. The block role is read straight from go/cask's 12-byte metadata footer: a **leaf** (height 0, numLinks 0) stores `data[0:dataLen]` plus zero padding the hash ignores; an **internal** node (height > 0) stores k child hashes plus a compact 4-byte-per-entry subtree-size table, with fanout capped at `k <= 28` because `32*k + 4*k <= 1024`. Leaves are cut by a rolling hash (Rabin/buzhash-style) whose state is **never reset** at a boundary, which is what makes a local edit perturb only nearby chunking and then "re-lock"; the same CDC is applied at **internal levels** over concatenated child entries (`hash || size`, honored only after a whole entry and once MinLinks is met, with MaxLinks always enforced) to form a stable **anchor tree** where changes remain local at every level. Random access descends the per-node size tables, subtracting preceding sizes; the tree holds no global metadata, so the caller keeps the root hash, the total size, and any chunking parameters. This is the concrete blob realization of [[merkle-tree-of-blocks]] and the per-leaf and per-level application of [[rabin-chunking]].

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--blob-design--block-format-and-limits](../sections/cask--blob-design--block-format-and-limits.md) | The leaf (height 0, dataLen + padding) and internal (k links + 4-byte size table, k ≤ 28) block formats over the 1024+12 layout, and the limits. |
| [cask--blob-design--content-defined-chunking-and-random-access](../sections/cask--blob-design--content-defined-chunking-and-random-access.md) | Leaf-level CDC (no-reset rolling hash, re-lock), the internal-level anchor tree, and O(tree height) random access via the size tables. |
| [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | Blobs split byte streams with a Rabin-fingerprint rolling hash so mid-file edits invalidate O(log n) blocks. |

## See also

- [[merkle-tree-of-blocks]] — the general tree-of-1KB-blocks shape blobs concretize.
- [[rabin-chunking]] — the content-defined-boundary rolling hash, here applied at both leaf and internal levels.
- [[content-addressed-block-store]] — why localized invalidation under edits matters for the store.
- [[cask-reducer-pattern]] — deterministic CDC boundaries keep blob mutations reducer-stable.
