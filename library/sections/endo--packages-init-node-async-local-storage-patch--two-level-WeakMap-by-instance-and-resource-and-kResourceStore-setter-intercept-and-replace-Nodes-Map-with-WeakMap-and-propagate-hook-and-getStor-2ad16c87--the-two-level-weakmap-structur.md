---
title: §The-two-level-WeakMap-structure
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
/** @type {WeakMap<AsyncLocalStorageInternal, WeakMap>} */
const resourceStoreMaps = new WeakMap();
```

§Outer-WeakMap: `AsyncLocalStorage instance → inner WeakMap`.
§Inner-WeakMap: `resource → store value`.

§Borrowable-pattern: §two-level-WeakMap-for-two-level-keying. §The-outer-key-is-the-AsyncLocalStorage-class-instance + §the-inner-key-is-the-async-resource. §Both-can-be-GC'd-independently. §When-the-AsyncLocalStorage-instance-is-GC'd, §all-its-resource-mappings-go-away-automatically.

§Sibling to cycle 225 node-async_hooks.js's §WeakMap-fallback-for-frozen-promises — both designs §use-WeakMap-to-make-resource-tracking-GC-friendly. §Cycle-225-uses-WeakMap-as-fallback-when-defineProperty-fails; §cycle-233-uses-WeakMap-as-the-primary-storage.
