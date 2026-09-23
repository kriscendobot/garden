---
title: Semantic — Deductive Rules
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

Abstract: **Rules** provide logical **disjunction** (OR): they derive a concept from alternative sets of premises. Where a concept query requires _all_ attributes to match (conjunction), installing multiple rules for the same concept means _any_ rule can produce a conclusion. A rule is a Rust function from a `Query<Concept>` conclusion pattern to an `impl When` tuple of premises, with `Term` variables acting as join points across them; rules are registered on a session with `Session::open(store).install(rule)?` (chainable). Premises may be other concept queries (deriving `Employee` from a `Person` or a `Contractor`) or relation expressions against the raw associative model (`the!("person/name").of(...).is(...)`, using `Term::<The>::var` for arbitrary relations). This is the crate-doc Rust surface for deductive rules.

## Deductive Rules

Rules provide logical disjunction (OR). They derive a concept from alternative sets of premises. Where a concept query requires all attributes to match, installing multiple rules for the same concept means _any_ rule can produce a conclusion.

A rule's body is a set of premises with `Term` variables acting as join points across them.

```rs
// An Employee can be derived from a Person
fn employee_from_person(employee: Query<Employee>) -> impl When {
    (
        Query::<Person> {
            this: employee.this.clone(),
            name: employee.name.clone(),
            title: employee.role.clone(),
        },
    )
}

// ...or from a Contractor
fn employee_from_contractor(employee: Query<Employee>) -> impl When {
    (
        Query::<Contractor> {
            this: employee.this.clone(),
            name: employee.name.clone(),
            position: employee.role.clone(),
        },
    )
}

// Installing both rules means querying Employee finds conclusions from either source
let session = Session::open(store)
    .install(employee_from_person)?
    .install(employee_from_contractor)?;
```

Relation expressions can also be used as premises, allowing rules to work directly with the associative model. Use `Term::<The>::var` to query arbitrary relations:

```rs
// Derive Employee from ad-hoc relations
fn employee_from_relations(employee: Query<Employee>) -> impl When {
    (
        the!("person/name")
            .of(employee.this.clone())
            .is(employee.name.clone()),
        the!("person/role")
            .of(employee.this.clone())
            .is(employee.role.clone()),
    )
}
```

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
