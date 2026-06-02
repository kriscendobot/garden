---
ts: 2026-06-02T18:33:02Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--bb0b25
cycle: 120
---

# Cycle 120 — keycollection-operators.js (Turadg Aleahmad, endo) — comments-lane

Ingested `packages/patterns/src/keys/keycollection-operators.js`
(223 lines) from `endojs/endo@c63b8b709` (master). **Twentieth
comment-fragment ingest.** One cohesion-honest section:

- **pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-
  collection-comparison** — the *generic Pareto-partial-order
  machinery* that powers CopySet, CopyBag, and CopyMap comparison.
  Cycle 104's `compareKeys.js` dispatch table delegates each
  per-style row to this file's
  `makeCompareCollection(getEntries, absentValue, compareValues)`.
  Three closely-coupled functions in a strict private→helper→
  export chain:

  1. `generateFullSortedEntries` (private) — refines a rank-sorted
     iterable into a fullCompare-sorted iterable; breaks same-rank
     ties by full-order comparison; enforces key-uniqueness via
     `Math.sign(fullCompare) || Fail`Duplicate entry key:` idiom.
  2. `generateCollectionPairEntries` — sorted-merge-join over two
     collections' reverse-rank-sorted entries producing `[key,
     valueA, valueB]` triples (missing sides get caller-supplied
     `absentValue`); uses the §single-result `{done, key, value}`
     buffer pattern with pre-advance via `nextX()`/`nextY()`.
  3. `makeCompareCollection(getEntries, absentValue, compareValues)`
     factory — closes over its three args and returns a binary
     KeyComparison using the §two-flag leftIsBigger/rightIsBigger
     Pareto pattern + the §early-exit
     `if (leftIsBigger && rightIsBigger) return NaN`
     short-circuit + the §NaN-passthrough for value-level
     incomparability.

## Why one section

The three functions form a strict private→helper→export chain that
implements *one structural mechanism*. Splitting would manufacture
boundaries the code refuses to maintain.

## The structurally interesting moves

- **History-dependent comparator scoped to the active invocation**.
  `makeFullOrderComparatorKit().antiComparator` is built *fresh per
  call* — two concurrent invocations can see the same rank-tied
  remotables in different orders without affecting each other's
  result. This is the *call-local-scoping* mitigation for the
  covert-channel hazard documented in marshal's `rankOrder.js` (see
  cycle 84's full-order-comparator-kit-observable-mutable-state
  section).

- **Anti-rank lift to anti-full-order**. Rank is a preorder; the
  merge-join needs a total order. The code lifts via
  `compareAntiRank` (reverse rank preorder) +
  `makeFullOrderComparatorKit().antiComparator` (reverse total
  order). The §`generateFullSortedEntries` helper does the lift,
  catching duplicate keys with the `Math.sign(...) || Fail` idiom.

- **The Pareto algebra worked example for CopyBag**. *X ≤ Y iff
  every multiplicity in X is ≤ the corresponding multiplicity in Y
  (absent = 0) AND some multiplicity is strictly less*. Same
  algebra lifts to CopySet (Boolean lattice, absentValue = false)
  and CopyMap (per-key value comparison).

- **Virtual-collection forward-looking generalization**. The JSDoc
  names the future direction: replace `getEntries => Array` with
  `generateEntries => IterableIterator` to support collections
  that don't materialize. The iterator-friendly merge-join algebra
  already supports it.

## Pairing with the four prior Keys-substrate ingests

The Keys substrate now consists of five cycle-ingested files:

- cycle 102 — `checkKey.js` (Confirm/Is/Assert trio + CopySet/
  CopyBag/CopyMap kind validation). *Is a thing a valid Key?*
- cycle 104 — `compareKeys.js` (Pareto comparator dispatch by
  pass-style). *How do two Keys compare?*
- cycle 110 — `copySet.js` (the CopySet shape: 5-layer validation).
- cycle 115 — `copyBag.js` (the CopyBag shape: 5-layer validation +
  key-significance-over-value).
- **cycle 120** — `keycollection-operators.js` (Pareto-partial-
  order machinery). *How is the partial-order cross-collection
  mechanism built once and reused?*

Together, kind-validation (102) + dispatch-table (104) + shape
(110 + 115) + *partial-order machinery* (120) cover the Keys
substrate's whole comparison surface.

## Rotation note

Cycle 120 was nominally **comments-lane** (cycle 119 pivoted
chat-lane → designs-lane after chat-lane exhaustion). Comments-lane
is now active. Papers-lane has been blocked for **14+ consecutive
cycles** (97/100/102/104/106/108/110/112/113/114/116/117/118/119)
due to lack of PDF-fetching infrastructure.

## Counts

- 622 → **623** sections (+1).
- 164 → **165** source documents (+1).
- Topic pages updated: `patterns.md` (+1 row), `marshal.md` (+1
  row — first patterns/keys cross-link into the marshal topic).
- Keywords index extended with ~37 collection-operator-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 121 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 14+ cycles); expect another pivot.
Designs-lane and comments-lane both have substantial backlogs.
