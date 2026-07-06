---
title: Associative — Relations
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

Abstract: A **relation** categorizes claims by the kind of association being established, comprised of a **domain** (scoping it to a problem area) and a **name** (the specific association within it), denoted `domain/name`. The `the!` macro produces a relation from a `"domain/name"` string literal, validated at compile time, letting you construct statements directly against the associative model without the semantic layer. Dynamic relation expressions support both concrete values and `Term` variables for querying: a variable value (`Term::<String>::var("name")`), a variable entity (`Term::var("entity")`), or a variable relation (`Term::<The>::var("relation")` — used to discover all relations between two entities). This is the crate-doc Rust surface for working directly with relations.

## Relations

Relations categorize claims by the kind of association being established. A relation is comprised of a **domain** (scoping it to a specific problem area) and a **name** (identifying the specific association within that domain), denoted as `domain/name`.

The `the!` macro produces a relation from a `"domain/name"` string literal, validated at compile time. You can construct statements from relations directly, skipping the semantic model:

```rs
use dialog_query::the;

let alice = Entity::new()?;

// Assert statements using relations directly
let mut edit = session.edit();
edit.assert(
    the!("employee/name")
        .of(alice.clone())
        .is("Alice")
);
edit.assert(
    the!("employee/role")
        .of(alice.clone())
        .is("cryptographer")
);
session.commit(edit).await?;
```

Dynamic expressions support both concrete values and `Term` variables for querying:

```rs
// Query with a variable value
let premise: Premise = the!("employee/name")
    .of(alice.clone())
    .is(Term::<String>::var("name"))
    .into();

// Query with a variable entity
let premise: Premise = the!("employee/name")
    .of(Term::var("entity"))
    .is("Alice".to_string())
    .into();
```

It is possible to use `Term::<The>` to discover all relations for an entity:

```rs
// Find all relations between alice and bob
let premise: Premise = Term::<The>::var("relation")
    .of(alice.clone())
    .is(bob.clone())
    .into();
```

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
