---
title: Layer 2 — Merkle Tree and File System
source: doc/design/architecture.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
---

> Abstract: Layer 2 lifts raw block transfer into Merkle-tree and filesystem operations. The `TREE` command carries an op byte selecting SYNC (send missing blocks), DIFF (tree difference), WALK (tree metadata), or GC (mark reachable blocks); tree sync is a request/response loop where the server returns missing block hashes and the client LOADs them. The `FSOP` command exposes READ/WRITE/LIST/STAT/SYNC over a filesystem where directories are Merkle trees of (hash, mode, name) entries and files are Merkle trees of data blocks — Git-like but with tree structure transparent to GC, so a collector can walk from any root to enumerate reachable blocks without parsing block content. Both commands carry the common casknet header fields: 8-byte session, 32-byte recipient ed25519 key, 8-byte span (distributed-trace correlation), 8-byte cohort (load-management grouping).

## Tree Operations (`TREE`)

```
Fixed Fields:
  0   4   command    "TREE"
  4   8   session    Session number (64-bit big-endian)
  12  32  recipient  Recipient's ed25519 public key
  44  8   span       Span ID (64-bit big-endian)
  52  8   cohort     Cohort ID (64-bit big-endian)
  60  1   op         Operation type
  61  32  rootHash   Root hash of tree
  93  ..  opData     Operation-specific data
```

Operations: `0x01` SYNC (synchronize entire tree), `0x02` DIFF (difference between two trees), `0x03` WALK (tree metadata), `0x04` GC (mark reachable blocks).

**Tree sync protocol**: client sends TREE/SYNC with a root hash; server replies with missing block hashes; client LOADs each; server STORs them; repeat until synchronized.

**Garbage collection**: tree structure is transparent to GC, so GC can walk from root to identify reachable blocks and safely delete unreachable ones; GC hints can be exchanged to coordinate collection.

## File System Abstractions (`FSOP`)

```
Fixed Fields:
  0   4   command    "FSOP"
  4   8   session    Session number
  12  32  recipient  Recipient's ed25519 public key
  44  8   span       Span ID
  52  8   cohort     Cohort ID
  60  1   op         Operation type
  61  ..  path       Path string (null-terminated)
  ..  ..  opData     Operation-specific data
```

Operations: `0x01` READ, `0x02` WRITE, `0x03` LIST, `0x04` STAT, `0x05` SYNC.

**Structure**: directories are Merkle trees of entries (each entry: hash, mode, name); files are Merkle trees of data blocks. Git-like, but the tree structure is transparent to GC. Benefits: efficient synchronization (transfer only missing blocks), transparent collection, and support for various data representations overlaid on the structure.

Source: [doc/design/architecture.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/architecture.md) at commit `cdb975d8`.
