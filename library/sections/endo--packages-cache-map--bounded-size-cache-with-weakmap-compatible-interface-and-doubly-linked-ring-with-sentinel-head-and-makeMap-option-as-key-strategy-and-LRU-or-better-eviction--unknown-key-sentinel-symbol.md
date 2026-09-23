---
title: §UNKNOWN_KEY sentinel symbol
source: endo packages/cache-map/{src/cachemap.js,README.md}
source-slug: endo--packages-cache-map
ingest-cycle: 203
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling; memoize+cache-map have parallel structures for WeakMap-key caching)
  - endo--packages-immutable-arraybuffer (cycle 201: §WeakMap-as-emulated-private-field — different use of WeakMap; this cycle uses WeakMap as the cache substrate)
  - endo--packages-pass-style (cycle 71+: passStyleOf uses internal memoization that could be cache-map; cycle 199 named passStyleOf as canonical memoize-user)
  - endo--packages-panic (cycle 197: §three-layer-dispatch-chain sibling — both designs have §gradient-of-fallbacks)
  - endo--packages-where-index-js (cycle 167: §small-files-with-large-knowledge-density sibling family)
keywords:
  - bounded-size-cache with WeakMap-compatible interface
  - makeMap-option-as-key-strategy (weak vs strong via WeakMap or Map)
  - doubly-linked-ring with sentinel-head
  - touch-moves-to-first; LRU-evicts-last
  - LRU-or-better eviction (CLOCK / SIEVE as named alternatives)
  - sentinel-head-throws-on-direct-access
  - UNKNOWN_KEY sentinel symbol
  - "delete" is a keyword idiom (object literal with delete property)
  - deepCopyJsonable + freezingReviver for metrics
  - WeakCacheMap vs CacheMap tag based on weak vs strong
  - capacity-bounded-strict (isSafeInteger non-negative; TypeError on invalid)
  - cells-not-frozen-because-closely-encapsulated
  - SingleEntryMap typedef for cell payload
  - WeakMap-instances-must-be-replaced-when-key-unknown
  - touchKey: side-effect of moving cell to first position
  - don't-establish-entry-until-prior-steps-succeed (keyToCell.set last)
  - freeze-each-method-individually + freeze-implementation + freeze-kit
  - cycle 203 chat-lane (alternation continues)
  - twentieth-member of small-files-with-large-knowledge-density family
  - thirty-seventh consecutive designs/chat alternation cycle 166-203
parent: endo--packages-cache-map--bounded-size-cache-with-weakmap-compatible-interface-and-doubly-linked-ring-with-sentinel-head-and-makeMap-option-as-key-strategy-and-LRU-or-better-eviction
---

```js
const UNKNOWN_KEY = Symbol('UNKNOWN_KEY');
```

§Local-symbol (not registered via `Symbol.for`) — §the-symbol-is-module-private. §Used-as-a-sentinel-value to signal §"caller-doesn't-have-the-key" to `resetCell`.

§Three-different-sentinel-patterns now in the library (cycle 197/199/201/203 + this):
- §Local-symbol (cycle 203 cache-map's UNKNOWN_KEY) — for §private-signaling-within-a-module
- §Registered-symbol (cycle 197 panic's PanicEndowmentSymbol = Symbol.for(...)) — for §cross-twin-coordination
- §Pumpkin-sentinel (cycle 199 memoize's `harden({})`) — for §reference-equality-marker-as-private-state
- §WeakMap (cycle 201 immutable-arraybuffer) — for §emulated-private-field-AND-brand-check

§Four-different-sentinel-shapes for §four-different-cross-cutting-needs. §The-cache-map-UNKNOWN_KEY is §the-simplest of the four — just §a-private-marker-for-an-API-contract.
