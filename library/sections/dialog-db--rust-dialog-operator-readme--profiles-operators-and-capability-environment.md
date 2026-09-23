---
title: Profiles, operators, and the runtime capability environment
source: rust/dialog-operator/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: `dialog-operator` is the crate that assembles profiles, operators, and the runtime capability environment for Dialog — the executable form of the account/profile/operator identity model described in `notes/repository.md`. A **Profile** is a named identity on a device, backed by a signing credential; an **Operator** is a *session-scoped environment derived from a profile* that routes all capability effects (storage, archive, memory, access control) through DID-based dispatch with privilege narrowing. The usage flow is: create a platform-specific `Storage` environment; `Profile::open("alice").perform(&storage)` to open or create a profile; `profile.derive(b"my-app").allow(Subject::any()).build(storage)` to derive an operator that narrows access and is scoped to the profile; then `profile.repository("contacts").open().perform(&operator)` to open a repository *through* that operator. The operator is the DID-dispatching, privilege-narrowed runtime through which every effect is performed — the concrete counterpart to `dialog-effects`' structural effect types and `dialog-storage`'s `Provider<Fx>` implementations.

## Profiles and operators

A **Profile** is a named identity on a device, backed by a signing credential. An **Operator** is a session-scoped environment derived from a profile that routes all capability effects (storage, archive, memory, access control) through DID-based dispatch with privilege narrowing.

## Usage

```rust
use dialog_operator::profile::Profile;
use dialog_capability::Subject;
use dialog_storage::provider::environment::Storage;

// Create the environment (platform-specific storage)
let storage = Storage::default();

// Open or create a profile
let profile = Profile::open("alice")
    .perform(&storage)
    .await?;

// Derive an operator (narrows access, scoped to profile)
let operator = profile
    .derive(b"my-app")
    .allow(Subject::any())
    .build(storage)
    .await?;

// Open a repository through the profile
let contacts = profile.repository("contacts")
    .open()
    .perform(&operator)
    .await?;
```

`derive(context)` deterministically derives the operator key from the profile key using the context byte string; `allow(...)` narrows the capabilities the operator is permitted; `build(storage)` produces the routing environment through which effects are performed.

Source: [rust/dialog-operator/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-operator/README.md) at commit `a898b5de`.
