---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate.
- [[patterns]] (topic) — the @endo/patterns key/CopyTagged surface.
- `endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion` (cycle 102) — sister file: the *Confirm/Is/Assert trio* validation pattern this file's `assertKey` import comes from.
- `endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms` (cycle 102) — sister file: the CopySet/CopyBag/CopyMap *getEntries* functions this file's collection-compare factories consume.
- `endo--packages-marshal-src-rankorder-js--*` (cycle 84) — provides `compareRank`, `compareNumerics`, `makeFullOrderComparatorKit`; this file's atomic-types branches reuse `compareRank` directly.
- `endo--packages-marshal-src-encodepassable-js--*` (cycle 81) — the rank-order-preserving encoder; consistent with this file's key-order-is-a-refinement-of-rank-order invariant.
- `endo--packages-pass-style-src-passstyleof-js--*` (cycle 71) — the source of `passStyleOf` dispatched on here.
