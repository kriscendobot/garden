---
title: On-disk format — superblocks, arena headers, allocation/deadlist logs, pivot/leaf blocks, key types, and upsert message opcodes
source: "GEFS: A Good Enough File System (Ori Bernstein)"
source_kind: paper
source_authors: [Ori Bernstein]
source_year: 2023
source_venue: "Plan 9 file-system paper (orib.dev/gefs.pdf; IWP9 2023 inferred)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
topics: [file-systems]
status: current
---

Abstract: The GEFS on-disk format is a small set of big-endian, byte-packed structures. Every block except a raw data block begins with a 2-byte header/type; the type table runs 0 (unused), 1 (pivot node), 2 (leaf node), 3 (allocation log), 4 (deadlist log), 5 (arena header), and `0x6765` (the superblock header, chosen to spell ASCII `ge`). Two duplicate **superblocks** (offset 0 and the last block) each hold everything needed to load the file system, including the snapshot-tree root and hash, the snap deadlist head/tail, arena count and locations, next qid/generation, and a content hash. **Arena headers** hold the freelist and sizes. **Logs** (allocation logs and deadlists) are the only structures mutated in place and so are not fully merkelized. **Pivot** and **leaf** blocks share a layout of a sorted offset table growing toward the block end and packed keys/pointers/messages/values growing toward the start. Keys begin with a type byte; the known key types are the data/entry/up keys of the file-system tree plus the label/snap/dead keys of the snapshot tree, and upsert **messages** carry an opcode (insert/delete, deferred free/"kill", wstat-style field updates, and snapshot rechain) plus the target key and message body. This is the reference-detail section; consult it for byte-level anchors.

## Block headers and the type table

The formats used for GEFS on-disk storage are: superblocks, arena headers, tree nodes, and tree values. All blocks except raw data blocks begin with a 2-byte header; the superblock header is chosen so it coincides with the ASCII representation of `ge`. All numbers in GEFS are big-endian integers, byte-packed. The header/type values:

| Value | Description |
|---|---|
| 0 | Unused |
| 1 | Pivot node |
| 2 | Leaf node |
| 3 | Allocation log |
| 4 | Deadlist log |
| 5 | Arena header |
| 0x6765 | Superblock header |

## Superblocks

Superblocks are the root of the file system, containing all information needed to load it. There is one superblock at offset 0 and one at the last block of the file system; these are duplicates, and only one intact superblock is needed to load GEFS successfully. Because the superblock fits in a single block, all the arenas must also fit into it, imposing an upper bound on the arena count — with 16k blocks the natural limit is approximately 1000 arenas, though GEFS imposes a smaller internal default of **256 arenas**. The superblock fields include: a magic string `= "gefs9.00"`; the block size; the buffer space; the height, root block, and hash of the snapshot tree; the address and hash of the snap deadlist head and tail; the number of arenas; flags for future expansion; the next qid to be allocated; the next generation number; the last queue generation synced to disk; the location of each arena (0th … Nth); and a hash of the superblock contents up to the last arena.

## Arena headers and logs

An **arena header** (magic `Tarena`) contains the address and hash of the start of the freelist, the arena size, and (for debugging) the used space. **Logs** track allocations; they are the only structure mutated in place and therefore not fully merkelized. There are two log types — allocation logs and deadlists — sharing a common header (`Tlog`/`Tdlist`: amount of log space used, hash of all data after the header, and the block pointer this log block chains to).

- **Allocation log** (`Tlog`): each entry is either a single u64int (an allocation or free of a single block) or a pair of u64ints (an operation on a range of blocks). The operation values are: 1 = allocate 1 block, 2 = free 1 block, 3 = sync barrier, 4 = alloc block range, 5 = free block range. Operations are packed with the operation in the low-order byte and the rest of the value in the upper bits; for multi-block operations the range length is packed in the second byte.
- **Deadlist log** (`Tdlist`): simpler than an allocation log — a flat list of blocks that have been killed.

## Tree nodes: pivot and leaf

The tree is composed of **pivot** blocks (inner nodes, `Tpivot`) and **leaf** blocks (`Tleaf`), laid out as described in the Bεtree section. A pivot header carries the count of values, bytes of value data, count of buffered messages, and bytes of buffered messages. Within a pivot block, the first half of the space after the header holds a **key/pointer set**: an array of 2-byte offsets to keys at the head of the space, and a packed set of keys and block pointers at the tail. Each key/pointer entry is a length-prefixed key plus the pointed-to block's address, hash, and generation number. The second half of the block holds **messages** directed to a value in a leaf, formatted similarly but with offsets pointing to messages; the offset array grows toward the end of the block while values/messages grow toward the start. Each message contains a single-byte opcode, a key, and a message body carrying an incremental update to the value. A leaf block's header carries the number of key-value pairs and their size; the leaf layout is similar (offset table plus packed key-value pairs, each a length-prefixed key and length-prefixed value).

## Key types and message opcodes

In GEFS, keys begin with a single **type byte** followed by data in a known format:

- **Data key** → pointer to a data block; value must be a block pointer; valid only in file-system trees.
- **Entry key** → pointer to a file entry (stat structure); value is the body of a `dir` structure (flags, qid path/version/type, permission bits, atime, mtime, size, uid, gid, muid); valid only in file-system trees.
- **Up key** → pointer to a parent directory; the value is the formatted key of the containing directory; present only for directories; valid only in file-system trees.
- **Label key** → a label for a snapshot; the value refers to a snapid; valid only in snapshot trees.
- **Snap key** → refers to a snapshot tree; the value is a tree entry (references from other trees, references from labels, tree height, flags, generation number, predecessor/successor/base snapshot, and the root block's address/hash/generation).
- **Dead key** → refers to a deadlist; the fields are the snapshot the deadlist belongs to and the birth generation of the blocks on it; the value is a pair of block pointers (head and tail of the block list).

Upsert **messages** replace or remove a key/value pair, insert a deferred free of a block without reading it first ("kill", key must be a data key), update an existing file entry (key is an entry key; value is a bitfield of wstat-style fields to update — size, mode, mtime, atime, uid, gid, muid), or **rechain** snapshots (key is a snap key; operand is the id of a new predecessor or successor snap).

## Cross-reference (editorial, not in the source)

Two things are worth naming against the CASK corpus. First, GEFS is **merkelized but not content-addressed**: block pointers carry a hash *and* an explicit disk address and generation, so the hash is a corruption check, not the block's identity — the opposite of CASK's block format (`cask--protocol--message-and-block-formats`, `cask--cask-go--block-byte-layout-and-metadata-footer`) where the hash *is* the address and identical content deduplicates for free. Second, GEFS's logs are "the only structure mutated in place and therefore not fully merkelized" — a deliberate escape hatch from the copy-on-write discipline for the allocation/deadlist bookkeeping, comparable in spirit to CASK's `dbstore` WAL (`cask--dbstore-design--on-disk-file-formats`) being the one append-in-place file amid otherwise immutable blocks.

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
