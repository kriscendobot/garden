---
title: §copyArray.js — §the-length-vs-ownKeys-check
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

```js
// Expect one key per index plus one for 'length'.
ownKeys(candidate).length === len + 1 ||
  assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
```

§Defensive-shape: an array with N indices has §exactly-N+1-own-keys (N indices + the special `length` key). §Any-extra-own-keys (e.g., `[]; arr.foo = 'bar'`) §violates-the-pass-style + §rejected-with-named-error.

§Borrowable-pattern: §invariant-on-own-keys-count + §reject-deviations. §The-array-has-no-non-index-properties is the §invariant-encoded-as-count-check.
