---
id: cask-nursery
aliases: ["cask nursery", "nursery", "nursery root", "block nursery", "block staging area", "packet TTL", "command TTL", "two TTLs", "cask command", "verb command", "cask/verb commands", "ready channel", "tempstore", "recvbuffer", "deadline clamping", "packet_ttl clamp", "nursery eviction", "reference counting eviction", "single-block command", "CBOR command body"]
topics: [content-addressed-storage, networking]
status: current
---

# cask-nursery

CASK's proposed **block staging area**: incoming blocks land in the nursery before they are rooted in permanent storage, so a multi-block verb command (a CBOR body spanning a `cask/blob` Merkle tree, arriving as out-of-order packets) can be fully assembled and executed before its result is committed to a cell. The design separates **two block lifetimes**: a short per-block **packet TTL** (bounded by the sender's retransmission schedule) and a longer **command TTL** (bounded by the client's patience, spanning the whole transfer). The nursery accepts blocks by hash for O(1) lookup, lets concurrent readers block-wait on a hash via the `ready`-channel pattern, tracks both deadlines, refuses to evict a block while any command references it (one content-addressed block may serve several commands), and the leading proposal places it in **permanent storage under a `caskhead` nursery root** so a mid-transfer restart is recoverable and GC reachability (not a refcount) handles cleanup. Two new wire commands drive it: **`cask`** stages one block with a packet TTL and no execution (replacing `stor` for command blocks), and **`verb`** references a Merkle root, collects the tree, validates the capability, walks the path, runs the reduce, and CAS-es the cell value (with a single-block combined form to save a round trip). The design also proposes consolidating the overlapping tempstore and recvbuffer into one hash-indexed + heap-evicted structure, weighs three eviction approaches (explicit refcount / command-TTL-only / GC-rooted), and specifies sender- and receiver-side deadline clamping. It is an exploratory essay ("more open questions than closed answers") and is not yet implemented.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--nursery--two-ttls-and-the-nursery](../sections/cask--nursery--two-ttls-and-the-nursery.md) | The packet-TTL vs command-TTL split, the five nursery requirements, and the in-memory-vs-permanent-storage (caskhead nursery root) placement question. |
| [cask--nursery--cask-and-verb-packet-commands](../sections/cask--nursery--cask-and-verb-packet-commands.md) | The `cask` (stage block) and `verb` (collect tree + execute) wire layouts, the single-block combined form, the CBOR command body, and the stor/load migration path. |
| [cask--nursery--eviction-consolidation-and-deadline-clamping](../sections/cask--nursery--eviction-consolidation-and-deadline-clamping.md) | Consolidating tempstore + recvbuffer, the three reference-counting/eviction approaches, and outbound/receiver deadline clamping. |

## See also

- [[cask-caskhead-root]] — the system root that would hold the nursery root link (`Links[3]` nursery hash in caskhead0).
- [[casknet-wire-protocol]] — the encrypted-UDP command family the `cask`/`verb` commands would extend (and presumably wrap as inner `*e` encrypted forms).
- [[casksock-local-protocol]] — the local-socket sibling command set.
- [[gc-quarantine-store]] — the reachability-based GC that the permanent-storage nursery (approach C) leans on for eviction.
- [[cask-verb-catalog]] — the verb vocabulary a `verb` command names in its CBOR body.
- [[cask-blob-cat]] — the Merkle tree a multi-block command body is chunked into.
