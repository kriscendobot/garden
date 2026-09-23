---
title: The vestigial Serialize bound on capabilities
source: notes/claim-based-serialization.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: Every capability type (attenuations, policies, effects) must implement `Serialize + DeserializeOwned` because `Caveat` requires it — a requirement that was needed before the `Claim` system existed, when effects were serialized directly for UCAN authorization. Now that `Claim` generates separate serializable claim types, the requirement on the effects themselves is vestigial, and it prevents effects from carrying non-serializable runtime types like `Ed25519Signer` or `CryptoKeyPair`. Current state: `Effect: Sized + Caveat + Claim`, `Caveat: Serialize + DeserializeOwned` (this is what forces effects to be serializable), `Claim { type Claim: Serialize + DeserializeOwned }` (the *actual* serializable form), and `Attenuation`/`Policy: Sized + Caveat` (forcing them serializable too). The UCAN path is `parameters(capability)` → `capability.constrain(&mut builder)` walking the chain, where each node calls `builder.push(self)` doing `to_ipld(self)`, which requires `Serialize`. The `Claim` trait and `#[derive(Claim)]` macro are already implemented; what remains is removing the `Serialize + DeserializeOwned` requirement from `Caveat` and switching the UCAN parameter collection to use claim projections instead of direct serialization.

## Status

The `Claim` trait and `#[derive(Claim)]` macro are implemented. What remains is removing the `Serialize + DeserializeOwned` requirement from `Caveat` and switching the UCAN parameter collection to use claim projections instead of direct serialization.

## Problem

Every capability type (attenuations, policies, effects) must implement `Serialize + DeserializeOwned` because `Caveat` requires it. This was needed before the `Claim` system existed, as effects were serialized directly for UCAN authorization.

Now that `Claim` generates separate serializable claim types, the requirement on the effects themselves is vestigial. It prevents effects from carrying non-serializable runtime types like `Ed25519Signer` or `CryptoKeyPair`.

## Current state

```
Effect: Sized + Caveat + Claim
Caveat: Serialize + DeserializeOwned       <-- forces effects to be serializable
Claim { type Claim: Serialize + DeserializeOwned }  <-- the actual serializable form

Attenuation: Sized + Caveat                <-- forces attenuations to be serializable
Policy: Sized + Caveat                     <-- forces policies to be serializable
Ability: Sized + Serialize + DeserializeOwned
```

The UCAN path: `parameters(capability)` calls `capability.constrain(&mut builder)` which walks the chain. Each node calls `builder.push(self)` which does `to_ipld(self)`, requiring `Serialize`.

Source: [notes/claim-based-serialization.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/claim-based-serialization.md) at commit `18c640a0`.
