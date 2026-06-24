---
title: Abstract
source: packages/patterns/src/keys/copyBag.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
source_lines: "1-137 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Eighteenth comment-fragment ingest. Kris Kowal-authored
  *copyBag entry-validation* file — *the* sister file to cycle
  110's `copySet.js`. The 136-line file is the canonical
  *internal-form-validation + factory* surface for copyBags. Same
  shape as cycle 110's copySet.js but with two bag-specific
  additions: (1) per-entry-shape validation (each entry is a
  2-element copyArray with bigint count); (2) per-entry-positive-
  count validation (count >= 1n). Three structurally interesting
  moves: (1) the *key-significance-over-value* comment — *Since
  the key is more significant than the value (the count), sorting
  by fullOrder is guaranteed to make duplicate keys adjacent
  independent of their counts* — encodes the fullOrder's
  lexicographic-key-first composite-key behavior on `[key, count]`
  tuples; (2) the *five-layer-confirmBagEntries* (vs cycle 110's
  three-layer confirmElements) — adds per-entry-shape + per-entry-
  positive-count; (3) the *one-discipline-shared-across-
  implementations* pattern repeats — the §history-dependent-state-
  call-local + §reverse-rank-sorted invariant from copySet.js
  appear verbatim here.
  
  Single-section cohesion-honest ingest. Pairs structurally with
  cycle 110's copySet.js (this file is the *bag-analog*; together
  they describe the canonical internal-form for the two CopyTagged
  Key-set collections — CopySet stores keys, CopyBag stores
  [key, count] entries).
parent: endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count
---

The §file opens (lines 1-19) with imports identical to cycle 110's `copySet.js`: `harden`, `Fail`+`hideAndHardenFunction` from `@endo/errors`, plus `makeTagged`/`passStyleOf`/`compareAntiRank`/`isRankSorted`/`makeFullOrderComparatorKit`/`sortByRank` from `@endo/marshal`. The §`confirmNoDuplicateKeys(bagEntries, fullCompare?, reject)` private predicate (lines 35-55) is the centerpiece — sister to cycle 110's `confirmNoDuplicates`: builds a fullOrder antiComparator if not provided (with the canonical *this fullOrder contains history dependent state ... does not survive the call* discipline); sorts entries by rank; scans adjacent for duplicate *keys* by comparing `bagEntries[i-1][0]` and `bagEntries[i][0]`. The §key-significance-over-value comment (lines 42-44): *Since the key is more significant than the value (the count), sorting by fullOrder is guaranteed to make duplicate keys adjacent independent of their counts*. The §`assertNoDuplicateKeys` (lines 63-65) is the public throw-form via `confirmNoDuplicateKeys(..., Fail)`. The §`confirmBagEntries(bagEntries, reject)` (lines 72-105) is the *five-layer* predicate (vs cycle 110's three-layer `confirmElements`): (1) `passStyleOf === 'copyArray'`; (2) `isRankSorted(..., compareAntiRank)` reverse-rank-order required; (3) per-entry-shape — each entry must be a 2-element copyArray with bigint count (`passStyleOf(entry) === 'copyArray' && entry.length === 2 && typeof entry[1] === 'bigint'`); (4) per-entry-positive-count — `entry[1] >= 1` (else *Each entry of a copyBag must have a positive count*); (5) delegates to `confirmNoDuplicateKeys` for the no-duplicate-keys check. The §`assertBagEntries` (lines 113-116) is the public throw-form *plus* `hideAndHardenFunction` so `.name` doesn't leak. The §`coerceToBagEntries(bagEntriesList)` (lines 122-127) is the public factory — sorts iterable into reverse-rank order, validates via `assertBagEntries`, returns the entries array. The §`makeBagOfEntries(bagEntryIter)` (lines 134-136) is the public factory wrapping `coerceToBagEntries` with `makeTagged('copyBag', ...)` to produce a passable `CopyBag` value.
