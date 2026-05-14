---
title: Cache coordinator (Coordinator interface for eventual consistency + optimistic updates)
source: packages/cache/README.md
source_repo: agoric/agoric-sdk
source_commit: 1fa31b00d031479481c30158286404ffd8a4ebed
source_date: 2022-08-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, pass-style]
status: current
notes: The Coordinator + Updater interface pair is the API for plugging different backends (in-memory map, durable store, remote backend) into the same client surface. The signatures are TS-style — Passable is the same type from @endo/pass-style. The `assertedMatch: Matcher` argument on updateCacheValue is the runtime check that guard matched before the actual update.
---

> Abstract: The backend interface. `Coordinator` implements eventual consistency with optimistic updates. Three methods: `getRecentValue(key)` returns the eventually-consistent value; `setCacheValue(key, newValue, guardPattern)` updates to `newValue` only if the current value matches `guardPattern`; `updateCacheValue(key, updater, assertedMatch)` is the higher-level form that runs an Updater (which computes `newValue` from `oldValue`) and asserts the match. All values must be Passable.

## Cache coordinator

The cache coordinator must implement the `Coordinator` interface, which supports eventual consistency with optimistic updates:

```ts
interface Updater {
  /**
   * Calculate the newValue for a given oldValue
   */
  update: (oldValue: Passable) => unknown
}

interface Coordinator {
  /**
   * Read an eventually-consistent value for the specified key.
   */
  getRecentValue: (key: Passable) => Promise<Passable>,
  /**
   * Update a cache value to newValue, but only if guardPattern matches the current value.
   */
  setCacheValue: (key: Passable, newValue: Passable, guardPattern: Pattern) => Promise<Passable>,
  /**
   * Update a cache value via an updater calculation of newValue, but only if guardPattern
   * matches the current value.
   */
  updateCacheValue: (key: Passable, updater: ERef<Updater>, assertedMatch: Matcher) => Promise<Passable>,
}
```

Source: [packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.
