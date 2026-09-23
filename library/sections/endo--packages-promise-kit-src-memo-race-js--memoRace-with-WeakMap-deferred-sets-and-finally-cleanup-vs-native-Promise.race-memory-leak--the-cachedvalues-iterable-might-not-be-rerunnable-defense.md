---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §cachedValues — §iterable-might-not-be-rerunnable defense
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
const cachedValues = [];
// ...
for (const value of values) {
  cachedValues.push(value);
  ...
}
// ... later, in finally:
for (const value of cachedValues) { ... }
```

The §iterable-might-not-be-rerunnable defense: the input
`values` is `T extends readonly unknown[] | []`, but
TypeScript types don't enforce *re-iterability*. Generators
and other one-shot iterables would *exhaust* on the first
`for` loop; the finally would see an empty iterable. Caching
into a fresh array preserves the values for the finally
cleanup.

The §single-pass-with-cached-array idiom is the standard
defense against one-shot iterables that need traversal twice.
