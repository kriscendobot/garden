---
title: §The-never-resolving-promise-as-trigger
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
const trigger = new Promise(() => {});
```

§A-Promise-with-an-executor-that-never-calls-resolve-or-reject. §Used-purely-as-a-test-fixture — §enables-the-async-hook's-init-callback to fire + §avoids-triggering-settlement-hooks.

§Borrowable-pattern: §use-a-never-resolving-promise-as-a-test-fixture-to-observe-construction-without-settlement. §The-Promise-is-a-side-effect-machine + §the-side-effect-of-construction-is-what-we-want + §the-side-effect-of-settlement-is-what-we-don't-want.

§Sibling to cycle 152 promise-kit memo-race.js's §primitive-fake-settled-record idiom — both designs §use-degenerate-Promise-shapes-as-test-fixtures.
