---
title: Overview, Root Store Structure, Cryptographic Sessions, and On-Disk Layout
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
notes: ocaps.md is the cryptographic capability-token / network layer named by cell-capabilities.md's *Relationship to the Capability Map* as complementary to the entry-type structural-local layer. Co-current lineage sibling of cells.md / cells-and-entries.md / cell-capabilities.md; not a supersession.
---

Abstract: CASK's object-capability authorization model and the extensible root store it lives in. A **capability** is an unguessable **32-byte token** (256 bits of entropy); possession of the token is sufficient proof of authorization, so there are **no ACLs and no identity checks**. The store's root is a **caskmap that can be extended over time** without breaking existing functionality: a `"cells"` section maps each `cell_id` to that cell's per-facet capability hashes, a `"sessions"` section maps each peer pubkey to a cryptographic-session state hash, and future top-level categories can be added beside them. On disk the store is just `.cask/` holding a 32-byte `NONCE` (which doubles as both the store identity and the **root capability** bearer token), a 32-byte `ROOT` (the current root caskmap hash), and a content-addressed `blocks/` directory. This is the cryptographic-network half of CASK's two-layer capability model; the structural-local half is the entry-type layer in cell-capabilities.md.

CASK uses an object capability (ocap) model for authorization. Capabilities are unguessable 32-byte tokens that grant specific permissions. Possession of a capability is sufficient proof of authorization — no ACLs or identity checks required.

## Root store structure

The root of the CAS is a caskmap that can be extended over time:

```
ROOT (caskmap)
 │
 ├─► "cells" ──► CELLS (caskmap)
 │                 │
 │                 ├─► cell_id_0 ──► CELL_0 (caskmap)
 │                 │                   ├─► "read"    ──► read_cap_hash
 │                 │                   ├─► "write"   ──► write_cap_hash
 │                 │                   └─► "observe" ──► observe_cap_hash
 │                 └─► ...
 │
 ├─► "sessions" ──► SESSIONS (caskmap)
 │                    ├─► peer_pubkey_0 ──► session_state_hash
 │                    └─► ...
 │
 └─► (future top-level categories...)
```

This structure allows the root to grow new top-level sections without breaking existing functionality.

## Cryptographic sessions

The `"sessions"` section of the root store tracks cryptographic sessions with peers:

```
SESSIONS (caskmap)
  peer_pubkey (32) ──► session_state_hash (32)
```

Session state includes handshake state (ephemeral keys, shared secrets), replay protection (nonce counters), and capability bindings (which capabilities this peer holds). See cryptography.md (`cask--cryptography`) for session establishment details.

## On-disk layout

```
.cask/
  NONCE           # 32 bytes: root capability / store identity
  ROOT            # 32 bytes: current root caskmap hash
  blocks/         # content-addressed block storage
```

The `NONCE` serves dual purposes: it is the **store identity** (uniquely identifies this store instance) and the **root capability** (a bearer token for full authority over the store).

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
