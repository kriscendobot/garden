---
title: Archive (decoupled hash-addressed blob store)
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

> Abstract: The Archive is a shared data store over a commodity backend (S3, R2, IPFS) holding **hash-addressed blobs** of encoded tree index and segment nodes. Read/write access control is managed out of band, tied to the backend's own authentication. The Archive is **fully decoupled** from the Mutable Pointer — the pointer SHOULD NOT have access to it nor verify that uploaded roots are archived — which keeps the two layers independently substitutable; more advanced implementations may add proof-based updates (Merkle inclusion proofs or signed archive commitments) for stronger consistency.

The **Archive** is a shared data store over a commodity backend such as S3, R2, or IPFS. It stores **hash-addressed blobs** representing encoded tree index and segment nodes. Access control (read/write) is managed out of band and tied directly to the backend's authentication.

The Mutable Pointer is fully decoupled from the archive — it SHOULD NOT have access to it, nor verify that uploaded roots are archived. More advanced implementations may require proof-based updates (e.g. Merkle inclusion proofs or signed archive commitments) to enforce stronger consistency invariants.

Source: [notes/sync.md](https://github.com/dialog-db/dialog-db/blob/bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1/notes/sync.md) at commit `bf88f2c3`.
