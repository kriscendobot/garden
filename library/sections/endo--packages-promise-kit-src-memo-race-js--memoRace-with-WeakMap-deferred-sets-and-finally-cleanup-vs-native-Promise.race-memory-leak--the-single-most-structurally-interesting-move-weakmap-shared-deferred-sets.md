---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §single most structurally interesting move — §WeakMap-shared-deferred-sets
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

The §`knownPromises` WeakMap is the architectural keystone:

```js
const knownPromises = new WeakMap();
// keys: input values; values: PromiseMemoRecord
```

Each WeakMap entry is a `PromiseMemoRecord`:

```js
{ settled: false, deferreds: Set<Deferred> }  // pending
{ settled: true, deferreds: undefined }       // settled, frozen
```

The §shared-record-across-races discipline: if the *same value*
appears in *multiple* races (a common pattern when one promise
is a member of many races), they share *one* memo record. The
§once-per-value-then-handler discipline is the §one-then-per-
value-lifetime invariant:

```js
if (!record) {
  record = { deferreds: new Set(), settled: false };
  knownPromises.set(value, record);
  Promise.resolve(value).then(
    val => { for (const { resolve } of markSettled(record)) resolve(val); },
    err => { for (const { reject } of markSettled(record)) reject(err); },
  );
}
```

The §`.then()` is *called once* per value (gated by `if
(!record)`). Subsequent races on the same value find the
record already in the WeakMap and just *register their
deferred* in the existing Set. The §amortize-one-then-across-
many-races optimization.

The §when-the-value-settles broadcast: `Promise.resolve(value).then`
fires *once* (when the value settles), and at that point
`markSettled(record)` returns the *entire Set of waiting
deferreds*. The handler iterates the set and notifies each
deferred. The §broadcast-pattern-via-shared-set.
