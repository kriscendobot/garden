---
title: §The-PromiseProto.defineProperty-on-three-symbols
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
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.async_id_symbol,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.async_id_symbol),
);
Object.defineProperty(
  PromiseProto,
  asyncHooksSymbols.trigger_async_id_symbol,
  getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.trigger_async_id_symbol),
);

if (asyncHooksSymbols.destroyed) {
  Object.defineProperty(
    PromiseProto,
    asyncHooksSymbols.destroyed,
    getAsyncHookSymbolPromiseProtoDesc(asyncHooksSymbols.destroyed, {
      disallowGet: true,
    }),
  );
}
```

§Install-three-accessor-properties-on-Promise.prototype-before-SES-lockdown. §Two-required (async_id_symbol + trigger_async_id_symbol) + §one-conditional (destroyed, only if Strategy 2 found it).

§Borrowable-pattern: §install-prototype-properties-with-symbols-discovered-at-runtime-before-the-prototype-is-frozen. §Sibling to cycle 219 @endo/ses-ava's §registered-symbol-on-globalThis-as-cross-module-coordination — both designs §pre-lockdown-installation-of-runtime-discovered-symbols.
