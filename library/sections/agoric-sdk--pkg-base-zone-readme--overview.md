---
title: Base Zone Library (overview + pending-migration note)
source: packages/base-zone/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d4729735e3ce04b146f8982e6b537e86546bc8b
source_date: 2024-01-27
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security, persistence]
status: current
notes: The "use @agoric/zone instead unless you're writing a backing store" guidance is the practical takeaway. The migration-to-endo announcement (heap/virtual/durable zone abstraction moving to `@endo/zone`) signals that this package is a transient surface; agents working on persistence-discipline code should expect imports to migrate.
---

> Abstract: A Zone provides an API for allocating Exo objects and Stores under one of three persistence regimes — heap (ephemeral, lost on vat termination), virtual (pageable to disk, lost on termination), durable (pageable AND revivable after a vat upgrade). `@agoric/base-zone` is the internal substrate; library code should normally use `@agoric/zone` to stay agnostic about the backing-store choice. The package is **destined for migration** to `@endo/zone` (along with `@agoric/store` → `@endo/store`); the migration will land first as deprecation, then as reexport stubs, then eventual removal.

# Base Zone Library

Each Zone provides an API that allows the allocation of [Exo objects](https://github.com/endojs/endo/tree/master/packages/exo#readme) and [Stores (object collections)](../store/README.md) which use the same underlying persistence mechanism. This allows library code to be agnostic to whether its objects are backed purely by the JS heap (ephemeral), pageable out to disk (virtual) or can be revived after a vat upgrade (durable).

This library is used internally by [@agoric/zone](../zone/README.md); refer to it for more details. Unless you are an author of a new Zone backing store type, or want to use `makeHeapZone` without introducing build dependencies on [@agoric/vat-data](../vat-data/README.md), you should instead use [@agoric/zone](../zone/README.md).

---

Be aware that both this package `@agoric/base-zone` and `@agoric/store` will move from the agoric-sdk repository to the endo repository and likely renamed `@endo/zone` and `@endo/store`. At that time, we will first deprecate the versions here, then replace them with deprecated stubs that reexport from their new home. We hope to eventually remove even these stubs, depending on the compat cost at that time.

Source: [packages/base-zone/README.md](https://github.com/Agoric/agoric-sdk/blob/7d4729735e3ce04b146f8982e6b537e86546bc8b/packages/base-zone/README.md) at commit `7d472973`.
