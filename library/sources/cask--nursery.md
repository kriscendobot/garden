---
source: doc/design/nursery.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 3
status: current
notes: An exploratory essay ("more open questions than closed answers"); the nursery, the cask/verb commands, and the buffer consolidation are proposed designs, not yet implemented. Introduces concept cask-nursery; the cask/verb commands extend the casknet command family (cf. casknet-wire-protocol, casksock-local-protocol); the nursery root attaches under cask-caskhead-root; eviction is GC-rooted via gc-quarantine-store.
---

> Abstract: The design of CASK's **block nursery**, a staging area where incoming blocks land before they are rooted in permanent storage, and the `cask`/`verb` packet commands that drive multi-block command execution. The essay separates two block lifetimes (a short per-packet TTL bounded by retransmission, a longer command TTL bounded by client patience), requires a hash-indexed staging structure with `ready`-channel blocking loads and reference-aware eviction, and proposes placing the nursery in permanent storage under a `caskhead` nursery root so a mid-transfer restart is recoverable and GC reachability handles cleanup. It defines the new `cask` (stage one block, no verb) and `verb` (collect the Merkle tree at a root, validate the capability, walk the path, run the reduce, CAS the cell) commands plus a single-block combined form and the CBOR command body, proposes consolidating the overlapping tempstore and recvbuffer into one structure, weighs three reference-counting/eviction approaches, and specifies sender- and receiver-side deadline clamping. It closes with eleven open questions (nursery location, cancellation, recovery, GC cadence, dedup, encryption, response shape, batching, read-verb formats, heartbeat, flow control).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [two-ttls-and-the-nursery](../sections/cask--nursery--two-ttls-and-the-nursery.md) | content-addressed-storage | current |
| [cask-and-verb-packet-commands](../sections/cask--nursery--cask-and-verb-packet-commands.md) | networking, content-addressed-storage | current |
| [eviction-consolidation-and-deadline-clamping](../sections/cask--nursery--eviction-consolidation-and-deadline-clamping.md) | networking, content-addressed-storage | current |

## Provenance

Source: [doc/design/nursery.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/nursery.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-25 (job `scholar-ingest-cask-13`, cycle 14).
