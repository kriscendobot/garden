---
id: prolly-tree
aliases: [prolly tree, prolly trees, probabilistic b-tree, probabilistic b-trees, content-defined tree, deterministic tree layout]
topics: [content-addressed-storage, local-first-sync]
---

# prolly-tree

A **Probabilistic B-Tree** (Prolly Tree) is a content-addressed search tree whose structure is a deterministic function of its data rather than of insertion order: node boundaries are chosen by a content-defined chunking rule, so the same set of keys always yields the same tree, node-for-node, on every replica. Nodes are addressed by the hash of their content. This buys cheap change detection and synchronization: two replicas holding the same facts hold byte-identical trees, so diffing their roots isolates exactly the differing subtrees to transfer. Dialog uses Prolly Trees for its EAV/AEV/VAE indexes; it is the tree analogue of a Rabin-chunked content-addressed structure.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments](../sections/dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments.md) | Deterministic content-addressed layout + segments; only modified subtrees sync. |
| [dialog-db--notes-architecture-overview--eav-aev-vae-indexing](../sections/dialog-db--notes-architecture-overview--eav-aev-vae-indexing.md) | Three Prolly-Tree indexes keyed by different column orderings cover all query patterns. |

## See also

- [[merkle-crdt]] — the causal-DAG merge semantics layered over the content-addressed tree.
- [[dialog-db]] — the database that uses Prolly Trees.
