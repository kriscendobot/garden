---
title: Usage walkthrough — open, commit, query, sync
source: rust/dialog-repository/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, datalog-query]
status: current
---

> Abstract: The `dialog-repository` README's end-to-end fluent walkthrough, showing the full lifecycle in one program: pick target-appropriate default storage (`Storage::default()` — filesystem on native, IndexedDB on web), open (load-or-create) a `Profile`, `.derive(b"my-app")` an application-scoped operator, open a named repository and its `main` branch, define a typed `#[derive(Concept)]` struct, commit data with `branch.transaction().assert(..).commit()`, query it back with `branch.query().select(Query::<T> { .. })`, then add a `remote("origin")` addressed by a concrete `impl Into<SiteAddress>` (here a `UcanAddress` fronting an S3 bucket), `set_upstream(..)`, and `push()`/`pull()`. Every operation terminates in `.perform(&operator)` — the operator is the capability environment that authorizes and routes each effect. This is the reference example for how the crate's builder chains compose.

## Usage

The whole lifecycle — storage, identity, repository, branch, typed schema, commit, query, remote, sync — in one fluent program:

```rust
use dialog_capability::Subject;
use dialog_operator::Profile;
use dialog_repository::RepositoryExt;
use dialog_storage::Storage;

// Target-appropriate default storage: filesystem on native, IndexedDB on web.
let storage = Storage::default();

// Open (load-or-create) the profile.
let profile = Profile::open("alice").perform(&storage).await?;

// Derive an operator scoped to this application.
let operator = profile
    .derive(b"my-app")
    .allow(Subject::any())
    .build(storage)
    .await?;

// Open or create a repository.
let contacts = profile
    .repository("contacts")
    .open()
    .perform(&operator)
    .await?;

// Work with branches.
let main = contacts
    .branch("main")
    .open()
    .perform(&operator)
    .await?;

// Define a concept with typed attributes.
#[derive(Concept)]
struct Employee {
    this: Entity,
    name: employee::Name,
    role: employee::Role,
}

// Commit data.
main.transaction()
    .assert(Employee {
        this: Entity::new()?,
        name: employee::Name("Alice".into()),
        role: employee::Role("Engineer".into()),
    })
    .commit()
    .perform(&operator)
    .await?;

// Query.
let results: Vec<Employee> = main
    .query()
    .select(Query::<Employee> {
        this: Term::var("this"),
        name: Term::var("name"),
        role: Term::var("role"),
    })
    .perform(&operator)
    .try_vec()
    .await?;
```

Adding a remote and syncing. `.create(...)` takes `impl Into<SiteAddress>`, so concrete variants like `UcanAddress` or an S3 `Address` can be passed directly — here pointing at a UCAN-gated access service in front of an S3 bucket:

```rust
use dialog_remote_ucan_s3::UcanAddress;

let origin = contacts
    .remote("origin")
    .create(UcanAddress::new("https://access.example.com"))
    .perform(&operator)
    .await?;

let upstream = origin
    .branch("main")
    .open()
    .perform(&operator)
    .await?;

main
    .set_upstream(upstream)
    .perform(&operator)
    .await?;

main.push().perform(&operator).await?;
main.pull().perform(&operator).await?;
```

Every builder terminates in `.perform(&operator)`: the operator (§ the `dialog-operator` crate) is the capability environment that both authorizes the effect and routes it to the storage or remote that backs the subject.

Source: [rust/dialog-repository/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-repository/README.md) at commit `a898b5de`.
