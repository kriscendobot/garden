---
id: content-addressed-block-store
aliases: ["CASK", "cask", "content-addressed block store", "content-addressed storage", "content addressing", "1KB block", "fixed-size block", "block store", "casknet", "casksock", "STOR LOAD", "cells", "layered protocol"]
topics: [content-addressed-storage, networking]
status: current
---

# content-addressed-block-store

A store in which every unit of data is a fixed-size **block** named by the cryptographic hash of its contents, and larger values are Merkle trees of such blocks. `kriskowal/cask` (CASK) is the worked example: every block is exactly 1KB, which lets one abstraction serve as both the storage unit and the transport unit (one block fits one UDP datagram inside the Ethernet MTU), and makes garbage collection content-agnostic (the GC walks links recorded in each block's metadata without parsing any block's content). Content addressing means identical content is stored once and references are tamper-evident; the trade is that a mutable reference needs an extra indirection (CASK's **cells**: named references whose stable ID is distinct from the content hash they currently point at).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--readme--overview](../sections/cask--readme--overview.md) | The 1KB-block constraint unifies storage and transport and makes GC content-agnostic. |
| [cask--readme--why-1kb-blocks](../sections/cask--readme--why-1kb-blocks.md) | The block is both a Merkle node and a self-describing transfer unit; up to 32 links plus payload plus a 12-byte footer. |
| [cask--readme--block-format](../sections/cask--readme--block-format.md) | 1024-byte body + 12-byte metadata; the hash covers only the occupied portion. |
| [cask--readme--cli-quick-start](../sections/cask--readme--cli-quick-start.md) | Store/load by hash; cells as named mutable references over immutable content. |
| [cask--readme--content-agnostic-gc](../sections/cask--readme--content-agnostic-gc.md) | GC walks the retention graph from pinned roots using only block metadata. |
| [cask--architecture--design-principles-and-protocols](../sections/cask--architecture--design-principles-and-protocols.md) | The two protocols (casknet, casksock) and the optional five-layer casknet stack over the block foundation. |
| [cask--architecture--layers-0-1-block-transfer-and-session](../sections/cask--architecture--layers-0-1-block-transfer-and-session.md) | Layer 0 LOAD/STOR block transfer as the unchanging foundation under sessions and higher layers. |
| [cask--dbstore-design--goals-and-directory-layout](../sections/cask--dbstore-design--goals-and-directory-layout.md) | caskdbstore: a `cask.CASStore` keeping all blocks in a few flat files with on-disk content-addressed indexes. |
| [cask--cask-go--block-model-and-merkle-trees](../sections/cask--cask-go--block-model-and-merkle-trees.md) | The package-header code that defines the 1KB block model and the why-1KB rationale (Ethernet MTU, UDP, filesystem block). |
| [cask--cask-go--block-byte-layout-and-metadata-footer](../sections/cask--cask-go--block-byte-layout-and-metadata-footer.md) | The concrete 1024-byte-body + 12-byte-footer layout in code; the hash covers only the occupied portion. |
| [cask--cask-go--store-interface-and-span-tracked-completion](../sections/cask--cask-go--store-interface-and-span-tracked-completion.md) | The `Store`/`CollectibleStore`/`CASStore` interface contracts every block-store implementation realizes. |

## See also

- [[merkle-tree-of-blocks]] — the tree structure CASK builds over blocks.
- [[rabin-chunking]] — how CASK splits byte streams into blocks so edits invalidate O(log n) blocks.
- [[parallel-arrays-columnar]] — the columnar pattern CASK's persistent tables use.
- [[cask-reducer-pattern]] — operations consume and produce the store's root hashes.
- [[noise-ik-session-establishment]] — how casknet secures block transfer between nodes.
- [[gc-quarantine-store]] — how CASK garbage-collects blocks no longer reachable from a pinned root.

## Common confusions

- CASK's content addressing is **not** Git's: Git's GC must parse object headers to find references, while CASK records link structure in fixed-size block metadata so the GC never parses content. See [cask--readme--merkle-trees-for-everything](../sections/cask--readme--merkle-trees-for-everything.md).
