---
title: §The `every` short-circuits at first rejection
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

Lines 50-59 (the helper's `confirmCanBeValid`):
```js
confirmCanBeValid: (candidate, reject) => {
  return (
    confirmObjectPrototype(candidate, reject) &&
    // Reject any candidate with a symbol-keyed property or method-like property
    // (such input is potentially a Remotable).
    ownKeys(candidate).every(key =>
      confirmPropertyCanBeValid(candidate, key, candidate[key], reject),
    )
  );
},
```

§Phase-1-uses-`.every()`-over-ownKeys to enforce the per-property rules — §the-`.every()`-short-circuits-at-first-rejection + §the-reject-callback-fires-on-the-first-failing-property + §subsequent-properties-not-checked-after-rejection; §this-IS-fail-fast-with-named-property-identification.

§The-comment-on-line-53-explains-the-WHY: *"such input is potentially a Remotable"*. §the-comment-documents-why-we-distinguish-CopyRecord-from-Remotable-here-rather-than-in-RemotableHelper.

§ownKeys-IS-used-twice (in confirmCanBeValid and assertRestValid) — §a-named-redundancy + §the-comment-on-line-63-acknowledges-it (*"we already know from confirmCanBeValid that the other constraints are satisfied"*) — §sibling-pattern to cycle 262's "ensured" comment + cycle 264's reuse-after-confirmation; §three-cycles-with-doc-comment-documenting-defense-in-depth-redundancy (260 + 262 + 264).

§The-helper-DOESN'T-use-`for...of`-like-copyArray — instead uses functional `.every()`. §the-functional-style-suits-the-AND-reduction-shape; §sibling-pattern to copyArray's `for (let i = 0; i < len; i += 1)` loop; §two-cycles-with-different-iteration-styles-for-different-validation-shapes (copyArray uses indexed-for; copyRecord uses ownKeys.every) — §the-iteration-style-matches-the-validation-shape-not-the-substrate.
