---
title: "@endo/init/node-async-local-storage-patch — §two-level-WeakMap-keyed-by-AsyncLocalStorage-instance-and-then-by-resource + §kResourceStore-setter-intercept-to-replace-Nodes-Map-with-WeakMap + §_propagate-hook-for-resource-creation + §run-with-try-finally-restore + §getStore-undefined-when-disabled"
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
kind: index
section_count: 15
---

Sections:

- [@endo/init/node-async-local-storage-patch — Patch AsyncLocalStorage to use a WeakMap-of-WeakMaps](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--endo-init-node-async-local-sto.md)
- [§The-load-bearing-substitution](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-2ad16c87--the-load-bearing-substitution.md)
- [§The-two-level-WeakMap-structure](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-two-level-weakmap-structur.md)
- [§The-kResourceStore-setter-intercept](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-kresourcestore-setter-inte.md)
- [§The-_propagate-hook for resource creation](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-propagate-hook-for-resourc.md)
- [§The-run() with try-finally-restore](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-run-with-try-finally-resto.md)
- [§getStore-undefined-when-disabled](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--getstore-undefined-when-disabl.md)
- [§The-enterWith() — §the-other-store-setter](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-2ad16c87--the-enterwith-the-other-store.md)
- [§The-eslint-disable-no-underscore-dangle](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-eslint-disable-no-undersco.md)
- [§The-file-must-run-before-AsyncLocalStorage-is-instantiated](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--the-file-must-run-before-async.md)
- [Related material in the library](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--related-material-in-the-librar.md)
- [§Three-cycles-with-underscore-prefix-naming-and-eslint-disable](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--three-cycles-with-underscore-p.md)
- [§Three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--three-cycles-with-pre-instanti.md)
- [§Sixth-instance of Reflect.apply-as-the-defensive-uncurry](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStor-2ad16c87--sixth-instance-of-reflect-appl.md)
- [§Three-cycles-with-try-finally-swap-and-restore](endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-2ad16c87--three-cycles-with-try-finally.md)
