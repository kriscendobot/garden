---
source: notes/sync.md
source_repo: dialog-db/dialog-db
source_commit: bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1
source_date: 2025-10-20
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: Dialog's Sync Implementation Proposal: how a local partial replica fetches, merges, and pushes changes against a remote, coordinating through a **Mutable Pointer** (the canonical signed root reference, Git-remote-like, updated by compare-and-swap) and an **Archive** (a decoupled hash-addressed blob store over S3/R2/IPFS). Pull = Fetch (materialize a partial replica from the pointer's current root) then Merge, where a differential against the last-pushed checkpoint (a ZSet-like set of Add/Remove entries) is integrated into the fetched remote tree, replicating only changed subtrees and resolving concurrent entry conflicts by greater-hash-wins. Provides eventual consistency with deterministic convergence.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-goals](../sections/dialog-db--notes-sync--overview-and-goals.md) | local-first-sync | current |
| [mutable-pointer-protocol](../sections/dialog-db--notes-sync--mutable-pointer-protocol.md) | local-first-sync | current |
| [archive](../sections/dialog-db--notes-sync--archive.md) | local-first-sync | current |
| [pull-fetch-and-merge](../sections/dialog-db--notes-sync--pull-fetch-and-merge.md) | local-first-sync, change-propagation | current |
| [consistency-model](../sections/dialog-db--notes-sync--consistency-model.md) | local-first-sync, change-propagation | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `bf88f2c3` (2025-10-20), authored by Irakli Gozalishvili.
- Ingested in the `scholar-ingest-dialog-db-remainder` follow-on cycle (2026-07-06), the second dialog-db cycle after the five-flagship first pass.
