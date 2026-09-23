---
title: Common confusions
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

- **"`confirmNoDuplicates` should accept `false` for fullCompare to skip sorting."** It cannot — *no fullCompare means build a fresh fullOrder antiComparator*. The §discipline: sort-then-adjacent-scan is the duplicate-detection algorithm; without sort, adjacent scan misses non-adjacent duplicates. The fullCompare parameter lets a caller *reuse a comparator* across calls; passing `false` would skip the sort entirely, breaking the algorithm.
- **"`compareAntiRank` is just `compareRank` reversed — why have both?"** They're *both used* in different contexts. Rank order is the *default*; anti-rank order positions tied keys adjacently for scan-based algorithms. The two coexist so callers can pick based on the consumer's needs.
- **"`assertNoDuplicates` is private — why is it exported?"** It is exported (line 60) but not commonly called by users. It's a *narrow primitive* for code that has already-sorted elements and just needs the duplicate check. The §discipline: *expose the narrow primitive for advanced consumers*; the canonical path is `coerceToElements + makeSetOfElements`.
- **"`makeTagged('copySet', ...)` is just a wrapper — why have a factory?"** The factory ensures the *internal form invariant* (sorted, no duplicates, all keys). A user constructing `makeTagged('copySet', [...])` directly might produce a malformed copySet. The factory is the *blessed* construction path.
- **"`confirmElements` is also used for copyMap — that's coupling."** The §discipline names this explicitly: *The keys of a copySet or copyMap must be a copyArray*. Both collections share the same key-array discipline; consolidating the validation prevents drift. The §error message *…of a copySet or copyMap* makes the shared use visible.
- **"The `&&=` TODO is just style preference."** It is — and the §discipline waits for *all tooling ready*. The TODO documents *when to apply* (tooling readiness) so a future maintainer doesn't apply it prematurely on environments that lack support.
- **"`coerceToElements` could just call `confirmElements`."** It cannot — `confirmElements` requires *already-sorted* input. `coerceToElements` *sorts first, then validates*. The two functions handle different input shapes: pre-sorted (confirmElements) vs unsorted iterable (coerceToElements).
- **"`fullCompare(k0, k1) === 0` for duplicate detection — what if the comparator returns `-0`?"** JavaScript's `===` treats `-0 === 0` as `true`, so the check works. The §implementation accepts either `+0` or `-0` from the comparator as the equal-signal.
- **"`elements = sortByRank(elements, fullCompare)` mutates the input array."** It doesn't — `sortByRank` returns a *new* sorted array; the local `elements` parameter binding is reassigned to the new array. The caller's array is unchanged.
- **"`makeFullOrderComparatorKit().antiComparator` creates allocations per call — that's wasteful."** It is — and §intentionally accepted. The §`fullCompare` parameter lets callers pass an externally-managed comparator to amortize the cost. The default path (no fullCompare) prioritizes *correctness via call-local state* over *allocation cost*.
