---
title: §makeTagged.js (31 lines)
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
import { confirmTagRecord } from './passStyle-helpers.js';

export const makeTagged = (tag, payload) => {
  // ... assertions ...
  return harden({
    [PASS_STYLE]: 'tagged',
    [Symbol.toStringTag]: tag,
    payload,
  });
};
```

§The-tagged-pass-style-constructor — pairs with cycle 227's tagged.js (the validator). §The-constructor-creates-a-valid-tagged-record + §the-validator-checks-it-can-be-trusted.

§Borrowable-pattern: §pair-the-constructor-with-the-validator in adjacent files; §the-constructor-is-the-trusted-path; §the-validator-is-the-untrusted-path.

§Sibling to cycle 136 make-far.js's §three-piece-prefix-handling-discipline — both designs §the-constructor-produces + §the-validator-checks.
