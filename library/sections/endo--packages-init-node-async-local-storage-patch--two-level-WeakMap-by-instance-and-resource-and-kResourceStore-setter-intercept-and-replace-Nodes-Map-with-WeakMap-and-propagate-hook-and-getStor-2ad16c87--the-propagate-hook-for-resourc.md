---
title: §The-_propagate-hook for resource creation
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
function _propagate(resource, triggerResource, type) {
  if (!this.enabled) return;
  const storeMap = getStoreMap(this);
  storeMap.set(resource, storeMap.get(triggerResource));
}

AsyncLocalStorage.prototype._propagate = _propagate;
```

§Node-calls-_propagate-when-a-new-resource-is-created from a trigger-resource. §The-patch-inherits-the-store-from-the-trigger-resource (the async parent).

§Borrowable-pattern: §when-the-platform-has-a-callback-for-resource-creation, §the-patch-uses-it-to-propagate-the-store-from-parent-to-child. §The-inheritance-is-via-callback-not-via-explicit-traversal.

§The-`if (!this.enabled) return;` guard — §when-the-AsyncLocalStorage-is-disabled, §do-nothing. §Zero-cost-when-not-in-use.

§Sibling to cycle 217 @endo/errors' §enumerate-required-methods-and-tolerate-missing-ones (cycle 217 tolerates missing prerequisites; cycle 233 tolerates disabled state).
