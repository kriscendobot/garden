---
title: §The-three-symbols-async_hooks-needs
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
const asyncHooksSymbols = {
  async_id_symbol: undefined,
  trigger_async_id_symbol: undefined,
  destroyed: undefined,
};
```

§Three-named-symbol-slots that must be filled before lockdown. §The-symbols-are-internal-to-Node + §their-string-descriptions-are-stable-across-versions-but-the-symbol-values-are-not. §This-file-discovers-them-at-runtime-by-description.

§Borrowable-pattern: §when-a-host-API-uses-internal-Symbols-you-need-to-reference, §discover-them-by-their-description-string. §The-description-IS-the-protocol-but-the-symbol-IS-the-key.
