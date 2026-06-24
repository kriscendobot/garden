---
title: Scope and Structure of caskhead0
source: doc/design/caskroot-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security, networking]
status: current
notes: caskhead0 is the minimal-viable concrete root block; ocaps.md's "ROOT (caskmap)" is the aspirational fuller root. caskhead0 ships only schema-version + session/membership/nursery links and defers cells/identity/consensus/pinned-roots to cells (the cell layer) or future iterations.
---

Abstract: `caskhead0` is the minimal viable first iteration of the CASK root structure — only what is essential to bootstrap a server with secure transport. Two things are in scope: a **schema version** (a fixed random 32-byte hash in `Links[0]` identifying the root format so future migrations can branch on it) and a **session table** (cryptographic session state for secure transport in `Links[1]`); everything else (identity, cells, membership, consensus, pinned roots) is deferred to future iterations or handled via cells. The root block is a fixed-layout block with four links — schema hash, sessions hash, membership hash (ZeroHash = empty), nursery hash (ZeroHash = empty) — and no bytes for v0; roots created with fewer than four links (legacy) remain valid because Load treats missing links as ZeroHash. The session-state blob (stored in compactblob, referenced by `Links[1]`'s sessiontable `data` hash) packs send/recv counters, the 32-byte ChaCha20-Poly1305 session key, a role byte, a mode byte, and a best-traffic-class byte.

## Scope

This iteration includes only what is essential to bootstrap a CASK server with secure transport:

1. **Schema version** — identifies this root format for future migration.
2. **Session table** — cryptographic session state for secure transport.

Everything else (identity, cells, membership, consensus, pinned roots) is deferred to future iterations or handled via cells.

## Structure

```
CASKHEAD0
 ├─► Links[0]     : schema_hash (fixed random value identifying v0)
 ├─► Links[1]     : sessions_hash (sessiontable root)
 ├─► Links[2]     : membership_hash (membership set root, ZeroHash = empty)
 ├─► Links[3]     : nursery_hash (nurserytable root, ZeroHash = empty)
 └─► Bytes: (none for v0)
```

Roots created with fewer than 4 links (legacy) are valid; Load treats missing links as ZeroHash.

### Schema hash

The schema hash is a fixed random 32-byte value identifying this version of the root structure:

```go
// Schema hash for caskhead0 - randomly generated, never changes
var SchemaV0 = cask.Hash{
    0x63, 0x61, 0x73, 0x6b, 0x68, 0x65, 0x61, 0x64,  // "caskhead"
    0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // "0" + padding
    0xa3, 0x7b, 0x91, 0x4c, 0x2e, 0x8f, 0x55, 0xd1,  // random
    0x6c, 0x42, 0x0e, 0x93, 0xb8, 0x71, 0xf4, 0x29,  // random
}
```

Future versions (caskhead1, caskhead2, ...) have different schema hashes. When loading a root, check `Links[0]` to determine which version's code path to use.

### Sessions table

Uses the existing `sessiontable` package:

```
sessiontable (from borkshop/cask/sessiontable)
 ├─► key (32 bytes)    : session_id for lookup
 ├─► expiry (uint64)   : deadline in Unix nanoseconds
 └─► data (Hash)       : reference to session state blob
```

Session-state blob format (stored in compactblob, referenced by `data` hash):

```
SESSION_STATE_BLOB
 ├─► Bytes[0:8]   : send_ctr (big-endian uint64)
 ├─► Bytes[8:16]  : recv_ctr (big-endian uint64)
 ├─► Bytes[16:48] : session_key (32 bytes, ChaCha20-Poly1305)
 ├─► Bytes[48]    : role (0=client, 1=server)
 ├─► Bytes[49]    : mode (0=member; future values for guest sessions)
 └─► Bytes[50]    : best_traffic_class (lowest class this session may claim; default 5)
```

Source: [doc/design/caskroot-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/caskroot-design.md) at commit `cdb975d8`.
