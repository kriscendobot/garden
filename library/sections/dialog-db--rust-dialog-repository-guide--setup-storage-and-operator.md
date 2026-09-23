---
title: Setup — storage, profile, operator base directory
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The bring-up sequence every dialog program starts with: obtain `Storage::default()`, open a `Profile` against it, then `.derive(b"my-app")` an application-scoped operator, `.allow(Subject::any())`, and `.build(storage)`. The operator's base directory defaults to `Directory::Current` and is overridden with `.base(Directory::Temp)`. Two mechanics worth pinning: `.build(storage)` **takes ownership** of the storage value (so it is threaded through the operator thereafter, not held separately), and the operator is the single argument every later builder's `.perform(&operator)` receives.

## Setup

```rs
let storage = Storage::default();

let profile = Profile::open("alice")
    .perform(&storage)
    .await?;

let operator = profile
    .derive(b"my-app")
    .allow(Subject::any())
    .build(storage)
    .await?;
```

The operator's base directory defaults to `Directory::Current`. Override it with `.base()`:

```rs
let operator = profile
    .derive(b"my-app")
    .base(Directory::Temp)
    .allow(Subject::any())
    .build(storage)
    .await?;
```

Note: `.build(storage)` takes ownership of the storage value.

Once built, the operator is the capability environment (the `dialog-operator` crate's central type) that every subsequent repository, branch, transaction, query, and sync builder terminates against via `.perform(&operator)`.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
