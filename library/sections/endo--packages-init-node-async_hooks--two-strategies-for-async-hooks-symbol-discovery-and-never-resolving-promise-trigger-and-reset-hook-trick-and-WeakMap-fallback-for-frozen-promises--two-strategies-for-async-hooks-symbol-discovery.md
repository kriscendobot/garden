---
title: §Two-strategies-for-async-hooks-symbol-discovery
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

The file defines §two-named-discovery-strategies with §different-cost-and-coverage:

### Strategy 1: §findAsyncSymbolsFromAsyncResource (cheap, partial)

```js
const findAsyncSymbolsFromAsyncResource = () => {
  let found = 0;
  for (const sym of Object.getOwnPropertySymbols(
    new AsyncResource('Bootstrap'),
  )) {
    const { description } = sym;
    if (description && description in asyncHooksSymbols) {
      if (setAsyncSymbol(description, sym)) {
        found += 1;
      }
    }
  }
  return found;
};
```

§Find-symbols-on-a-fresh-AsyncResource-instance. §Cheap (one allocation, no hook enable/disable). §But-only-gets-two-of-the-three: `async_id_symbol` and `trigger_async_id_symbol` (not `destroyed`).

### Strategy 2: §findAsyncSymbolsFromPromiseCreateHook (expensive, complete)

```js
const getPromiseFromCreateHook = () => {
  const bootstrapHookData = [];
  const bootstrapHook = createHook({
    init(asyncId, type, triggerAsyncId, resource) {
      if (type !== 'PROMISE') return;
      bootstrapHookData.push({ asyncId, triggerAsyncId, resource });
    },
    destroy(_asyncId) {
      // Needs to be present to trigger the addition of the destroyed symbol
    },
  });

  bootstrapHook.enable();
  // Use a never resolving promise to avoid triggering settlement hooks
  const trigger = new Promise(() => {});
  bootstrapHook.disable();
  // ...
};
```

§Enable-a-hook + §create-a-trigger-promise + §disable-the-hook + §extract-the-data. §More-expensive (a hook is enabled and disabled). §Gets-all-three-symbols including `destroyed`.

§The-honest-comment names the destroy-hook's purpose:

> destroy(_asyncId) { // Needs to be present to trigger the addition of the destroyed symbol }

§Just-providing-the-destroy-callback-changes-Node's-behavior — Node only installs the `destroyed` symbol if a destroy hook exists. §Borrowable-pattern: §when-the-platform's-behavior-depends-on-whether-you-passed-a-callback, §pass-the-empty-callback-to-trigger-the-behavior.

### §setup({ withDestroy }) chooses between them

```js
export const setup = ({ withDestroy = true } = {}) => {
  if (withDestroy) {
    findAsyncSymbolsFromPromiseCreateHook();
  } else {
    findAsyncSymbolsFromAsyncResource();
  }
  // ...
};
```

§Two-strategies-with-a-cost-coverage-trade-off + §a-named-option-to-pick. §Borrowable-pattern: §when-two-strategies-have-different-cost-and-coverage, §default-to-the-complete-one + §let-the-caller-opt-out-with-a-named-option.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §two-CapTP-transports — both designs §two-options-with-named-trade-offs.
