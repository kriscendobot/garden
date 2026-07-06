---
title: Semantic — Concepts
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

Abstract: A **concept** is a composition of attributes sharing an entity, much like a type in a programming language — the primary unit of domain modeling, realized through **schema-on-read** rather than schema-on-write, so one entity can simultaneously satisfy `Employee`, `Manager`, and `Person` if it has the right claims. A concept is a *bidirectional* mapping into the associative model: asserting a concept (built with `#[derive(Concept)]` over a `this: Entity` plus attribute fields) decomposes it into individual attribute statements, while querying a concept (`Query::<Employee> { this, name, role }` with `Term::var`/`Term::from` fields) is a logical **conjunction** — an entity matches only when _all_ attributes are present — composing matching claims into a set of **conclusions** (realized concept instances). You can also query by a single attribute, and retracting works the same way as asserting. This is the crate-doc Rust surface for the schema-on-read concept model.

## Concepts

A concept is a composition of attributes sharing an entity, much like a type in a programming language. It is the primary unit of domain modeling, realized through schema-on-read rather than schema-on-write. An entity is not limited to a single concept: the same entity can simultaneously satisfy `Employee`, `Manager`, and `Person` if it has the right claims.

A concept acts as a bidirectional mapping into the associative model. In one direction, querying a concept composes matching claims into **conclusions** (realized concept instances, analogous to instances of a type). In the other direction, asserting a concept decomposes it into individual attribute statements.

```rs
#[derive(Concept, Debug, Clone, PartialEq)]
pub struct Employee {
    this: Entity,
    name: employee::Name,
    role: employee::Role,
}
```

Asserting a concept decomposes it into individual attribute statements:

```rs
let mut tx = session.edit();
tx.assert(Employee {
    this: alice.clone(),
    name: employee::Name("Alice".to_string()),
    role: employee::Role("cryptographer".to_string()),
});
session.commit(tx).await?;

// Equivalent to:
// tx.assert(the!("employee/name").of(alice.clone()).is("Alice"));
// tx.assert(the!("employee/role").of(alice.clone()).is("cryptographer"));
```

Querying a concept is a logical conjunction (AND). An entity matches only when _all_ of the concept's attributes are present. The result is a set of conclusions:

```rs
let pattern = Query::<Employee> {
    this: Term::var("person"),
    name: Term::from("Alice".to_string()),
    role: Term::var("role"),
};
let conclusions = pattern.perform(&session).try_vec().await?;
```

You can also query by a single attribute:

```rs
let query = Query::<employee::Name> {
    of: Term::var("entity"),
    is: Term::var("name"),
};
let results = query.perform(&session).try_vec().await?;
```

Retracting works the same way as asserting:

```rs
let mut tx = session.edit();
tx.retract(Employee {
    this: alice.clone(),
    name: employee::Name("Alice".to_string()),
    role: employee::Role("cryptographer".to_string()),
});
session.commit(tx).await?;

// Equivalent to:
// tx.retract(the!("employee/name").of(alice.clone()).is("Alice"));
// tx.retract(the!("employee/role").of(alice.clone()).is("cryptographer"));
```

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
