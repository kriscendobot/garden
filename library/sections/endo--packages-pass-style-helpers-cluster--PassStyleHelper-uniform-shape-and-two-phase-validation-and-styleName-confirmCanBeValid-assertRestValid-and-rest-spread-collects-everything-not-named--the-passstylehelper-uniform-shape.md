---
title: §The-`PassStyleHelper`-uniform-shape
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
---

Four of the seven files (byteArray + copyArray + copyRecord + tagged) export a `PassStyleHelper`-typed object with the same three-field shape:

```js
export const XxxHelper = harden({
  styleName: '...',
  confirmCanBeValid: (candidate, reject) => ...,
  assertRestValid: (candidate, passStyleOfRecur) => ...,
});
```

§Three-uniform-fields-per-helper:
1. **§styleName** — string literal identifying the pass-style kind.
2. **§confirmCanBeValid** — cheap structural check (returns boolean or rejects via the Rejector parameter).
3. **§assertRestValid** — deep validation (called only after confirmCanBeValid passed; throws on invalid).

§Borrowable-pattern: §uniform-shape-with-pluggable-fields across a cluster of files. §The-dispatcher (passStyleOf, cycle 71) dispatches on `styleName` + §calls-both-methods-in-sequence (confirmCanBeValid first; if true, then assertRestValid).

§Sibling to cycle 226 endoclaw cluster's §two-facet-control-pair canonical shape — both designs §uniform-shape-across-cluster-members.
