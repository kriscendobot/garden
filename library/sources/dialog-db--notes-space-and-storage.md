---
source: notes/space-and-storage.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The storage runtime that routes capability effects to backend providers via two-level dispatch — first by subject DID (which space), then by capability (which provider within that space). Three core types: a `Location` (a `Directory` category plus a name, resolved per-platform), a `Space<A, M, C, D>` (a `#[derive(Provider)]` product of archive, memory, credential, and certificate providers with generated capability dispatch), and `Storage<S>` (a `Loader` for space bootstrap plus a `Router` for DID-based dispatch; native default over `FileSystem`, web default over `IndexedDb`). Mounting resolves a location, creates providers, reads the credential directly (no bootstrap-DID hack), registers the space under its DID, and returns the credential; the concrete FileSystem and IndexedDB layouts and the `Profile`/`Repository` setup flow follow.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [core-types-location-space-storage](../sections/dialog-db--notes-space-and-storage--core-types-location-space-storage.md) | ucan-authorization | current |
| [mounting-and-two-level-dispatch](../sections/dialog-db--notes-space-and-storage--mounting-and-two-level-dispatch.md) | ucan-authorization | current |
| [layouts-and-setup-flow](../sections/dialog-db--notes-space-and-storage--layouts-and-setup-flow.md) | ucan-authorization, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. The runtime-routing companion to `notes/capability-sysstem.md` (the capability model the two-level dispatch enforces).
- Ingested in the `scholar-ingest-dialog-db-remainder-3` follow-on cycle (2026-07-06), part of the rules/scope cluster.
