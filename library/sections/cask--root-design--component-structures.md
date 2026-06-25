---
title: Component Structures
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

Abstract: The seven component structures the full caskhead1+ root links to. (1) **Identity block**: ed25519 public/private key (private encrypted at rest), a created_ns timestamp, and a stable random 32-byte node_id used for peer recognition independent of key material (so it survives key rotation). (2) **Session table**: the existing `sessiontable` structure (session_id, deadline, data-hash), with the session-state blob holding send/recv counters, a 32-byte ChaCha20-Poly1305 session key, role, and mode; active sessions are cached in memory with dirty tracking and periodic flush, evicted past deadline. (3) **Cell bank**: the capability system's mutable-reference store (a capability_map cap_token→cell_addr plus a cell_map cell_addr→value_hash), and the GC root for mutable state. (4) **Membership**: a Rabin-chunked sorted array of peers (peers_index node_id→peer_info_index, a peer_info parallel array, and a `trusted` pure-set subset authorized for cluster operations); sorted-by-node_id enables lookup, range-query sharding, localized Merkle change, and tree-diff sync, and adding to `trusted` requires an explicit bootstrap ceremony. (5) **Consensus (Raft) state**: term/voted_for/commit_index/last_applied plus a log_root and snapshot_hash, placed in the root because leader election must work before the application layer is available. (6) **Pinned roots**: a caskset of root hashes that is the GC root for the pinned retention regime, auto-pinning the root block, cell values, Raft state, and membership, with application pins added/removed explicitly. (7) **Application root**: a single hash reference under which the application layer builds its own structure, cleanly separating system structures above from application structures below.

## Component Structures

### 1. Identity Block

The server's cryptographic identity, generated once at bootstrap.

```
IDENTITY_BLOCK
 │
 ├─► Bytes[0:32]   : ed25519_public_key
 ├─► Bytes[32:64]  : ed25519_private_key (encrypted at rest)
 ├─► Bytes[64:72]  : created_ns (Unix nanoseconds)
 └─► Bytes[72:104] : node_id (random 32 bytes, stable identifier)
```

**Security**: The private key should be encrypted with a key derived from a passphrase (interactive), a hardware security module, a secrets manager, or an environment variable (development only).

The `node_id` is a stable random identifier that doesn't change even if keys are rotated. It's used for peer recognition independent of key material.

### 2. Session Table

Uses the existing `sessiontable` structure (see ALLOCATOR_DESIGN.md):

```
SESSION_TABLE (from sessiontable package)
 ├─► session_id (32 bytes) - lookup key
 ├─► deadline (uint64)     - expiry in Unix nanoseconds
 └─► data (Hash)           - reference to session state blob
```

**Session State Blob** (compactblob):
```
Bytes[0:8]   : send_ctr (big-endian)
Bytes[8:16]  : recv_ctr (big-endian)
Bytes[16:48] : session_key (32 bytes, ChaCha20-Poly1305)
Bytes[48]    : role (0=client, 1=server)
Bytes[49]    : mode (0=member; future values for guest sessions)
Bytes[50]    : best_traffic_class (lowest class this session may claim; default 5)
```

**In-Memory Cache**: Active sessions are cached in memory with dirty tracking. Periodic flush writes dirty sessions to the table. On eviction (deadline passed), sessions are removed from both cache and table.

### 3. Cell Bank

The capability system's mutable reference store (see CELLS.md):

```
CELL_BANK
 │
 ├─► Links[0] : capability_map (caskmap: cap_token → cell_addr)
 └─► Links[1] : cell_map (caskmap: cell_addr → value_hash)
```

The cell bank is the GC root for mutable state. All application data that needs to persist must be reachable from a cell.

### 4. Membership

Known peers for clustering, replication, and routing. Uses a Rabin-chunked sorted array (see SORTED_ARRAY_DESIGN.md) for efficient lookup and sync.

```
MEMBERSHIP_ROOT
 │
 ├─► Links[0] : peers_index (sortedarray: node_id → peer_info_index)
 ├─► Links[1] : peer_info (array of peer info blocks)
 ├─► Links[2] : trusted (sortedarray: trusted node_ids, pure set)
 │
 └─► Bytes[0:32] : self_node_id
```

**Peers Index Entry** (40 bytes): `Bytes[0:32]` node_id (sort key), `Bytes[32:40]` peer_info_index (uint64 into peer_info array).

**Peer Info Block** (stored in parallel array):
```
PEER_INFO
 ├─► Bytes[0:32]   : ed25519_public_key
 ├─► Bytes[32:40]  : first_seen_ns
 ├─► Bytes[40:48]  : last_seen_ns
 ├─► Bytes[48:50]  : port (big-endian uint16)
 ├─► Bytes[50]     : address_type (0=IPv4, 1=IPv6, 2=hostname)
 └─► Bytes[51:..]  : address (4 bytes IPv4, 16 bytes IPv6, or hostname)
```

**Why Rabin-chunked sorted array**: sorted by node_id enables efficient peer lookup; range queries support sharding (peers in a hash range); Rabin chunking localizes Merkle changes when peers join/leave; efficient sync (peers can diff membership trees).

**Trust Model**: `peers_index` contains all known peers (discovered or configured); `trusted` is the subset authorized for cluster operations; adding to `trusted` requires explicit action (bootstrap ceremony).

### 5. Consensus State (Raft)

For clustered deployments, Raft state for leader election.

```
RAFT_STATE
 │
 ├─► Bytes[0:8]    : current_term
 ├─► Bytes[8:40]   : voted_for (node_id, or zero if none)
 ├─► Bytes[40:48]  : commit_index
 ├─► Bytes[48:56]  : last_applied
 │
 ├─► Links[0]      : log_root (array of log entries)
 └─► Links[1]      : snapshot_hash (latest snapshot, if any)
```

**Log Entry**: `Bytes[0:8]` term, `Bytes[8:16]` index, `Bytes[16]` entry_type (0=command, 1=config_change, 2=noop), `Links[0]` command_hash (application command).

**Placement**: Raft operates at Layer 4 (Orchestration) but its state lives in the root structure because leader election must work before the application layer is available, consensus state is fundamental to cluster operation, and log entries reference application commands by hash.

### 6. Pinned Roots

The set of root hashes for GC (see GC_AND_RETENTION.md):

```
PINNED_ROOTS
 └─► caskset of root hashes
```

This is the GC root for the pinned retention regime. Everything reachable from these hashes is retained; unreachable blocks may be collected.

**Automatic Pins**: the root block itself, all cell values (via cell_map), Raft log and snapshot, membership info. **Application Pins**: added via explicit pin operations, removed when no longer needed.

### 7. Application Root

A single hash reference for application-specific data. The application layer builds its own structure rooted here.

```
APPLICATION_ROOT
 └─► (application-defined structure)
```

This provides a clean separation: system structures above, application structures below this single reference point.

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8`.
