---
id: schema-on-read
aliases: [schema-on-read, schema on read, schema-on-query, schema on query, concept as lens, structural concept equivalence]
topics: [datalog-query]
---

# schema-on-read

The discipline of imposing structure at read time, not write time: facts are stored as unschematized `{the, of, is}` associations, and a **concept** (a set of attributes over a shared entity) is a *lens* that reads a typed shape back out — an entity satisfies a concept exactly when it has claims for every attribute in it, so one entity can satisfy many concepts simultaneously. Two concepts with the same attribute set are structurally equivalent regardless of name. Dialog calls this schema-on-read (concept model) or schema-on-query (architecture), and it is what lets schema evolve organically without migrations.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-concept--schema-on-read-and-rules](../sections/dialog-db--notes-concept--schema-on-read-and-rules.md) | A concept is a lens over the claim store; concepts as rule conclusions with disjunction across rules. |
| [dialog-db--notes-architecture-overview--schema-on-query](../sections/dialog-db--notes-architecture-overview--schema-on-query.md) | Schema-on-query vs schema-on-write; evolution without migration; per-application interpretation. |
| [dialog-db--notes-concept--attributes-and-concepts](../sections/dialog-db--notes-concept--attributes-and-concepts.md) | Concept identity from the sorted attribute set; structural equivalence regardless of struct name. |

## See also

- [[fact-triple]] — the raw associations the concept lens reads.
- [[dialog-db]] — the database realizing schema-on-read.
