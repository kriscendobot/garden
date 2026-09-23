---
source: notes/concept.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The concept/attribute data model — how Dialog's semantic layer sits over the schema-less associative layer of `{the, of, is, cause}` claims. Four sections: claims and the semantic layer (attributes and concepts as elevations over raw associations); defining attributes and concepts (the `(the, type, cardinality)` attribute identity in `domain/name` form, the Rust derive macros, concept identity from the sorted attribute set); the bidirectional assert/retract/query mapping (concepts decompose to per-attribute claims on write, compose to typed conclusions on read, conjunction on query); and schema-on-read plus concepts as the conclusion type of deductive rules (disjunction across rules). The developer-facing Rust-API counterpart to the architecture overview's schema-on-query framing.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [claims-and-the-semantic-layer](../sections/dialog-db--notes-concept--claims-and-the-semantic-layer.md) | datalog-query | current |
| [attributes-and-concepts](../sections/dialog-db--notes-concept--attributes-and-concepts.md) | datalog-query | current |
| [bidirectional-mapping-assert-retract-query](../sections/dialog-db--notes-concept--bidirectional-mapping-assert-retract-query.md) | datalog-query | current |
| [schema-on-read-and-rules](../sections/dialog-db--notes-concept--schema-on-read-and-rules.md) | datalog-query | current |

## Provenance

- Repository default branch `main`, file at HEAD `f777fe7c` (2026-07-05), authored by Irakli Gozalishvili.
- The rule system this doc points at (`notes/rules.md`, `notes/rule-pipeline.md`, `notes/layered-rule-resolution.md`) is deferred to a follow-on `scholar-ingest-dialog-db` job.
