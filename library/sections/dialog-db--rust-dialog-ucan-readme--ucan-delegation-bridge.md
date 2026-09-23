---
title: The UCAN delegation bridge
source: rust/dialog-ucan/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: `dialog-ucan` is the UCAN authorization protocol crate for Dialog-DB: it **bridges** `dialog-capability`'s generic access protocol with `dialog-ucan-core`'s UCAN-spec implementation, defining how UCAN delegation chains are used to prove and delegate access. It is the seam where dialog's typed capability chains become interoperable offline-verifiable UCAN tokens. The usage pattern is delegation-then-retention: Alice claims access to a repo and delegates it to Bob's DID (`alice_profile.access().claim(&repo).delegate(bob_profile.did()).perform(&alice_operator)`); Bob retains the received delegation (`bob_profile.access().save(delegation).perform(&bob_operator)`). Delegation can target a *narrowed* capability rather than the whole repo — for example a capability to the archive's `"index"` catalog is built by attenuating the repo subject (`repo.subject().archive().catalog("index")`) and only that capability is delegated. This is the transport realization of the `access` domain's `Prove`/`Retain` effects from `dialog-effects`.

## What it bridges

`dialog-ucan` provides the UCAN authorization protocol for Dialog-DB. It bridges `dialog-capability`'s generic access protocol with `dialog-ucan-core`'s UCAN spec implementation, and defines how UCAN delegation chains are used to prove and delegate access.

## Usage

```rust
// Delegate repo access from Alice to Bob
let delegation = alice_profile.access()
    .claim(&repo)
    .delegate(bob_profile.did())
    .perform(&alice_operator)
    .await?;

// Bob retains the delegation
bob_profile.access()
    .save(delegation)
    .perform(&bob_operator)
    .await?;

// Capability to access archive's "index" catalog
let capability = repo
    .subject()
    .archive()
    .catalog("index");

let chain = alice_profile.access()
    .claim(capability)
    .delegate(bob_profile.did())
    .perform(&alice_operator)
    .await?;
```

The first form delegates whole-repo access; the second narrows the delegated capability to a single archive catalog before delegating, so Bob receives only the attenuated authority.

Source: [rust/dialog-ucan/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-ucan/README.md) at commit `a898b5de`.
