---
title: Abstract
source: packages/patterns/src/keys/copySet.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-109 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Seventeenth comment-fragment ingest. Kris Kowal-authored
  *copySet element-validation* file — the sibling that cycle 102's
  checkKey.js imports `confirmElements` and `makeSetOfElements`
  from. The 109-line file is the *internal-form-validation* and
  *factory* surface for copySets. Three structurally interesting
  moves: (1) the *history-dependent-state-call-local* discipline
  for the fullOrder antiComparator (built fresh per `confirmNo-
  Duplicates` call when no explicit comparator is provided; the
  comment repeats the discipline introduced in cycle 102's
  `makeCopyBagFromElements`); (2) the *reverse-rank-sorted invariant*
  for copySet keys — `compareAntiRank` not `compareRank`, consistent
  with cycle 84's rankOrder.js and cycle 102's makeCopyBagFromElements
  + makeCopyMap; (3) the *honest-known-perf-limit-with-named-mitigation*
  TODO at the top — *If doing this redundantly turns out to be
  expensive, we could memoize this no-duplicate finding as well,
  independent of the `fullOrder` use to reach this finding*.
  
  Pairs structurally with cycle 102's checkKey.js (which uses this
  file's exports to validate CopySet payloads) and cycle 104's
  compareKeys.js (which uses this file's `getCopySetKeys` indirectly
  via setCompare). Single-section cohesion-honest ingest.
parent: endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form
---

The §file opens (lines 1-19) with imports of `harden` and `Fail`/`hideAndHardenFunction` from `@endo/errors`, plus `makeTagged`/`passStyleOf`/`compareAntiRank`/`isRankSorted`/`makeFullOrderComparatorKit`/`sortByRank` from `@endo/marshal`. The §`confirmNoDuplicates(elements, fullCompare?, reject)` private predicate (lines 35-52) is the centerpiece: it builds a fullOrder antiComparator (via `makeFullOrderComparatorKit().antiComparator`) if no explicit `fullCompare` was provided, with the explicit comment naming the *history-dependent-state-call-local* discipline — *This fullOrder contains history dependent state. It is specific to this one call and does not survive it*; sorts elements by rank; scans adjacent pairs for equal elements (`fullCompare(k0, k1) === 0`); rejects duplicates via `reject\`value has duplicate keys: ${k0}\``. The §TODO at the top of this function names a future optimization: *If doing this redundantly turns out to be expensive, we could memoize this no-duplicate finding as well, independent of the `fullOrder` use to reach this finding*. The §`assertNoDuplicates(elements, fullCompare?)` (lines 60-62) is the public throw-form via `confirmNoDuplicates(..., Fail)`. The §`confirmElements(elements, reject)` (lines 69-83) is the three-layer copySet-payload predicate: (1) `passStyleOf(elements) === 'copyArray'` (else *The keys of a copySet or copyMap must be a copyArray*); (2) `isRankSorted(elements, compareAntiRank)` reverse-rank-order required (else *must be sorted in reverse rank order*); (3) delegates to `confirmNoDuplicates(elements, undefined, reject)` for the duplicate-free check. The §`assertElements(elements)` (lines 86-89) is the public throw-form via `confirmElements(..., Fail)` *plus* `hideAndHardenFunction(assertElements)` so `.name` doesn't leak. The §`coerceToElements(elementsList)` (lines 95-100) is the public factory that takes an iterable, `sortByRank(elementsList, compareAntiRank)` into reverse-rank order, validates via `assertElements`, returns the elements array. The §`makeSetOfElements(elementIter)` (lines 107-109) is the public factory that wraps `coerceToElements` with `makeTagged('copySet', ...)` to produce a passable `CopySet` value.
