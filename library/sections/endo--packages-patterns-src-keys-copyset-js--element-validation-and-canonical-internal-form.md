---
title: The §`confirmNoDuplicates(elements, fullCompare?, reject)` private predicate that builds a fullOrder antiComparator (with the explicit *this fullOrder contains history dependent state ... does not survive the call* discipline) when no explicit comparator is provided, sorts elements by rank, and scans adjacent for equal elements rejecting any duplicate; the §TODO that names the *memoize-no-duplicate-finding* future optimization with explicit *independent of the `fullOrder` use to reach this finding* gloss; the §`assertNoDuplicates(elements, fullCompare?)` public throw-form via `confirmNoDuplicates(..., Fail)`; the §`confirmElements(elements, reject)` three-layer predicate — (1) `passStyleOf(elements) === 'copyArray'` (else *The keys of a copySet or copyMap must be a copyArray*); (2) `isRankSorted(elements, compareAntiRank)` reverse-rank-order required (else *must be sorted in reverse rank order*); (3) delegates to `confirmNoDuplicates(elements, undefined, reject)`; the §`assertElements(elements)` public throw-form *plus* `hideAndHardenFunction(assertElements)` so `.name` doesn't leak; the §`coerceToElements(elementsList)` public factory that takes an iterable, `sortByRank(elementsList, compareAntiRank)` into reverse-rank order, validates via `assertElements`, returns elements; the §`makeSetOfElements(elementIter)` factory that wraps `coerceToElements` with `makeTagged('copySet', ...)` producing a passable CopySet value; the canonical *copySet internal form* invariant — `tagged: 'copySet'` whose payload is a `copyArray` rank-sorted in *reverse* order (`compareAntiRank`) with no duplicates
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--abstract.md)
- [Body](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--body.md)
- [Connection to the wider library](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--see-also.md)
- [Common confusions](endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form--common-confusions.md)
