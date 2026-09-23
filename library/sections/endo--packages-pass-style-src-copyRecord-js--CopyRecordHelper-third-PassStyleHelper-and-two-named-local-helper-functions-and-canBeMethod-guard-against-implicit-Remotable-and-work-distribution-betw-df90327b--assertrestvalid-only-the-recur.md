---
title: §assertRestValid — only the recursive walk
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

Lines 61-69:
```js
assertRestValid: (candidate, passStyleOfRecur) => {
  // Validate that each own property has a recursively passable associated
  // value (we already know from confirmCanBeValid that the other constraints are
  // satisfied).
  for (const name of ownKeys(candidate)) {
    const { value } = confirmOwnDataDescriptor(candidate, name, true, Fail);
    passStyleOfRecur(value);
  }
},
```

§Phase-2-does-only-the-recursive-walk — §the-other-rejection-criteria-were-already-applied-in-phase-1; §the-comment-documents-this. §the-work-distribution-between-phases-varies-per-helper.

§For-of-loop-here — copyArray uses indexed-for; copyRecord uses for-of over ownKeys; §the-iteration-shape-suits-the-validation; §each-name-is-validated-as-`confirmOwnDataDescriptor(_, name, true, Fail)` (the `true` says enumerableRequired); §sibling-pattern to copyArray's index validation.

§The-record's-recursive-walk-is-simpler-than-copyArray's because §no-index-count-check + §no-length-check + §only-the-per-property-recursion-matters.
