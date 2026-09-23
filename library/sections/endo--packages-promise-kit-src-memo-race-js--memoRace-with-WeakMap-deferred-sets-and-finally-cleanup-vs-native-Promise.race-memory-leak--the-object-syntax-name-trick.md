---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §object-syntax-name-trick
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
const { race } = {
  race(values) { ... },
};
// ...
export { race as memoRace };
```

The §named-function-via-object-destructure idiom. The
function's `.name` is `'race'` because it's the method-name in
the object literal. If `const race = (values) => { ... }`
were used, the name would still be `'race'` (assignment
inference), but the §method-syntax has a subtle benefit: the
function is *non-constructable* and lacks a prototype property.
The §don't-let-callers-`new`-this-function discipline.

The §`export { race as memoRace }` rename: external API uses
`memoRace`; internal name is `race`. The §api-name-vs-impl-
name asymmetry.
