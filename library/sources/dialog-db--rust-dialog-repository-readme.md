---
source: rust/dialog-repository/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The README for `dialog-repository`, dialog-db's top-of-stack crate that presents a **git-like interface for structured data** — repositories with branches, remotes, push/pull, and merge, but over `{the, of, is, cause}` claims rather than files. It states the defining determinism property (same name under the same profile → same repository identity) and gives one end-to-end fluent walkthrough: `Storage::default()` → `Profile::open` → `.derive` operator → `repository("contacts").open()` → `branch("main")` → a `#[derive(Concept)]` schema → `transaction().assert().commit()` → `query().select(Query::<T>)` → `remote("origin").create(UcanAddress::new(..))` → `set_upstream` → `push`/`pull`. The design-level counterpart is `notes/repository.md`; the task-oriented companion is this crate's `Guide.md`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-repository-readme--overview.md) | local-first-sync, capability-security | current |
| [usage-walkthrough](../sections/dialog-db--rust-dialog-repository-readme--usage-walkthrough.md) | local-first-sync, datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- The reference-shape README of the top-of-stack repository crate. Its task-oriented companion is `rust/dialog-repository/Guide.md` (ingested the same cycle); the design-level rationale is `notes/repository.md` (identity layers, named spaces, opening).
- Ingested in the `scholar-ingest-dialog-db-remainder-11` cycle (2026-07-06).
