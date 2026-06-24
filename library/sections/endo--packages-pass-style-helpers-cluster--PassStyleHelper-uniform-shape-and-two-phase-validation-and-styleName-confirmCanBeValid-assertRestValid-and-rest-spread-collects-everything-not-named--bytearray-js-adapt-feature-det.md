---
title: §byteArray.js — §adapt-feature-detection for §immutable-ArrayBuffer
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
const adaptImmutableArrayBuffer = () => {
  const anArrayBuffer = new ArrayBuffer(0);
  if (anArrayBuffer.sliceToImmutable === undefined) {
    return {
      immutableArrayBufferPrototype: null,
      immutableGetter: () => false,
    };
  }
  const anImmutableArrayBuffer = anArrayBuffer.sliceToImmutable();
  const immutableArrayBufferPrototype = getPrototypeOf(anImmutableArrayBuffer);
  const immutableGetter = getOwnPropertyDescriptor(immutableArrayBufferPrototype, 'immutable').get;
  return { immutableArrayBufferPrototype, immutableGetter };
};

const { immutableArrayBufferPrototype, immutableGetter } =
  adaptImmutableArrayBuffer();
```

§Feature-detection-with-fallback. §If-the-platform-lacks-sliceToImmutable (cycle 201 @endo/immutable-arraybuffer sibling), §return-deny-shapes (null prototype + always-false getter). §The-rest-of-the-file-uses-these-bindings-uniformly — §the-validation-degrades-to-always-reject-byteArrays.

§Borrowable-pattern: §feature-detection-returns-bindings-that-deny-when-the-feature-is-missing. §The-consumer-code-doesn't-branch-on-feature-presence; §the-bindings-do-the-right-thing.

§Sibling to cycle 215 @endo/hex's §ponyfill-with-load-time-dispatch — both designs §load-time-feature-test + §use-bindings-uniformly-after.

§Apply-immutableGetter via Reflect.apply: `apply(immutableGetter, candidate, [])`. §Sibling to cycle 215's §Reflect.apply-as-the-defensive-uncurry. §Fifth-instance of §Reflect.apply-defensive-uncurry in library (cycles 199 + 207 + 211 + 215 + 227).

§Six-cycles-with-the-identifier-IS-the-capability discipline now if we extend to §the-prototype-IS-the-discriminator: cycle 200 (retention paths) + cycle 210 (deterministic naming) + cycle 211 (file path IS import path) + cycle 220 (deterministic address IS the route) + cycle 224 (formula ID IS bearer token) + cycle 227 (immutableArrayBufferPrototype IS the discriminator).
