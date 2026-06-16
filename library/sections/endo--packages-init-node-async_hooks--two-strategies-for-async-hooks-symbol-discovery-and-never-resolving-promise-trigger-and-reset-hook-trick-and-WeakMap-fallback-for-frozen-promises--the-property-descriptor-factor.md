---
title: §The-property-descriptor-factory with §disallowGet-variant
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
const getAsyncHookSymbolPromiseProtoDesc = (
  symbol,
  { disallowGet = false } = {},
) => ({
  set(value) { /* ... */ },
  get() {
    if (disallowGet) {
      return undefined;
    }
    const state = getAsyncHookFallbackState(this, { create: false });
    return state && state[symbol];
  },
  enumerable: false,
  configurable: true,
});
```

§Factory-returns-a-property-descriptor + §`disallowGet`-option-changes-the-getter. §The-`destroyed`-symbol-uses-disallowGet:

```js
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.destroyed,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.destroyed, {
    disallowGet: true,
  }),
);
```

§The-`destroyed`-symbol-only-needs-a-setter — Node writes to it; nothing reads it. §The-disallowGet-makes-the-getter-return-undefined (and skip the WeakMap lookup).

§Borrowable-pattern: §when-a-Symbol-is-write-only-from-the-host-side, §disallow-get-to-avoid-leaking-fallback-state.

§Workaround-comment:

> Workaround a Node bug setting the destroyed sentinel multiple times

§The-writable: disallowGet line is the §double-purpose: when disallowGet is true, the property is writable so Node can re-set it. §Borrowable-pattern: §the-writable-flag-can-encode-Node-version-quirks-not-just-mutation-policy.
