---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §primitive-fake-settled-record idiom
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
if (isPrimitive(value)) {
  // If the contender is a primitive, attempting to use it as a key in the
  // weakmap would throw an error. Luckily, it is safe to call
  // `Promise.resolve(contender).then` on a primitive value multiple times
  // because the promise fulfills immediately. So we fake a settled record.
  return harden({ settled: true });
}
```

The §primitive-bypass-via-fake-record discipline: primitives
(`undefined`, `null`, `boolean`, `number`, `bigint`, `string`,
`symbol`) cannot be WeakMap keys. Rather than special-case the
caller, the function returns a *hardened fake record* signaling
"settled". The caller then calls `Promise.resolve(value).then(...)`
which fires *immediately* (primitives are not thenable; the
spec resolves them in the microtask queue).

The §harden-the-fake-record discipline: even the fake record
is hardened, matching the §frozen-after-transition discipline
of real records. The §uniform-record-shape across primitive
and object cases.

§TODO marker at the top: *Consolidate with `isPrimitive`
that's currently in `@endo/pass-style`. Layering constraints
make this tricky, which is why we haven't yet figured out how
to do this*. The §honest-duplication acknowledgment — cycle
142's `passStyle-helpers.js` also duplicated `isPrimitive`
(its version dropped the cycle's §safer-but-slower-on-XS
trade-off). The §layering-constraints-block-DRY observation:
@endo/promise-kit sits *below* @endo/pass-style in the
dependency graph; importing it would create a cycle.
