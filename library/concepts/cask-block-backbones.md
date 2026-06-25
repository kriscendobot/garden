---
id: cask-block-backbones
aliases: ["hashtree", "arraytree", "block backbone", "32-way trie", "sparse trie", "dense tree", "ZeroHash", "adaptive index width", "hashtreetouint8", "hashtreetouint16", "hashtreetouint32", "hashtreetouint64", "StoreLinkLeaf", "StoreLeaf", "DigitLSB", "LoadRootLE"]
topics: [data-structures, content-addressed-storage]
status: current
---

# cask-block-backbones

The two internal 32-way tree implementations every CASK block structure builds on. **`hashtree`** is a sparse, associative trie of fixed 4-level depth (20 bits of key space via 5 bits × 4 levels), keyed by arbitrary 32-bit hash values; most slots hold `ZeroHash`, it supports deletion with automatic node collapsing, and it backs `map` and `set`. **`arraytree`** is a dense, sequential tree of variable depth that grows with array length, keyed by contiguous indexes; leaves are fully packed, there is no deletion (append-only, set-in-place), and it backs `array` and the `uint*array`/`int*array` packages. `array` and `uint*array` share `arraytree` but differ in leaf storage (Links in `cask.Model` nodes via `StoreLinkLeaf` vs packed bytes in `cask.Block` leaves via `StoreLeaf`) and, for backwards compatibility, in endianness and digit order (`array`: little-endian length, LSB-first digits, `LoadRootLE`/`DigitLSB`; `uint*array`: big-endian length, MSB-first digits, `LoadRoot`/`Digit`). The related **adaptive index width** family `hashtreetouint8/16/32/64` shares one 4-level trie layout differing only in leaf value width and sentinel, so a byKey index uses the narrowest leaf that fits its capacity (≤255 → uint8 with 32-byte leaves, up to uint64 with 256-byte leaves).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--package-taxonomy--hashtree-vs-arraytree](../sections/cask--package-taxonomy--hashtree-vs-arraytree.md) | Sparse-associative vs dense-sequential backbones; how array/uint*array share arraytree. |
| [cask--package-taxonomy--package-categories](../sections/cask--package-taxonomy--package-categories.md) | The backbones and the adaptive-width hashtreetouint* family in the taxonomy. |
| [cask--parallel-arrays--compact-index-representation](../sections/cask--parallel-arrays--compact-index-representation.md) | Adaptive 1/2/4/8-byte index width with hysteresis; positional-link table roots. |
| [cask--readme--columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | Adaptive-width tries that minimize Merkle-tree disturbance. |
| [cask--array-design--compact-trie-layout-and-capacity](../sections/cask--array-design--compact-trie-layout-and-capacity.md) | The `arraytree` backbone in full: one 32-slot block per node, height-in-metadata distinguishing leaf from internal, `32^(D+1)` capacity, a separate array-root block carrying the length. |
| [cask--allocator-design--hashtreetouint-and-index-heap](../sections/cask--allocator-design--hashtreetouint-and-index-heap.md) | `hashtreetouint64`: the hashtree trie with leaves packing 32 × uint64 instead of hash Links; the adaptive uint8/16/32/64 width family and MaxUint64 sentinel. |

## See also

- [[merkle-tree-of-blocks]] — the content-addressed tree these backbones realize.
- [[parallel-arrays-columnar]] — the columnar structures `arraytree` backs.
- [[rabin-chunking]] — the chunking approach for sorted arrays, a sibling backbone strategy.
- [[cask-operational-transform]] — the Keep/Skip/Inject primitive that rebuilds an `arraytree`.
