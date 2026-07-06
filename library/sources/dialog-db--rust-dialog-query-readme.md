---
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 7
status: current
---

The `dialog-query` crate README — the Datalog-inspired query engine's public Rust API. It is the crate-doc face of the associative/semantic information model the `notes/concept.md` and `notes/architecture-overview.md` prose describe conceptually, and its distinctive value is the concrete Rust surface: the `{the, of, is, cause}` claim model, the `the!` compile-time relation macro, `Term` variables, the `#[derive(Attribute)]` newtype DSL (`#[domain(...)]`, `#[cardinality(many)]`), `#[derive(Concept)]` with its bidirectional assert/decompose and `Query<T>` conjunction, deductive rules as `fn(Query<T>) -> impl When` disjunctions installed with `Session::install`, and `#[derive(Formula)]` pure computations with the built-in formula catalog. Cross-references the `datalog-query` notes sections rather than restating their rationale.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-query-readme--overview.md) | datalog-query | current |
| [associative-claims](../sections/dialog-db--rust-dialog-query-readme--associative-claims.md) | datalog-query | current |
| [associative-relations](../sections/dialog-db--rust-dialog-query-readme--associative-relations.md) | datalog-query | current |
| [semantic-attributes](../sections/dialog-db--rust-dialog-query-readme--semantic-attributes.md) | datalog-query | current |
| [semantic-concepts](../sections/dialog-db--rust-dialog-query-readme--semantic-concepts.md) | datalog-query | current |
| [deductive-rules](../sections/dialog-db--rust-dialog-query-readme--deductive-rules.md) | datalog-query | current |
| [formulas](../sections/dialog-db--rust-dialog-query-readme--formulas.md) | datalog-query | current |
