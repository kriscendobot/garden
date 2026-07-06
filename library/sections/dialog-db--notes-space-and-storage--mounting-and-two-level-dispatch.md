---
title: Mounting flow and the two levels of dispatch
source: notes/space-and-storage.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: When `storage::Load` or `storage::Create` is performed, the `Loader` resolves the `Location` to platform-specific addresses, creates provider instances for each capability domain, reads the credential directly from the credential provider (no DID needed yet), registers the space under its DID in the `Router`, and returns the `Credential` (signer or verifier) — no bootstrap-DID hack, because the credential is read from the provider before registering in the router. Every other effect then flows through two levels of dispatch: an effect arrives carrying a subject DID; the `Router` looks up the DID to find its `Space`; the `Space` routes by capability to the right `Provider`; the provider executes the effect.

## Mounting Flow

When `storage::Load` or `storage::Create` is performed:

1. The `Loader` resolves the `Location` to platform-specific addresses
2. Creates provider instances for each capability domain
3. Reads the credential directly from the credential provider (no DID needed yet)
4. Registers the space under its DID in the `Router`
5. Returns the `Credential` (signer or verifier)

No bootstrap DID hack. The credential is read directly from the provider before registering in the router.

## Two Levels of Dispatch

```
Effect arrives with Subject DID
  |
  v
Router looks up DID -> Space
  |
  v
Space routes by capability -> Provider
  |
  v
Provider executes the effect
```

Source: [notes/space-and-storage.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/space-and-storage.md) at commit `18c640a0`.
