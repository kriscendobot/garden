---
title: §Each cell holds a §SingleEntryMap
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

```typescript
type SingleEntryMap<K, V> = WeakMapAPI<K, V> & ({clear?: undefined} | Pick<Map<K, V>, 'clear'>);
```

§A-SingleEntryMap is §WeakMap-or-Map (or compatible) §holding-exactly-one-entry. §Three-reset-strategies enumerated in `resetCell`:

```js
const resetCell = (cell, oldKey, makeMap) => {
  if (oldKey !== UNKNOWN_KEY) {
    cell.data.delete(oldKey);       // strategy 1: delete the known old key
    return;
  }
  if (cell.data.clear) {
    cell.data.clear();              // strategy 2: clear if supported (Map but not WeakMap)
    return;
  }
  if (!makeMap) {
    throw Error('internal: makeMap is required with UNKNOWN_KEY');
  }
  cell.data = makeMap();            // strategy 3: replace the Map entirely (WeakMap path)
};
```

§Three-strategy-cascade for §resetting-a-cell-without-knowing-the-prior-key. §The-`UNKNOWN_KEY`-sentinel-symbol marks §the-case-where-the-caller-doesn't-know-or-can't-cheaply-recover-the-prior-key.

§The-WeakMap-instances-must-be-replaced clause is §an-information-theoretic-limit: §you-cannot-iterate-a-WeakMap-to-clear-it (by design — WeakMaps don't expose iteration). §So-the-only-way-to-clear-a-WeakMap-without-knowing-its-keys is §to-discard-it-and-make-a-new-one.

§Borrowable-pattern: §three-strategy-cascade for §reset-with-graceful-degradation. §Sibling-pattern to cycle 197 panic's §three-layer-dispatch-chain (also a §three-strategy-cascade with §named-fallback-conditions).
