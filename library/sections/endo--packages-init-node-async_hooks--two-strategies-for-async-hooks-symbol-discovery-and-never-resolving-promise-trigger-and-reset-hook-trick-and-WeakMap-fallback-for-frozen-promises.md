---
title: "@endo/init/node-async_hooks — §two-strategies-for-async-hooks-symbol-discovery + §never-resolving-promise-as-trigger + §reset-hook-trick + §WeakMap-fallback-for-frozen-promises + §debug-prints-left-as-commented-comments + §named-Node-version-specific-workarounds"
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
kind: index
section_count: 16
---

Sections:

- [@endo/init/node-async_hooks — Make Node async_hooks coexist with SES-frozen Promise.prototype](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--endo-init-node-async-hooks-mak.md)
- [§The-three-symbols-async_hooks-needs](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-three-symbols-async-hooks-needs.md)
- [§Two-strategies-for-async-hooks-symbol-discovery](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--two-strategies-for-async-hooks-symbol-discovery.md)
- [§The-never-resolving-promise-as-trigger](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-never-resolving-promise-as-trigger.md)
- [§The-reset-hook-trick](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-reset-hook-trick.md)
- [§The-WeakMap-fallback-for-frozen-promises](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-weakmap-fallback-for-frozen-promises.md)
- [§The-property-descriptor-factory with §disallowGet-variant](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-property-descriptor-factor.md)
- [§The-debug-prints-left-as-commented-comments](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-debug-prints-left-as-commented-comments.md)
- [§Two-named-out-of-scope cases](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--two-named-out-of-scope-cases.md)
- [§The-setAsyncSymbol-three-case-logic](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-setasyncsymbol-three-case-logic.md)
- [§The-PromiseProto.defineProperty-on-three-symbols](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-promiseproto-defineproperty-on-three-symbols.md)
- [§The-file-must-run-before-lockdown](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-file-must-run-before-lockdown.md)
- [§The-module-pattern-vs-class-pattern](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--the-module-pattern-vs-class-pattern.md)
- [Related material in the library](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--related-material-in-the-library.md)
- [§Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--six-different-runtime-version.md)
- [§Three-different-shapes-for-debug-instrumentation-in-production-code](endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises--three-different-shapes-for-deb.md)
