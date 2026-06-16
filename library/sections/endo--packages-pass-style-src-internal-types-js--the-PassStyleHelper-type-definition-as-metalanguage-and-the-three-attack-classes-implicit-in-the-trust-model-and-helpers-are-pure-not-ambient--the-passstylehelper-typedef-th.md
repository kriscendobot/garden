---
title: §The PassStyleHelper typedef — three properties define the protocol
source-slug: endo--packages-pass-style-src-internal-types-js
section-slug: the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
source-repo: endojs/endo
source-path: packages/pass-style/src/internal-types.js
source-author: Endo project (collective)
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
---

Lines 19-30:
```js
/**
 * @typedef {object} PassStyleHelper
 * @property {PassStyle} styleName
 * @property {(candidate: any, reject: Rejector) => boolean} confirmCanBeValid
 * If `confirmCanBeValid` returns true, then the candidate would
 * definitely not be valid for any of the other helpers.
 * `assertRestValid` still needs to be called to determine if it
 * actually is valid, but only after the `confirmCanBeValid` check has passed.
 *
 * @property {(candidate: any,
 *             passStyleOfRecur: (val: any) => PassStyle
 *            ) => void} assertRestValid
 */
```

§Three-properties-define-the-PassStyleHelper-protocol:

### §styleName: PassStyle
The pass-style tag — `'byteArray'` for `ByteArrayHelper`, `'copyArray'` for `CopyArrayHelper`, `'copyRecord'` for `CopyRecordHelper`. §the-typedef-uses-the-narrowed-`PassStyle`-string-literal-union-not-`string` — §typing-the-tag-as-an-enumeration-not-a-string + §the-type-system-catches-typos-at-the-helper-declaration-site.

### §confirmCanBeValid: (candidate, reject) => boolean
The phase-1 loose check. §The-doc-property-description carries a §mutual-exclusivity-property:

> *If `confirmCanBeValid` returns true, then the candidate would definitely not be valid for any of the other helpers. `assertRestValid` still needs to be called to determine if it actually is valid, but only after the `confirmCanBeValid` check has passed.*

§First-explicit-observation in library: **§the-mutual-exclusivity-property-named-explicitly-in-the-PassStyleHelper-type-definition — §when-one-helper's-`confirmCanBeValid`-returns-true, §no-other-helper's-`confirmCanBeValid`-would-also-return-true**.

§The-property-IS-a-protocol-invariant + §it-IS-not-enforced-by-the-type-system + §it-IS-enforced-by-the-helpers'-implementations + §the-typedef-DOCUMENTS-the-invariant.

§The-relationship-between-`confirmCanBeValid`-and-`assertRestValid` is §a-two-phase-progressive-tightening (cycle 260's named pattern) — §the-phase-1-narrows-to-the-right-helper + §the-phase-2-validates-that-helper's-specific-rules; §the-typedef-DOCUMENTS-the-phase-1-IS-mutually-exclusive-across-the-cluster-but-not-sufficient-on-its-own.

### §assertRestValid: (candidate, passStyleOfRecur) => void
The phase-2 thorough check. §Returns-void-but-throws-on-failure — §the-`void`-return-type-IS-the-conventional-encoding-of-"throws-or-completes"; §sibling-pattern to many `assert`-style APIs.

§The-`passStyleOfRecur`-parameter — §the-callback-into-the-marshal-core; §the-type-IS-`(val: any) => PassStyle`; §the-core-knows-how-to-walk-children-and-tell-the-helper-the-child's-pass-style.

§The-three-fields-IS-the-cluster's-protocol-contract-as-a-three-tuple — §`(styleName, confirmCanBeValid, assertRestValid)`; §each-concrete-helper-supplies-all-three; §sibling-pattern to functional-language records or Haskell typeclass instances.
