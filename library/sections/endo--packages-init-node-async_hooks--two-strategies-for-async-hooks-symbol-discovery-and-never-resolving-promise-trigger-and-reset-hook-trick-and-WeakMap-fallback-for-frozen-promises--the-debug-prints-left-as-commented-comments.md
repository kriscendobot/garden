---
title: §The-debug-prints-left-as-commented-comments
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
// process._rawDebug(
//   `Found duplicate ${description}:`,
//   symbol,
//   asyncHooksSymbols[description],
// );

// process._rawDebug('Found multiple potential candidates');

// process._rawDebug('No candidates matched');

// process._rawDebug(`Async symbols not found, moving on`);

// process._rawDebug(`Couldn't find destroyed symbol to setup trap`);

// process._rawDebug('fallback set of async id', symbol, value, Error().stack);
```

§Six-named-debug-prints commented out throughout the file. §Borrowable-pattern: §debug-prints-left-as-commented-comments-for-easy-reactivation. §When-the-bug-recurs-the-developer-uncomments-them.

§process._rawDebug-not-console.log because §the-console-might-be-tamed-by-SES + §process._rawDebug-bypasses-Node's-console.

§Sibling to cycle 90 track-turns.js's §`__HIDE_`-prefix discipline — both designs §keep-debug-instrumentation-near-the-code-it-instruments without making it production noise. §Cycle-90-prefixes-functions; §cycle-225-comments-out-the-call-sites.

§Borrowable-pattern: §three-different-shapes-for-debug-instrumentation-in-production-code:
- Cycle 90: §`__HIDE_`-prefix-hides-from-stack-traces + active in production but invisible.
- Cycle 130 message-breakpoints: §env-option-gated breakpoint tester + active only when ENV var set.
- Cycle 225: §commented-out-debug-prints + inactive but easy-to-reactivate.
