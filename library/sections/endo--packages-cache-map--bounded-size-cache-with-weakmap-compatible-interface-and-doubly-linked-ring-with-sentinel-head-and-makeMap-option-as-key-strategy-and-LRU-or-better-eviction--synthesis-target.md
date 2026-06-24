---
title: §Synthesis-target
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

Slot machine library §bounded-payout-history-cache can §borrow-the-cache-map-kit directly — recent payouts indexed by §player-session-token (Map-strong-keys) or by §session-object-reference (WeakMap-weak-keys).

§Doubly-linked-ring-with-sentinel-head borrowable for any §ordered-collection-with-LRU-semantics — game-state replay buffer, audit log of recent operations, recently-used-asset-cache.

§LRU-or-better-eviction-with-named-alternatives borrowable as §the-API-contract for §pluggable-cache-policies — the slot machine library can promise §at-least-LRU-quality while leaving room to swap in CLOCK or SIEVE.

§Metrics-via-deepCopyJsonable-with-freezingReviver borrowable for any §performance-counters-surface where §the-counters-must-be-defensively-frozen on read.

§Kit-pattern borrowable for §factories-returning-multiple-related-objects (cache + metrics; game-state + observer; deck + reshuffle).

§TODO-comments-with-citations (Ben-Haim/Tom-Tov streaming histograms) as §the-shape-for-future-extensions-with-known-implementation-shapes.
