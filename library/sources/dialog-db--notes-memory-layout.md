---
source: notes/memory-layout.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The memory-cell layout each repository (scoped to a subject DID) uses to hold its Git-like sync state, and how fetch/pull/push manipulate it. Local branches use `branch/{name}/revision` (`Cell<Revision>`, the head) and `branch/{name}/upstream` (`Cell<Option<UpstreamState>>`, what it tracks); remote sites use `remote/{name}/address` (`Cell<RemoteAddress>`) and `remote/{name}/branch/{branch}/revision` (`Cell<Revision>`, last-fetched). **fetch** resolves the remote revision and writes only the remote cell; **pull** three-way-merges upstream/base/local and advances the local revision and upstream tree; **push** diffs base-to-local for novel blocks, uploads and publishes, then advances the upstream and remote cells. Supporting types: `SiteAddress` (`S3 | Ucan`), `RemoteAddress` (adds `subject: Did`), `UpstreamState` (`Local | Remote`), and `Revision` (`{ subject, issuer, authority, tree, cause, period, moment }`, `tree` = blake3 `NodeReference` of the prolly-tree root).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [branch-and-remote-cells](../sections/dialog-db--notes-memory-layout--branch-and-remote-cells.md) | change-propagation, local-first-sync | current |
| [fetch-pull-push-operations](../sections/dialog-db--notes-memory-layout--fetch-pull-push-operations.md) | change-propagation, local-first-sync | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. Part of the `notes/` storage cluster; the concrete cell layout under the `memory` capability whose Resolve/Publish/Retract operations `notes/repository.md` and `notes/space-and-storage.md` describe. The fetch/pull/push flows are the operational side of the sync design in `notes/sync.md` and `notes/version-control.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-6` cycle (2026-07-06), the storage cluster.
