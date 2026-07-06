---
title: Identity — profile, operator, account
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

> Abstract: Dialog's three-keypair identity model as the Guide states it, each keypair an Ed25519 key identified by a `did:key`. A **Profile** is a named identity on a device, created on first use and persisting for the device lifetime. An **Operator** is a session key *derived* from the profile — the same profile plus the same context always yields the same key — and is ephemeral and revocable. An **Account** (optional) is a passkey or hardware key for cross-device recovery, and can be deferred. Every capability invocation carries the delegation chain `subject -> profile -> operator`. This is the crate-doc statement of the identity layers whose full local-vs-recovered chain analysis lives in `notes/repository.md`; see the [[profile-account-operator]] concept for the deterministic-derivation and recovery detail.

## Identity

Three Ed25519 keypairs, each identified by a `did:key`:

- **Profile**: a named identity on a device. Created on first use, persists for the device lifetime.
- **Operator**: a session key derived from the profile. Same profile + context always yields the same key. Ephemeral, revocable.
- **Account** *(optional)*: a passkey or hardware key for cross-device recovery. Can be deferred.

Every capability invocation carries a delegation chain: `subject -> profile -> operator`.

The determinism of operator derivation (same profile + context → same key) is what lets an application re-derive its operator on every launch without storing it, and the ephemerality is what makes it revocable independently of the long-lived profile. When an account exists, the chain lengthens to include the recovery identity (`subject -> account -> profile -> operator`), the mechanism analysed in the notes-level `dialog-db--notes-repository--authorization-chain-and-capability-domains` section.

Source: [rust/dialog-repository/Guide.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/rust/dialog-repository/Guide.md) at commit `18c640a0`.
