---
title: Root Block Layout and Flags
source: doc/design/root-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, capability-security, networking]
status: current
---

Abstract: The concrete link layout of the CASK root block across versions. **Version 0 (caskhead0, implemented)** is minimal: `Links[0]` is the schema hash (a fixed 32-byte SchemaV0 constant whose first 8 bytes are ASCII "caskhead", next 8 are "0" plus padding, last 16 are random for uniqueness) and `Links[1]` is the sessions hash (a session table root). **Future versions (caskhead1+)** expand to eight links: schema_hash, identity_hash, sessions_hash, cells_hash, membership_hash, consensus_hash (ZeroHash if not clustered), pinned_hash (pinned roots for GC), and application_hash (the application-specific root), plus an 8-byte feature-flags field in `Bytes[0:8]`. The **flags** are a big-endian uint64 where bit 0 is `clustered` (the server participates in a cluster with consensus enabled), bit 1 is `encrypted` (all sessions require encryption), bit 2 is `authenticated` (all sessions require authentication), and bits 3 through 63 are reserved.

## Root Block Layout

### Version 0 (caskhead0) - IMPLEMENTED

Minimal viable root with only session management:

```
CASKROOT0
 │
 ├─► Links[0]  : schema_hash      (SchemaV0 constant, identifies v0)
 └─► Links[1]  : sessions_hash    (session table root)
```

The schema hash is a fixed 32-byte value that identifies this version:
- First 8 bytes: "caskhead" (ASCII)
- Next 8 bytes: "0" + padding
- Last 16 bytes: random (for uniqueness)

See [caskroot-design](caskroot-design.md) for implementation details.

### Future Versions (caskhead1+)

Full root structure with all system components:

```
CASK_ROOT
 │
 ├─► Links[0]  : schema_hash      (identifies version)
 ├─► Links[1]  : identity_hash    (server identity block)
 ├─► Links[2]  : sessions_hash    (session table root)
 ├─► Links[3]  : cells_hash       (cell bank root)
 ├─► Links[4]  : membership_hash  (peer membership)
 ├─► Links[5]  : consensus_hash   (raft state, ZeroHash if not clustered)
 ├─► Links[6]  : pinned_hash      (pinned roots for GC)
 ├─► Links[7]  : application_hash (application-specific root)
 │
 └─► Bytes[0:8]: flags            (feature flags, see below)
```

### Flags (8 bytes, big-endian uint64)

```
Bit 0: clustered      - Server participates in a cluster (consensus enabled)
Bit 1: encrypted      - All sessions require encryption
Bit 2: authenticated  - All sessions require authentication
Bit 3-63: reserved
```

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8`.
