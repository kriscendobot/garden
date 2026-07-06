---
id: fact-triple
aliases: [fact triple, claim, the of is cause, semantic triple, fact quadruple, associative layer, retraction fact]
topics: [datalog-query]
---

# fact-triple

Dialog's atomic unit of knowledge: an immutable **claim** of the form `{the, of, is, cause}` — `the` the relation, `of` the entity, `is` the value, `cause` the provenance (the fact this one succeeds). At the associative layer there is no schema; claims are just associations. The store is append-only and never modifies a fact; "deleting" adds a **retraction** fact. The semantic layer (attributes, concepts) reads typed shapes back out of these raw claims (schema-on-read). (Note: the architecture-overview prose labels `the` "entity" and `of` "attribute" while `concept.md` binds `the` to the relation and `of` to the entity; both agree on the four members and that `cause` carries causality.)

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-concept--claims-and-the-semantic-layer](../sections/dialog-db--notes-concept--claims-and-the-semantic-layer.md) | The `{the, of, is, cause}` claim and the associative-vs-semantic layering. |
| [dialog-db--notes-architecture-overview--facts-as-atomic-units](../sections/dialog-db--notes-architecture-overview--facts-as-atomic-units.md) | Facts as atomic immutable append-only units; retraction facts; the cause edge. |
| [dialog-db--notes-notation--assertions-and-claims](../sections/dialog-db--notes-notation--assertions-and-claims.md) | The notation view: assert/retract become claims; the `{the, of, is}` assertion, optional `cause` succession, and the `{by, period, moment}` provenance. |
| [dialog-db--rust-dialog-query-readme--associative-claims](../sections/dialog-db--rust-dialog-query-readme--associative-claims.md) | Crate-doc: a statement is a set of {the, of, is} associations stored as immutable content-addressed claims {the, of, is, cause}; an entity's state is the set of all its claims. |
| [dialog-db--rust-dialog-repository-readme--overview](../sections/dialog-db--rust-dialog-repository-readme--overview.md) | Crate-doc: information stored as claims {the, of, is, cause} — the relation, entity, value, and provenance — queried with typed concepts or deductive rules. |
| [dialog-db--rust-dialog-repository-guide--writing-semantic-triples](../sections/dialog-db--rust-dialog-repository-guide--writing-semantic-triples.md) | Data stored as semantic triples the attribute of entity is value; asserted in a branch transaction and committed as a new revision. |
| [dialog-db--rust-dialog-csv-readme--overview](../sections/dialog-db--rust-dialog-csv-readme--overview.md) | The CSV interchange format serializing each fact as a five-column row (the/of/as/is/cause), with an explicit `as` value-type column. |
| [dialog-db--ts-dialog-experimental-session--changes-assert-retract](../sections/dialog-db--ts-dialog-experimental-session--changes-assert-retract.md) | JS change model: a Retraction is the set of {the,of,is} facts of one relation; transact commits Assert/Retract instructions atomically. |
| [dialog-db--ts-dialog-experimental-session--query-and-selection](../sections/dialog-db--ts-dialog-experimental-session--query-and-selection.md) | JS read path: select by a partial the/of/is FactsSelector; fromArtifact re-derives the cause as the content hash of the {the,of,is} triple. |

## See also

- [[schema-on-read]] — how typed concepts are read back out of raw claims.
- [[merkle-crdt]] — how the `cause` edges form the convergent causal DAG.
- [[dialog-db]] — the database built on these facts.
- [[dialog-notation]] — the notation whose assertions become these claims.
