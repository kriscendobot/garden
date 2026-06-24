---
title: "@endo/cache-map — bounded-size cache with WeakMap-compatible interface"
source-slug: endo--packages-cache-map
url: https://github.com/endojs/endo/tree/master/packages/cache-map
authors: [Endo contributors]
repo: endojs/endo
path:
  - packages/cache-map/src/cachemap.js
  - packages/cache-map/README.md
total-lines: 317 source + 54 README
license: Apache-2.0
ingest-cycle: 203
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/cache-map

Bounded-size cache exposing the same `has`/`get`/`set`/`delete` interface as `WeakMap`/`Map`. The `makeMap` option (defaults to `WeakMap`) controls §key-validity + §comparison + §referential-strength simultaneously. Pass `Map` instead of `WeakMap` for strong references and arbitrary keys.

```js
import { makeCacheMapKit } from '@endo/cache-map';

// Weak (default): WeakMap-compatible keys
const { cache: weakCache, getMetrics } = makeCacheMapKit(2);

// Strong: arbitrary keys
const { cache, getMetrics } = makeCacheMapKit(100, { makeMap: Map });
```

## Key design moves

- **§Bounded-size-cache with WeakMap-compatible interface** — `has`/`get`/`set`/`delete` parity for interchangeable call sites.
- **§`makeMap`-option-as-key-strategy** — one option controls weak vs strong references + key-type-restrictions simultaneously.
- **§Try-as-factory-fall-back-to-constructor** — `MaybeCtor()` then `new MaybeCtor()` for APIs accepting both shapes.
- **§Doubly-linked-ring-with-sentinel-head** — `head.next = head; head.prev = head` initially; cells splice in/out around head; §sentinel-head's-`data.has`-throws to catch accidental use.
- **§Touch-moves-to-first; LRU-evicts-last** (`head.prev`) — every cache operation flows through `touchKey` which moves the cell.
- **§LRU-or-better-eviction with named-alternatives** (CLOCK / SIEVE) + §strives-for-hit-ratio-at-least-as-good-as-LRU as the §API-contract — implementation-flexibility-via-bounded-quality-promise.
- **§Each cell holds a §SingleEntryMap** with §three-strategy-cascade for reset (delete known key / clear if supported / replace entirely for WeakMap path).
- **§UNKNOWN_KEY-sentinel-symbol** — local Symbol marking "caller doesn't know the prior key" for `resetCell`.
- **§"delete" is a keyword idiom** — object-literal-then-destructure-with-rename (`const { delete: deleteEntry } = { delete: key => {...} }`).
- **§Metrics via §deepCopyJsonable + §freezingReviver** — JSON roundtrip with reviver as one-pass deep-clone-with-freeze; `getMetrics()` returns fresh frozen copy on every call (§defensive-clone-on-read).
- **§zeroMetrics with §named-TODO comments** — three future extensions named (method-specific counts; liveTouchStats/evictedTouchStats; p50/p90/p95/p99 via Ben-Haim/Tom-Tov streaming histograms — algorithm cited).
- **§WeakCacheMap-vs-CacheMap toStringTag discrimination** — based on presence of `clear` method (WeakMap has none; Map has `clear`).
- **§Cells-not-frozen-because-closely-encapsulated** — honest trade-off named in comment ("Instances are not frozen, and so should be closely encapsulated").
- **§Capacity-bounded-strict** — TypeError on non-safe-integer or negative; error names implicit upper bound (`<= 2**53 - 1`).
- **§Don't-establish-entry-until-prior-steps-succeed** — `keyToCell.set` last so failures leave no half-state.
- **§Seven freezes** — has / get / set / deleteEntry / implementation / kit / makeCacheMapKit.
- **§Kit-pattern** — factory returns `{ cache, getMetrics }` with named object properties.

## Information-theoretic limit named explicitly

> WeakMap instances must be replaced when the key is unknown.

§You-cannot-iterate-a-WeakMap-to-clear-it (by design — WeakMaps don't expose iteration). §So-the-only-way-to-clear-a-WeakMap-without-knowing-its-keys is §to-discard-it-and-make-a-new-one. This is why `resetCell` falls through to `cell.data = makeMap()` for the WeakMap path.

## Ingest scope

Cycle 203 (chat-lane): full ingest of the 317-line source + 54-line README. One section.

## Related material in the library

- **cycle 199 endo--packages-trampoline-memoize-nat-trio**: §minimal-dependency-discipline sibling; @endo/memoize has parallel structure for WeakMap-key caching (memoize is one-key-per-arg; cache-map is bounded-many-keys).
- **cycle 201 endo--packages-immutable-arraybuffer**: §WeakMap-as-emulated-private-field-AND-brand-check sibling — different use of WeakMap (cycle 201 uses for private state; cycle 203 uses as the cache substrate).
- **cycle 197 endo--packages-panic**: §three-layer-dispatch-chain sibling pattern (cycle 203 has §three-strategy-cascade for `resetCell`).
- **cycle 71+ endo--packages-pass-style**: passStyleOf uses internal memoization (cited in cycle 199 memoize.md as canonical memoize-user); could in principle adopt cache-map for bounded memoization.
- **cycle 167 endo--packages-where-index-js**: §small-files-with-large-knowledge-density sibling family.
- **cycle 202 endo-but-for-bots--llm-designs-endor-run-expanded**: §root-hash-printed-to-stderr-for-re-run uses the CAS as a similar bounded-storage but with content-addressing; sibling-pattern at different layer.

## Eviction policy citations

- LRU: https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU
- CLOCK: https://en.wikipedia.org/wiki/Page_replacement_algorithm#Clock
- SIEVE: https://sievecache.com/
- Streaming histograms for percentiles: Ben-Haim/Tom-Tov streaming histograms algorithm (named in TODO).
