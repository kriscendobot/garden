---
title: Cache client (transactional update + retry semantics)
source: packages/cache/README.md
source_repo: agoric/agoric-sdk
source_commit: 1fa31b00d031479481c30158286404ffd8a4ebed
source_date: 2022-08-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, patterns]
status: current
notes: The cache-client API is CAS-style: three steps (read, check guard pattern, call updater + sanitize); retries the whole sequence if the stored value moved while we were thinking. The default `guardPattern` of "matching only undefined" gives one-time-init semantics for free.
---

> Abstract: The client API surface. `makeCache(coordinator, follower)` creates the client function; the default coordinator is an in-memory local map. Ground state for any key is undefined; you cannot distinguish "value set to undefined" from "key unset." Two overloads: `cache(key, updaterFn, guardPattern?)` returns the new value after a transactional update (read current → match guard → call updater on current → sanitize result → write); retries the whole sequence if the stored value moved during the transaction; `guardPattern` defaults to matching only undefined. `cache(key, passable, guardPattern?)` is shorthand for an updater that ignores its argument and returns `passable`.

## Cache client

The client-side API is normally exposed as a single function named `cache`. You can create a cache client function by running `makeCache(coordinator, follower)`. If not specified, the default coordinator is just a local in-memory map without persistence.

- the ground state for a cache key value is `undefined`. It is impossible to distinguish a set value of `undefined` from an unset key
- `cache(key, (oldValue) => ERef<newValue>, guardPattern?): Promise<newValue>` -
  transactionally updates the value of `key` from a value matched by `guardPattern`
  to the results of sanitizing the result of calling the updater function with
  that value. Retries all three steps (read current value, attempt match, call updater),
  if the transaction is stale. `guardPattern` defaults to matching only `undefined`.
  Returns the current value after any resulting update.
- `cache(key, passable, guardPattern?): Promise<newValue>` -
  same as above with an updater function that ignores arguments and returns
  `passable` (e.g., `() => passable`).

Source: [packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.
