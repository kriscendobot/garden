---
source: notes/glossary.md
source_repo: dialog-db/dialog-db
source_commit: 054a7982ae47c06693c5ce6372a0844d1549a8d1
source_date: 2025-07-08
source_authors: [Argonaut Nautilus, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: Dialog's glossary — the canonical short definitions for the whole system, consolidated (per the library's glossary convention) into three grep-friendly sections that preserve the source's H3 anchors inline rather than mirroring ~50 entries as ~50 files. Covers core concepts (Fact/Entity/Attribute/Namespace/Value/Cause, Relation, Evidence, Rule, Fact Store) and database operations (Assertion, Retraction, Transaction, Commit, Revision, …); querying (Datalog, Variable, Term, Selector, Predicate, Formula, Negation, Query Planner); and data architecture, indexing/storage (EAV/AEV/VAE, Prolly Trees, segments, blob store), distributed sync (CRDT, Merkle-CRDT, Mutable Pointer, DID, CAS, Pull, Partial Replication), and implementation terms (Artifact, Scalar, Branch Factor, Genesis).

| Section | Topics | Status |
|---------|--------|--------|
| [terms-core-concepts-and-operations](../sections/dialog-db--notes-glossary--terms-core-concepts-and-operations.md) | datalog-query, local-first-sync | current |
| [terms-querying](../sections/dialog-db--notes-glossary--terms-querying.md) | datalog-query | current |
| [terms-architecture-storage-and-sync](../sections/dialog-db--notes-glossary--terms-architecture-storage-and-sync.md) | local-first-sync, datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `054a7982` (2025-07-08), by Argonaut Nautilus (a project contributor alias) with Irakli Gozalishvili. Consolidated per `library/conventions.md` § Sectioning shapes by source type (glossaries → 1–3 sections preserving anchors).
- Ingested in the `scholar-ingest-dialog-db-remainder` follow-on cycle (2026-07-06).
