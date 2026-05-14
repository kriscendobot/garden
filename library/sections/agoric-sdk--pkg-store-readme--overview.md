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
---

> Abstract: A wrapper around JavaScript Map with two specific improvements: (1) explicit `init` (set-new-key) vs `set` (update-existing-key) distinction — the caller marks the intent and the Store enforces correct usage, removing the need for "check if key exists first" patterns; (2) functional API — `Store.get` can be passed to `myArray.map(Store.get)` etc., because Store methods are tied to instances via closure, unlike Map's methods which are tied to instances via `this`. `makeScalarWeakMapStore` is the WeakMap-shaped variant. Pending migration to `@endo/store`.

# TODO REWRITE

# Store

A wrapper around JavaScript Map.

Store adds some additional functionality on top of Map.

1. Store distinguishes between initializing (`init`) a (key, value) pair and resetting the key to a different value (`set`), whereas Map doesn't. This means you can use the Store abstraction without having to check whether the key already exists. This is because the method that you call (`init` or `set`) marks your intention and does it for you.

2. You can use the Store methods in a functional programming pattern, which you can't with Map. For instance, you can create a new function `const getPurse = Store.get` and you can do `myArray.map(Store.get)`. You can't do either of these with Map, because the Map methods are not tied to a particular Map instance.

See `makeScalarWeakMapStore` for the wrapper around JavaScript's WeakMap abstraction.

---

Be aware that both `@agoric/base-zone` and this package `@agoric/store` will move from the agoric-sdk repository to the endo repository and likely renamed `@endo/zone` and `@endo/store`. At that time, we will first deprecate the versions here, then replace them with deprecated stubs that reexport from their new home. We hope to eventually remove even these stubs, depending on the compat cost at that time.

Source: [packages/store/README.md](https://github.com/Agoric/agoric-sdk/blob/7d4729735e3ce04b146f8982e6b537e86546bc8b/packages/store/README.md) at commit `7d472973`.
