---
title: §The-canonical-JSON-discipline
source-slug: endo--packages-marshal-src-encodeToCapData
section-id: QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
---

> Must encode `val` into plain JSON data *canonically*, such that `JSON.stringify(encode(v1)) === JSON.stringify(encode(v1))`.

§The-load-bearing-architectural-property of CapData encoding. §Canonical-encoding-means: §the-same-input-always-produces-the-same-output-bytes. §This-matters-because: §`JSON.stringify(encode(v1)) === JSON.stringify(encode(v2))` must hold when v1 and v2 are equivalent.

The §honest-disclosure-about-non-determinism-mitigation:

> Readers must not care about this order anyway. We impose this requirement mainly to reduce non-determinism exposed outside a vat.

§Borrowable-pattern: §reduce-non-determinism-exposed-outside-the-vat by §making-encoding-canonical + §but-don't-require-readers-to-rely-on-the-order.

### §The-load-bearing-mechanism: §sort-copyRecord-property-names

```js
case 'copyRecord': {
  // ...
  const names = ownKeys(passable).sort();
  return fromEntries(
    names.map(name => [name, encodeToCapDataRecur(passable[name])]),
  );
}
```

§The-only-case-where-order-is-not-implicit-in-the-code is copyRecord (where the natural enumeration order can differ between equivalent records). §sort()-the-property-names + §encode-in-sorted-order — §canonical-JSON-via-sorted-keys.

The §TODO-noting-could-use-canonical-JSON-encoder-for-modular-encapsulation:

> Encoding with a canonical-JSON encoder would also solve this canonicalness problem in a more modular and encapsulated manner. [...] TODO perhaps we should indeed switch to a canonical JSON encoder, and not delicately depend on the order in which these object literals are written.

§Borrowable-pattern: §the-design-acknowledges-its-fragility + §names-the-alternative-architecture-that-would-fix-it + §carries-the-TODO. §The-other-record-properties-are-visited-in-the-order-in-which-they-are-literally-written; §that-IS-the-fragility.

§Sibling to cycle 229 marshal-justin's §TODO-to-fold-back-to-one-validating-pass — both designs §carry-a-TODO-naming-a-better-architecture.
