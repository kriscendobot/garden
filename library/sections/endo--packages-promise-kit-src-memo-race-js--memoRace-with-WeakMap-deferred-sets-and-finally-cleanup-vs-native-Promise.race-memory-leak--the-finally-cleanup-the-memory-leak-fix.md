---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §finally-cleanup — the §memory-leak fix
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
return result.finally(() => {
  for (const value of cachedValues) {
    const { deferreds } = getMemoRecord(value);
    if (deferreds) {
      deferreds.delete(deferred);
    }
  }
});
```

The §finally-as-cleanup-hook idiom. After `result` settles
(by resolution or rejection of *any* input), the `.finally`
runs and *removes* the race's deferred from every input
value's deferred-Set. After this cleanup:

- Settled inputs: their `deferreds` field is already
  `undefined`, so `if (deferreds) deferreds.delete(deferred)`
  is a no-op.
- Pending inputs: the deferred is removed from their Set.

The §`if (deferreds)` short-circuit handles both cases
uniformly.

The §the-deferred-no-longer-holds-the-result-promise: once
the deferred is removed, *no* path from a still-pending input
holds the result promise. GC can reclaim the result.

The §finally-vs-then-for-cleanup choice: `.finally` runs
*after* `result` settles (in *both* resolve and reject paths)
*without* affecting the chain's value. A `.then(cleanup,
cleanup)` would work but visually conflates cleanup with
result handling. `.finally` makes the cleanup intent visible.
