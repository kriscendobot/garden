---
id: merkle-tree-of-blocks
aliases: ["Merkle tree", "Merkle DAG", "hash tree", "merkle", "hashtree", "arraytree", "32-way trie", "Merkle disturbance", "tree sync", "TREE command", "leaf-to-root path"]
topics: [content-addressed-storage, networking]
status: current
---

# merkle-tree-of-blocks

A tree (or DAG) whose nodes are content-addressed blocks: each node holds the hashes of its children, so a node's hash commits to its entire subtree, and a change anywhere re-hashes only the path to the root. In `kriskowal/cask` every higher-level data structure is a Merkle tree of 1KB blocks: blobs (Rabin-chunked byte streams), directories (name-ordered trees of entries), arrays (dense 32-way tries via `arraytree`), and maps/sets (sparse 4-level 32-way hash tries via `hashtree`). The shared block format is what lets one content-agnostic garbage collector serve all of them, and lets a mid-structure edit disturb only O(log n) blocks.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | Blobs, directories, arrays, maps, and sets are all trees of 1KB blocks; GC needs only metadata. |
| [cask--readme--package-taxonomy](../sections/cask--readme--package-taxonomy.md) | `arraytree` (dense, index-keyed) and `hashtree` (sparse, hash-keyed) are the trie backbones under the data-structure packages. |
| [cask--readme--why-1kb-blocks](../sections/cask--readme--why-1kb-blocks.md) | A block is simultaneously a Merkle node and a unit of transfer. |
| [cask--architecture--layer-2-merkle-tree-and-filesystem](../sections/cask--architecture--layer-2-merkle-tree-and-filesystem.md) | The TREE command (SYNC/DIFF/WALK/GC) and a GC-transparent filesystem of Merkle-tree directories and files. |
| [cask--parallel-arrays--persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | Reducers minimize Merkle disturbance by modifying a single leaf-to-root path; 32-way tries keep depth shallow. |

## See also

- [[content-addressed-block-store]] — the store these trees live in.
- [[rabin-chunking]] — how blob leaves are chosen so edits are local.
- [[cask-reducer-pattern]] — operations written to disturb only one path of the tree.
- [[parallel-arrays-columnar]] — the table structures built over arraytree/hashtree backbones.
