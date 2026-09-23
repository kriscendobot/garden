---
source: notes/dbsp.md
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: "DBSP Exploration" — Dialog's earliest note (2025-06) on adopting DBSP-style incremental view maintenance over its prolly-tree triple store. The framing that recurs throughout the incremental cluster starts here: a working top-down Datalog engine (planner + cycle analyzer + selective loading) over hash-addressed prolly-tree indexes (EAV/AEV/VAE) in commodity blob storage, whose content-defined structure means a root-pointer change lets the system replicate *only the changed subtrees relevant to a query* rather than streaming all fact changes. The note captures the store interface as a TypeScript contract (`Fact`, `Selector`, `Source.pull → Differential` as a z-set of signed fact weights) and the query model (`Term`/`Select`/`DeductiveRule`/`Formula`), then explores whether one selective-subtree-replication mechanism can serve both incremental maintenance and initial evaluation, unifying the two. Its companion `notes/incremental-subscriptions.md` later revises the *architecture* to demand-driven magic sets (pull) rather than DBSP (push) while keeping DBSP's algebra as the account of *what* each incremental operator computes; this note remains the IVM/selective-pull exploration and the DBSP formalism reference.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [context-and-storage-architecture](../sections/dialog-db--notes-dbsp--context-and-storage-architecture.md) | change-propagation, content-addressed-storage | current |
| [goal-hypothesis-selective-pull](../sections/dialog-db--notes-dbsp--goal-hypothesis-selective-pull.md) | change-propagation, datalog-query | current |
| [query-model-and-exploration](../sections/dialog-db--notes-dbsp--query-model-and-exploration.md) | change-propagation, datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `ff9f03bf` (2025-06-03), authored by Irakli Gozalishvili — the oldest note in the incremental/causal cluster. A `notes/dbsp/` subdirectory (`findings.mds`) accompanies it and is deferred to a follow-on.
- Companion to `notes/incremental-subscriptions.md` (the later demand-driven revision) and `notes/divergence-clock.md` (the causal-ordering half of reconciliation).
- Ingested in the `scholar-ingest-dialog-db-remainder-5` follow-on cycle (2026-07-06).
