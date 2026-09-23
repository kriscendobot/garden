---
title: Abstract
source: packages/patterns/src/keys/compareKeys.js
source_repo: endojs/endo
source_branch: master
source_commit: c63b8b709ecb25a32469f5eae1003a719c7f3608
source_date: 2026-03-26
source_authors: [Turadg Aleahmad]
source_lines: "1-265 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Fourteenth comment-fragment ingest. Sister file to cycle 102's
  checkKey.js (same author, same package, same shared idioms).
  Where checkKey.js defines the *Confirm/Is/Assert trio* validation
  pattern, this file defines the *partial-order comparison* surface
  for keys + collections. Four structurally interesting moves:
  (1) the *partial-order vs total-order* distinction — keys form a
  *partial order* (some pairs are incommensurate, signaled by `NaN`)
  unlike rank order which is a *total order* (every pair has a
  defined comparison); (2) the *Pareto-partial-order* algorithm for
  copyRecord comparison — same property set required; element-wise
  comparison must all-go-the-same-direction-or-be-equal else NaN;
  (3) the *ABSENT Symbol sentinel* unused-but-preserved scaffolding
  for the future copyMap-comparison decision, with a TODO that
  *names the cross-reference* (endo PR #1737 review thread); (4) the
  *number NaN special case* — NaN === NaN compares as 0 in this
  module (NaN is equal to itself) but NaN vs any non-NaN number
  returns NaN (incommensurate). Single-section cohesion-honest ingest
  (like cycle 103) — the 264-line file is *one comparison surface*
  with specialized handling per passStyle, plus the five-predicate
  wrapper suite.
parent: endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order
---

The §file opens (lines 1-20) by importing `harden`, `passStyleOf`/`getTag`/`compareNumerics`/`compareRank`/`recordNames`/`recordValues` from `@endo/marshal`, `q`+`Fail` from `@endo/errors`, and sibling `assertKey`/`getCopyBagEntries`/`getCopyMapEntryArray`/`getCopySetKeys` from `./checkKey.js`, plus `makeCompareCollection` from `./keycollection-operators.js`. The §setCompare (lines 22-42) defines partial-order set comparison via `makeCompareCollection` parameterized by (a) a function `collection → Array<[Key, 1]>` that maps a CopySet to *[key, count=1]* entries, (b) the default value `0` (count for absent keys), and (c) `compareNumerics` as the value-comparator. The §JSDoc names the two-condition definition: *CopySet X is smaller than Y iff all x in X are in Y AND there exists y in Y not in X*. The §bagCompare (lines 44-59) mirrors setCompare but uses bigint counts and the condition *for every x in X, x is also in Y and count(X,x) <= count(Y,x); there is a y in Y such that y is not in X or count(X,y) < count(Y,y)*. The §unused-but-preserved `_mapCompare` (lines 61-104) introduces the `ABSENT` Symbol sentinel (*a unique local value that is guaranteed to not exist in any inbound data structure (which would not be the case if we used `Symbol.for`)*) and recursively-calls `compareKeys` on values, with `ABSENT` handled as *smaller than everything* — but the §TODO names the *undecided CopyMap-comparison semantics* with a cross-reference to the *endojs/endo#1737* pull-request review thread. The §compareKeys main function (lines 106-249) dispatches on passStyle: atomic types reuse `compareRank` (key order matches rank order for these); number is NaN-special-cased; remotable comparison is identity-only with non-identical remotables returning NaN; copyArray is lexicographic with *prefix-shorter-is-smaller* rule (`compareRank(left.length, right.length)` when all matching elements are equal); copyRecord uses *Pareto partial order* (different property sets → NaN; same property sets compare element-wise with mixed-direction detection returning NaN); tagged dispatches to setCompare/bagCompare/(unimplemented copyMap throw); the *unexpected-passStyle-throws* default matches checkKey.js's discipline. The §five-comparator predicate suite (lines 251-264) wraps compareKeys with `< 0` / `<= 0` / `=== 0` / `>= 0` / `> 0` for `keyLT`/`keyLTE`/`keyEQ`/`keyGTE`/`keyGT` partial-order queries.
