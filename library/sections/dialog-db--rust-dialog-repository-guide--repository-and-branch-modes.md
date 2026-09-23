---
title: Repository and branch — open, load, create modes
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

> Abstract: How a repository and its branches are opened, and the mode vocabulary that decides existence semantics *and the returned credential type*. A repository has its own keypair, branches, and remotes; **the same name under the same profile always yields the same identity**. Repositories are opened through the profile (which supplies the correct subject DID); the operator resolves the name against its base directory and verifies access. Repository modes: `.open()` loads-or-creates and returns `Repository<Credential>`; `.load()` loads-or-fails and returns `Repository<Credential>`; `.create()` creates-or-fails and returns `Repository<SignerCredential>`. The type distinction is load-bearing — `.create()` guarantees you hold the full signer (owner authority), while `.open()`/`.load()` return the weaker `Credential` that may be only a verifier. Branch modes are the same idea without the credential twist: `.open()` loads-or-creates, `.load()` loads-or-fails.

## Repository

A repository has its own keypair, branches, and remotes. Same name under the same profile always yields the same identity.

Repositories are opened through the profile, which provides the correct subject DID. The operator resolves the name against its base directory and verifies access.

```rs
let repo = profile.repository("contacts")
    .open()
    .perform(&operator)
    .await?;

let main = repo
    .branch("main")
    .open()
    .perform(&operator)
    .await?;
```

Repository modes:

- `.open()` loads existing or creates new. Returns `Repository<Credential>`.
- `.load()` loads existing, fails if not found. Returns `Repository<Credential>`.
- `.create()` creates new, fails if exists. Returns `Repository<SignerCredential>`.

Branch modes:

- `.open()` loads existing or creates new.
- `.load()` loads existing, fails if not found.

The `Repository<Credential>` vs `Repository<SignerCredential>` return-type split is the type-level encoding of the [[signer-verifier-credential]] distinction: only the create path proves ownership of the full signing keypair, so operations that require owner authority are reachable only from a `SignerCredential`-typed repository.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
