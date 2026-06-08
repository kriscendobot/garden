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
---

# @endo/init/node-async-local-storage-patch — Patch AsyncLocalStorage to use a WeakMap-of-WeakMaps

A 98-line file in `@endo/init` that patches `AsyncLocalStorage.prototype` to replace Node's default Map-based store with a §two-level-WeakMap-keyed-by-AsyncLocalStorage-instance-then-by-resource. §Sibling to cycle 225's node-async_hooks.js — both files patch Node's async-hooks substrate to coexist with SES lockdown.

## §The-load-bearing-substitution

Node's default `AsyncLocalStorage` uses a §regular-Map internally (`kResourceStore`). The patch replaces it with a §WeakMap so that §resources-can-be-GC'd-when-no-other-references-hold-them.

§Why-the-substitution-matters: §a-regular-Map-keeps-its-keys-alive + §async-resources-accumulate-over-time + §without-WeakMap-AsyncLocalStorage-becomes-a-memory-leak. §The-patch-makes-AsyncLocalStorage-resource-tracking-GC-friendly.

§Borrowable-pattern: §when-a-platform-API-uses-a-strong-reference-where-a-weak-reference-suffices, §patch-the-prototype-to-use-WeakMap-instead. §The-patch-IS-the-memory-leak-fix.

## §The-two-level-WeakMap-structure

```js
/** @type {WeakMap<AsyncLocalStorageInternal, WeakMap>} */
const resourceStoreMaps = new WeakMap();
```

§Outer-WeakMap: `AsyncLocalStorage instance → inner WeakMap`.
§Inner-WeakMap: `resource → store value`.

§Borrowable-pattern: §two-level-WeakMap-for-two-level-keying. §The-outer-key-is-the-AsyncLocalStorage-class-instance + §the-inner-key-is-the-async-resource. §Both-can-be-GC'd-independently. §When-the-AsyncLocalStorage-instance-is-GC'd, §all-its-resource-mappings-go-away-automatically.

§Sibling to cycle 225 node-async_hooks.js's §WeakMap-fallback-for-frozen-promises — both designs §use-WeakMap-to-make-resource-tracking-GC-friendly. §Cycle-225-uses-WeakMap-as-fallback-when-defineProperty-fails; §cycle-233-uses-WeakMap-as-the-primary-storage.

## §The-kResourceStore-setter-intercept

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

## §The-_propagate-hook for resource creation

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

## §The-run() with try-finally-restore

```js
AsyncLocalStorage.prototype.run = function run(store, callback, ...args) {
  // Avoid creation of an AsyncResource if store is already active
  if (ObjectIs(store, this.getStore())) {
    return ReflectApply(callback, null, args);
  }

  this._enable();
  const storeMap = getStoreMap(this);
  const resource = executionAsyncResource();
  const oldStore = storeMap.get(resource);
  storeMap.set(resource, store);

  try {
    return ReflectApply(callback, null, args);
  } finally {
    storeMap.set(resource, oldStore);
  }
};
```

§Four-step-discipline:
1. §Optimize-when-store-is-already-active (skip AsyncResource creation).
2. §Enable + capture old store + set new store.
3. §try { invoke callback }.
4. §finally { restore old store }.

§Borrowable-pattern: §the-run()-method-temporarily-swaps-the-store + §restores-it-via-try-finally + §the-swap-is-stack-scoped. §Sibling to cycle 229 marshal-justin's §nested-render-with-indenter-swap and cycle 231 encodeToCapData's §don't-harden-since-we're-not-done-mutating-it — three-cycles-with-try-finally-swap-and-restore + §closure-state-mutation-bounded-by-try-finally.

§ObjectIs-not-equality for §SameValue-semantics — §`-0`-vs-`0` and §NaN-vs-NaN matter. §Sibling to cycle 231 encodeToCapData's §`-0`-normalization-for-canonical-encoding — both designs §use-Object.is-for-SameValue-semantics.

### §Optimize-when-store-is-already-active

> Avoid creation of an AsyncResource if store is already active

§Borrowable-pattern: §when-the-input-matches-the-current-state, §skip-the-work-and-call-the-callback-directly. §AsyncResource-creation-is-the-expensive-step; §the-fast-path-bypasses-it.

§Sibling to cycle 215 @endo/hex's §native-fast-path-stays-fast (no instrumentation overhead) and cycle 222 endoclaw-skill-registry's §two-shapes-for-the-same-operation (explicit-five-step-flow + single-convenience-command). §Three-cycles-on-fast-path-when-input-matches-current-state.

### §`ReflectApply(callback, null, args)` discipline

```js
return ReflectApply(callback, null, args);
```

§Three-named-arguments: `callback`, `null` (no this), `args` (spread). §Borrowable-pattern: §use-Reflect.apply-not-callback.call-or-callback.apply when invoking caller-supplied callbacks. §The-callback's-`this`-is-explicitly-null + §Reflect.apply-can't-be-tampered-by-prototype-mutation.

§Sixth-instance of §Reflect.apply-as-the-defensive-uncurry in library (cycles 199 + 207 + 211 + 215 + 227 + 233).

## §getStore-undefined-when-disabled

```js
AsyncLocalStorage.prototype.getStore = function getStore() {
  return this.enabled
    ? getStoreMap(this).get(executionAsyncResource())
    : undefined;
};
```

§Two-cases: §enabled (look up by current resource) + §disabled (undefined). §Borrowable-pattern: §getStore-returns-undefined-when-disabled-not-throws — §the-caller-gets-a-distinct-falsy-value-indicating-no-store.

§Sibling to cycle 225 node-async_hooks.js's §named-sentinel-return-value (cycle 225 returns `-2` for not-applicable; cycle 233 returns `undefined`). §Two-different-sentinel-shapes.

## §The-enterWith() — §the-other-store-setter

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

## §The-eslint-disable-no-underscore-dangle

```js
/* eslint-disable no-underscore-dangle */
```

§File-level-disable for the `_propagate` + `_enable` underscore-prefixed names. §Borrowable-pattern: §when-a-design-must-honor-a-platform's-internal-API-naming, §disable-the-linter-rule-at-the-file-level + §the-comment-IS-the-justification.

§Sibling to cycle 223 @endo/module-source's §`__double-underscore__`-private-names-convention + §eslint-disable-no-underscore-dangle (cycle 223 uses double-underscores for SES compartment internal contract; cycle 233 honors Node's single-underscore convention).

§Three-cycles-with-underscore-prefix-naming-and-eslint-disable: cycle 217 @endo/errors' `__HIDE_` prefix + cycle 223 @endo/module-source's `__double-underscore__` SES contract + cycle 233 node-async-local-storage-patch's `_propagate`/`_enable` Node convention.

§Three-different-underscore-conventions:
- Cycle 217: §`__HIDE_<name>` (double-prefix marker).
- Cycle 223: §`__name__` (double-underscore-wrap, SES internal contract).
- Cycle 233: §`_name` (single-underscore-prefix, Node internal API).

§The-pattern: §each-substrate-has-its-own-underscore-convention-that-the-honoring-code-must-match.

## §The-file-must-run-before-AsyncLocalStorage-is-instantiated

§The-patch-IS-pre-instantiation-prep. §If-the-patch-runs-after-an-AsyncLocalStorage-has-been-created, §the-existing-instance-already-has-its-Map-set + §the-WeakMap-substitution-doesn't-apply-to-it.

§Borrowable-pattern: §when-patching-a-platform-prototype-to-redirect-storage, §the-patch-must-run-before-any-instance-is-created. §The-load-order-is-the-correctness-criterion.

§Sibling to cycle 225 node-async_hooks.js's §pre-lockdown-installation-of-properties-that-lockdown-would-block + cycle 219 @endo/ses-ava's §pre-lockdown-installation-of-runtime-discovered-symbols. §Three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation.

## Related material in the library

- **cycle 225 node-async_hooks.js**: §sibling-substrate-patch — both files patch Node's async-hooks layer; cycle 225 handles per-promise tracking symbols; cycle 233 handles the AsyncLocalStorage class.
- **cycle 219 @endo/ses-ava + cycle 225 node-async_hooks**: §three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation (cycle 233 is the third).
- **cycle 215 @endo/hex + cycle 222 endoclaw-skill-registry + cycle 233**: §three-cycles-on-fast-path-when-input-matches-current-state.
- **cycle 231 encodeToCapData + cycle 233**: §two-cycles-on-`Object.is`-for-SameValue-semantics (cycle 231 normalizes `-0` to `0`; cycle 233 uses `Object.is` for store comparison).
- **cycle 217 @endo/errors + cycle 223 @endo/module-source + cycle 233**: §three-cycles-with-underscore-prefix-naming-and-eslint-disable; §three-different-underscore-conventions.
- **cycle 199 + 207 + 211 + 215 + 227 + 233**: §sixth-instance of §Reflect.apply-as-the-defensive-uncurry.
- **cycle 229 marshal-justin + cycle 231 encodeToCapData + cycle 233**: §three-cycles-with-try-finally-swap-and-restore for closure-state-mutation.

## §Library-reaches-739-sections at cycle 233 (chat-lane @endo/init/node-async-local-storage-patch).

## §Sixty-seventh consecutive designs-chat alternation cycles 166-233.

## §Three-cycles-with-underscore-prefix-naming-and-eslint-disable

| Cycle | Source | Convention |
|-------|--------|-----------|
| 217 | @endo/errors | §`__HIDE_<name>` (double-prefix marker for stack-trace censoring) |
| 223 | @endo/module-source | §`__name__` (double-underscore-wrap, SES Compartment internal contract) |
| 233 | @endo/init/node-async-local-storage-patch | §`_name` (single-underscore-prefix, Node internal API) |

§Three-different-underscore-conventions for §three-different-substrates. §The-pattern: §each-substrate-has-its-own-underscore-convention.

## §Three-cycles-with-pre-instantiation-or-pre-lockdown-property-installation

| Cycle | Source | Layer |
|-------|--------|-------|
| 219 | @endo/ses-ava | §registered-symbol-on-globalThis (pre-lockdown-installation) |
| 225 | @endo/init/node-async_hooks | §pre-lockdown-property-installation on Promise.prototype (async_id/trigger_async_id/destroyed) |
| 233 | @endo/init/node-async-local-storage-patch | §pre-instantiation-setter-installation on AsyncLocalStorage.prototype (kResourceStore) |

§Three-different-load-order-disciplines for §three-different-platform-substrates.

## §Sixth-instance of Reflect.apply-as-the-defensive-uncurry

| Cycle | Source | Use |
|-------|--------|-----|
| 199 | trampoline-memoize-nat | `bind.bind(bind.call)` shape |
| 207 | env-options | Reflect.apply |
| 211 | @endo/common | `Function.prototype.call.bind` |
| 215 | @endo/hex | Reflect.apply for native intrinsic dispatch |
| 227 | pass-style/byteArray | Reflect.apply for immutableGetter |
| 233 | node-async-local-storage-patch | Reflect.apply for callback invocation |

§Six-different-instances of the same canonical defensive-uncurry discipline.

## §Three-cycles-with-try-finally-swap-and-restore

| Cycle | Source | Swap |
|-------|--------|------|
| 229 | marshal-justin | §nested-render-with-indenter-swap |
| 231 | encodeToCapData | §don't-harden-since-we're-not-done-mutating-it |
| 233 | node-async-local-storage-patch | §run()-store-swap-and-restore |

§Three-different-uses of the same try-finally-restore discipline.

## §Thirty-fourth-member of §small-files-with-large-knowledge-density family.
