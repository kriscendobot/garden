---
title: §The-setAsyncSymbol-three-case-logic
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
const setAsyncSymbol = (description, symbol) => {
  if (!(description in asyncHooksSymbols)) {
    throw Error('Unknown symbol');
  } else if (!asyncHooksSymbols[description]) {
    if (symbol.description !== description) {
      throw Error(
        `Mismatched symbol found for ${description}: ${String(symbol)}`,
      );
    }
    asyncHooksSymbols[description] = symbol;
    return true;
  } else if (asyncHooksSymbols[description] !== symbol) {
    // process._rawDebug(
    //   `Found duplicate ${description}:`,
    //   symbol,
    //   asyncHooksSymbols[description],
    // );
    return false;
  } else {
    return true;
  }
};
```

§Three-cases-with-three-different-return-values:
1. §Unknown-symbol-description → throw.
2. §First-time-setting → validate-description-matches + assign + return true.
3. §Subsequent-setting:
   - §Same-symbol → return true (idempotent).
   - §Different-symbol → return false (duplicate; logged).

§Borrowable-pattern: §the-symbol-registration-function-distinguishes-unknown-from-first-time-from-duplicate. §The-validation-against-`symbol.description !== description` is §the-belt-and-suspenders-check on top of the allow-list check.
