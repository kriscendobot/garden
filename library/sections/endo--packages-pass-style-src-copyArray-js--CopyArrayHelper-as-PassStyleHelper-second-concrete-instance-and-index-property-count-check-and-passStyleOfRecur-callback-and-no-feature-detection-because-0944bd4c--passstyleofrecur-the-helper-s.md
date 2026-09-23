---
title: §passStyleOfRecur — the helper's interaction with the marshal core
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

Line 30-32:
```js
for (let i = 0; i < len; i += 1) {
  passStyleOfRecur(
    confirmOwnDataDescriptor(candidate, i, true, Fail).value,
  );
}
```

§The-`passStyleOfRecur`-callback is the helper's hook back into the marshal core's recursion. §The-helper-validates-this-level + §the-core-handles-the-recursion-by-asking-the-right-helper-for-each-child. §inversion-of-control between helper and core; §the-helper-doesn't-know-which-helper-validates-its-children + §it-delegates-via-the-callback.

§First-explicit-observation in library: **§passStyleOfRecur-as-named-callback-for-helper-to-core-recursion-on-each-child-value** — §the-helpers-cluster's-protocol-for-recursive-validation; §the-callback-name-`Recur`-suffix-IS-the-canonical-naming-for-helper-to-core-callbacks; §sibling-pattern to byteArray's `_passStyleOfRecur` ignored parameter (byteArray has no children to walk; copyArray does).

§The-byteArray-helper-takes-the-callback-but-doesn't-use-it (`_passStyleOfRecur` with leading underscore-via-ESLint-disable). §The-copyArray-helper-takes-the-callback-and-uses-it-per-index. §the-API-IS-symmetric-because-the-marshal-core-treats-all-helpers-uniformly; §helpers-that-don't-need-recursion-receive-the-callback-anyway. §uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments; §first-explicit-observation in library.
