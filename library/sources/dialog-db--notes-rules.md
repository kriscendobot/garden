---
source: notes/rules.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The user-facing guide to Dialog's deductive rules — Datalog-style inference that derives new concepts from existing data. Covers defining attributes and concepts with derive macros; writing a rule as a function from a `Query<T>` conclusion pattern to an `impl When` tuple of premises; the grounding requirement and order-independence of premises; installing rules into a `Session` with `.install()`; and the four ways a rule body reaches past plain concept patterns — formulas as value-computing premises, attribute expressions (`the!(...).of(...).is(...)`) working directly with the associative model, `!`-prefixed negation, and asserting/retracting facts through transactions.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [defining-rules-and-grounding](../sections/dialog-db--notes-rules--defining-rules-and-grounding.md) | datalog-query | current |
| [formulas-negation-and-transactions](../sections/dialog-db--notes-rules--formulas-negation-and-transactions.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `f777fe7c` (2026-07-05, repo HEAD), authored by Irakli Gozalishvili. The user-facing companion to the design corpus (`notes/rule-pipeline.md`, `notes/query-engine-design.md`).
- Ingested in the `scholar-ingest-dialog-db-remainder-2` follow-on cycle (2026-07-06), part of the query-planner/rules cluster.
