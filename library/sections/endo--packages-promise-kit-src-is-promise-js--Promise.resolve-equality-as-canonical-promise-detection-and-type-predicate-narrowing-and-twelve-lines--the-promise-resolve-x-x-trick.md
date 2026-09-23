---
title: §The `Promise.resolve(x) === x` trick
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
parent: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines
---

```js
export function isPromise(maybePromise) {
  return Promise.resolve(maybePromise) === maybePromise;
}
```

§The-canonical-promise-detection: §Promise.resolve-applied-to-a-Promise-returns-the-same-Promise + §Promise.resolve-applied-to-anything-else-returns-a-new-Promise. §So-the-`===`-check-succeeds-iff-the-input-is-already-a-Promise.

§The-ES-spec-guarantees-this-behavior: §`Promise.resolve(value)`-checks-if-value-is-a-Promise-with-the-same-constructor + §if-so-returns-the-value-unchanged + §otherwise-wraps. §The-`===`-test-IS-the-evidence-of-the-unchanged-return.

§Why-not-duck-typing-via-`.then`: §a-thenable-(any object with a callable `.then`)-would-pass-a-duck-type-check + §but-a-thenable-is-not-the-same-as-a-Promise-instance. §The-Promise.resolve-trick-distinguishes-genuine-Promises-from-mere-thenables. §When-the-distinction-between-genuine-Promise-and-thenable-matters, §use-the-Promise.resolve-equality-trick + §not-the-`.then`-duck-type-check.

§First-explicit-observation in library of §`Promise.resolve(x) === x`-as-canonical-promise-detection.

§Sibling-pattern-to-cycle-243's-host-endian-detection-via-typed-array-aliasing — §two-cycles-with-canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose: §cycle-243-uses-Uint16-aliasing-to-detect-byte-order-from-typed-array-feature + §cycle-252-uses-Promise.resolve-identity-to-detect-Promise-instance-from-Promise.resolve-feature. §Both-tricks-leverage-an-incidental-property-of-the-feature-not-its-stated-purpose. §First-explicit-observation in library of §canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose-as-recurring-named-discipline.
