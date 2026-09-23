---
title: Opening a repository and building an operator
source: notes/repository.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: Opening a repository is a two-step `space::Load` / `space::Create` process. **Load** attempts to load an existing credential for the named space: a `Signer` grants owner access (can delegate), a `Verifier` grants delegate/read-only access, and `None` means the repository does not exist. On `None`, **Create** generates an ed25519 keypair, saves the credential via `space::Create`, delegates `subject → profile` with a powerline UCAN, and creates the repository with the new `did:key` as its subject. `Repository::open()` combines these, with `.open()` (load-or-create), `.load()` (fail if absent), and `.create()` (fail if exists) modes. An **operator** is built from a profile via a builder chain: `Profile::open(name)` opens/creates the profile keypair from storage, `.derive(context)` starts a deterministic-key operator, `.allow(capability)` scopes the UCAN delegation, `.network(...)` optionally adds remote capability, and `.build(storage)` takes ownership of storage and produces the `Operator`. Profile keys live at platform data dirs — native `~/Library/Application Support/dialog/profile/{name}/key` (32-byte seed), web IndexedDB database `dialog`, store `credentials`, key `profile/{name}` (CryptoKeyPair).

## Opening a Repository

Opening a repository is a two-step process using `space::Load` and `space::Create` capabilities:

1. **Load**: attempts to load an existing credential for the named space
   - If `Some(Credential::Signer(signer))` -- owner access, can delegate
   - If `Some(Credential::Verifier(verifier))` -- delegate access, read-only unless invited
   - If `None` -- repository doesn't exist

2. **Create** (if None):
   1. Generate an ed25519 keypair
   2. Save the credential via `space::Create`
   3. Delegate subject -> profile (powerline UCAN delegation)
   4. The repository is created with the new `did:key` as its subject

Higher-level `Repository::open()` combines these steps. Three modes:
- `.open()` -- loads existing or creates new
- `.load()` -- loads existing, fails if not found
- `.create()` -- creates new, fails if exists

## Environment Setup

The operator is built from a profile:

```rust
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

The builder chain:
1. `Profile::open(name)` opens or creates the profile keypair from storage
2. `.derive(context)` starts building an operator with a deterministic key
3. `.allow(capability)` configures the UCAN delegation scope
4. `.network(network)` optionally adds remote network capability
5. `.build(storage)` takes ownership of storage and produces the `Operator`

Profile keys are stored at the platform data directory:
- **Native**: `~/Library/Application Support/dialog/profile/{name}/key` (32-byte seed)
- **Web**: IndexedDB database `dialog`, store `credentials`, key `profile/{name}` (CryptoKeyPair)

Source: [notes/repository.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/repository.md) at commit `18c640a0`.
