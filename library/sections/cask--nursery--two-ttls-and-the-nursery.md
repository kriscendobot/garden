---
title: Two TTLs and the Nursery Staging Area
source: doc/design/nursery.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage]
status: current
notes: nursery.md is an exploratory essay ("more open questions than closed answers"); the design is not yet implemented.
---

Abstract: The **nursery** is a staging area where incoming blocks land before they are rooted in permanent storage, motivated by the problem that today `stor` puts blocks directly into permanent storage with no staging, no TTL enforcement, and no link between receiving blocks and executing the verb command that references them. A verb command encoded as CBOR may span multiple blocks (a `cask/blob` Merkle tree) that arrive as individual out-of-order packets; the server needs all of them before it can execute the verb, but must not commit them permanently until the verb succeeds and its result is rooted in a cell. This separates **two lifetimes**: a short per-block **packet TTL** (how long one block is retained while its command's other blocks arrive, bounded by the sender's retransmission schedule) and a longer **command TTL** (how long the whole block set is retained while the command assembles and executes, bounded by the client's patience). A large command may send hundreds of blocks each with a short packet TTL while the command TTL must span the entire transfer. The nursery must accept blocks by hash for O(1) lookup, let concurrent readers block-wait on a specific hash (the `ready`-channel pattern from tempstore), track both deadlines per block, never evict a block while any command still references it (one content-addressed block may serve several concurrent commands), and evict only when the command TTL has expired and no active command references it. The leading proposal places the nursery in **permanent storage** retained under a `caskhead` "nursery root" rather than in memory: a large command may exceed memory, a mid-transfer restart loses nothing (the client resumes rather than retransmits), and GC treats nursery blocks like any other (retained while reachable from the nursery root, collected when not). The open trade is whether the restart-recovery benefit justifies the disk I/O on every incoming block; a memory-backed hybrid with periodic flush, or memory-only with client retransmit on restart, are alternatives.

## The Problem

Today, `stor` puts blocks directly into permanent storage. There is no staging area, no TTL enforcement, and no connection between receiving blocks and executing commands that reference them.

A verb command (see `verbs.md`) encoded as CBOR may span multiple blocks (a `cask/blob` Merkle tree). The blocks arrive as individual packets, potentially out of order. Before the server can execute the verb, it needs all the blocks. But it shouldn't commit them to permanent storage until the verb succeeds and the result is rooted in a cell.

There are two lifetimes in play:

1. **Packet TTL**: How long a single block should be retained while waiting for the rest of its command to arrive. Bounded by the sender's retransmission schedule.
2. **Command TTL**: How long the entire set of blocks for a command should be retained while the command is being assembled and executed. Bounded by the client's patience.

These are different. A large storage command might send hundreds of blocks. Each individual block's packet TTL is short (bounded by the next retry), but the command TTL must span the entire transfer.

## The Nursery

The nursery is a staging area where incoming blocks land before they are rooted in permanent storage. It must:

1. Accept blocks by hash, indexed for O(1) lookup.
2. Allow concurrent readers to block-wait for a specific hash to arrive (the `ready` channel pattern from tempstore).
3. Track two deadlines per block: the packet-level TTL and the command-level TTL.
4. Not evict a block while any command still references it (a block may serve multiple concurrent commands because it is content-addressed).
5. Evict blocks whose command TTL has expired and which are not referenced by any active command.

## Where the Nursery Lives

The initial thought was that the nursery should be in-memory (like tempstore) for speed, since blocks are transient. The revised proposal places the nursery in **permanent storage**, retained under `caskhead`:

- A large command may transfer more blocks than fit in memory.
- If the server restarts mid-transfer, blocks already received are not lost. The client can resume rather than retransmit everything.
- The nursery is just another part of the block store, distinguished by being reachable from a "nursery root" in `caskhead` rather than from a cell.
- GC treats nursery blocks like any other: retained while reachable from the nursery root, collected when not.

**Open question**: Is the restart-recovery benefit worth the disk I/O cost for every incoming block? A hybrid approach (memory-backed with periodic flush to disk) might be better. Or a memory-only nursery with the understanding that server restart loses in-flight commands and clients must retransmit (the client already retransmits on timeout, so this may be acceptable).

**Open question**: If the nursery is in permanent storage, how does it differ from just storing blocks normally? The difference is GC rooting: nursery blocks are rooted by the nursery structure (with a TTL), not by a cell. When the command completes, the result hash is swapped into a cell, which roots the blocks permanently. The nursery entry is then removed, and any blocks not reachable from the cell become collectible.

Source: [doc/design/nursery.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/nursery.md) at commit `cdb975d8`.
