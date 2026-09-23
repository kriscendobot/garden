---
title: §Three-line validity check as the assertRestValid body
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
---

Lines 57–67 define the helper's `assertRestValid` field (called by the `passStyleOf` core after `confirmCanBeValid` has returned true):

```js
assertRestValid: (candidate, _passStyleOfRecur) => {
  getPrototypeOf(candidate) === immutableArrayBufferPrototype ||
    assert.fail(X`Malformed ByteArray ${candidate}`, TypeError);
  apply(immutableGetter, candidate, []) ||
    Fail`Must be an immutable ArrayBuffer: ${candidate}`;
  ownKeys(candidate).length === 0 ||
    assert.fail(
      X`ByteArrays must not have own properties: ${candidate}`,
      TypeError,
    );
},
```

§Three-line-check-with-three-orthogonal-rejection-criteria:

1. **§Prototype-identity check** — `getPrototypeOf(candidate) === immutableArrayBufferPrototype` rejects anything that doesn't directly inherit from the canonical prototype. *Why direct identity, not `instanceof`?* — §a-malicious-subclass-of-ImmutableArrayBuffer-would-pass-instanceof-but-fail-strict-equality; §a-malicious-host-could-substitute-an-evil-toString-via-prototype-pollution-on-a-deeper-chain-link.
2. **§Immutability check** — `apply(immutableGetter, candidate, [])` calls the captured `.immutable` getter with `candidate` as `this`. *Why `Reflect.apply` not `candidate.immutable`?* — §defensive-binding-against-property-shadowing; §a-malicious-object-could-shadow-`.immutable`-with-its-own-true-getter; §reading-the-property-via-a-pre-captured-getter-function-bypasses-the-instance's-own-prototype-chain. Sibling pattern to cycle 235's base64 Reflect.apply defensive binding and cycle 245's panic Reflect-defensive-getter-call.
3. **§Own-keys check** — `ownKeys(candidate).length === 0` rejects ArrayBuffers with own properties. *Why?* — §ByteArrays-must-be-canonical-bag-of-bytes-with-no-attached-metadata; §a-host-could-attach-a-hidden-credential-as-an-own-property-and-have-it-flow-through-a-marshal-channel-as-a-side-channel; §strip-the-side-channel-by-rejecting-any-own-property.

§Each-line-uses-the-`predicate-OR-fail`-idiom — §short-circuit-evaluation-as-conditional-assert; §when-predicate-true-the-or-is-not-evaluated + §when-predicate-false-the-or-fires-the-fail; §the-idiom-is-tighter-than-an-if-statement.

§Two-error-API-styles-in-one-helper: §`assert.fail(X\`...\`, TypeError)` is used for the structural rejections (prototype mismatch, own keys present); §`Fail\`...\`` is used for the semantic rejection (immutable check). §**Why the asymmetry?** — §assert.fail-takes-a-constructor-argument-so-you-can-choose-the-error-class (TypeError signals "wrong shape"); §Fail-always-throws-a-plain-Error-but-is-more-ergonomic. §the-style-asymmetry-encodes-the-distinction (TypeError = structural; Error = semantic).

§First-explicit-observation in library: **§three-line-validity-check-with-three-orthogonal-rejection-criteria-each-with-the-predicate-OR-fail-idiom**.
