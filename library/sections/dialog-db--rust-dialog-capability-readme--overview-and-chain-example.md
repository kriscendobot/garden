---
title: Overview and capability-chain example
source: rust/dialog-capability/README.md
source_repo: dialog-db/dialog-db
source_commit: b4fb5ea9e23bfc515967353f485c3f19d00643be
source_date: 2026-02-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: `dialog-capability` is dialog-db's Rust crate of capability-based authorization primitives — the implemented realization of the `subject × command × policy` sketch in `notes/capability-sysstem.md`. A capability is a **chain** built from a root `Subject` (a resource identified by a [did:key](https://w3c-ccg.github.io/did-method-key/), representing full authority) through any number of constraints down to an invocable `Effect`. The chain is assembled fluently: `Subject::from(did!(...)).attenuate(Storage).attenuate(Store { name }).invoke(Get { key })`. Each link narrows authority in one of two ways — an **attenuation** extends the ability *path* (`/` → `/storage`), while a **policy** constrains *parameters* without changing the path — and the terminal effect both extends the path (`/storage` → `/storage/get`) and is invocable. The chain then answers two questions structurally: `capability.ability()` returns the accreted path string (`"/storage/get"`), and each constraint type's `::of(&capability)` extracts its own values back out of the chain (`Store::of(&cap).name`, `Get::of(&cap).key`). This is the typed-Rust encoding of attenuated object-capability delegation.

## Overview

The crate provides a hierarchical capability system for authorization and access control. Capabilities form chains from a root `Subject` (represented by did:key) through any number of constraints down to `Effect`s that perform actual operations.

## Quick example

```rust
use dialog_capability::{Subject, Attenuation, Policy, Effect};
use serde::{Serialize, Deserialize};

// Attenuation: narrows ability (adds "/storage" to path)
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Storage;
impl Attenuation for Storage {
    type Of = Subject;
}

// Policy: constrains parameters only (no path change)
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Store { name: String }
impl Policy for Store {
    type Of = Storage;
}

// Effect: narrows ability (adds "/get"), and is invocable
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Get { key: Vec<u8> }
impl Effect for Get {
    type Of = Store;
    type Output = Result<Option<Vec<u8>>, std::io::Error>;
}

// Build a capability chain
let capability = Subject::from(did!("key:z6MkhaXgBZD..."))
    .attenuate(Storage)                        // ability: /storage
    .attenuate(Store { name: "index".into() }) // ability: /storage (unchanged)
    .invoke(Get { key: b"my-key".to_vec() });  // ability: /storage/get

// The ability is expressed as a path
assert_eq!(capability.ability(), "/storage/get");

// Extract constraint values from the chain
assert_eq!(Store::of(&capability).name, "index");
assert_eq!(Get::of(&capability).key, b"my-key");
```

Each constraint declares its parent via the `type Of` associated type (`Store`'s `Of = Storage`, `Get`'s `Of = Store`), so the chain is type-checked link by link, and an `Effect` additionally declares its `type Output`.

Source: [rust/dialog-capability/README.md](https://github.com/dialog-db/dialog-db/blob/b4fb5ea9e23bfc515967353f485c3f19d00643be/rust/dialog-capability/README.md) at commit `b4fb5ea9`.
