---
title: §Type-predicate narrowing via `maybePromise is Promise`
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
/**
 * @param {unknown} maybePromise The value to examine
 * @returns {maybePromise is Promise} Whether it is a promise
 */
```

§The-JSDoc-`@returns`-uses-a-type-predicate-narrowing-form: §`{maybePromise is Promise}` tells TypeScript that the boolean-true return narrows the parameter type to `Promise`. §When-a-predicate-function-returns-a-boolean, §the-return-type-can-be-a-type-predicate + §callers-get-automatic-type-narrowing-in-the-`if (isPromise(x)) { ... }`-branch.

§`@param {unknown}`-as-the-honest-input-type: §the-parameter-could-be-anything + §`unknown`-is-the-honest-encoding-of-that + §narrower-types-would-be-misleading-when-the-function-is-being-used-to-discover-the-type.

§Two-named-TypeScript-disciplines-in-the-JSDoc: §`unknown`-for-the-honest-input-type + §type-predicate-narrowing-for-the-output. §When-a-detection-function-is-typed, §use-`unknown`-for-input + §use-type-predicate-narrowing-for-output. §First-explicit-observation in library of §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline.

§Sibling-pattern-to-cycle-249's-`keyof InterfaceName`-as-defense-by-construction — §two-cycles-with-named-TypeScript-discipline-around-validation: §cycle-249-uses-keyof-to-prevent-string-union-drift + §cycle-252-uses-type-predicate-narrowing-to-bind-runtime-check-to-static-type.
