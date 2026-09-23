---
title: §tagged.js — §rest-spread-collects-everything-not-named (revisit)
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
const {
  [passStyleKey]: _passStyleDesc,
  [tagKey]: _labelDesc,
  payload: _payloadDesc,
  ...restDescs
} = getOwnPropertyDescriptors(candidate);
ownKeys(restDescs).length === 0 ||
  Fail`Unexpected properties on tagged record ${ownKeys(restDescs)}`;
```

§The-rest-spread-collects-everything-not-named idiom (sibling to cycle 217 @endo/errors' rename-utilities-split-from-assertions). §Destructure-the-three-known-properties + §rest-spread-collects-the-unexpected-ones + §reject-if-any-unexpected.

§Borrowable-pattern: §when-an-object-must-have-exactly-N-specific-properties + §no-others, §destructure-the-N-known-ones + §rest-spread-the-rest + §assert-the-rest-is-empty. §The-rest-spread-IS-the-validation-of-no-extra-properties.

§This-is-the-second-use-of-the-pattern in library:
- Cycle 217 @endo/errors: §destructure-with-underscore-prefix-to-deliberately-discard (omits one property).
- Cycle 227 tagged.js: §rest-spread-collects-the-unexpected + §assert-rest-is-empty.

§Two-different-purposes-for-the-same-mechanism: cycle 217 omits known property; cycle 227 detects unknown properties.
