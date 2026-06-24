---
title: §`PromiseKit<T>` — a reified Promise
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

```js
/**
 * @template T
 * @typedef {object} PromiseKit A reified Promise
 * @property {(value: ERef<T>) => void} resolve
 * @property {(reason: any) => void} reject
 * @property {Promise<T>} promise
 */
```

§A-Promise's-three-roles-(resolver + rejecter + the-future-value)-are-hidden-inside-the-Promise-constructor's-executor-callback. §A-PromiseKit-IS-the-Promise-with-those-three-roles-exposed-as-explicit-object-properties.

§Reified-Promise-as-named-pattern: §reify-means-to-make-the-implicit-explicit + §the-Promise-constructor's-executor-callback-IS-implicit-state + §the-PromiseKit-object-IS-the-explicit-projection. §First-explicit-observation in library of §PromiseKit-as-reified-Promise as named architectural pattern.

§Sibling-pattern-to-cycle-241's-postponed.js — §the-resolve-callback-is-captured-via-closure-in-Promise-executor (cycle 241's mechanism for one specific case) + §the-PromiseKit-IS-the-systematic-generalization-of-that-pattern (the entire triple is exposed, not just resolve). §When-the-resolve-and-reject-must-be-called-from-outside-the-Promise-constructor-executor, §use-the-PromiseKit + §don't-reach-into-the-Promise-via-closure-tricks.

§The-three-properties (resolve + reject + promise) are §the-canonical-three-roles-of-Promise-resolution. §Sibling-pattern-to-cycle-249's-`TrapCompletion`-as-discriminator-payload-tuple — §two-different-shapes-of-Promise-result-encoding: §cycle-249-tuple-for-sync-result + §cycle-256-record-for-async-resolver-triple.
