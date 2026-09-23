---
ts: 2026-06-02T20:07:16Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--e2816b
cycle: 123
---

# Cycle 123 — merge-set-operators.js (Kris Kowal, endo) — comments-lane

Ingested `packages/patterns/src/keys/merge-set-operators.js` (327
lines) from `endojs/endo@e56bf00f` (master). **Twenty-first
comment-fragment ingest.** One cohesion-honest section:

- **seven-set-operations-derived-from-one-merge-iterator-with-
  mergeify-and-setify-adapters** — the *set-algebra layer*
  sitting on top of cycle 120's keycollection-operators.js
  infrastructure. Three structural layers: (1) `windowResort` —
  element-variant of cycle 120's `generateFullSortedEntries`
  (with the §raw-JS-array-iterator-doesn't-harden escape hatch
  and the *unfrozen-value-does-not-escape-this-file* §correctness-
  by-closed-scope-confidence note); (2) `merge` produces
  `Iterable<[T, xCount, yCount]>` triples — *bigint counts
  generalize nicely for bags*; same merge-join algebra as cycle
  120's `generateCollectionPairEntries`; (3) seven iterOp folds +
  two adapter pyramids producing 13 exports
  (`elementsIsSuperset` / `elementsIsDisjoint` /
  `elementsCompare` / `elementsUnion` / `elementsDisjointUnion`
  / `elementsIntersection` / `elementsDisjointSubtract` +
  `setIsSuperset` / `setIsDisjoint` / `setUnion` /
  `setDisjointUnion` / `setIntersection` / `setDisjointSubtract`).

## Why one section

The 327-line file is a tight three-layer factory chain (iterOp →
elementsOp → setOp) with adapter pyramids tying the layers. The
opening `// TODO share more code with keycollection-operators.js`
comment makes the *one structural mechanism shared with cycle 120*
discipline explicit. Splitting would manufacture boundaries the
code refuses to maintain.

## The Keys substrate now spans six cycle-ingested files

- cycle 102 — `checkKey.js` (kind validation)
- cycle 104 — `compareKeys.js` (partial-order dispatch table)
- cycle 110 — `copySet.js` (CopySet shape)
- cycle 115 — `copyBag.js` (CopyBag shape)
- cycle 120 — `keycollection-operators.js` (Pareto-partial-order
  pair-merging machinery)
- **cycle 123 (this cycle)** — `merge-set-operators.js`
  (set-algebra layer over cycle 120's machinery)

The six together cover the Keys substrate's *complete operational
surface*: kind-validation, partial-order dispatch, shape,
partial-order pair-merging, and set-algebra.

## *TODO share more code* — the visible abstraction debt

The §opening TODO comment makes explicit the structural
duplication between this file's `windowResort` + `merge` and cycle
120's `generateFullSortedEntries` + `generateCollectionPairEntries`.
Both implementations are correct; the consolidation is deferred.
The §asymmetry with cycle 104's compareKeys (whose setCompare
uses cycle 120's `makeCompareCollection`, not this file's
`iterCompare`) confirms that the algebra appears in *two places*
already — the TODO marker is real abstraction debt.

## Rotation note

Cycle 123 was nominally **comments-lane** (cycle 122 was a
designs-lane pivot). Comments-lane is active. Papers-lane has been
blocked for **17+ consecutive cycles** (97/100/102/104/106/108/
110/112/113/114/116/117/118/119/120/121/122) due to lack of
PDF-fetching infrastructure.

## Counts

- 626 → **627** sections (+1).
- 167 → **168** source documents (+1).
- Topic pages updated: `patterns.md` (+1 row — sixth @endo/patterns
  row), `marshal.md` (+1 row — second @endo/patterns consumer of
  `makeFullOrderComparatorKit().antiComparator` shown at section
  grain).
- Keywords index extended with ~32 set-algebra-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 124 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked). Expect another pivot.
