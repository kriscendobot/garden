---
title: §Borrowable patterns (tier-1)
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

1. **§Bounded-size-cache-with-WeakMap-compatible-interface** — `has`/`get`/`set`/`delete` parity with WeakMap/Map for §interchangeable-call-sites.
2. **§`makeMap`-option-as-key-strategy** — one option controls §key-validity + §comparison + §referential-strength simultaneously.
3. **§Try-as-factory-fall-back-to-constructor** for §APIs-that-accept-both-shapes (`MaybeCtor()` then `new MaybeCtor()`).
4. **§Doubly-linked-ring-with-sentinel-head** — head.next = head; head.prev = head initially; cells splice in/out around head.
5. **§Sentinel-head-that-throws-on-direct-access** — `head.data.has` throws "internal: sentinel head cell has no data" to catch accidental use.
6. **§Touch-moves-to-first; LRU-evicts-last** — every cache operation flows through `touchKey`; eviction targets `head.prev`.
7. **§LRU-or-better-eviction with named-alternatives** (CLOCK + SIEVE) + §strives-for-hit-ratio-at-least-as-good-as-LRU as the §API-contract — §implementation-flexibility-via-bounded-quality-promise.
8. **§Each-cell-holds-a-SingleEntryMap** with §three-strategy-cascade for reset (delete known key / clear if supported / replace entirely for WeakMap path).
9. **§UNKNOWN_KEY-sentinel-symbol** as §a-private-marker-for-an-API-contract.
10. **§"delete" is a keyword idiom** — object-literal-then-destructure-with-rename for §functions-named-after-reserved-words.
11. **§deepCopyJsonable + freezingReviver** for §deep-clone-with-freeze in one pass via JSON roundtrip.
12. **§Metrics-via-defensive-clone-on-read** — `getMetrics` returns a fresh frozen copy on every call.
13. **§TODO-comments-with-citations** (Ben-Haim/Tom-Tov streaming histograms) for §future-extensions-with-known-implementation-shapes.
14. **§WeakCacheMap-vs-CacheMap toStringTag discrimination** by §presence-of-`clear`-method.
15. **§Cells-not-frozen-because-closely-encapsulated** — §honest-trade-off-named-in-comment.
16. **§Capacity-bounded-strict** with TypeError naming the implicit upper bound (`<= 2**53 - 1`).
17. **§Don't-establish-entry-until-prior-steps-succeed** — `keyToCell.set` last so failures leave no half-state.
18. **§Freeze-each-method-individually + freeze-implementation + freeze-kit + freeze-factory** — seven freezes total.
19. **§Kit-pattern** with §named-object-properties for §factories-returning-multiple-related-things.
20. **§WeakMap-instances-must-be-replaced-when-key-unknown** — §information-theoretic-limit: cannot iterate WeakMap.
