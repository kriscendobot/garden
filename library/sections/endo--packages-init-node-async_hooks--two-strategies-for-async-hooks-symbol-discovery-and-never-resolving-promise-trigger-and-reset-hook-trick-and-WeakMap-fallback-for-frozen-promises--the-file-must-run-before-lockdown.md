---
title: §The-file-must-run-before-lockdown
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

§The-whole-file-is-pre-lockdown-prep. §If-it-runs-after-lockdown, §the-Promise.prototype-is-frozen + §Object.defineProperty-throws-or-returns-false. §The-file-belongs-to-`@endo/init` which §loads-before-SES-lockdown-as-the-precondition-arrange-stage.

§Sibling to cycles 132 + 146 + 154 + 199 + 219 + 223 (the §freeze-not-harden-with-named-correctness-argument family). §Cycle-225-is-different — §it's-not-just-pre-lockdown-frozen-objects, §it's-pre-lockdown-installation-of-properties-that-lockdown-would-block. §Different-load-order-discipline-but-same-load-order-substrate.
