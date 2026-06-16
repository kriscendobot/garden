---
title: §The-WeakMap-fallback-for-frozen-promises
source-slug: endo--packages-init-node-async_hooks
section-id: two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async_hooks.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async_hooks.js
status: shipping
ingest-cycle: 225
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises
---

```js
const promiseAsyncHookFallbackStates = new WeakMap();

const setAsyncIdFallback = (promise, symbol, value) => {
  const state = getAsyncHookFallbackState(promise, { create: true });

  if (state[symbol]) {
    if (state[symbol] !== value) {
      // This can happen if a frozen promise created before hooks were enabled
      // is used multiple times as a parent promise
      // It's safe to ignore subsequent values
    }
  } else {
    state[symbol] = value;
  }
};
```

§The-belt-and-suspenders-pattern: when Reflect.defineProperty on the promise fails (because the promise is frozen), §fall-back-to-a-WeakMap-keyed-by-promise.

```js
set(value) {
  if (
    !Reflect.defineProperty(this, symbol, {
      value,
      writable: disallowGet,
      configurable: false,
      enumerable: false,
    })
  ) {
    setAsyncIdFallback(this, symbol, value);
  }
},
```

§Reflect.defineProperty-returns-false-on-failure (instead of throwing). §The-falsey-return-triggers-the-fallback-path.

§Borrowable-pattern: §when-an-operation-might-fail-silently-via-return-false, §check-the-return-and-fall-back-without-throwing. §Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic — both designs §use-the-failure-path-to-route-to-a-fallback.

§Honest-acknowledgment-of-edge-case:

> This can happen if a frozen promise created before hooks were enabled is used multiple times as a parent promise. It's safe to ignore subsequent values.

§Borrowable-pattern: §when-an-edge-case-is-rare-and-the-ignore-policy-is-safe, §name-the-edge-case + §name-the-policy.
