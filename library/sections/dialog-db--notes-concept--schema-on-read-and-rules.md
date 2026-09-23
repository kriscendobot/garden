---
title: Schema-on-read and concepts in rules
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

> Abstract: A concept does not define storage layout; it is a **lens over the claim store**. The same underlying claims can satisfy multiple concepts simultaneously — an entity matches a concept only when it has claims for every attribute in the concept, so `Alice` with `employee/name` + `employee/role` claims satisfies both `Employee` and a narrower `Named { this, name }`. Concepts are also the **conclusion type for deductive rules**: a rule derives a concept from premises, installed on a session (`Session::open(artifacts).install(rule)`), and multiple rules for the same concept provide logical **disjunction** (any rule can produce the conclusion). This is the semantic-layer face of Dialog's schema-on-query design.

A concept doesn't define storage layout. It's a lens over the claim store. The same underlying claims can satisfy multiple concepts simultaneously:

```rs
#[derive(Concept, Debug, Clone)]
pub struct Named {
    pub this: Entity,
    pub name: employee::Name,
}

// Alice satisfies both Employee and Named, because she has
// both employee/name and employee/role claims.
```

An entity only matches a concept when it has claims for _every_ attribute in the concept.

Concepts are the conclusion type for deductive **rules**. A rule derives a concept from premises:

```rs
fn employee_from_contractor(employee: Query<Employee>) -> impl When {
    (
        Query::<Contractor> {
            this: employee.this.clone(),
            name: employee.name.clone(),
            position: employee.role.clone(),
        },
    )
}

let session = Session::open(artifacts)
    .install(employee_from_contractor)?;
```

Multiple rules for the same concept provide logical **disjunction** (OR): any rule can produce a conclusion. (The rule system itself — its pipeline, planning, and cost model — lives in the `notes/rules.md`, `notes/rule-pipeline.md`, and `notes/query-engine-design.md` documents, deferred to a follow-on ingest.)

Source: [notes/concept.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/concept.md) at commit `f777fe7c`.
