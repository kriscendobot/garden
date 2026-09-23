---
title: The cask and verb Packet Commands
source: doc/design/nursery.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
notes: nursery.md is an exploratory design; the cask/verb commands are proposed, not yet in the shipped casknet/casksock command sets.
---

Abstract: The proposed two new wire commands that drive nursery staging and verb execution. The **`cask` command** (block staging) stages one block in the nursery with a given packet TTL without triggering any verb; it replaces `stor` for the purpose of receiving blocks that are part of a multi-block command, and the server replies `ackn` (or encrypted `acke`) and takes no further action. Its layout: `command` "cask" (4 bytes), `trace` priority/trace cohort (uint64 BE, 8 bytes), `ttl_ms` packet TTL (uint32 BE, 4 bytes), `hash` block hash (32 bytes), `metadata` (12 bytes: height:8, numLinks:1, dataLen:2, reserved:1), then up to 1024 bytes of block data. The **`verb` command** references a Merkle root already (or concurrently) staged in the nursery and triggers execution; layout: `command` "verb", `trace`, `cmd_ttl_ms` command TTL (uint32 BE), `root_hash` Merkle root of the CBOR command body (32 bytes); total 48 bytes. On `verb` the server collects the tree rooted at `root_hash` via `caskio.Reader` (each `Load` blocks on the block's `ready` channel until concurrent `cask` packets deliver it), deserializes the CBOR body, parses (capability, path, verb code, arguments), validates the capability, walks the path to the target entry, executes the verb's reduce function, propagates new hashes up the path, and CAS-es the cell's value hash; on success the result is rooted in a cell and the nursery entries are cleaned up, on failure a conflict response is returned and nursery blocks remain until their command TTL expires. For commands whose CBOR body fits in one block (the common case for `push`/`setv`/`delk`) a **single-block combined** `verb` packet inlines the block (adding the 12-byte metadata + block data) to save a round trip. The CBOR body maps `0`→32-byte cap_token, `1`→path-segment array, `2`→4-byte verb code text, `3`→verb-specific arguments; large-payload verbs (such as `writ`) may reference further nursery block hashes in their arguments, which the server loads during execution.

## The `cask` Command (Block Staging)

A new command that stages a block in the nursery without triggering any verb execution. This replaces the current `stor` for the purpose of receiving blocks that are part of a multi-block command.

```
Offset  Size    Field           Description
0       4       command         "cask" (0x63 0x61 0x73 0x6B)
4       8       trace           Priority/trace cohort (uint64 BE)
12      4       ttl_ms          Packet TTL in milliseconds (uint32 BE)
16      32      hash            Block hash
48      12      metadata        Block metadata (height:8, numLinks:1, dataLen:2, reserved:1)
60      N       block           Block data (up to 1024 bytes)
```

The server receives this, stages the block in the nursery with the given TTL, and sends an `ackn` (or encrypted `acke`). No further action is taken.

## The `verb` Command

A separate command that references a Merkle root in the nursery and triggers command execution.

```
Offset  Size    Field           Description
0       4       command         "verb" (0x76 0x65 0x72 0x62)
4       8       trace           Priority/trace cohort (uint64 BE)
12      4       cmd_ttl_ms      Command TTL in milliseconds (uint32 BE)
16      32      root_hash       Merkle root of CBOR command body
```

**Total**: 48 bytes.

On receiving `verb`, the server:

1. Begins collecting the Merkle tree rooted at `root_hash` from the nursery, using `caskio.Reader`. Each `Load` call blocks until the block arrives (via the `ready` channel).
2. As blocks arrive (via concurrent `cask` packets), the reader unblocks and proceeds.
3. Once the full tree is collected, deserializes the CBOR body.
4. Parses the command: capability, path, verb code, arguments.
5. Validates the capability.
6. Walks the path to the target entry.
7. Executes the verb (reduce function).
8. Propagates new hashes back up the path.
9. CAS the cell's value hash.
10. On success: the result is now rooted in a cell. Nursery blocks that are also reachable from the cell are retained by normal GC. Nursery entries can be cleaned up.
11. On failure: returns conflict response. Nursery blocks remain until their command TTL expires.

## Single-Block Commands

For commands whose CBOR body fits in a single block (the common case for simple verbs like `push`, `setv`, `delk`), the client can combine the block and the verb trigger into one packet to avoid a round trip:

```
Offset  Size    Field           Description
0       4       command         "verb" (0x76 0x65 0x72 0x62)
4       8       trace           Priority/trace cohort (uint64 BE)
12      4       cmd_ttl_ms      Command TTL in milliseconds (uint32 BE)
16      32      root_hash       Hash of the inline CBOR block
48      12      metadata        Block metadata (height:8, numLinks:1, dataLen:2, reserved:1)
60      N       block           CBOR command body (single block)
```

The server stages the block in the nursery and immediately begins execution. No separate `cask` packets needed.

## CBOR Command Body

The CBOR body (once assembled from the Merkle tree) encodes:

```cbor
{
  0: h'<32-byte cap_token>',     ; cell capability
  1: ["path", "segments"],        ; directory path (array of text)
  2: "push",                      ; verb code (text, 4 bytes)
  3: <verb arguments>             ; verb-specific (any CBOR type)
}
```

See `verbs.md` for the verb catalog and argument shapes. For verbs that carry large payloads (such as `writ` to store a blob), the CBOR arguments themselves may reference hashes of blocks that are also in the nursery; the server loads these as needed during verb execution.

## Relationship to Existing `stor` and `load`

The existing `stor` command continues to work for backward compatibility and for simple block transfers that don't involve verb execution; it puts blocks directly into permanent storage. The new `cask` command is for blocks that are part of a command being assembled, which go to the nursery. The proposed migration path: Phase 1 adds `cask`/`verb` alongside `stor`/`load` (both paths work); Phase 2 routes verb-based operations through `cask`+`verb` while simple replication keeps using `stor`/`load`; Phase 3 considers whether `stor` should also go through the nursery with an implicit "store this block permanently" verb.

Source: [doc/design/nursery.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/nursery.md) at commit `cdb975d8`.
