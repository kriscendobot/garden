---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `Different passStyles are incommensurate` | The *partial-order signaled by NaN* discipline; incommensurate pairs return NaN, not 0. |
| `NaN is equal to itself, but incommensurate with everything else` | The *key-semantics-NaN-self-equal* special-case; key semantics deviates from IEEE-754 self-inequality. |
| `If two remotables are not identical, then as keys they are incommensurate` | The *remotables-are-opaque-except-by-identity* discipline. |
| `Lexicographic by key order. Rank order of arrays is lexicographic by rank order` | The *element-wise-extends-to-aggregate* invariant for arrays. |
| `If array X is a prefix of array Y, then X is smaller than Y` | The *prefix-is-smaller* lexicographic rule. |
| `Pareto partial order comparison` | The *vector-typed-comparison-with-mixed-direction-detection* algorithm. |
| `If they do not have exactly the same properties, they are incommensurate` | The *same-shape-required-for-comparison* discipline. |
| `If copyRecord X is smaller than copyRecord Y ... compareKeys(X,Y) < 0 then compareRank(X,Y) < 0` | The *key-order-is-a-refinement-of-rank-order* invariant. |
| `A unique local value that is guaranteed to not exist in any inbound data structure` (ABSENT) | The *Symbol-not-Symbol.for* private-sentinel discipline. |
| `ABSENT is not passable, and so only exists at the JS level of abstraction, not pass-style` | The *JS-level-vs-pass-style-level* distinction; sentinels live at JS level. |
| `TODO ... See https://github.com/endojs/endo/pull/1737#pullrequestreview-1596595411` | The *named-dependency-in-todo* + URL-cross-reference shape. |
| Five-comparator suite (`keyLT`/`keyLTE`/`keyEQ`/`keyGTE`/`keyGT`) | The *boolean-predicate-wrappers-around-partial-order* idiom; all five return false for incommensurate pairs. |
