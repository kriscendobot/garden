---
title: §The-file-must-run-before-AsyncLocalStorage-is-instantiated
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

§The-patch-IS-pre-instantiation-prep. §If-the-patch-runs-after-an-AsyncLocalStorage-has-been-created, §the-existing-instance-already-has-its-Map-set + §the-WeakMap-substitution-doesn't-apply-to-it.

§Borrowable-pattern: §when-patching-a-platform-prototype-to-redirect-storage, §the-patch-must-run-before-any-instance-is-created. §The-load-order-is-the-correctness-criterion.

§Sibling to cycle 225 node-async_hooks.js's §pre-lockdown-installation-of-properties-that-lockdown-would-block + cycle 219 @endo/ses-ava's §pre-lockdown-installation-of-runtime-discovered-symbols. §Three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation.
