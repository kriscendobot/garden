---
title: Goals and architecture overview
source: notes/sync.md
source_repo: dialog-db/dialog-db
source_commit: bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1
source_date: 2025-10-20
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The sync protocol's three goals — fetch and integrate changes from a remote tree, reconcile all changes into a deterministic convergent structure, and push results back — and its two-component architecture: a **Mutable Pointer** holding the canonical shared root hash (conceptually a Git remote ref) and an **Archive** storing immutable hash-addressed blobs (tree index and segment nodes) over commodity backends (S3, R2, IPFS). A local replica queries the pointer for the root, fetches blobs for that root from the archive, merges locally, uploads new blobs, and PATCHes the pointer.

The synchronization protocol has three goals:

- Fetch and integrate changes from a remote tree.
- Reconcile all changes into a deterministic, convergent structure.
- Push the resulting changes back to the remote.

A **Mutable Pointer** represents the canonical shared root of a tree, while the **Archive** stores immutable, hash-addressed blobs representing tree nodes. The local tree replica queries the root from the pointer, fetches blobs for that root from the archive (unless cached), merges local and remote, uploads new blobs to the archive, and updates the root on the pointer.

The synchronization sequence:

1. `HEAD /did` (query root) → `200 ETag=abc123` from the Remote Pointer.
2. `GET` blobs for root `abc123` from the Archive (Fetch).
3. `merge(local, remote)` locally.
4. `PUT` new blobs to the Archive (Put).
5. `PATCH /did` (Push) → `200 OK` or `412 Precondition Failed`.

Source: [notes/sync.md](https://github.com/dialog-db/dialog-db/blob/bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1/notes/sync.md) at commit `bf88f2c3`.
