---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §`this`-as-PromiseConstructor subclassability
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
const C = this;
const result = new C((resolve, reject) => { ... });
```

The §subclassable-design discipline: `memoRace` takes `this`
as the Promise constructor. Default-call (`memoRace(values)`)
uses *whatever* `this` is bound to (typically global Promise);
subclasses can call `MyPromise.memoRace(values)` to get
results in the subclass.

The §this-as-constructor pattern matches the standard
ECMAScript Promise.* static methods (Promise.all, Promise.race,
Promise.allSettled). The §interop-with-promise-subclasses
property.
