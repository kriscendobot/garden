---
title: §The destructure-then-rest-then-count-zero pattern — first cycle in library
source-slug: endo--packages-pass-style-src-tagged-js
section-slug: TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/tagged.js
source-author: Endo project (collective)
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-tagged-js--TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
---

Lines 27-41 carry a structurally novel side-channel-strip pattern:

```js
assertRestValid: (candidate, passStyleOfRecur) => {
  confirmTagRecord(candidate, 'tagged', Fail);

  // Typecasts needed due to https://github.com/microsoft/TypeScript/issues/1863
  const passStyleKey = /** @type {unknown} */ (PASS_STYLE);
  const tagKey = /** @type {unknown} */ (Symbol.toStringTag);
  const {
    // confirmTagRecord already verified PASS_STYLE and Symbol.toStringTag own data properties.
    [/** @type {string} */ (passStyleKey)]: _passStyleDesc,
    [/** @type {string} */ (tagKey)]: _labelDesc,
    payload: _payloadDesc, // value checked by recursive walk at the end
    ...restDescs
  } = getOwnPropertyDescriptors(candidate);
  ownKeys(restDescs).length === 0 ||
    Fail`Unexpected properties on tagged record ${ownKeys(restDescs)}`;
  ...
};
```

§First-explicit-observation in library: **§the-destructure-then-rest-then-count-zero-pattern — §a-side-channel-strip-pattern-that-(1) enumerates-all-own-descriptors-at-once-via-`getOwnPropertyDescriptors` + (2) destructures-out-the-three-known-keys (PASS_STYLE + Symbol.toStringTag + payload) + (3) collects-everything-else-into-`...restDescs` + (4) asserts-`restDescs`-has-zero-keys**.

§The-pattern-IS-structurally-different-from-cycle-264's-`ownKeys(candidate).length === len + 1`-arithmetic — §here-the-arithmetic-IS-zero-but-the-zero-applies-to-`restDescs`-not-to-`ownKeys(candidate)`; §the-destructuring-discharges-the-three-known-keys + §the-zero-applies-to-the-leftover.

§Three-cycles-with-own-keys-side-channel-strip-with-pass-style-specific-arithmetic-or-shape:
- **byteArray** (cycle 260) — `ownKeys.length === 0` (no own keys at all).
- **copyArray** (cycle 262) — `ownKeys.length === len + 1` (length + indices).
- **copyRecord** (cycle 264) — no count check; per-key-and-per-value rules.
- **tagged** (cycle 268) — destructure-out-three-known-then-`restDescs.length === 0`.

§Four-cycles-with-pass-style-specific-side-channel-defense-takes-four-forms:
1. **count-zero** (byteArray).
2. **count-equal-to-len-plus-1** (copyArray).
3. **per-key-and-per-value-rules** (copyRecord).
4. **destructure-then-rest-then-count-zero** (tagged).

§First-explicit-observation in library: **§the-side-channel-defense-takes-four-forms-across-the-quartet — §the-cycle-264-pedagogy-extends-with-a-fourth-form: §destructure-then-rest-then-count-zero**.
