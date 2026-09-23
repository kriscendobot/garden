---
title: §The-run() with try-finally-restore
source-slug: endo--packages-init-node-async-local-storage-patch
section-id: two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-undefined-when-disabled
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async-local-storage-patch.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async-local-storage-patch.js
total-lines: 98
status: shipping
ingest-cycle: 233
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-undefined-when-disabled
---

```js
AsyncLocalStorage.prototype.run = function run(store, callback, ...args) {
  // Avoid creation of an AsyncResource if store is already active
  if (ObjectIs(store, this.getStore())) {
    return ReflectApply(callback, null, args);
  }

  this._enable();
  const storeMap = getStoreMap(this);
  const resource = executionAsyncResource();
  const oldStore = storeMap.get(resource);
  storeMap.set(resource, store);

  try {
    return ReflectApply(callback, null, args);
  } finally {
    storeMap.set(resource, oldStore);
  }
};
```

§Four-step-discipline:
1. §Optimize-when-store-is-already-active (skip AsyncResource creation).
2. §Enable + capture old store + set new store.
3. §try { invoke callback }.
4. §finally { restore old store }.

§Borrowable-pattern: §the-run()-method-temporarily-swaps-the-store + §restores-it-via-try-finally + §the-swap-is-stack-scoped. §Sibling to cycle 229 marshal-justin's §nested-render-with-indenter-swap and cycle 231 encodeToCapData's §don't-harden-since-we're-not-done-mutating-it — three-cycles-with-try-finally-swap-and-restore + §closure-state-mutation-bounded-by-try-finally.

§ObjectIs-not-equality for §SameValue-semantics — §`-0`-vs-`0` and §NaN-vs-NaN matter. §Sibling to cycle 231 encodeToCapData's §`-0`-normalization-for-canonical-encoding — both designs §use-Object.is-for-SameValue-semantics.

### §Optimize-when-store-is-already-active

> Avoid creation of an AsyncResource if store is already active

§Borrowable-pattern: §when-the-input-matches-the-current-state, §skip-the-work-and-call-the-callback-directly. §AsyncResource-creation-is-the-expensive-step; §the-fast-path-bypasses-it.

§Sibling to cycle 215 @endo/hex's §native-fast-path-stays-fast (no instrumentation overhead) and cycle 222 endoclaw-skill-registry's §two-shapes-for-the-same-operation (explicit-five-step-flow + single-convenience-command). §Three-cycles-on-fast-path-when-input-matches-current-state.

### §`ReflectApply(callback, null, args)` discipline

```js
return ReflectApply(callback, null, args);
```

§Three-named-arguments: `callback`, `null` (no this), `args` (spread). §Borrowable-pattern: §use-Reflect.apply-not-callback.call-or-callback.apply when invoking caller-supplied callbacks. §The-callback's-`this`-is-explicitly-null + §Reflect.apply-can't-be-tampered-by-prototype-mutation.

§Sixth-instance of §Reflect.apply-as-the-defensive-uncurry in library (cycles 199 + 207 + 211 + 215 + 227 + 233).
