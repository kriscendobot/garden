---
title: Authorization chains (local vs recovered) and capability domains
source: notes/repository.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, local-first-sync]
status: current
---

> Abstract: Invoking a capability on a repository requires a delegation chain from the subject back to the operator, and the chain comes in two shapes. **Local** (no account configured) delegates `subject → profile → operator`; access is tied to this device and cannot be recovered if the device is lost. **Recovered** (an account is present) routes through the persistent identity that survives device loss, `subject → account → profile → operator`, or directly `subject → account → operator` when the repository was created after the account already existed on the device. The profile is the stable per-device identity; the account, when present, is the recovery and cross-device delegation anchor. The system's effects are organized into capability domains defined in `dialog-effects`: `authority::Identify` (return the current chain), `archive` (Get/Put content-addressed storage), `memory` (Resolve/Publish/Retract CAS cells), `credential` (Save/Load), `space` (named-space Load/Create), `storage` (location-based Load/Create bootstrap), and `access` (Prove/Retain/Authorize).

## Authorization Chain

Invoking a capability on a repository requires a delegation chain from the subject back to the operator. The chain always includes the profile layer; the account layer is optional:

### Local

No account is configured. The subject delegates directly to the profile:

```
subject -> profile -> operator
```

Access is tied to this device. If the device is lost, access cannot be recovered.

### Recovered

An account is present, meaning access has been delegated through a persistent identity that survives device loss:

```
subject -> account -> profile -> operator
```

Or directly, if the repository was created after the account already existed on the device:

```
subject -> account -> operator
```

The profile is the stable identity on each device. The account, when present, is the anchor for recovery and cross-device delegation.

## Capability Domains

The system is organized into these effect domains (defined in `dialog-effects`):

- **`authority::Identify`** -- returns the current delegation chain as `Capability<Operator>`
- **`archive`** -- content-addressed storage (`Get`, `Put`)
- **`memory`** -- CAS memory cells (`Resolve`, `Publish`, `Retract`)
- **`credential`** -- credential storage (`Save<T>`, `Load<T>`)
- **`space`** -- named space discovery (`Load`, `Create`)
- **`storage`** -- location-based bootstrap (`Load`, `Create`)
- **`access`** -- authorization via protocols (`Prove`, `Retain`, `Authorize`)

Source: [notes/repository.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/repository.md) at commit `18c640a0`.
