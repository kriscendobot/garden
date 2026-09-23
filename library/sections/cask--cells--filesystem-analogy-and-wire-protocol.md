---
title: Relationship to Filesystem, Wire Protocol, and Open Questions
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: Two naming systems coexist over the same data: a human, hierarchical **path** (`/foo/bar/baz`) and a cryptographic, flat **capability** (`0x7f3a...`); a directory can map a name to an immutable hash, a mutable cell address, or both. The analogy to traditional filesystems is exact: an `inode` (stable identity, mutable content) is a cell, and a `directory` (maps names to inodes/hashes) is a caskdir. Network access to cell operations rides the CAS wire protocol (`casw`/`casr`, currently in `peer.go`), with future `ALLOC` / `WRITE` / delegation-revocation commands anticipated. The document closes with five open questions: whether reads need a capability, whether cells carry metadata, cross-peer cell transfer, cell versioning/history, and conflict resolution (is CAS atomicity enough, or are CRDTs needed).

## Relationship to Filesystem

Two naming systems coexist:

- **Path** (human, hierarchical): `/foo/bar/baz`
- **Capability** (cryptographic, flat): `0x7f3a...`

A directory can map names to:
- Immutable hash (classic caskdir)
- Mutable cell address
- Both (cell that points to latest hash)

The inode/directory split in traditional filesystems is analogous:
- **inode** ≈ cell (stable identity, mutable content)
- **directory** ≈ caskdir (maps names to inodes/hashes)

## Wire Protocol

The CAS wire protocol (`casw`/`casr`) provides network access to cell
operations. See peer.go for current implementation.

Future extensions may add:
- `ALLOC` command for remote cell allocation
- `WRITE` command for cell mutation (vs CAS)
- Capability delegation/revocation commands

## Open Questions

1. **Read capabilities**: Should reading a cell require a capability, or is the
   cell_addr sufficient? Security vs convenience tradeoff.

2. **Cell metadata**: Should cells store metadata beyond value_hash? (e.g.,
   creation time, last modified, access control lists)

3. **Cross-peer cell transfer**: Can cell ownership be transferred between peers?
   What does that mean for capabilities?

4. **Cell versioning**: Should cells maintain history? Or is that the
   application's responsibility via the value tree?

5. **Conflict resolution**: When multiple writers race on a cell, CAS provides
   atomicity. Is that sufficient, or do we need CRDTs?

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
