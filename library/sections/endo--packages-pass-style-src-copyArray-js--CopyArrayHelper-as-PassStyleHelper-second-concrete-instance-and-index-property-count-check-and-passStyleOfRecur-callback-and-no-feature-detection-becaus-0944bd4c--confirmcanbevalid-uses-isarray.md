---
title: §confirmCanBeValid uses isArray as the loose phase-1 check
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Line 16-17:
```js
confirmCanBeValid: (candidate, reject) =>
  isArray(candidate) || (reject && reject`Array expected: ${candidate}`),
```

§Phase-1-loose-check uses `Array.isArray` not `instanceof Array`:

- §`Array.isArray`-IS-the-canonical-realm-aware-array-test — works across cross-realm boundaries (a TypedArray from another realm passes `isArray` but fails `instanceof Array`); §sibling-pattern to cycle 142's pass-style realm-aware checks.
- §the-helper-uses-`isArray`-not-`instanceof`-at-phase-1 — §loose-shape-question-uses-realm-aware-API-not-instance-walking; §the-phase-1-question-is-"is-this-an-array-at-all?".
- §the-phase-2-question-asks-something-tighter (whether the prototype is the realm's `Array.prototype` exactly).

§Two-cycles-with-phase-1-uses-realm-aware-platform-test (260 instanceof-ArrayBuffer-loose + 262 isArray-realm-aware) — §each-helper-picks-the-right-realm-aware-shape-test-for-its-substrate; §sibling-pattern that emerges from the §two-helpers-side-by-side.

§The-`reject &&`-short-circuit on line 17 — same as byteArray's line 55; §the-reject-callback-pattern-from-the-helpers-cluster.
