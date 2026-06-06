---
title: §bounded-size-cache-with-WeakMap-compatible-interface + §doubly-linked-ring-with-sentinel-head + §makeMap-option-as-key-strategy (weak vs strong) + §touch-moves-to-first-LRU-evicts-last + §LRU-or-better-eviction-with-CLOCK-and-SIEVE-as-named-alternatives + §metrics-via-deepCopyJsonable-with-freezingReviver + §UNKNOWN_KEY-sentinel-symbol + §"delete"-is-a-keyword-idiom + §sentinel-head-throws-on-direct-access — @endo/cache-map
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
---

# @endo/cache-map — §bounded-size-cache with §doubly-linked-ring + §sentinel-head + §makeMap-option-as-key-strategy + §touch-moves-to-first-LRU-evicts-last + §metrics-via-deepCopyJsonable

## Source

- `endo packages/cache-map/src/cachemap.js` — 317 lines (single module exporting `makeCacheMapKit(capacity, options)`)
- `endo packages/cache-map/README.md` — 54 lines (named overview + Weak Cache + Strong Cache examples)
- Cycle 203 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 202's designs-lane endor-run-expanded; §thirty-seventh consecutive designs/chat alternation cycle 166-203).

§Twentieth-member of §small-files-with-large-knowledge-density family (cycles 165-203 chat-lane).

## Single most structurally interesting move

§Bounded-size-cache-with-WeakMap-compatible-interface (`has`/`get`/`set`/`delete`) + §`makeMap`-option-as-key-strategy (default WeakMap for weak keys; pass Map for strong arbitrary keys) + §doubly-linked-ring-with-sentinel-head + §touch-moves-to-first-LRU-evicts-last + §LRU-or-better-eviction-with-CLOCK-and-SIEVE-as-named-alternatives + §each-cell-holds-a-SingleEntryMap (so the key can be deleted by `delete(oldKey)` OR cleared if `clear` is available OR the entire Map replaced when neither works).

§Key-validity, §comparison, and §referential-strength are all controlled by §a-single-option (`makeMap`). §Default-WeakMap means §weak-references + §WeakMap-key-compatible-types-only; §Map-instead means §strong-references + §arbitrary-keys (`'unweakable key'` works). §One-option-three-axes simultaneously.

## §The `makeMap`-option-as-key-strategy (weak vs strong)

```js
// Weak (default): WeakMap-compatible keys; weak references
const { cache, getMetrics } = makeCacheMapKit(2);

// Strong: arbitrary keys; strong references; opt-in
const { cache, getMetrics } = makeCacheMapKit(100, { makeMap: Map });
```

§The-`makeMap`-option-defaults-to-`WeakMap` but accepts §any-producer-of-objects-with-WeakMap-interface. §`Map`-allows-arbitrary-keys-which-will-be-strongly-held; §any-other-WeakMap-compatible-shape would also work.

§Detection-of-constructor-vs-factory:

```js
const makeMap = (MaybeCtor => {
  try {
    MaybeCtor();
    return MaybeCtor;
  } catch (err) {
    const constructNewMap = () => new MaybeCtor();
    return constructNewMap;
  }
})(options.makeMap ?? WeakMap);
```

§Try-calling-as-factory; §fall-back-to-`new MaybeCtor()`-if-it-throws. §Both-`WeakMap`-and-`Map`-throw-when-called-without-`new`, so they take the second path. §Custom-factories-that-don't-need-`new` take the first.

§Borrowable-pattern: §try-as-factory-fall-back-to-constructor for §APIs-that-accept-both-shapes.

## §The doubly-linked-ring with §sentinel-head

```js
const head = {
  id: 0,
  next: undefined,
  prev: undefined,
  data: {
    has: () => { throw Error('internal: sentinel head cell has no data'); },
  },
};
head.next = head;
head.prev = head;
```

§Sentinel-head-that-points-to-itself-when-the-ring-is-empty. §`head.data.has`-throws-on-direct-access — §the-sentinel-is-not-a-real-cell; if someone tries to use it as one, they'll discover the bug.

§Self-referential-establishment via §two-statements-after-the-object-literal — JavaScript doesn't allow self-referential object literals, so `head.next = head; head.prev = head;` is §the-canonical-shape.

§Borrowable-pattern: §sentinel-head-that-throws-on-direct-access for §doubly-linked-data-structures. §The-sentinel-is-a-real-object so neighbors can hold pointers; §the-sentinel-is-not-data so accidental use is loud.

§Three-cell-operations:
- `appendNewCell(prev, id, data)` — splice after prev.
- `moveCellAfter(cell, prev, next = prev.next)` — splice out + splice in (no-op if already in position).
- `resetCell(cell, oldKey, makeMap?)` — preserve the Map when possible (`delete(oldKey)`); use `clear()` if available; else replace the Map entirely (WeakMap-instances-must-be-replaced-when-key-unknown because §you-can't-iterate-a-WeakMap-to-clear-it).

## §Touch-moves-to-first; §LRU-evicts-last (head.prev)

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

## §LRU-or-better-eviction (CLOCK / SIEVE as named alternatives)

> Cache eviction policy is not currently configurable, but strives for a hit ratio at least as good as [LRU](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU) (e.g., it might be [CLOCK](https://en.wikipedia.org/wiki/Page_replacement_algorithm#Clock) or [SIEVE](https://sievecache.com/)).

§Two-named-alternatives-with-citations: CLOCK (page-replacement algorithm Wikipedia) + SIEVE (sievecache.com). §The-explicit-naming-of-alternatives-with-citations is §a-borrowable-pattern for §design-comments-about-algorithmic-choice — §future-readers-can-look-up-the-alternatives-without-guessing.

§Current-implementation: LRU via doubly-linked ring. §Future-direction: could swap to CLOCK or SIEVE without changing the API.

§Borrowable-pattern: §LRU-or-better-eviction with §named-alternatives + §strives-for-hit-ratio-at-least-as-good-as-LRU as §the-API-contract. §Implementation-flexibility-via-bounded-quality-promise.

§Sibling-pattern: cycle 199 memoize's §contingent-safety framing (`memoize` only guarantees if-then safety) — both designs §promise-bounded-behavior without committing to a specific algorithm.

## §Each cell holds a §SingleEntryMap

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

## §UNKNOWN_KEY sentinel symbol

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

## §"delete" is a keyword — object literal idiom

```js
// "delete" is a keyword.
const { delete: deleteEntry } = {
  delete: key => {
    // ...
  },
};
```

§Object-literal-with-`delete`-property-then-destructure-with-rename. §This-is-the-canonical-shape for §defining-a-function-named-"delete"-as-a-local-binding (since you can't write `const delete = ...` directly because `delete` is a reserved word).

§The-comment-`// "delete" is a keyword.` explicitly names §why-the-idiom-is-needed.

§Borrowable-pattern: §object-literal-then-destructure-with-rename for §functions-named-after-reserved-words.

§Sibling-pattern to cycle 199 trampoline's §classic-uncurry-this (also §a-canonical-idiom for §a-named-language-quirk).

## §Metrics via §deepCopyJsonable with §freezingReviver

```js
const deepCopyJsonable = (value, reviver) => {
  const encoded = stringify(value);
  const decoded = parse(encoded, reviver);
  return decoded;
};

const freezingReviver = (_name, value) => freeze(value);

const deepCopyAndFreezeJsonable = value => deepCopyJsonable(value, freezingReviver);

const zeroMetrics = freeze({
  totalQueryCount: 0,
  totalHitCount: 0,
});

const metrics = deepCopyJsonable(zeroMetrics);
const getMetrics = () => deepCopyAndFreezeJsonable(metrics);
```

§JSON-roundtrip-with-reviver as §a-deep-clone-mechanism + §freezingReviver applies `freeze` to each value during the reviver pass. §So-`deepCopyAndFreezeJsonable`-returns-a-deeply-frozen-copy.

§`getMetrics`-returns-a-fresh-frozen-copy-on-every-call — §so-the-caller-cannot-mutate-the-internal-metrics. §Defensive-clone-on-read.

§Borrowable-pattern: §JSON-roundtrip-with-freezing-reviver for §deep-clone-with-freeze in one pass.

§zeroMetrics with §named-TODO comments:

```js
const zeroMetrics = freeze({
  totalQueryCount: 0,
  totalHitCount: 0,
  // TODO?
  // * method-specific counts
  // * liveTouchStats/evictedTouchStats { count, sum, mean, min, max }
  //   * p50/p90/p95/p99 via Ben-Haim/Tom-Tov streaming histograms
});
```

§Three-named-future-extensions in comments:
1. method-specific counts (count per has/get/set/delete)
2. liveTouchStats / evictedTouchStats with count/sum/mean/min/max
3. percentiles via §Ben-Haim/Tom-Tov-streaming-histograms (citation to the algorithm)

§Borrowable-pattern: §TODO-comments-with-citations for §future-extensions-that-have-known-implementation-shapes. §Sibling-pattern to cycle 197 panic's §three-named-future-extensions and cycle 198 patterns-diagnostic-feedback's §future-helpers-named-not-shipped.

## §`WeakCacheMap`-vs-`CacheMap` Symbol.toStringTag based on weak vs strong

```js
const tag =
  makeMap().clear === undefined
    ? 'WeakCacheMap'
    : 'CacheMap';
// ...
[toStringTagSymbol]: tag,
```

§Tag-discrimination by §the-presence-of-`clear`-method on the produced instance. §`WeakMap`-has-no-`clear` (because WeakMaps can't be iterated); §`Map`-has-`clear`. §So-the-tag-reflects-the-key-strategy.

§Sibling-pattern to cycle 201 immutable-arraybuffer's §Purposeful-Violation (`Symbol.toStringTag = 'ImmutableArrayBuffer'` for §concordance-sniff-defense). §Cycle-203-uses-toStringTag-for-§informational-discrimination not §defense — but the same surface (Symbol.toStringTag).

## §Cells-not-frozen-because-closely-encapsulated

```js
/**
 * A cell of a doubly-linked ring (circular list) for a cache map.
 * Instances are not frozen, and so should be closely encapsulated.
 */
```

§Honest-trade-off-named-in-comment: §cells-are-mutable (next/prev/data must be reassignable for the ring operations); §so-they-must-be-closely-encapsulated (don't leak them out of the module).

§Sibling-pattern to cycle 197 panic's §Object.freeze on the export function (freeze-but-not-harden) — both designs §name-the-freeze-discipline-explicitly with §named-rationale-for-the-exception.

## §Capacity-bounded-strict

```js
if (!isSafeInteger(capacity) || capacity < 0) {
  throw TypeError(
    'capacity must be a non-negative safe integer number <= 2**53 - 1',
  );
}
```

§Two-conditions-checked at construction: §safe-integer (cycle 199 @endo/nat's §safely-representable-IEEE-754-discipline) + §non-negative. §Single-TypeError-with-named-range.

§The-error-message-names-the-implicit-upper-bound (`<= 2**53 - 1`) — §greppable-for-callers-who-hit-it.

§Sibling-pattern to cycle 199 @endo/nat's §two-different-error-types (TypeError = wrong-kind; RangeError = right-kind-wrong-value). §Cycle-203-collapses-both into TypeError with §combined-message; cycle-199-distinguishes-them.

## §`freeze`-each-method-individually + §freeze-implementation + §freeze-kit

```js
freeze(has);
freeze(get);
freeze(set);
freeze(deleteEntry);
freeze(implementation);
freeze(kit);
freeze(makeCacheMapKit);
```

§Seven-freezes total. §Each-method-frozen-individually before composition; §the-implementation-object-frozen after; §the-kit-frozen after; §the-factory-frozen as the last line.

§Sibling-pattern to cycle 199 memoize's §harden-the-factory-and-the-products (memoize-the-factory + memoFn-the-product both hardened) — same discipline at finer granularity. §Cycle-203-uses-`freeze`-not-`harden` because it's a §pre-lockdown-utility (sibling to cycle 199 nat's §freeze-as-harden-substitute-pending-PR-#3008).

## §The kit pattern (cache + getMetrics)

```js
const kit = { cache: implementation, getMetrics };
return freeze(kit);
```

§The-factory-returns-a-kit-pair: §cache-object + §getMetrics-function. §Two-related-but-distinct-surfaces returned together. §The-`Kit`-suffix is a §convention in @endo/ses-ava and @endo/exo for §factory-returns-multiple-related-things.

§Borrowable-pattern: §kit-pattern for §factories-returning-multiple-related-objects. §Avoid-array-destructuring (positional) in favor of §named-object-properties for §readability.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §bounded-payout-history-cache can §borrow-the-cache-map-kit directly — recent payouts indexed by §player-session-token (Map-strong-keys) or by §session-object-reference (WeakMap-weak-keys).

§Doubly-linked-ring-with-sentinel-head borrowable for any §ordered-collection-with-LRU-semantics — game-state replay buffer, audit log of recent operations, recently-used-asset-cache.

§LRU-or-better-eviction-with-named-alternatives borrowable as §the-API-contract for §pluggable-cache-policies — the slot machine library can promise §at-least-LRU-quality while leaving room to swap in CLOCK or SIEVE.

§Metrics-via-deepCopyJsonable-with-freezingReviver borrowable for any §performance-counters-surface where §the-counters-must-be-defensively-frozen on read.

§Kit-pattern borrowable for §factories-returning-multiple-related-objects (cache + metrics; game-state + observer; deck + reshuffle).

§TODO-comments-with-citations (Ben-Haim/Tom-Tov streaming histograms) as §the-shape-for-future-extensions-with-known-implementation-shapes.

## §Cycle 203 meta-observations

§The-thirty-seventh-consecutive-designs/chat-alternation-cycle 166-203.

§Papers-lane-blocked 97+ consecutive cycles (since cycle ~106). §The-papers-lane-block is now §nearly-half-of-the-total-cycle-count.

§Library-reaches-708-sections at cycle 203.

§Twentieth-member of §small-files-with-large-knowledge-density family.

§Four-different-sentinel-shapes now in the library:
- §Local-symbol (cycle 203 cache-map's UNKNOWN_KEY).
- §Registered-symbol (cycle 197 panic's PanicEndowmentSymbol).
- §Pumpkin-sentinel (cycle 199 memoize's `harden({})`).
- §WeakMap (cycle 201 immutable-arraybuffer's `buffers`).

§Each-sentinel-shape has §a-different-cross-cutting-need that motivates its specific design. §The-family-of-private-state-emulation-techniques in @endo is §richer-than-any-single-technique.

§Sibling-pattern to cycle 199's §three-different-approaches-to-the-same-harden-discipline. §Both-meta-observations record §the-family-of-techniques-for-a-common-need rather than §a-single-canonical-pattern.
