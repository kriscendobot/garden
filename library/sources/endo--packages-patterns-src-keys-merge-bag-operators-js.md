---
source: packages/patterns/src/keys/merge-bag-operators.js
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
  Twenty-second comment-fragment ingest. Bag sister to cycle 123's
  merge-set-operators.js. Same author + same commit `e56bf00f`
  (the *coordinated-update* commit that also touched cycles 108,
  110, 115, 118). Three explicit *code-sharing callouts* mark the
  abstraction debt with cycle 120's keycollection-operators.js
  AND cycle 123's merge-set-operators.js:

  - file-level: *Based on merge-set-operators.js, but altered for
    the bag representation. TODO share more code with that file
    and keycollection-operators.js.*
  - above `bagIterIsSuperbag`: *We should be able to use this for
    iterIsSuperset as well. The generalization is free.*
  - above `bagIterIsDisjoint`: *We should be able to use this for
    iterIsDisjoint as well. The code is identical.*

  The §generalization-is-free claim for isSuperbag is the
  structurally interesting observation: the bag version's
  count-comparison (`xc < yc`) reduces to the set version's
  membership-check (`xc === 0n`) when counts are clipped to
  {0n, 1n}. *Bag machinery subsumes set machinery; consolidation
  should be straightforward*. The §code-is-identical claim for
  isDisjoint is even stronger — literally the same code.

  Single most structurally interesting move: *the same merge-
  iterator + adapter pyramids support two different algebras*.
  Sets form a Boolean lattice (elements present-or-absent); bags
  form a multiplicity lattice (elements have non-negative integer
  multiplicities):
    - Set union: *push each* (element-presence only)
    - Bag union: *add counts* (multiplicities accumulate)
    - Set intersection: *push if both present*
    - Bag intersection: *push min(xc, yc)* (multiplicity-min)
    - Set superset: *every y is in x* (`xc !== 0n`)
    - Bag superset: *every y count <= x count* (`xc >= yc`)

  Five exports (vs cycle 123's six): no `bagDisjointUnion`
  because bag union *already sums counts* — equivalent keys merge
  by addition automatically. Sets need the disjoint-union to
  assert no shared elements; bags get element-sharing-is-just-
  counted for free.

  291-line single-section file with three structural layers:
    (1) `bagWindowResort(bagEntries, rankCompare, fullCompare)`
        — entry-variant of cycle 120's `generateFullSortedEntries`
        and cycle 123's `windowResort`; takes `[T, bigint][]`
        bag entries; uses `assertNoDuplicateKeys` (vs set's
        `assertNoDuplicates`); same §raw-JS-array-iterator-doesn't-
        harden escape hatch with the *unfrozen-value-does-not-
        escape-this-file* invariant. Terminating value is the
        tuple-shaped `[null, 0n]` (vs cycle 123's bare `null`).
    (2) `merge(xbagEntries, ybagEntries)` produces
        `Iterable<[T, xCount, yCount]>` (same output shape as
        cycle 123's `merge`). Six-let-buffer variant (cycle 123
        used four lets — bags need the extra `xc`/`yc` slots for
        the actual multiplicities, not hardcoded `0n`/`1n`).
    (3) Five bagIterOp folds + two adapter pyramids producing
        5 exports — `bagIterIsSuperbag` (count-comparison),
        `bagIterIsDisjoint` (identical to set isDisjoint),
        `bagIterUnion` (sum), `bagIterIntersection` (min),
        `bagIterDisjointSubtract` (subtract; precondition; >=1n
        filter preserves cycle 115's canonical-internal-form
        invariant).

  Missing from this file but present in cycle 123: `iterCompare`
  + `disjointUnion`. Bag comparison lives in cycle 104's
  `compareKeys.js` dispatch table via cycle 120's
  `makeCompareCollection`; bag union already includes the
  disjoint-union case via count-summation.

  Cycle 125 was nominally comments-lane (cycle 124 was a designs-
  lane pivot). Comments-lane is active. Papers-lane has been
  blocked for 19+ consecutive cycles. The Keys substrate is now
  *seven-files-ingested*: 102 + 104 + 110 + 115 + 120 + 123 + 125.
  Together they cover the substrate's complete operational
  surface in both the set and bag dimensions.
---

> Abstract: `packages/patterns/src/keys/merge-bag-operators.js`
> (291 lines) is the *bag-algebra layer* sister to cycle 123's
> `merge-set-operators.js` (327 lines). Same author + same commit
> `e56bf00f`. The file makes its abstraction-debt *visible* with
> three explicit code-sharing callouts (one file-level, two
> per-function): two pieces are claimed *literally identical* or
> *generalization-is-free* between the bag and set implementations.
>
> The structural shape: (1) `bagWindowResort` is the entry-variant
> taking `[T, bigint][]` (vs cycle 123's `T[]`); uses
> `assertNoDuplicateKeys` (vs set's `assertNoDuplicates`); same
> §correctness-by-closed-scope-confidence raw-JS-iterator escape
> hatch; (2) `merge` produces `Iterable<[T, xCount, yCount]>` — six
> let-buffer variables (cycle 123 used four; bag-merge tracks real
> multiplicities); (3) five bagIterOps + two adapter pyramids
> producing 5 exports.
>
> The structural thesis: *the same merge-iterator + adapter
> pyramids support two different algebras*. Sets form a Boolean
> lattice (presence-only); bags form a multiplicity lattice
> (counts accumulate / min / subtract). Bag union *sums counts*;
> bag intersection takes *min*; bag superset compares *counts*.
> The set algebra is *bag-algebra-with-counts-clipped-to-{0n,1n}*.
>
> Missing from this file vs cycle 123: `iterCompare` (bag-compare
> lives in cycle 104's compareKeys via cycle 120's
> `makeCompareCollection`) and `iterDisjointUnion` (bag-union
> already handles via count-summation). The *generalization-is-
> free* claim is the design's structural payoff.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts](../sections/endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts.md) | patterns, marshal | current |

The 291-line file is a tight bag-version of cycle 123's structural
shape: bagWindowResort → merge → bagIterOps → mergeify → bagOps.
The three code-sharing callouts make the *one algebra, two
specializations* discipline explicit. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f` (`master`) via the
  local bare-clone.
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`. Same
  commit as cycles 108 (exo-makers.js), 110 (copySet.js), 115
  (copyBag.js), 118 (exo-tools.js), 123 (merge-set-operators.js).
- Verified file existence and structure via the local bare-clone:
  291 lines + 5 exported bag operations + one private `merge` +
  one private `bagWindowResort` + five private bagIterOps + three
  explicit code-sharing callouts.
- **Twenty-second comment-fragment ingest.** Extends the Keys-
  substrate cluster to seven cycle-ingested files (102 + 104 +
  110 + 115 + 120 + 123 + 125) covering the substrate's complete
  operational surface in both set and bag dimensions.
- Cycle 125 was nominally **comments-lane** (cycle 124 was a
  designs-lane pivot). Comments-lane is active. Papers-lane has
  been blocked for **19+ consecutive cycles** due to lack of
  PDF-fetching infrastructure.
- One cohesion-honest section.
