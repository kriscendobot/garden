---
source: notes/subject-routing-options.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: A historical design decision record for how a capability effect (e.g. `archive::Get` on subject `did:key:zRepo`) finds its storage — the subject DID says *who* but not *where*, so the system must both resolve a name to a DID and route the DID to a storage location. Three options are weighed (A: location carried in `Subject`, breaks on bare-DID reconstruction; B: a `Did → Provider` routing table in the environment, robust but shared mutable state; C: routing by filesystem layout convention, simplest but single-provider), and the implementation adopts a hybrid: Option B (`Router` in `Storage<S>`) for DID dispatch plus Option C's convention for per-space layout, with the `Loader` creating providers from `Location` address resolution and registering them under each space's DID.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--notes-subject-routing-options--overview.md) | ucan-authorization, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. Part of the `notes/` storage cluster; the design rationale behind the `Router`/`Loader` split that `notes/space-and-storage.md` documents as the implemented two-level dispatch.
- Ingested in the `scholar-ingest-dialog-db-remainder-6` cycle (2026-07-06), the storage cluster.
