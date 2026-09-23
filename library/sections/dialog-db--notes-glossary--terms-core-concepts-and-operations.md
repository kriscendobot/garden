---
title: Glossary — core concepts and database operations
source: notes/glossary.md
source_repo: dialog-db/dialog-db
source_commit: 054a7982ae47c06693c5ce6372a0844d1549a8d1
source_date: 2025-07-08
source_authors: [Argonaut Nautilus, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

> Abstract: The glossary's Core-Concepts and Database-Operations terms, consolidated for grep. **Core concepts:** Fact (atomic immutable `{the, of, is, cause}` triple, like an RDF triple / Datomic datom — "the color of sky is blue"), its parts Entity (`of`, a URI), Attribute (`the`, a `/`-delimited name whose first component is a Namespace giving data locality), Value (`is`, an unchanging scalar), Causal Reference (`cause`, a hash grounding facts in partial order); Relation (query-time composable attribute group, DialogDB's "table"/schema), Evidence (a fact-set proving a relation, the "row"/document), Rule (derived relation via predicates, the "view", recursive, query-time-evaluated), Fact Store. **Operations:** Assertion (adds a fact), Retraction (adds a fact marking one no-longer-true, never deletes), Transaction (atomic set of instructions → a Revision), Commit, Instruction, Session, Revision (immutable content-hash snapshot enabling time-travel).

Consolidated glossary entries (Core Concepts and Database Operations), anchors preserved inline for lookup.

## Core Concepts

### Fact
Atomic, immutable unit of knowledge — equivalent to semantic triples in RDF and datoms in Datomic. In dialog, facts are in `{the, of, is, cause}` form corresponding to natural language: *the* **color** *of* **sky** *is* **blue**. The `cause` field establishes a causal relationship.

- **Entity (of):** the subject denoted via `of`; an arbitrary URI (`uuid:...`, `did:...`).
- **Attribute (the):** something asserted about an entity, named via `the`; `/`-delimited UTF-8 (`person/name`, `db.type/uint32`). First component is a **namespace**.
  - **Namespace:** first component of the attribute; like a relational table name but without obligations (an entity can hold attributes from multiple namespaces). Namespaces provide **data locality** — attributes sharing a namespace collocate for efficient querying — and global uniqueness (reverse-domain notation recommended, e.g. `io.gozala.note`).
- **Value (is):** something that does not change (`42`, `"John"`, `true`), denoted via `is`; data types are bytes, entity, boolean, string, integers, floats, records, symbols.
- **Causal Reference (cause):** grounds facts in time and establishes partial order between them; currently a hash reference to the preceding fact (alternatives being explored).

### Relation
DialogDB's equivalent of a relational table or document schema — a set of attributes entities can have. Any entity can have any attribute; relations define semantically-meaningful groups. Unlike rigid schemas, relations are **composable and applied at query time**, so multiple relations can describe the same entity (different views, no migration).

### Evidence
DialogDB's equivalent of a table row or document — a set of facts about an entity that prove a particular relation. Querying searches for evidence supporting claimed relations; asserting a relation derives and stores the corresponding facts.

### Rule
DialogDB's equivalent of a view — a derived relation defined by predicates that must hold. Rules enable logical inference (new relations from existing facts/relations), can be recursive (transitive relationships), and are evaluated at query time (future versions may support incremental view maintenance).

### Fact Store
Storage system for facts (semantic triples with causal references), indexing facts multiple ways to support diverse query patterns.

## Database Operations

- **Assertion:** an atomic fact associating an entity, attribute, value, and cause; the primary way data enters, creating facts without modifying existing ones (immutable, append-only). Opposite of a retraction.
- **Retraction:** an atomic fact dissociating an entity from a particular value of an attribute; rather than removing information, it adds a fact indicating something is no longer true. Opposite of an assertion.
- **Transaction:** an atomic set of assertions and retractions, applied all-or-none; each results in a new revision.
- **Commit:** the act of applying a transaction, resulting in a new revision.
- **Instruction:** a component of a transaction without specifying assertion vs. retraction.
- **Session:** a database connection providing query and transaction capabilities; manages caching and transaction boundaries.
- **Revision:** an immutable snapshot of database state at a point in time, a content hash; each commit creates one, enabling time-travel queries and audit trails.

Source: [notes/glossary.md](https://github.com/dialog-db/dialog-db/blob/054a7982ae47c06693c5ce6372a0844d1549a8d1/notes/glossary.md) at commit `054a7982`.
