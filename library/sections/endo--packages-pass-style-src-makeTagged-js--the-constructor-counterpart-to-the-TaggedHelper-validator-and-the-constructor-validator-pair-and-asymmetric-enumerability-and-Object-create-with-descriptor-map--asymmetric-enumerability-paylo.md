---
title: §Asymmetric enumerability — payload is enumerable, marker fields are not
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

Lines 25-27 carry a structurally important asymmetry:

```js
[PASS_STYLE]: { value: 'tagged' },         // → non-enumerable by default
[Symbol.toStringTag]: { value: tag },      // → non-enumerable by default
payload: { value: payload, enumerable: true },  // → explicitly enumerable
```

§The-asymmetric-enumerability — §the-payload-IS-visible-to-iteration + §the-marker-fields-are-hidden; §sibling-pattern to JS's many-conventions-where-protocol-fields-are-hidden-and-user-fields-are-visible.

§The-descriptor-map's-default-behavior: `Object.defineProperty`-style descriptors default ALL boolean fields (writable + enumerable + configurable) to `false` when not specified. §the-marker-fields-default-to-non-enumerable + §the-explicit-`enumerable: true`-on-`payload`-IS-the-only-deviation; §the-default-IS-the-discipline-and-the-deviation-IS-the-feature.

§First-explicit-observation in library: **§the-asymmetric-enumerability-IS-encoded-by-omission — §the-defaults-IS-the-discipline + §the-explicit-`enumerable: true`-on-payload-IS-the-deviation + §the-pattern-`{ value: X }`-without-other-flags-IS-the-canonical-form-for-non-enumerable-protocol-fields**.

§The-validator-side (cycle 268 TaggedHelper) §assertRestValid §destructure-then-rest-then-count-zero relies on this descriptor shape — §`getOwnPropertyDescriptors(candidate)` returns the same descriptor shape that `Object.create` was given.

§First-explicit-observation in library: **§the-constructor-and-validator-share-the-descriptor-shape — §`Object.create`-with-descriptor-map-on-construction + §`Object.getOwnPropertyDescriptors`-on-validation + §the-two-functions-IS-protocol-duals**.
