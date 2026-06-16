---
title: §The-module-pattern-vs-class-pattern
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

§Module-pattern: §closure-state (`asyncHooksSymbols`, `promiseAsyncHookFallbackStates`) + §exported-setup-function. §No-class + §no-`new` + §single-singleton-per-module-load.

§Borrowable-pattern: §when-the-shape-is-a-singleton-with-internal-state, §use-module-closure-state + §exported-setup. §Sibling to cycle 223 @endo/module-source which uses §class-pattern for the ModuleSource value-type. §Two-different-design-choices-for-two-different-shapes (class for value-types-with-instances; module for singleton-with-internal-state).
