---
title: Identity layers — account, profile, operator
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

> Abstract: Authorizing operations on a dialog-db repository uses a three-layer identity model — **account**, **profile**, **operator** — that maps directly onto the UCAN delegation chain `Subject → Profile { profile, account } → Operator { operator }`. An **account** is an optional persistent recovery identity backed by a passkey/hardware/paper key, holding no storage of its own and represented only as an `Option<Did>` on the profile attenuation; you may hold several (work, personal) and its creation can be deferred until you need cross-device sync. A **profile** is a named per-device identity with its own ed25519 keypair generated on first use (a default profile is auto-created on first run) and persists for the device's lifetime. An **operator** is an ephemeral per-session/per-process key *derived deterministically* from the profile key using a context byte string, so the same profile plus the same context always yields the same operator — the immediate invoker of a capability.

## Identity Layers

Credentials enable authorization of operations on a repository through a three-layer identity model: **account**, **profile**, and **operator**.

### Account

An optional persistent identity backed by a passkey, hardware key, or paper key. It has no storage of its own; it exists purely as a recovery point and delegation target. You may have multiple accounts for different purposes (e.g. work, personal). When recovering access on a new device, you authenticate to the account and selectively delegate from it to that device's profile, choosing which capabilities to grant rather than delegating everything. Account creation can be deferred until you need to sync or share across devices.

In the type system, Account is represented as an `Option<Did>` field on the `Profile` attenuation, not as a standalone type.

### Profile

A named user identity on a specific device. A device may have multiple profiles (e.g. "work" and "personal"), each with its own ed25519 keypair generated on first use. Profiles persist for the lifetime of the device. On first run, a default profile is created automatically.

The profile is represented in the capability chain as:

```
Subject -> Profile { profile: Did, account: Option<Did> } -> Operator { operator: Did }
```

### Operator

An ephemeral key representing the immediate invoker of a capability in a specific session or process context. Derived from the profile key using a context byte string (same profile + context always yields the same operator key).

Source: [notes/repository.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/repository.md) at commit `18c640a0`.
