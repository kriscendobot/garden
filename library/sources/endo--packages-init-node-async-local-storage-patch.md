---
title: "@endo/init/node-async-local-storage-patch — Patch AsyncLocalStorage to use a WeakMap-of-WeakMaps for GC-friendly resource tracking"
source-slug: endo--packages-init-node-async-local-storage-patch
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async-local-storage-patch.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async-local-storage-patch.js
total-lines: 98
status: shipping
ingest-cycle: 233
ingest-date: 2026-06-08
lane: chat
---

# @endo/init/node-async-local-storage-patch

A 98-line file in `@endo/init` that patches `AsyncLocalStorage.prototype` to replace Node's Map-based store with a §two-level-WeakMap-keyed-by-AsyncLocalStorage-instance-then-by-resource. §Sibling to cycle 225's node-async_hooks.js — both files patch Node's async-hooks substrate to coexist with SES lockdown + make resource tracking GC-friendly.

## Key design moves

- **§The-load-bearing-substitution** — replace Node's Map (strong reference) with WeakMap (GC-friendly) so async resources can be reclaimed.
- **§Two-level-WeakMap-structure** — outer WeakMap<instance, inner-WeakMap>, inner WeakMap<resource, store>.
- **§The-kResourceStore-setter-intercept** — `Object.defineProperty(AsyncLocalStorage.prototype, 'kResourceStore', { set() { ... } })` redirects Node's internal property-set to the outer-WeakMap allocation.
- **§The-_propagate-hook for resource creation** — inherits store from trigger-resource via Node's async-hooks callback.
- **§The-run() with try-finally-restore** — temporarily swaps store + restores in finally; §optimize-when-store-is-already-active fast path.
- **§ObjectIs-not-equality** for SameValue semantics.
- **§ReflectApply-with-null-this** for callback invocation — sixth-instance of Reflect.apply-as-the-defensive-uncurry.
- **§getStore-undefined-when-disabled** — distinct sentinel return value.
- **§enterWith() — §the-other-store-setter** without try-finally cleanup (no-cleanup-counterpart to run).
- **§Two-API-shapes-for-two-different-lifetime-models** — scoped (run with try-finally) + persistent (enterWith).
- **§The-eslint-disable-no-underscore-dangle** to honor Node's `_propagate`/`_enable` internal-API convention.
- **§`configurable: true`** on the prototype property to leave the door open for the platform to undo the patch if needed.

## Section files

- [§two-level-WeakMap-by-instance-and-resource + §kResourceStore-setter-intercept + §replace-Nodes-Map-with-WeakMap + §propagate-hook + §getStore-undefined-when-disabled](../sections/endo--packages-init-node-async-local-storage-patch--two-level-WeakMap-by-instance-and-resource-and-kResourceStore-setter-intercept-and-replace-Nodes-Map-with-WeakMap-and-propagate-hook-and-getStore-undefined-when-disabled.md) — full source ingest.

## Ingest scope

Cycle 233 (chat-lane): full 98-line ingest. §Sibling to cycle 225's node-async_hooks.js (both files patch Node's async-hooks substrate). §Three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation (cycles 219 + 225 + 233). §Six-instances of Reflect.apply-as-the-defensive-uncurry now (199 + 207 + 211 + 215 + 227 + 233).
