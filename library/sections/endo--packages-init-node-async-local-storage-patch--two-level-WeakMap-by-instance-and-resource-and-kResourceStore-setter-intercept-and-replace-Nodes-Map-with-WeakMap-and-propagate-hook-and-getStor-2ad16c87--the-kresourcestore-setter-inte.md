---
title: §The-kResourceStore-setter-intercept
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

§The-novel-move-of-the-patch:

```js
Object.defineProperty(AsyncLocalStorage.prototype, 'kResourceStore', {
  configurable: true,
  set() {
    resourceStoreMaps.set(this, new WeakMap());
  },
});
```

§Node's-AsyncLocalStorage-constructor-sets-`this[kResourceStore] = new Map()` internally. §The-patch-intercepts-this-set + §substitutes-an-allocation-in-the-outer-WeakMap-instead.

§Borrowable-pattern: §intercept-the-platform's-internal-property-set-via-setter-on-prototype + §redirect-the-storage-to-your-own-structure. §The-original-property-is-never-actually-stored-on-the-instance; §the-setter-redirects-the-storage-to-the-outer-WeakMap.

§Sibling to cycle 225 node-async_hooks.js's §property-descriptor-factory with §`disallowGet`-variant. §Both-designs-define-property-descriptors-on-platform-prototypes + §intercept-the-platform's-internal-protocol.

§Three-cycles-now-on-intercept-platform's-internal-property-set: cycle 219 @endo/ses-ava (registered-symbol-on-globalThis), cycle 225 node-async_hooks (defineProperty for async_id/trigger_async_id/destroyed), cycle 233 node-async-local-storage-patch (defineProperty setter for kResourceStore).

§Different-from-cycle-219 + cycle-225: cycle 219 reads a platform-installed value; cycle 225 writes to the prototype for the platform to read; cycle 233 §intercepts-the-platform's-write to redirect it. §Three-different-roles in the same general discipline.

§The-`configurable: true` — §the-platform's-later-attempt-to-define-the-same-property-can-still-redefine-it; §the-patch-is-not-locked-in. §Borrowable-pattern: §when-patching-a-platform-prototype, §`configurable: true`-leaves-the-door-open-for-the-platform-to-undo-the-patch if needed.
