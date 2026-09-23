---
title: Status Document Shape and Roadmap
source: doc/design/status.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [repository-governance]
status: current
notes: Captured as SHAPE, not rows, per conventions.md "shape not content for upstream meta-tables". The implemented-package and CLI-command lists change at upstream's cadence; query status.md at the current commit for the live inventory. The stable interface definitions and roadmap structure are captured because they are slow-moving.
---

Abstract: The shape of CASK's `status.md` roadmap document (as of February 2026), captured per the library's "shape not rows" rule because the per-package and per-command inventories change at upstream's cadence rather than the library's. The document partitions into three time horizons. **Implemented** is a six-category inventory (Core Storage; Data Structures; Network; System Root; Utilities; CLI) plus two protocol command lists (the encrypted-UDP casknet set and the plaintext-Unix-socket casksock set) and a set of stable Go interface definitions. **In Progress** tracks cells (the mutable-reference layer: cell bank, weak refs in trees, extended caskdir modes). **Planned** is itself three-tiered: Near Term (the ROOT→HEAD rename — now `cask/head`; cell bank implementation; extended caskdir modes), Medium Term (distributed cells; object capabilities; phase-locked NTP-like clocks), and Long Term (Raft consensus + replication; sharding). A **Design Documents** table at the foot indexes the whole `doc/design/` corpus with one-line descriptions. The stable, slow-moving content worth recording is the interface set and the roadmap structure; the changing content (which packages exist, which CLI subcommands ship, which casknet/casksock opcodes are live) should be read from `status.md` at the current commit rather than mirrored here. Notable cross-references this status surfaces: the implemented `cask/net` data commands are `stor`/`load`/`rots`, `casc`/`csac`, `gcgc`/`cgcg` (responses are the request reversed), distinct from the proposed `cask`/`verb` nursery commands; the casksock command set is the twelve documented in [[casksock-local-protocol]].

## Document structure (the shape)

`status.md` is a roadmap organized by implementation status. Its top-level structure:

- **Current State (February 2026) → Implemented** — six sub-categories, each a bullet list of packages with a one-line role:
  - **Core Storage**: the `cask` block format, the store family (`memstore`, `diskstore`, `dbstore`, `tempstore`, `collectorstore`, `diskcollectorstore`).
  - **Data Structures**: `blob`/`compactblob`, `dir`/`compactdir`, `map`, `set`, `array`, `hashtree`, the `hashtreetouint8/16/32/64` family, `allocator`, `indexheap`, `sessiontable`, `membertable`, `bigintarray`, `arraytree`.
  - **Network**: `net` (encrypted UDP), `sock` (local Unix socket), `memnet` (test simulator), `sendbuffer`/`recvbuffer`.
  - **System Root**: `head` (server head: schema version + session table + membership).
  - **Utilities**: `io`, `tel`, `storetest`, and the `cask/go/*` helpers (`heap`, `jot`, `raft` (partial), `swap`, `repeat`, `typeuint64`).
  - **CLI**: the `cask` subcommands (`init`, `start`, `stop`, `serve`, `daemon`, `relay`, `checkin`/`checkout`, `store`/`load`, `nonce`/`head`, `cas`, `member add`/`rm`/`ls`).
- **casknet Protocol** and **casksock Protocol** — two opcode lists (the shape: a session-handshake pair plus reversed-response data commands for casknet; a dozen lowercase 4-byte commands for casksock).
- **Interfaces** — Go interface definitions (the stable API surface; see below).
- **In Progress** — cells.
- **Planned** — Near / Medium / Long term.
- **Design Documents** — an index table mapping each `doc/design/*.md` to a one-line description.

## Stable interface surface

The interface block is slow-moving and worth recording verbatim:

```go
// Basic block storage
type Store interface {
    Store(ctx, hash, block, metadata) error
    Load(ctx, hash, block, metadata) error
}

// Garbage collection support
type CollectibleStore interface {
    Store
    List(ctx, fn) error
    Delete(ctx, hash) error
}

// Mutable reference support
type CASStore interface {
    Store
    CAS(ctx, nonce, address, old, new) (success, current, error)
    Nonce(ctx) (Hash, error)
    Head(ctx) (Hash, error)
}

// GC with quarantine and statistics
type CollectStats struct {
    BlocksRetained  int64
    BlocksCollected int64
    Err             error
}
type Collector interface {
    Collect(ctx, root) <-chan CollectStats
}
```

## Roadmap horizons (structure, not commitments)

- **Near Term**: ROOT → HEAD rename (the `caskroot` → `cask/head` package rename is done; the `.cask/ROOT` → `.cask/HEAD` file rename and `cask tip` → `cask head` command follow); cell bank implementation (caskmap for capability→cell_addr and cell_addr→value_hash); extended caskdir modes (category/subtype encoding, cell-reference entries).
- **Medium Term**: distributed cells (remote refs, cross-peer resolution, capability delegation); object capabilities (hierarchical allocation, delegation/revocation, RPC on cells — see `ocaps.md`); phase-locked NTP-like clocks (PING/PONG keep-alive and RTT, clock sync for tighter session-timestamp tolerance).
- **Long Term**: consensus and replication (Raft leader election, replicated cell banks, consistent snapshots); sharding (partitioned cell banks, routing and migration).

To recover the live per-package, per-command, and per-subcommand inventory, read `doc/design/status.md` at the current `main` commit rather than relying on this captured shape.

Source: [doc/design/status.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/status.md) at commit `cdb975d8`.
