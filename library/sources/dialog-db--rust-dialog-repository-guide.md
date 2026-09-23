---
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 8
status: current
---

> Abstract: The task-oriented Guide for `dialog-repository`, opening with the framing **Dialog is a local-first database with built-in identity, replication, and delegated access control** and walking the whole surface: the three-keypair Identity model (profile / operator / account, chain `subject -> profile -> operator`); Setup (`Storage::default()`, `Profile::open`, `.derive().allow().build()`, base-directory override); Repository and branch open/load/create modes and their `Repository<Credential>` vs `Repository<SignerCredential>` return types; Writing semantic triples through `branch.transaction().assert().commit()`; Querying via typed concepts, deductive rules (`.query().install(rule)`), and raw artifact selection with automatic remote fallback; Syncing (remote, `set_upstream`, push/pull, `.subject(did)` targeting, on-demand block replication); and Collaboration through UCAN delegation (the Alice-sets-up / Alice-invites-Bob / Bob-joins flow). The reference-shape counterpart is this crate's `README.md`; the design-level rationale is `notes/repository.md`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-repository-guide--overview.md) | local-first-sync | current |
| [identity-profile-operator-account](../sections/dialog-db--rust-dialog-repository-guide--identity-profile-operator-account.md) | ucan-authorization, capability-security | current |
| [setup-storage-and-operator](../sections/dialog-db--rust-dialog-repository-guide--setup-storage-and-operator.md) | local-first-sync | current |
| [repository-and-branch-modes](../sections/dialog-db--rust-dialog-repository-guide--repository-and-branch-modes.md) | local-first-sync | current |
| [writing-semantic-triples](../sections/dialog-db--rust-dialog-repository-guide--writing-semantic-triples.md) | datalog-query | current |
| [querying-concepts-rules-and-artifacts](../sections/dialog-db--rust-dialog-repository-guide--querying-concepts-rules-and-artifacts.md) | datalog-query | current |
| [syncing-remotes-and-upstream](../sections/dialog-db--rust-dialog-repository-guide--syncing-remotes-and-upstream.md) | local-first-sync, ucan-authorization | current |
| [collaboration-ucan-delegation](../sections/dialog-db--rust-dialog-repository-guide--collaboration-ucan-delegation.md) | ucan-authorization, capability-security | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili.
- The task-oriented Guide of the top-of-stack repository crate. Its reference-shape companion is `rust/dialog-repository/README.md` (ingested the same cycle); the design-level rationale is `notes/repository.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-11` cycle (2026-07-06).
