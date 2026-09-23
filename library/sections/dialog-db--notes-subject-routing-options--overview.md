---
title: Subject routing — how effects find their storage
source: notes/subject-routing-options.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage]
status: current
---

> Abstract: A design decision record for the problem that when a capability effect arrives (e.g. `archive::Get` with subject `did:key:zRepo`), the subject DID says *who* but not *where* — the system must both resolve a human name to a subject DID (name→DID, by loading a keypair) and route effects on that DID to a storage location (DID→storage). Three options were weighed: **A. location in Subject** (extend `Subject` to carry an optional storage location — self-contained but fails when a Subject is reconstructed from a bare DID, since the location is runtime-only metadata that does not serialize); **B. a routing table in the environment** (a `Did → Provider` map registered when a profile/repository opens — robust to how the Subject was built and supports mixed providers, at the cost of shared mutable state, and effects on unregistered DIDs fail); **C. routing by layout convention** (all subjects under a shared root organized by DID — simplest, one provider, no dispatch logic, but forces every subject onto the same provider type). The implementation adopts a **hybrid of B and C**: Option B (`Router` in `Storage<S>`) for DID-based dispatch combined with Option C's convention for layout within each space, where the `Loader` creates providers from platform-specific `Location` address resolution and registers them in the `Router` under the space's DID.

## Problem

When a capability effect arrives (e.g. `archive::Get` with subject `did:key:zRepo`), the system needs to know *where* to read/write data for that subject. The subject DID identifies *who*, but not *where*.

Two things must happen:
1. **Name to DID**: Resolve a human name ("home", "personal") to a subject DID by loading a keypair.
2. **DID to Storage**: Route effects on that DID to the right storage location.

## Option A: Location in Subject

Extend `Subject` to carry an optional storage location alongside the DID.

**Pros:** No secondary lookups; each Subject is self-contained.
**Cons:** If someone constructs a Subject from just a DID, the location is missing and effects fail. The location is runtime-only metadata that doesn't serialize.

## Option B: Routing Table in the Environment

The environment maintains a `Did -> Provider` mapping. When a profile or repository is opened, the DID gets registered with its storage provider.

**Pros:** Doesn't matter how the Subject was constructed. Supports mixed providers.
**Cons:** Shared mutable state (interior mutability). Effects on unregistered DIDs fail.

## Option C: Routing by Layout Convention

Use filesystem layout conventions. All subjects live under a shared root, organized by DID.

**Pros:** Simplest; one provider, no dispatch logic.
**Cons:** All subjects must use the same provider type. Can't spread repos across different directories.

## Decision

The current implementation uses Option B (`Router` in `Storage<S>`) for DID-based dispatch, combined with Option C's convention for layout within each space. The `Loader` creates providers using platform-specific address resolution from a `Location`, then registers them in the `Router` under the space's DID.

Source: [notes/subject-routing-options.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/subject-routing-options.md) at commit `18c640a0`.
