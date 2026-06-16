---
title: §The-load-bearing-substitution
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

Node's default `AsyncLocalStorage` uses a §regular-Map internally (`kResourceStore`). The patch replaces it with a §WeakMap so that §resources-can-be-GC'd-when-no-other-references-hold-them.

§Why-the-substitution-matters: §a-regular-Map-keeps-its-keys-alive + §async-resources-accumulate-over-time + §without-WeakMap-AsyncLocalStorage-becomes-a-memory-leak. §The-patch-makes-AsyncLocalStorage-resource-tracking-GC-friendly.

§Borrowable-pattern: §when-a-platform-API-uses-a-strong-reference-where-a-weak-reference-suffices, §patch-the-prototype-to-use-WeakMap-instead. §The-patch-IS-the-memory-leak-fix.
