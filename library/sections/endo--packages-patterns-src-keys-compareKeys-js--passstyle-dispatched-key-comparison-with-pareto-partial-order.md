---
title: The §setCompare and §bagCompare collection-comparison surfaces built via `makeCompareCollection(getEntries, defaultValue, compareValues)` from `keycollection-operators.js` — set-compare uses count `1` constant + `compareNumerics`; bag-compare uses bigint count + `compareNumerics`; the §unused-but-preserved `_mapCompare` with the `ABSENT` Symbol sentinel (*not passable, exists only at the JS level*) for *absent-entries-treated-as-present-with-a-value-smaller-than-everything* semantics — paired with a TODO citing `endojs/endo#1737` review thread for the undecided CopyMap-comparison semantics; the §compareKeys main function with passStyle-dispatched comparison: atomic types (undefined/null/boolean/bigint/string/byteArray/symbol) reuse `compareRank` since key order matches rank order; number is special-cased for NaN (NaN equal to itself, incommensurate with everything else, returns NaN); remotable comparison is identity-only (different remotables are *incommensurate as keys* returning NaN); copyArray is lexicographic with prefix-shorter-is-smaller rule; copyRecord uses *Pareto partial order* comparison (different property sets → NaN; same property sets compare element-wise with mixed-direction detection returning NaN); tagged dispatches into setCompare/bagCompare/(unimplemented copyMap throw); the *unexpected-passStyle-throws* discipline matches checkKey.js's; the §five-comparator predicate suite `keyLT`/`keyLTE`/`keyEQ`/`keyGTE`/`keyGT` that wraps compareKeys with `< 0` / `<= 0` / `=== 0` / `>= 0` / `> 0` for boolean partial-order queries
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--abstract.md)
- [Body](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--body.md)
- [Connection to the wider library](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--see-also.md)
- [Common confusions](endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order--common-confusions.md)
