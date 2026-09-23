---
title: §The-enterWith() — §the-other-store-setter
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
AsyncLocalStorage.prototype.enterWith = function enterWith(store) {
  this._enable();
  const resource = executionAsyncResource();
  getStoreMap(this).set(resource, store);
};
```

§Three-line-method: enable + get current resource + set store. §Borrowable-pattern: §enterWith-is-the-no-cleanup-counterpart-to-run; §run-is-stack-scoped; §enterWith-persists-until-overridden.

§Two-methods-with-two-different-cleanup-policies (run with try-finally; enterWith with no restore). §The-API-shape-reflects-the-intended-use:
- `run` — §a-callback-scope (cleanup expected at end).
- `enterWith` — §a-flag-flip-with-no-corresponding-leave.

§Borrowable-pattern: §design-two-API-shapes-for-two-different-lifetime-models — §scoped (try-finally) + §persistent (set and forget).
