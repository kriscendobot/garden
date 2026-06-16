---
title: "@endo/init/node-async_hooks — Make Node async_hooks coexist with SES-frozen Promise.prototype"
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

A 240-line file in `@endo/init` that bridges Node.js's `async_hooks` machinery with SES lockdown. §The-problem: Node's async_hooks library installs per-promise tracking symbols on the Promise prototype; SES lockdown freezes Promise.prototype; the two collide unless something gives. §The-solution-installed-by-this-file: §intercept-the-symbol-setting-on-the-prototype + §fall-back-to-WeakMap-when-defineProperty-fails-on-a-frozen-promise.
