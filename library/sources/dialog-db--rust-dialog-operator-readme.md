---
source: rust/dialog-operator/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: The README for `dialog-operator`, the crate that assembles profiles, operators, and the runtime capability environment for Dialog — the executable form of the account/profile/operator identity model from `notes/repository.md`. A **Profile** is a named device identity backed by a signing credential; an **Operator** is a session-scoped environment derived from a profile that routes all capability effects (storage, archive, memory, access control) through DID-based dispatch with privilege narrowing. The documented flow is create `Storage` → `Profile::open(name)` → `profile.derive(context).allow(cap).build(storage)` → `profile.repository(name).open().perform(&operator)`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [profiles-operators-and-capability-environment](../sections/dialog-db--rust-dialog-operator-readme--profiles-operators-and-capability-environment.md) | ucan-authorization | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- The runtime counterpart to `rust/dialog-capability` (typed chains), `rust/dialog-effects` (structural effect types), and `rust/dialog-storage` (`Provider<Fx>` execution). Notes-level design counterpart: `notes/repository.md` (identity layers, operator setup) and `notes/space-and-storage.md` (the routing environment).
- Ingested in the `scholar-ingest-dialog-db-remainder-9` cycle (2026-07-06).
