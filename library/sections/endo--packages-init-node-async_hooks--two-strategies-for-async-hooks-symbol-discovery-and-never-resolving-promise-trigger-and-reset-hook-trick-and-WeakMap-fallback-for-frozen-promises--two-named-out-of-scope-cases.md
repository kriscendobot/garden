---
title: §Two-named-out-of-scope cases
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

The file has §two-honest-acknowledgments-of-cases-it-doesn't-handle:

1. **§Frozen-promise-reused-as-parent**:
   > This can happen if a frozen promise created before hooks were enabled is used multiple times as a parent promise. It's safe to ignore subsequent values.

2. **§Node-version-not-mutating-promises**:
   > // This node version is not mutating promises
   > return -2;

§The-return-value-of-`-2` is a §named-sentinel for §this-version-doesn't-need-the-shim. §Borrowable-pattern: §return-a-specific-named-sentinel-for-a-named-platform-condition; §the-caller-can-distinguish-not-found-(0)-from-not-applicable-(-2).
