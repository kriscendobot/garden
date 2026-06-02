---
source: packages/patterns/src/keys/merge-set-operators.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-first comment-fragment ingest. Sister file to cycle 120's
  `keycollection-operators.js` — same merge-join algebra, different
  output tuple shape (`[T, xCount, yCount]` here vs `[Key, valueA,
  valueB]` in cycle 120). The §opening `// TODO share more code with
  keycollection-operators.js` comment names the abstraction debt
  explicitly.

  327-line single-section file with three structural layers:

  1. **`windowResort(elements, rankCompare, fullCompare)`** — the
     element (vs entry) variant of cycle 120's
     `generateFullSortedEntries`. Same shape: rank-sorted input
     walk, look-ahead for same-rank ties, fullCompare-sort each
     tied run, enforce uniqueness via `assertNoDuplicates`. Single
     structurally interesting deviation: the §raw-JS-array-
     iterator-doesn't-harden-IteratorResult escape hatch
     (*Fixing this is expensive and I'm confident the unfrozen
     value does not escape this file, so I'm leaving this as is*).

  2. **`merge(xelements, yelements)`** — produces
     `Iterable<[T, xCount, yCount]>`. Same merge-join algebra as
     cycle 120's `generateCollectionPairEntries`. Bigint counts
     anticipate CopyBag generalization (*For sets, these counts
     are always 0 or 1, but this representation generalizes nicely
     for bags*). History-dependent comparator built fresh per call
     (*scoped to this one merge call and does not survive it*) —
     same call-local-scoping covert-channel mitigation cycle 120
     applied.

  3. **Seven iterOp folds + two adapter pyramids (mergeify +
     {raw,full}-setify) producing 13 exports**:
     - iterIsSuperset / iterIsDisjoint (boolean early-exit folds)
     - iterCompare (Pareto two-flag pattern with NaN short-circuit)
     - iterUnion / iterDisjointUnion (push-each folds)
     - iterIntersection (filter-by-both fold)
     - iterDisjointSubtract (assert-x-present-filter-y-absent fold)
     - mergeify lifts iterOp to elementsOp (raw T[] arrays)
     - rawSetify lifts elementsOp to setOp for *predicates*
     - setify lifts elementsOp to setOp for *constructors*, re-
       tagging via `makeSetOfElements(...)` to preserve the
       canonical copySet internal form (cycle 110 invariant)

  Single most structurally interesting move: the §three-layer
  factory chain (iterOp → mergeify → elementsOp → {raw,}setify →
  setOp). Each layer adds one wrapping concern: iterOp is pure
  fold; elementsOp does the merge-iterator construction; setOp
  unwraps the tagged-value envelope. The split lets the seven
  iterOps stay shape-agnostic, the elementsOps stay payload-
  agnostic, and only the setOps know about the `copySet` tag.

  Note the §asymmetry with cycle 104's compareKeys.js: compareKeys
  uses cycle 120's `makeCompareCollection(getElements, false, ...)`
  for the dispatch-table setCompare, not this file's `iterCompare`.
  Same algebra in two places — the explicit *TODO share more code*
  marker.

  Cycle 123 was nominally comments-lane (cycle 122 was a designs-
  lane pivot). Comments-lane is active. Papers-lane has been
  blocked for 17+ consecutive cycles. The Keys substrate is now
  *six-files-ingested*: 102 (checkKey) + 104 (compareKeys) + 110
  (copySet) + 115 (copyBag) + 120 (keycollection-operators) +
  123 (this cycle / merge-set-operators).
---

> Abstract: `packages/patterns/src/keys/merge-set-operators.js` is
> the *set-algebra layer* — 13 exported set operations (union,
> intersection, disjoint-subtract, etc.) derived from one merge
> iterator + seven generic iterOp folds + two adapter pyramids
> (mergeify + setify). Sister to cycle 120's
> `keycollection-operators.js` with the explicit
> `// TODO share more code` connector comment.
>
> The structural shape: (1) `windowResort` is the element-variant
> of cycle 120's `generateFullSortedEntries` (resorts same-rank
> runs by fullCompare and enforces uniqueness); (2) `merge`
> produces `Iterable<[T, xCount, yCount]>` triples — bigint counts
> generalize to bags; (3) seven iterOps each fold over the
> merge-triple stream; (4) `mergeify` lifts iterOp →
> elementsOp; (5) `rawSetify` lifts elementsOp → setOp for
> predicates; (6) `setify` lifts elementsOp → setOp for
> constructors, re-tagging via `makeSetOfElements(...)` to preserve
> the canonical copySet internal form (cycle 110's invariant).
>
> The §history-dependent comparator scoping repeats verbatim from
> cycle 120: `makeFullOrderComparatorKit().antiComparator` is built
> *fresh per call* and *does not survive* the merge call. Same
> call-local-scoping covert-channel mitigation.
>
> The §raw-JS-array-iterator-doesn't-harden-IteratorResult escape
> hatch is the §correctness-by-closed-scope-confidence note: the
> author is explicit that this is a known deviation from the
> hardened-iterator convention, justified by the
> *unfrozen-value-does-not-escape-this-file* invariant.
>
> The §asymmetry with cycle 104's compareKeys.js — its setCompare
> uses cycle 120's `makeCompareCollection`, not this file's
> `iterCompare`. Same algebra in two places; the *TODO share more
> code* marker flags the duplication.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters](../sections/endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters.md) | patterns, marshal | current |

The 327-line file is a tight three-layer factory chain (iterOp →
elementsOp → setOp) with adapter pyramids tying the layers. The
opening `// TODO share more code with keycollection-operators.js`
comment makes the *one structural mechanism shared with cycle 120*
discipline explicit. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f` (`master`) via the
  local bare-clone.
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`. Same
  commit as cycles 108 (exo-makers.js), 110 (copySet.js), 115
  (copyBag.js), 118 (exo-tools.js).
- Verified file existence and structure via the local bare-clone:
  327 lines + 13 exported set/elements operations + one private
  `merge` + one private `windowResort` + seven private iterOps.
- **Twenty-first comment-fragment ingest.** Extends the Keys-
  substrate cluster to six cycle-ingested files (102 + 104 + 110 +
  115 + 120 + 123) covering the substrate's complete operational
  surface.
- Cycle 123 was nominally **comments-lane** (cycle 122 was a
  designs-lane pivot). Comments-lane is active. Papers-lane has
  been blocked for **17+ consecutive cycles**
  (97/100/102/104/106/108/110/112/113/114/116/117/118/119/120/121
  /122) due to lack of PDF-fetching infrastructure.
- One cohesion-honest section.
