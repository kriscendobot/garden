---
title: Bidirectional mapping, assert/retract, and querying
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

> Abstract: A concept acts as a **bidirectional mapping** between the semantic and associative layers. Writing (semantic to associative) decomposes an asserted concept into individual `{the, of, is}` assertions, one per attribute; reading (associative to semantic) composes matching claims into **conclusions** — realized concept instances with typed fields. Transactions are edited then committed on a session (`session.edit()` / `session.commit(tx)`); `tx.assert`/`tx.retract` take a whole concept and expand it into per-attribute claims. Querying a concept is a **logical conjunction**: an entity matches only when all attributes are present (`Query::<T>` with `Term::var`/`Term::from` per field; `Default` fills every field with a named variable). Individual attributes can be queried without defining a concept.

A concept acts as a bidirectional mapping between the semantic and associative layers:

- **Writing** (semantic to associative): asserting a concept decomposes it into individual `{the, of, is}` assertions, one per attribute.
- **Reading** (associative to semantic): querying a concept composes matching claims into **conclusions**, which are realized concept instances with typed fields.

Asserting a concept decomposes it into individual attribute claims:

```rs
let mut tx = session.edit();
tx.assert(Employee {
    this: alice.clone(),
    name: employee::Name("Alice".into()),
    role: employee::Role("cryptographer".into()),
});
session.commit(tx).await?;

// Equivalent to:
// tx.assert(employee::Name::of(alice.clone()).is("Alice"));
// tx.assert(employee::Role::of(alice.clone()).is("cryptographer"));
```

Retraction has the same shape (`tx.retract(Employee { ... })`).

Querying a concept is a logical conjunction: an entity matches only when _all_ attributes are present. `Query::<T>` is an alias for the generated query struct; each field takes a `Term` (a bound `Term::from("Alice")` or an unbound `Term::var("role")`):

```rs
// Find all employees named Alice
let results = Query::<Employee> {
    this: Term::var("person"),
    name: Term::from("Alice"),
    role: Term::var("role"),
}.perform(&session).try_vec().await?;
```

`Default` fills every field with a named variable, useful when you want all matches (`Query::<Employee>::default()`). Individual attributes can be queried without defining a concept (`Query::<employee::Name> { of: Term::var("entity"), is: Term::var("name") }`).

Source: [notes/concept.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/concept.md) at commit `f777fe7c`.
