# Topic: content-addressed-storage

> Abstract: Storing data as content-addressed blocks organized into Merkle trees, as practiced by `kriskowal/cask` (CASK). The organizing constraint is a fixed 1KB block size that unifies storage and transport: every higher structure (blobs, directories, arrays, maps, sets) is a tree of 1KB blocks, the same bytes move on the wire and onto disk with no reformatting, and garbage collection is content-agnostic because every block's link structure lives in its metadata. Seeded 2026-06-24 from the cask README and deepened the same day from the `doc/design/` corpus (the layered casknet architecture and the parallel-arrays persistent-structure designs). Related to but distinct from `persistence` (Endo's formula-graph value persistence across vat incarnations) — both are about durable identity, but CAS keys on content hash while Endo persistence keys on formula identity. Distinct from `networking` (CASK's UDP transport side), though the two share the block abstraction.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [cask--readme--overview](../sections/cask--readme--overview.md) | cask README | A content-addressed block store where every block is exactly 1KB; one constraint unifying storage, transport, and content-agnostic GC. |
| [cask--readme--cli-quick-start](../sections/cask--readme--cli-quick-start.md) | cask README | The `cask` CLI: store/load by hash, checkin/checkout directories, the root tree, and cells (named mutable references). |
| [cask--readme--why-1kb-blocks](../sections/cask--readme--why-1kb-blocks.md) | cask README | A 1KB block plus envelope is one UDP datagram and one Merkle node; up to 32 links plus payload plus a 12-byte footer. |
| [cask--readme--storage-transport-single-abstraction](../sections/cask--readme--storage-transport-single-abstraction.md) | cask README | Blocks land in storage without reformatting; dbstore WriteAt's the same wire bytes at slot*BlockSize. |
| [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md) | cask README | Blobs (Rabin chunking), directories, arrays (32-way tries), maps/sets (hash tries); content-agnostic GC vs Git. |
| [cask--readme--columnar-ecs-design](../sections/cask--readme--columnar-ecs-design.md) | cask README | Parallel-arrays / ECS pattern translated to persistent storage via adaptive-width tries. |
| [cask--readme--content-agnostic-gc](../sections/cask--readme--content-agnostic-gc.md) | cask README | Link structure in metadata lets GC walk the retention graph without parsing content; pinned vs deadline regimes; concurrent quarantine. |
| [cask--readme--block-format](../sections/cask--readme--block-format.md) | cask README | 1024-byte body (links then data) plus 12-byte metadata footer; hash covers only the occupied portion. |
| [cask--readme--package-taxonomy](../sections/cask--readme--package-taxonomy.md) | cask README | CASK's package layers from trie backbones up through stores and tables. |
| [cask--architecture--design-principles-and-protocols](../sections/cask--architecture--design-principles-and-protocols.md) | cask architecture | The two protocols (casknet, casksock) and the optional five-layer casknet stack over the block foundation. |
| [cask--architecture--layer-2-merkle-tree-and-filesystem](../sections/cask--architecture--layer-2-merkle-tree-and-filesystem.md) | cask architecture | TREE (SYNC/DIFF/WALK/GC) and FSOP over a GC-transparent filesystem of Merkle-tree directories and files. |
| [cask--parallel-arrays--persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | cask parallel-arrays | Persistent structures as reducers `(state_hash, args) → new_state_hash` minimizing Merkle disturbance. |
| [cask--parallel-arrays--compact-index-representation](../sections/cask--parallel-arrays--compact-index-representation.md) | cask parallel-arrays | Adaptive index width with hysteresis; positional-link table roots more compact than caskmap. |
| [cask--parallel-arrays--universal-tree-and-schema-hashes](../sections/cask--parallel-arrays--universal-tree-and-schema-hashes.md) | cask parallel-arrays | Schema hashes self-describe structures; directories-as-tables; one adaptive TreeNode schema. |
| [cask--parallel-arrays--rabin-bounded-sorted-indexes](../sections/cask--parallel-arrays--rabin-bounded-sorted-indexes.md) | cask parallel-arrays | Rabin-chunked sorted (key, slot) records give B-tree queries without rebalancing. |

## See also

- [`networking`](networking.md): CASK's transport side (encrypted UDP, priority shedding) — the same 1KB block is the unit of transfer.
- [`data-structures`](data-structures.md): the columnar parallel-array pattern CASK's tables share.
- [`persistence`](persistence.md): Endo's formula-graph persistence — a different keying (formula identity vs content hash) for the same durable-identity problem.
