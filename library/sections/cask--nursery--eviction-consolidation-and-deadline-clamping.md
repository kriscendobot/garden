---
title: Buffer Consolidation, Eviction, and Deadline Clamping
source: doc/design/nursery.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
notes: nursery.md is an exploratory design; an aggregated set of open questions (location, cancellation, recovery, GC cadence, dedup, encryption, response shape, batching, read verbs, heartbeat, flow control) closes the document.
---

Abstract: The implementation mechanics the nursery needs, in three threads. **Consolidating tempstore and recvbuffer**: today tempstore (in-memory, deadline-eviction via a collector heap, has the `ready` channel for blocking loads, but its collector runs inline on every Store/Load scanning the heap) and recvbuffer (in-memory parallel-array buffer with O(log n) priority + deadline heaps, but no block storage, no `ready` channel, no hash indexing, not yet wired into the network layer) serve overlapping purposes and should merge into one structure with recvbuffer's efficient heap-indexed eviction plus tempstore's hash-indexed storage and `ready` channel plus a reference count; tempstore is then deleted. The recvbuffer augmentations: a `map[cask.Hash]int` hash→slot index for O(1) `Load`, per-slot `cask.Block`+metadata storage, a per-slot `chan struct{}` ready channel closed when data arrives, per-slot reference counting (eviction suppressed while refcount > 0, decremented when a command completes), and deadline clamping against the receiver's own RTT observations (which needs an RTT mechanism that does not yet exist). **Reference counting and eviction** offers three approaches: A explicit per-block refcount incremented on `verb` arrival and decremented on completion (most precise, most complex); B command-level TTL only, tagging each block with the max command TTL of any referencing command (simplest, wastes memory); C the nursery-in-permanent-storage approach where the nursery root is just another GC root with TTL cleanup and reachability handles the rest (cleanest, has the disk I/O concern). **Deadline clamping** runs at both ends: the sender clamps outbound packet TTL to `clamp(rto, min_ttl, cmd_ttl_remaining)` so a packet lives at least until the next retry but no longer than the command, and the receiver should not blindly trust the sender's TTL but clamp against its own RTT estimates and extend deadlines for blocks of a steadily-arriving command (lacking an independent heartbeat, the receiver can infer RTT from the `cask`-to-`verb` gap or inter-arrival times).

## Consolidating tempstore and recvbuffer

Today there are two structures serving overlapping purposes:

- **tempstore**: In-memory store with deadline-based eviction via a collector heap. Has the `ready` channel pattern for blocking loads. Performance problem: the collector runs inline on every Store/Load call, scanning the heap.
- **recvbuffer**: In-memory parallel-array buffer with priority and deadline heaps. Efficient O(log n) eviction. No block storage, no `ready` channel, no hash indexing. Not yet integrated into the network layer.

These should be consolidated into a single structure combining recvbuffer's efficient heap-indexed eviction (priority + deadline), tempstore's hash-indexed block storage and `ready` channel for blocking loads, and a reference count or command association so blocks serving multiple concurrent commands are not prematurely evicted. tempstore should be deleted after consolidation.

### recvbuffer Augmentations Needed

1. **Hash-indexed lookup**: A `map[cask.Hash]int` from block hash to buffer slot index, so `Load(hash)` is O(1).
2. **Block storage**: Each slot holds a `cask.Block` and metadata, not just priority/deadline.
3. **Ready channel**: Each slot has a `chan struct{}` that is closed when the block data arrives. `Load` blocks on this channel (or context cancellation).
4. **Reference counting**: Each slot tracks how many active commands reference this block. Eviction is suppressed while refcount > 0. When a command completes (success or failure), it decrements the refcount of all blocks it referenced.
5. **Deadline clamping**: The receiver should clamp incoming block deadlines based on its own RTT observations, not just trust the sender's TTL. This requires a heartbeat or RTT measurement mechanism that does not yet exist.

## Reference Counting and Eviction

Because blocks are content-addressed, the same block may be part of multiple concurrent commands. The nursery must not evict a block while any command still needs it.

- **Approach A: Explicit reference counting.** When a `verb` command arrives, the server walks the Merkle tree and increments a refcount on each nursery block. When the command completes (success or failure), it decrements. Eviction only proceeds when refcount is 0 and the deadline has passed.
- **Approach B: Command-level TTL only.** Each block is tagged with the maximum command TTL of any command that references it. No per-block refcount; just extend the deadline. Simpler but less precise: a block might be retained longer than necessary if one command has a long TTL and another has already completed.
- **Approach C: The nursery is in permanent storage.** Blocks are just blocks in the store. The nursery root (a set of hashes with deadlines) tracks what is "in the nursery." When a command succeeds, its result is rooted in a cell, and the nursery entries are removed. GC handles the rest. No refcount needed because GC is reachability-based; the nursery root is just another GC root with TTL-based cleanup.

Approach C is the cleanest but has the disk I/O concern. Approach A is the most precise but adds complexity. Approach B is the simplest but wastes memory.

## Outbound Deadline Clamping

The sender should clamp outbound packet TTLs to be useful:

- **Minimum**: The packet must survive at least until the next scheduled retry. A TTL shorter than the retransmission timeout is wasteful: the block will expire before the sender knows whether to retry.
- **Maximum**: The command TTL. No individual packet needs to live longer than the overall command.

So: `packet_ttl = clamp(rto, min_ttl, cmd_ttl_remaining)`. This prevents packets from clogging the receiver's nursery with deadlines that are either too short (evicted before useful) or too long (retained after the command has timed out).

## Receiver Deadline Clamping

The receiver should not blindly trust the sender's TTL; it should clamp based on its own observations. If it has RTT estimates (from ack round-trips) it can set a minimum retention time based on expected retransmission intervals, and if it observes a command's blocks arriving steadily it can extend the effective deadline for blocks that are part of an active command.

**Open question**: The receiver does not currently have a heartbeat mechanism to measure RTT independently. The sender measures RTT from ack round-trips, but the receiver only sees incoming packets. A heartbeat (periodic ping/pong) would give the receiver its own RTT estimate. Alternatively, the receiver could infer RTT from the gap between a `cask` packet and the corresponding `verb` packet, or from the inter-arrival time of blocks within a command.

## Open Questions (aggregated)

The document closes with eleven open questions spanning: nursery location (memory/disk/hybrid and memory limits), command cancellation detection (timeout vs explicit cancel), partial command recovery after a mid-command restart, nursery GC cadence (per-packet vs timer vs memory pressure), block deduplication between nursery and permanent storage, how `cask`/`verb` interact with the encrypted session layer (presumably as inner commands like `stoe`/`lode`/`acke`), the shape of the `verb` response (success/failure + new hash, or the full updated path), batching multiple verb operations for atomic multi-cell updates (as in the OCAPS batch operation), command formats for read verbs (`getv`/`getk`/`walk`, which need no nursery but do need capability validation and path traversal), the heartbeat mechanism, and command-level flow control distinct from the existing block-level send-queue backpressure.

Source: [doc/design/nursery.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/nursery.md) at commit `cdb975d8`.
