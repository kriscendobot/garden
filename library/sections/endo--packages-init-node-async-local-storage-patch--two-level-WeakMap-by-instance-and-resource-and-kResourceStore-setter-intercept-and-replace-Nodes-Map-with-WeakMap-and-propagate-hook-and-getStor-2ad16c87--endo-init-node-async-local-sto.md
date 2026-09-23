---
title: "@endo/init/node-async-local-storage-patch — Patch AsyncLocalStorage to use a WeakMap-of-WeakMaps"
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

A 98-line file in `@endo/init` that patches `AsyncLocalStorage.prototype` to replace Node's default Map-based store with a §two-level-WeakMap-keyed-by-AsyncLocalStorage-instance-then-by-resource. §Sibling to cycle 225's node-async_hooks.js — both files patch Node's async-hooks substrate to coexist with SES lockdown.
