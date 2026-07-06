---
title: Writing — semantic triples via branch.transaction()
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

> Abstract: How data enters a branch. Data is stored as **semantic triples** — *the `attribute` of `entity` is `value`* — and typed writes go through `branch.transaction()`, which accumulates `.assert(..)` statements and terminates in `.commit().perform(&operator)`. The Guide's example uses the attribute-builder form `Name::of(alice).is("Alice")`, the same `of(entity).is(value)` shape the `dialog-query` associative surface exposes, batching several asserts into one committed transaction. Each committed transaction becomes a new revision on the branch, so the branch's history is the sequence of commits — the "version-control over structured data" property made concrete.

## Writing

Data is stored as semantic triples: *the `attribute` of `entity` is `value`*.

Typed writes use `branch.transaction()`:

```rs
main.transaction()
    .assert(Name::of(alice).is("Alice"))
    .assert(Age::of(alice).is(30u32))
    .commit()
    .perform(&operator)
    .await?;
```

Each `.assert(..)` contributes one semantic triple; the `.commit()` folds the batch into a single new branch revision. The triple builder (`Attribute::of(entity).is(value)`) is the same one the `dialog-query` crate documents at the associative layer — the repository crate simply routes the resulting claims into a branch transaction rather than a bare session edit.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
