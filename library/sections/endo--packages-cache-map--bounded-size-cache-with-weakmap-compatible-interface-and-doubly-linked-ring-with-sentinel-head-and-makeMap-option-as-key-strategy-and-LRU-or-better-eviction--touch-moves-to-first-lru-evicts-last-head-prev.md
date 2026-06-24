---
title: §Touch-moves-to-first; §LRU-evicts-last (head.prev)
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
const touchKey = key => {
  metrics.totalQueryCount += 1;
  const cell = keyToCell.get(key);
  if (!cell?.data.has(key)) return undefined;

  metrics.totalHitCount += 1;
  moveCellAfter(cell, head);
  return cell;
};
```

§Touching-a-key §moves-its-cell-to-first-position (immediately after head). §The-LRU-victim-is-then-`head.prev` (the cell furthest from head in the ring's circular ordering).

§Every-cache-operation-touches: `has`/`get`/`set` all flow through `touchKey`. §Even-a-miss-counts-toward-totalQueryCount.

§Insertion-flow on miss:
1. If `cellCount < capacity` — append new cell at first position; increment cellCount after successful cell creation.
2. Else — §reuse-the-tail (head.prev), reset it, move it to first position.

§Don't-establish-entry-until-prior-steps-succeed:

```js
// Don't establish this entry until prior steps succeed.
if (cell) keyToCell.set(key, cell);
```

§Failure-mode-safety: §if-the-Map-allocation-throws-or-the-set-throws, §the-keyToCell-mapping-is-not-established. §No-half-state. §Sibling-pattern to cycle 199 memoize's §try/catch-cleanup-on-fn-throw — same discipline: §don't-leave-the-state-half-updated-on-failure.
