---
title: §The index-property-count check — single line rejects two attack classes
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

Line 35-36:
```js
ownKeys(candidate).length === len + 1 ||
  assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
```

§A-single-line-structural-completeness-check rejects:

- **§Sparse arrays** — if `len = 5` but the array has indices `[0, 1, 3, 4]` (skipping 2), `ownKeys` would be `['0', '1', '3', '4', 'length']` = 5, but `len + 1 = 6`; the equality fails. §sparse-array-rejection-at-marshal-boundary; §when-a-passable-array-has-a-missing-index-the-receiver-cannot-tell-what-was-there-from-just-the-encoding; §strict-density-is-a-protocol-invariant.
- **§Arrays-with-extra-own-properties** — if someone attached `arr.secret = 'leaked'`, `ownKeys` would include `'secret'`; the equality fails. §side-channel-strip — §an-attacker-could-attach-a-hidden-credential-as-a-non-index-own-property-and-have-it-flow-through-marshal-as-a-side-channel; §sibling-pattern to byteArray's `ownKeys(candidate).length === 0` defense; §the-discipline-IS-the-same-across-both-helpers-but-with-different-arithmetic-because-the-structures-differ.

§Two-cycles-with-ownKeys-length-check-as-side-channel-strip (260 byteArray-no-own-keys + 262 copyArray-exactly-len+1-own-keys); §the-discipline-IS-canonical-for-passable-leaf-validation; §first-explicit-observation in library.

§the-`len + 1`-arithmetic — §the-`+1`-IS-the-length-property; §the-arithmetic-IS-the-invariant; §named-arithmetic-in-the-comment-as-self-documentation (*"Expect one key per index plus one for 'length'"*).
