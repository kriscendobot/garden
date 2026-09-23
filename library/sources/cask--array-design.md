---
source: doc/design/array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: `caskarray` — the smallest, most compact CASK-block trie for a long array of 32-byte block hashes. Exactly 32 hashes fill one 1024-byte block, so every node is one block of 32 slots and a single metadata `height` field distinguishes leaves (value hashes) from internal nodes (child hashes); capacity is `32^(D+1)` for depth D, and a separate array-root block carries the trie root plus an 8-byte length. All mutation goes through one operational-transform primitive, `Transform(priorRoot, ops)`, over three op types — Keep (copy), Skip (drop), Inject (insert) — that must cover the prior breadth; Append and Set preserve structure while Insert and Delete at an offset discard a trie suffix (the stated weakness the columnar tables avoid). An op sequence can be **reified** into a linked list of CASK blocks (Reify / Realize / TransformReified) so it can be persisted, transmitted, or replayed without staying resident — the same op encoding the SDIF/SOPS sorted-array sync serializes on the wire. This is the `arraytree` backbone the parallel-array tables and the Rabin-chunked sorted array build on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [compact-trie-layout-and-capacity](../sections/cask--array-design--compact-trie-layout-and-capacity.md) | data-structures, content-addressed-storage | current |
| [operational-transform-keep-skip-inject](../sections/cask--array-design--operational-transform-keep-skip-inject.md) | data-structures, content-addressed-storage | current |
| [reified-op-streams](../sections/cask--array-design--reified-op-streams.md) | data-structures, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-17 by Kris Kowal.
- Ingested cycle 11 (`scholar-ingest-cask-10`) as the array/columnar machinery cluster alongside sorted-array-design, allocator-design, and bigint-design. `caskarray` is the dense `arraytree` backbone (see [[cask-block-backbones]]); its Keep/Skip/Inject primitive is captured by [[cask-operational-transform]] and reused by the sorted array and its SDIF/SOPS sync.

Source: [doc/design/array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/array-design.md) at commit `cdb975d8`.
