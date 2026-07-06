---
id: dialog-query-rust-api
aliases: [the! macro, derive Attribute, derive Concept, derive Formula, cardinality many, domain attribute, Query<T>, Session install, Session open, edit assert retract commit, Term var, "Term::<The>", impl When, Input<Self> compute, output field, dialog-query crate]
topics: [datalog-query]
---

# dialog-query-rust-api

The concrete Rust surface of the `dialog-query` crate — how the associative/semantic model (fact-triples, attributes, concepts, deductive rules, formulas) is authored in Rust, as opposed to the JSON/YAML `dialog-notation` face or the conceptual `notes/` prose. The associative layer is reached with the `the!("domain/name")` macro (compile-time-validated) producing relations you `.of(entity).is(value)`, with `Term::var` / `Term::<The>::var` supplying query variables. The semantic layer is authored with derive macros: `#[derive(Attribute)]` on a value-wrapping newtype (domain from the module name, name from the struct name in kebab-case; `#[domain("...")]` and `#[cardinality(many)]` override the defaults), `#[derive(Concept)]` on a struct with a `this: Entity` plus attribute fields (a bidirectional map — `tx.assert(concept)` decomposes to claims, `Query::<Concept> { .. }.perform(&session)` composes claims into conclusions by conjunction), and `#[derive(Formula)]` with `#[output]`-marked fields and a `compute(input: Input<Self>) -> Vec<Self>` method. Deductive rules are plain functions `fn(Query<Concept>) -> impl When` returning a premise tuple, registered with `Session::open(store).install(rule)?` (chainable); multiple rules for one concept give disjunction. Mutations flow through `session.edit()` → `assert`/`retract` → `session.commit(edit).await?`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--rust-dialog-query-readme--associative-relations](../sections/dialog-db--rust-dialog-query-readme--associative-relations.md) | The `the!` compile-time relation macro and `Term`/`Term::<The>` query variables against the associative model. |
| [dialog-db--rust-dialog-query-readme--semantic-attributes](../sections/dialog-db--rust-dialog-query-readme--semantic-attributes.md) | `#[derive(Attribute)]` newtype DSL; module→domain, struct→name; `#[domain]`/`#[cardinality(many)]` overrides; `of(..).is(..)` assert/retract. |
| [dialog-db--rust-dialog-query-readme--semantic-concepts](../sections/dialog-db--rust-dialog-query-readme--semantic-concepts.md) | `#[derive(Concept)]` bidirectional map; `Query::<T> { .. }.perform(&session)` conjunction into conclusions; single-attribute queries. |
| [dialog-db--rust-dialog-query-readme--deductive-rules](../sections/dialog-db--rust-dialog-query-readme--deductive-rules.md) | Rules as `fn(Query<T>) -> impl When` premise tuples installed with `Session::install`; disjunction across rules. |
| [dialog-db--rust-dialog-query-readme--formulas](../sections/dialog-db--rust-dialog-query-readme--formulas.md) | `#[derive(Formula)]` with `#[output]` and `compute(Input<Self>) -> Vec<Self>`; the built-in formula catalog. |
| [dialog-db--rust-dialog-repository-readme--usage-walkthrough](../sections/dialog-db--rust-dialog-repository-readme--usage-walkthrough.md) | End-to-end example: a #[derive(Concept)] schema committed via transaction().assert().commit() and read back with query().select(Query::<T>). |
| [dialog-db--rust-dialog-repository-guide--writing-semantic-triples](../sections/dialog-db--rust-dialog-repository-guide--writing-semantic-triples.md) | Typed writes via branch.transaction().assert(Attribute::of(entity).is(value)).commit() — the associative of/is builder routed into a branch revision. |
| [dialog-db--rust-dialog-repository-guide--querying-concepts-rules-and-artifacts](../sections/dialog-db--rust-dialog-repository-guide--querying-concepts-rules-and-artifacts.md) | Typed concept queries, deductive-rule queries via .query().install(rule), and raw .claims().select(ArtifactSelector) with automatic remote fallback. |

## See also

- [[dialog-notation]] — the JSON/YAML formal and abbreviated notations, the other authoring surface for the same attribute/concept/rule model.
- [[fact-triple]] — the `{the, of, is, cause}` claim this API asserts and queries.
- [[schema-on-read]] — the read-time-structure discipline `#[derive(Concept)]` realizes.
- [[deductive-rule]] — the notation-level and query-planning view of the rules this API installs.
- [[formula-scheme]] — the polymorphic-typing rationale behind the built-in formulas.
