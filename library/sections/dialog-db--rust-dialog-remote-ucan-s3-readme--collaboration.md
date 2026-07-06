---
title: Collaboration — sharing access through UCAN delegation chains
source: rust/dialog-remote-ucan-s3/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: How a UCAN remote enables multi-party collaboration. Alice grants Bob access by `alice_profile.access().claim(&repo).delegate(bob_profile.did()).perform(&alice_operator)` — claiming her access to the repository and delegating it to Bob's DID, producing a delegation `chain`. Bob retains the chain with `bob_profile.access().save(chain).perform(&bob_operator)`. Thereafter Bob can push and pull through the *same* UCAN remote by adding it with `.subject(alice_repo.did())` so the access service knows which repository the delegated capability targets: `bob_repo.remote("origin").create(UcanAddress::new(..)).subject(alice_repo.did()).perform(&bob_operator)`. No S3 credential is ever shared; the capability to read/write the repository travels as a UCAN delegation chain and the access service enforces it. This is the concrete replication-layer expression of Dialog's capability-security model.

## Collaboration

Access is shared through UCAN delegation chains:

```rust
// Alice delegates repo access to Bob
let chain = alice_profile.access()
    .claim(&repo)
    .delegate(bob_profile.did())
    .perform(&alice_operator)
    .await?;

// Bob retains the delegation
bob_profile.access()
    .save(chain)
    .perform(&bob_operator)
    .await?;

// Bob can now push/pull through the same UCAN remote
let origin = bob_repo.remote("origin")
    .create(UcanAddress::new("https://access.example.com"))
    .subject(alice_repo.did())
    .perform(&bob_operator)
    .await?;
```

- `alice.access().claim(&repo).delegate(bob.did())` mints a UCAN chain granting Bob a (possibly narrowed) capability over Alice's repository; `bob.access().save(chain)` stores it on Bob's side.
- `.subject(alice_repo.did())` tells the access service which repository Bob's delegated capability applies to — the same cross-repository targeting used elsewhere in [[repository-branch-remote]].
- No bucket secret is shared: the whole trust transfer is a [[ucan-delegation]] chain the access service verifies, which is why this remote fits the shared-repository / [[capability-chain]] use case.

Source: [rust/dialog-remote-ucan-s3/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-remote-ucan-s3/README.md) at commit `a898b5de`.
