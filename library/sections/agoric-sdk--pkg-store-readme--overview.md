---
title: "@agoric/store (overview + pending-migration note)"
source: packages/store/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d4729735e3ce04b146f8982e6b537e86546bc8b
source_date: 2024-01-27
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security, persistence]
status: current
notes: The `init` vs `set` distinction is the API-level expression of the "make intent visible to the type system" principle. The functional-API claim (`Store.get` can be passed standalone) only applies to the Store methods, not JavaScript Map. `makeScalarWeakMapStore` is the WeakMap-shaped variant. Header carries `# TODO REWRITE` — incomplete documentation.
kind: index
section_count: 1
---

> Abstract: A wrapper around JavaScript Map with two specific improvements: (1) explicit `init` (set-new-key) vs `set` (update-existing-key) distinction — the caller marks the intent and the Store enforces correct usage, removing the need for "check if key exists first" patterns; (2) functional API — `Store.get` can be passed to `myArray.map(Store.get)` etc., because Store methods are tied to instances via closure, unlike Map's methods which are tied to instances via `this`. `makeScalarWeakMapStore` is the WeakMap-shaped variant. Pending migration to `@endo/store`.

Sections:

- [Store](agoric-sdk--pkg-store-readme--overview--store.md)

Source: [packages/store/README.md](https://github.com/Agoric/agoric-sdk/blob/7d4729735e3ce04b146f8982e6b537e86546bc8b/packages/store/README.md) at commit `7d472973`.
