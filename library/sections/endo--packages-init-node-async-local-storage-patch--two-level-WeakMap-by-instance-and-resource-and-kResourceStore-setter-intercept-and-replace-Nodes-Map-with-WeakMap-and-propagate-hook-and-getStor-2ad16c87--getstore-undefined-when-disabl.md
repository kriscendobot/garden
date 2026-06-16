---
title: §getStore-undefined-when-disabled
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
AsyncLocalStorage.prototype.getStore = function getStore() {
  return this.enabled
    ? getStoreMap(this).get(executionAsyncResource())
    : undefined;
};
```

§Two-cases: §enabled (look up by current resource) + §disabled (undefined). §Borrowable-pattern: §getStore-returns-undefined-when-disabled-not-throws — §the-caller-gets-a-distinct-falsy-value-indicating-no-store.

§Sibling to cycle 225 node-async_hooks.js's §named-sentinel-return-value (cycle 225 returns `-2` for not-applicable; cycle 233 returns `undefined`). §Two-different-sentinel-shapes.
