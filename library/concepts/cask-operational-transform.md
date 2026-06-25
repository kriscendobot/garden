---
id: cask-operational-transform
aliases: ["operational transform", "Keep Skip Inject", "Keep/Skip/Inject", "Transform primitive", "caskarray transform", "op stream", "op-stream root", "Reify", "Realize", "TransformReified", "reified ops", "covering invariant", "SOPS operations encoding"]
topics: [data-structures, content-addressed-storage]
status: current
---

# cask-operational-transform

The single mutation primitive shared across CASK's array-shaped structures. Every mutation is `Transform(ctx, store, priorRoot, ops) → newRoot`, where `ops` is a sequence of three op types — **Keep(n)** (copy the next n prior elements), **Skip(n)** (drop the next n), **Inject(values)** (insert new values at the output position) — subject to the **covering invariant**: the sum of all Keep and Skip counts equals the prior length, so every prior index is kept or skipped exactly once. The transform walks a read cursor over the prior structure and the op stream in lockstep, building a fresh structure from the kept and injected runs in one pass; each named mutation (Set, Append, Insert, Delete, Replace-range) is just a particular op sequence. The op sequence can be **reified** into a linked list of CASK blocks (`Reify` to encode, `Realize` to decode, `TransformReified` to apply from a stored op-stream root) so it can be persisted, transmitted, or replayed without staying resident. `caskarray` defines the primitive; the Rabin-chunked sorted array reuses it (with sorted Inject) for bulk edits; the SDIF/SOPS network protocol serializes the same Keep/Skip/Inject encoding on the wire as the diff between two peers' sorted arrays. Append and Set preserve structure (one root-to-leaf path); Insert and Delete at an offset re-write the suffix and discard much of the trie — the cost the columnar parallel-array tables sidestep by moving narrow indexes instead of values.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--array-design--operational-transform-keep-skip-inject](../sections/cask--array-design--operational-transform-keep-skip-inject.md) | The Keep/Skip/Inject primitive, the covering invariant, the lockstep Transform routine, and each mutation as an op sequence. |
| [cask--array-design--reified-op-streams](../sections/cask--array-design--reified-op-streams.md) | Reify/Realize/TransformReified: op sequences as a linked list of blocks; the op-stream root distinct from the array root. |
| [cask--sorted-array-design--operations-transform-and-use-cases](../sections/cask--sorted-array-design--operations-transform-and-use-cases.md) | The sorted array reuses Transform with sorted Inject for bulk edits, re-chunking the output via Rabin fingerprinting. |
| [cask--sorted-array-design--sdif-sops-diff-sync-protocol](../sections/cask--sorted-array-design--sdif-sops-diff-sync-protocol.md) | SOPS carries the serialized Keep/Skip/Inject op sequence as the wire form of a sorted-array diff. |

## See also

- [[cask-reducer-pattern]] — Transform is itself a reducer: `(priorRoot, ops) → newRoot`, a pure function of its inputs.
- [[cask-block-backbones]] — `caskarray`'s `arraytree` is the structure Transform rebuilds.
- [[rabin-chunking]] — the sorted array re-chunks the transform output at content-defined boundaries.
- [[parallel-arrays-columnar]] — the columnar tables avoid Transform's offset-edit suffix-rewrite cost by moving indexes, not values.
- [[casknet-wire-protocol]] — SDIF/SOPS sit alongside casknet's other Layer-2 verbs.
