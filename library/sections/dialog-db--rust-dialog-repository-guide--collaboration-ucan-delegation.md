---
title: Collaboration — sharing a repo through UCAN delegation
source: rust/dialog-repository/Guide.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: How two people collaborate on one repository without sharing keys. Access is shared through **UCAN delegation** — signed tokens forming a chain of trust — via a fluent `.access().claim(&capability).delegate(audience)` pattern: `repo.access()` / `profile.access()` return an `Access` handle, `.claim()` takes anything convertible to a `Capability` (`&repo`, `&profile`, or a capability chain), `.delegate(audience_did)` produces a delegation chain on `.perform()`, and `.save(chain)` stores a received delegation under the profile. The Guide walks the canonical three-act flow: **Alice sets up a shared repo** (repo delegates to Alice's profile, Alice saves it, creates the remote, pushes); **Alice invites Bob** (`alice_profile.access().claim(&repo).delegate(bob_profile.did())`, optionally bounded with `.not_before(start).expires(end)`, producing a chain that includes the full proof path repo → Alice → Bob); **Bob joins** (saves the delegation — the act that authorizes his operator — opens his own repo, creates an `origin` remote `.subject(alice_repo_did)` pointed at Alice's repo, pulls, edits, pushes). The delegation chain, not key sharing, is what carries authority across the boundary.

## Collaboration

Access is shared through UCAN delegation: signed tokens forming a chain of trust.

The access API follows a fluent pattern: `.access().claim(&capability).delegate(audience)`.

- `repo.access()` and `profile.access()` return an `Access` handle
- `.claim()` takes anything that converts into a `Capability` (a `&repo`, `&profile`, or capability chain)
- `.delegate(audience_did)` produces a delegation chain on `.perform()`
- `.save(chain)` stores a received delegation under the profile

### Alice sets up a shared repo

```rs
let repo = alice_profile.repository("shared")
    .create()
    .perform(&alice_operator).await?;

// Repo delegates to Alice's profile
let chain = repo.access()
    .claim(&repo)
    .delegate(alice_profile.did())
    .perform(&alice_operator)
    .await?;

// Alice saves the delegation under her profile
alice_profile
    .access()
    .save(chain)
    .perform(&alice_operator)
    .await?;

let origin = repo.remote("origin")
    .create(SiteAddress::Ucan(UcanAddress::new("https://access.example.com")))
    .perform(&alice_operator).await?;

let main = repo.branch("main").open().perform(&alice_operator).await?;
let remote_main = origin.branch("main").open().perform(&alice_operator).await?;
main.set_upstream(remote_main).perform(&alice_operator).await?;

main.transaction()
    .assert(Name::of(alice).is("Alice"))
    .commit()
    .perform(&alice_operator)
    .await?;

main.push().perform(&alice_operator).await?;
```

### Alice invites Bob

Alice claims her authority over the repo and re-delegates to Bob. The resulting chain includes the full proof path from the repo subject through Alice to Bob.

```rs
let chain = alice_profile.access()
    .claim(&repo)
    .delegate(bob_profile.did())
    .perform(&alice_operator).await?;
```

Optional time bounds can constrain the delegation:

```rs
let chain = alice_profile.access()
    .claim(&repo)
    .not_before(start)
    .expires(end)
    .delegate(bob_profile.did())
    .perform(&alice_operator).await?;
```

### Bob joins

Bob saves the delegation under his profile. This is what authorizes his operator to act on Alice's repo.

```rs
bob_profile.access().save(chain).perform(&bob_operator).await?;

let bob_repo = bob_profile.repository("bob-copy")
    .open()
    .perform(&bob_operator)
    .await?;

let origin = bob_repo.remote("origin")
    .create(SiteAddress::Ucan(UcanAddress::new("https://access.example.com")))
    .subject(alice_repo_did)  // point at Alice's repo
    .perform(&bob_operator).await?;

let main = bob_repo.branch("main").open().perform(&bob_operator).await?;
let remote_main = origin.branch("main").open().perform(&bob_operator).await?;
main.set_upstream(remote_main).perform(&bob_operator).await?;

// Pull, edit, push
main.pull().perform(&bob_operator).await?;

main.transaction()
    .assert(Name::of(bob).is("Bob"))
    .commit()
    .perform(&bob_operator)
    .await?;

main.push().perform(&bob_operator).await?;
```

Alice pulls to get Bob's changes:

```rs
main.pull().perform(&operator).await?;
```

The chain-of-trust discipline is the [[ucan-delegation]] model applied to repositories: the `claim(&capability).delegate(audience)` / `save(chain)` flow is the same delegate-then-retain pattern the `dialog-ucan` crate documents, and the produced chain carries the full proof path (repo → Alice → Bob) so Bob's authority is offline-verifiable back to the repo subject.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
