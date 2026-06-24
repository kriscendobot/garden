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
| [cask--gc-and-retention--overview-and-two-regimes](../sections/cask--gc-and-retention--overview-and-two-regimes.md) | cask gc-and-retention | Two retention regimes: pinned-roots (on-disk, hash-trie) vs deadline (in-memory, min-heap). |
| [cask--gc-and-retention--pinned-roots-hash-trie](../sections/cask--gc-and-retention--pinned-roots-hash-trie.md) | cask gc-and-retention | Roots in a persistent hash-trie; retained set by mark/sweep; snapshot+chain optimization. |
| [cask--gc-and-retention--deadline-based-ephemeral-retention](../sections/cask--gc-and-retention--deadline-based-ephemeral-retention.md) | cask gc-and-retention | In-memory deadline retention via a min-heap (recvbuffer/tempstore pattern); evict at now_ns. |
| [cask--gc-concurrent-design--snapshot-gc-with-quarantine](../sections/cask--gc-concurrent-design--snapshot-gc-with-quarantine.md) | cask gc-concurrent | Snapshot GC with mandatory write quarantine; CollectorStore (primary + quarantine). |
| [cask--gc-concurrent-design--concurrency-invariants-and-root-swaps](../sections/cask--gc-concurrent-design--concurrency-invariants-and-root-swaps.md) | cask gc-concurrent | Seven invariants (install-after-store, snapshot safety, epoch monotonicity); Collect channel API. |
| [cask--gc-concurrent-design--proposed-tests](../sections/cask--gc-concurrent-design--proposed-tests.md) | cask gc-concurrent | Tests asserting retention under concurrent root swaps across blob/dir/array. |
| [cask--store-gc-design--architecture-and-root-set-keying](../sections/cask--store-gc-design--architecture-and-root-set-keying.md) | cask store-gc | Store wrapper + cask/set root set keyed by a 32-bit projection of the 32-byte hash. |
| [cask--store-gc-design--mark-and-sweep](../sections/cask--store-gc-design--mark-and-sweep.md) | cask store-gc | Mark via Links through successful Loads; sweep stored-and-unreachable; index/List/copy-forward. |
| [cask--store-gc-design--missing-links-and-insertion-order](../sections/cask--store-gc-design--missing-links-and-insertion-order.md) | cask store-gc | Failed Load ≠ garbage; pin-root-when-stored + top-to-bottom write order; safety table. |
| [cask--store-gc-design--higher-level-ops-and-root-set-retention](../sections/cask--store-gc-design--higher-level-ops-and-root-set-retention.md) | cask store-gc | Blob/dir write order; multi-root pins; the root set retains itself via a fixed meta root. |
| [cask--dbstore-design--goals-and-directory-layout](../sections/cask--dbstore-design--goals-and-directory-layout.md) | cask dbstore | caskdbstore goals and the `.cask/` flat-file layout (blocks, meta, alloc, hashmap, root, WAL). |
| [cask--dbstore-design--on-disk-file-formats](../sections/cask--dbstore-design--on-disk-file-formats.md) | cask dbstore | Byte-exact blocks/meta/alloc/hashmap/root/nonce/WAL formats; Robin-Hood hashmap; 1068-byte WAL entry. |
| [cask--dbstore-design--operations-store-load-cas-collect](../sections/cask--dbstore-design--operations-store-load-cas-collect.md) | cask dbstore | Store/Load/Consolidate/CAS/Collection; WAL-as-quarantine mark-and-sweep with on-disk diskHashSet. |
| [cask--dbstore-design--concurrency-model-and-lock-protocol](../sections/cask--dbstore-design--concurrency-model-and-lock-protocol.md) | cask dbstore | Single flock-owner mutator; lock-free WAL writers; lock-free pread readers over append-only files. |
| [cask--dbstore-design--implementation-plan-and-sizing](../sections/cask--dbstore-design--implementation-plan-and-sizing.md) | cask dbstore | Phases 1–4; slot alloc against the alloc file; root temp+rename; sizing; diskstore comparison. |
| [cask--trace2--span-as-storage-completion-abstraction](../sections/cask--trace2--span-as-storage-completion-abstraction.md) | cask trace2 | How stores track block-store completion on a casktel Span: sync Store vs async StoreWithSpan, the SpanDriver embeddable, Peer/dir/blob fire-and-forget + ack via Add(1)/Add(-1). |
| [cask--trace2--dir-store-span-contract-and-test](../sections/cask--trace2--dir-store-span-contract-and-test.md) | cask trace2 | dir.Store makes a Span mandatory (ErrSpanRequired) and is fire-and-forget: returns the root hash immediately, the caller waits on `<-span.Done()`. |

## See also

- [`networking`](networking.md): CASK's transport side (encrypted UDP, priority shedding) — the same 1KB block is the unit of transfer.
- [`data-structures`](data-structures.md): the columnar parallel-array pattern CASK's tables share.
- [`persistence`](persistence.md): Endo's formula-graph persistence — a different keying (formula identity vs content hash) for the same durable-identity problem.
