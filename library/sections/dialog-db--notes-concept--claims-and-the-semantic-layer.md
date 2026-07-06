---
title: Claims and the semantic layer
source: notes/concept.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Dialog stores information as immutable **claims** of the form `{the, of, is, cause}` — `the` identifies the relation, `of` the entity, `is` the value, `cause` the provenance. At the **associative layer** there is no schema; claims are just associations. A **semantic layer** sits on top introducing **attributes** (a raw relation elevated with domain invariants: value type and cardinality) and **concepts** (a composition of attributes sharing an entity, describing the shape of a thing much like a class, but realized through schema-on-read rather than schema-on-write). One entity is not limited to a single concept: the same entity can simultaneously satisfy `Employee`, `Manager`, and `Person` if it carries the right claims.

Dialog stores information as immutable claims in the form `{the, of, is, cause}`:

- `the` identifies the **relation**.
- `of` identifies the **entity**.
- `is` is the **value**.
- `cause` is the **provenance** (the fact this claim succeeds).

At the associative layer there is **no schema**; claims are just associations.

The **semantic layer** introduces attributes and concepts on top of this:

- An **attribute** elevates a raw relation with domain-specific invariants (value type and cardinality).
- A **concept** composes multiple attributes sharing an entity, describing the shape of a thing much like a type or class in a programming language — but realized through **schema-on-read rather than schema-on-write**.

An entity is not limited to a single concept. The same entity can simultaneously satisfy `Employee`, `Manager`, and `Person` if it has the right claims. This is the defining move of the model: the shape a reader imposes is a lens over an unschematized association store, not a constraint enforced at write time.

Source: [notes/concept.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/concept.md) at commit `f777fe7c`.
