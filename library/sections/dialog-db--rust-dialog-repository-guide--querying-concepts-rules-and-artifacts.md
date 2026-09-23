---
title: Querying — typed concepts, deductive rules, raw artifacts
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The three query shapes a branch exposes. **Typed concept queries** use `#[derive(Concept)]` structs and `main.select(Query::<Employee> { this: Term::var("this"), .. })` terminated by `.perform(&operator).try_vec()`, returning `Vec<Employee>`. **Deductive-rule queries** interpose `.query().install(my_rule)?` before `.select(..)`, layering a rule over the same concept select. **Raw artifact selection** drops to the claim level with `main.claims().select(ArtifactSelector::new().the("user/name".parse()?))`, which crucially carries **automatic remote fallback** — an artifact not present locally is fetched from the branch's upstream on demand. These are the repository-branch bindings of the same `Query<T>` / `Session::install` / selector API the `dialog-query` crate documents; the [[dialog-query-rust-api]] concept holds the derive-macro detail.

## Querying

Typed queries use concepts defined with derive macros:

```rs
#[derive(Concept)]
struct Employee {
    this: Entity,
    name: employee::Name,
    role: employee::Role,
}

let results: Vec<Employee> = main
    .select(Query::<Employee> {
        this: Term::var("this"),
        name: Term::var("name"),
        role: Term::var("role"),
    })
    .perform(&operator)
    .try_vec()
    .await?;
```

For queries with deductive rules:

```rs
let results: Vec<Employee> = main
    .query()
    .install(my_rule)?
    .select(Query::<Employee> { ... })
    .perform(&operator)
    .try_vec()
    .await?;
```

Raw artifact selection (with automatic remote fallback):

```rs
let artifacts = main
    .claims()
    .select(ArtifactSelector::new().the("user/name".parse()?))
    .perform(&operator)
    .await?
    .collect::<Vec<_>>()
    .await;
```

The automatic remote fallback on `.claims().select(..)` is the read-side of the branch/upstream relationship: when a branch has a remote upstream, a select that misses locally replicates the missing blocks on demand rather than failing — the same on-demand replication the Syncing section notes for queries generally.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
