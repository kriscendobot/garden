---
source: packages/patterns/src/keys/copySet.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Seventeenth comment-fragment ingest. Kris Kowal-authored
  *copySet element-validation* file — *the* sibling that cycle 102's
  checkKey.js imports `confirmElements` and `makeSetOfElements`
  from. The 109-line file is the canonical *internal-form-
  validation* + *factory* surface for copySets. Three structurally
  interesting moves: (1) the *history-dependent-state-call-local*
  discipline for the fullOrder antiComparator (built fresh per
  `confirmNoDuplicates` call when no explicit comparator is
  provided; the comment repeats the discipline introduced in cycle
  102's `makeCopyBagFromElements`); (2) the *reverse-rank-sorted
  invariant* for copySet keys — `compareAntiRank` not `compareRank`,
  consistent with cycle 84's rankOrder.js and cycle 102's
  `makeCopyBagFromElements` + `makeCopyMap`; (3) the
  *honest-known-perf-limit-with-named-mitigation* TODO at the top
  — *If doing this redundantly turns out to be expensive, we
  could memoize this no-duplicate finding as well, independent of
  the `fullOrder` use to reach this finding*.
  
  Cycle 110 papers-lane pivot to comments-lane (seventh consecutive
  papers-lane block, cycles 97/100/102/104/106/108/110). Pairs
  structurally with cycle 102's checkKey.js (which imports from
  this file) and cycle 104's compareKeys.js (which uses CopySet
  comparison indirectly via setCompare). Single-section
  cohesion-honest ingest.
---

> Abstract: `packages/patterns/src/keys/copySet.js` is the *internal-
> form-validation + factory* surface for copySets. The file
> defines: (a) `confirmNoDuplicates(elements, fullCompare?, reject)`
> — the private predicate that builds a fullOrder antiComparator
> (with the explicit *this fullOrder contains history dependent
> state ... does not survive the call* discipline), sorts elements,
> and scans adjacent for equal elements rejecting duplicates;
> (b) `assertNoDuplicates(elements, fullCompare?)` — the public
> throw-form; (c) `confirmElements(elements, reject)` — the
> three-layer copySet-payload predicate (is-copyArray + is-reverse-
> rank-sorted + no-duplicates); (d) `assertElements(elements)` —
> the public throw-form with `hideAndHardenFunction` so `.name`
> doesn't leak; (e) `coerceToElements(elementsList)` — sorts an
> iterable into reverse-rank order, validates, returns elements;
> (f) `makeSetOfElements(elementIter)` — produces a passable
> `tagged: 'copySet'` value via `makeTagged`. The canonical
> *copySet internal form* invariant: `tagged: 'copySet'` whose
> payload is a `copyArray` rank-sorted in *reverse* order
> (`compareAntiRank`) with no duplicates. Two TODOs in the file
> name future-work with explicit rationale: *`&&=` once all
> tooling ready* and *memoize no-duplicate finding independent of
> fullOrder use*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [element-validation-and-canonical-internal-form](../sections/endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form.md) | hardened-javascript, patterns | current |

The 109-line file is honestly one cohesive argument-cluster — *one validation + factory surface* with shared idioms (history-dependent-state-call-local, reverse-rank-sorted invariant, Rejector dual-mode). Single-section ingest preserves the unified structure.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f289ff8484094b785b11636b8bc71d87e` via the local bare-clone.
- Last touched 2025-10-09 by Kris Kowal. Same author + same commit as cycle 108's `exo-makers.js`; both files belong to the `@endo/patterns` and `@endo/exo` packages' coordinated update.
- Verified file existence and structure via the local bare-clone: 109 lines / 39 comment lines (~36% comment density).
- **Seventeenth comment-fragment ingest**. The chosen file *pairs structurally* with cycle 102's `checkKey.js` (which imports `confirmElements` + `makeSetOfElements` from this file) and cycle 104's `compareKeys.js` (which uses CopySet comparison indirectly).
- Cycle 110 pivoted from papers-lane (seventh consecutive papers-lane block — cycles 97 / 100 / 102 / 104 / 106 / 108 / 110) to comments-lane.
- Single-section cohesion-honest count. The 109-line file is *one validation + factory surface*; forcing a multi-section split would create artificial divisions within a tight unified module.
