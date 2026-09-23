---
title: Cell Facets, Per-Cell Structure, and Capability Hierarchy
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: The heart of the ocap model — each cell has **five facets**, each gated by a separate capability: **read** (`READ(read_cap) -> (content_hash, version)`), **write** (`WRITE(write_cap, old_hash, new_hash) -> (success, current_hash, version)`, always compare-and-swap), **observe** (`OBSERVE`/`UNOBSERVE` register persisted write-guards so the cell pushes `(version, content_hash)` notifications to peers over authenticated sessions), and two **delegation** facets, **delegate-read** and **delegate-write** (each can create / revoke / list the read or write capabilities for that cell). Because multiple capabilities can grant the same access, a cell's per-cell caskmap entry points its `"read"` and `"write"` keys at **sets** of capabilities while `observe` and the delegate facets stay single. The capabilities form a **hierarchy** under the `root_cap`: root allocates/deletes/lists cells; per cell, `delegate_write_cap` (which implies delegate-read authority) and `delegate_read_cap` manage the individual `write_cap`s and `read_cap`s, while `observe_cap` manages observers. Authority strictly narrows down the tree — an individual read or write cap grants only its one specific access.

## Cell facets

Each cell has five facets, each controlled by a separate capability.

**Read facet** — `READ(read_cap) -> (content_hash, version)`. Knowing the read capability hash allows looking up the current content hash and version for that cell.

**Write facet** — `WRITE(write_cap, old_hash, new_hash) -> (success, current_hash, version)`. All writes are compare-and-swap: present the write capability, provide expected old hash and desired new hash; the operation succeeds only if the current hash matches the old hash, version increments atomically on success, and the call returns success/failure, current hash, and current version. This ensures atomic updates and enables optimistic concurrency control.

**Observe facet** — `OBSERVE(observe_cap, peer_addr) -> subscription_id` and `UNOBSERVE(observe_cap, subscription_id) -> error`. Registering a peer address means CASK sends that peer a message on each update containing the monotonic version number and current content hash — enabling reactive patterns and cache invalidation. Observer registrations are persisted in block storage as part of the cell's metadata:

```
CELL_OBSERVERS (caskmap):
  subscription_id (32) ──► OBSERVER_REGISTRATION

OBSERVER_REGISTRATION:
  peer_pubkey: 32 bytes
  peer_addr:   variable (connection hints)
  registered:  uint64 (timestamp)
```

Observer authentication is tied to session cryptography — notifications are sent over authenticated sessions (details TBD pending session protocol design).

**Delegate-read facet** — `DELEGATE_READ(delegate_read_cap) -> new_read_cap`, `REVOKE_READ`, `LIST_READ_CAPS`. Allows creating, revoking, and listing read capabilities: granting read access to new parties, revoking it without affecting other readers, and auditing who has read access.

**Delegate-write facet** — `DELEGATE_WRITE(delegate_write_cap) -> new_write_cap`, `REVOKE_WRITE`, `LIST_WRITE_CAPS`. Allows creating, revoking, and listing write capabilities.

## Cell structure in the root store

With five facets, each cell's entry in the cells caskmap expands:

```
ROOT (caskmap)
 └─► "cells" ──► CELLS (caskmap)
                  └─► cell_id ──► CELL (caskmap)
                                   ├─► "state"          ──► cell_state_hash
                                   ├─► "observers"      ──► observers_map_hash
                                   ├─► "read"           ──► read_caps_set_hash
                                   ├─► "write"          ──► write_caps_set_hash
                                   ├─► "observe"        ──► observe_cap_hash
                                   ├─► "delegate_read"  ──► delegate_read_cap_hash
                                   └─► "delegate_write" ──► delegate_write_cap_hash
```

The read and write facets point to **sets** of capabilities (multiple capabilities can grant the same access level); the observe and delegate facets remain single capabilities.

## Capability hierarchy

```
root_cap (full authority)
    │
    ├─► allocate/delete cells
    ├─► list all cells
    └─► for each cell:
          ├─► delegate_write_cap
          │     ├─► create/revoke/list write_caps
          │     └─► (implies delegate_read authority)
          ├─► delegate_read_cap
          │     └─► create/revoke/list read_caps
          ├─► write_cap (one of many)
          │     └─► CAS cell content
          ├─► read_cap (one of many)
          │     └─► read cell content
          └─► observe_cap
                └─► register/unregister observers
```

The root capability confers all authority. Delegation capabilities allow creating and managing access without root authority. Individual read/write capabilities grant only their specific access.

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
