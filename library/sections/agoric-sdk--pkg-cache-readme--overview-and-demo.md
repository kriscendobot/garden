---
title: Agoric Cache (overview + demo)
source: packages/cache/README.md
source_repo: agoric/agoric-sdk
source_commit: 1fa31b00d031479481c30158286404ffd8a4ebed
source_date: 2022-08-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, capability-security]
status: current
notes: The demo's four patterns (direct value, match-and-set, one-time-init, guard-pattern-update) are the core API surface in worked-example form. `M.any()` from `@agoric/store` is the no-guard match-anything pattern. Note that there's no way to distinguish a set value of undefined from an unset key — the ground state is always undefined.
---

> Abstract: The cache lets a client function synchronize with a cache backend. Any Passable value can be a key or value. The worked demo shows: direct value get/set (`cache('baz')` to get, `cache('baz', 'value')` to set); match-and-set (3rd arg is the guard pattern — only set if current matches); one-time-init (second call returns the original since the guard implicitly requires undefined); updater function (`cache(key, updater, M.any())` with a function `(oldValue) => newValue` and any-match guard).

# Agoric Cache

This cache mechanism allows a cache client function to synchronize with a cache backend. Any passable object can be a cache key or a cache value.

## Demo

```js
import { makeCache, makeScalarStoreCoordinator } from '@agoric/cache';
import { M } from '@agoric/store';
import { makeScalarBigMapStore } from '@agoric/vat-data';

const store = makeScalarBigMapStore('cache');
const coordinator = makeScalarStoreCoordinator(store);
const cache = makeCache(coordinator);

// Direct value manipulation.
await cache('baz'); // undefined
await cache('baz', 'barbosa'); // 'barbosa'

// Match-and-set.
await cache('baz', 'babaloo', undefined); // 'barbosa'
await cache('baz', 'babaloo', 'barbosa'); // 'babaloo'

// One-time initialization.
await cache('frotz', 'default'); // 'default'
await cache('frotz', 'ignored'); // 'default'

// Update the `'foo'` entry, using its old value (initially `undefined`).
await cache('foo'); // `undefined`
const updater = (oldValue = 'bar') => `${oldValue}1`;
await cache('foo', updater, M.any()); // 'bar1'
await cache('foo', updater, M.any()); // 'bar11'
await cache('foo'); // 'bar11'

// You can also specify a guard pattern for the value to update. If it
// doesn't match the latest value, then the cache isn't updated.
await cache('foo', updater, 'nomatch'); // 'bar11'
await cache('foo', updater, 'bar11'); // 'bar111'
await cache('foo', updater, 'bar11'); // 'bar111'
await cache('foo'); // 'bar111'
```

Source: [packages/cache/README.md](https://github.com/Agoric/agoric-sdk/blob/1fa31b00d031479481c30158286404ffd8a4ebed/packages/cache/README.md) at commit `1fa31b00`.
