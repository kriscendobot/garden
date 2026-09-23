---
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 9
status: current
---

> Abstract: The DialogDB architecture overview — the single most complete statement of the system's design. It sets six design goals (user-owned data, local-first operation, flexible schema, efficient sync, privacy/security, collaboration) and an information model built on an immutable append-only fact store combining Probabilistic B-Trees with Datalog. Nine sections decompose it: the design goals and information model; facts as atomic `{the, of, is, cause}` units; the causal (B-theory) temporal model; schema-on-query; the Merkle-CRDT query-time merge semantics; the Probabilistic-B-Tree + segment storage layer; the EAV/AEV/VAE indexes; the blob-store + DID:key-mutable-pointer decoupled persistence; and the Datalog query language with time-travel. Prior art acknowledged: Datomic (Datalog + facts), Merkle-CRDTs, Prolly Trees, RhizomeDB (causal consistency), Ink & Switch (local-first).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--notes-architecture-overview--overview.md) | local-first-sync, datalog-query | current |
| [facts-as-atomic-units](../sections/dialog-db--notes-architecture-overview--facts-as-atomic-units.md) | datalog-query, local-first-sync | current |
| [causal-temporal-model](../sections/dialog-db--notes-architecture-overview--causal-temporal-model.md) | local-first-sync, change-propagation | current |
| [schema-on-query](../sections/dialog-db--notes-architecture-overview--schema-on-query.md) | datalog-query | current |
| [merkle-crdt-merge-semantics](../sections/dialog-db--notes-architecture-overview--merkle-crdt-merge-semantics.md) | change-propagation, local-first-sync | current |
| [probabilistic-btrees-and-segments](../sections/dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments.md) | content-addressed-storage, local-first-sync | current |
| [eav-aev-vae-indexing](../sections/dialog-db--notes-architecture-overview--eav-aev-vae-indexing.md) | datalog-query | current |
| [blob-store-and-mutable-pointers](../sections/dialog-db--notes-architecture-overview--blob-store-and-mutable-pointers.md) | content-addressed-storage, local-first-sync, ucan-authorization | current |
| [datalog-query-language](../sections/dialog-db--notes-architecture-overview--datalog-query-language.md) | datalog-query | current |

## Provenance

- Repository default branch `main`, file at HEAD `f777fe7c` (2026-07-05), authored by Irakli Gozalishvili.
- The flagship first-pass source. Larger docs referenced here for deferral: `notes/sync.md`, `notes/version-control.md`, `notes/query-engine-design.md`, `notes/rules.md`, `notes/dbsp.md`, `notes/divergence-clock.md`, and the rest of the `notes/` corpus — follow-on `scholar-ingest-dialog-db` job.
