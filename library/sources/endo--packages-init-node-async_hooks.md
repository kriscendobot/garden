---
title: "@endo/init/node-async_hooks — Make Node async_hooks coexist with SES-frozen Promise.prototype; two strategies for symbol discovery; WeakMap fallback for frozen promises"
source-slug: endo--packages-init-node-async_hooks
url: https://github.com/endojs/endo/blob/master/packages/init/src/node-async_hooks.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/init/src/node-async_hooks.js
total-lines: 240
status: shipping
ingest-cycle: 225
ingest-date: 2026-06-08
lane: chat
---

# @endo/init/node-async_hooks

A 240-line file in `@endo/init` that bridges Node.js's `async_hooks` machinery with SES lockdown. Solves the §collision-between-Node's-per-promise-tracking-symbols and §SES-lockdown's-frozen-Promise.prototype.

## Key design moves

- **§Three-named-symbol-slots** (`async_id_symbol`, `trigger_async_id_symbol`, `destroyed`) discovered at runtime by description string.
- **§Two-strategies-for-async-hooks-symbol-discovery** with §cost-coverage-trade-off (findAsyncSymbolsFromAsyncResource is cheap but only gets two of three; findAsyncSymbolsFromPromiseCreateHook is expensive but complete) + §named-option `withDestroy` to pick between them.
- **§The-never-resolving-promise-as-trigger** (`new Promise(() => {})`) — observe construction without settlement.
- **§The-reset-hook-trick** — enable then immediately disable a no-op hook to disable Node's internal promise init hook.
- **§Named-Node-version-specific-workaround** (v14.16.2 destroyed-hook-exception). §Sixth-member of §runtime-version-or-environment-compat-hacks-and-disclosures family.
- **§WeakMap-fallback-for-frozen-promises** — `Reflect.defineProperty` failure routes to the fallback WeakMap; §use-the-failure-path-to-route-to-a-fallback.
- **§The-property-descriptor-factory** with §`disallowGet`-variant — `destroyed` is write-only.
- **§Reflect.defineProperty-returns-false-on-failure** (instead of throwing); §when-an-operation-might-fail-silently-via-return-false, §check-the-return-and-fall-back-without-throwing.
- **§The-setAsyncSymbol-three-case-logic** (unknown / first-time / subsequent same-or-different).
- **§The-destroy-hook-only-needs-to-exist-to-trigger-Node-installing-the-destroyed-symbol** — §when-the-platform's-behavior-depends-on-whether-you-passed-a-callback, §pass-the-empty-callback-to-trigger-the-behavior.
- **§Two-named-out-of-scope cases** (frozen-promise-reused-as-parent + node-version-not-mutating-promises) with §named-sentinel-return-value (`-2`).
- **§Debug-prints-left-as-commented-comments** — `process._rawDebug` bypasses SES-tamed console; §third-shape-of-debug-instrumentation-in-production-code.
- **§Module-pattern (closure-state + exported setup function)** vs class-pattern.

## Section files

- [§two-strategies-for-async-hooks-symbol-discovery + §never-resolving-promise-trigger + §reset-hook-trick + §WeakMap-fallback-for-frozen-promises](../sections/endo--packages-init-node-async_hooks--two-strategies-for-async-hooks-symbol-discovery-and-never-resolving-promise-trigger-and-reset-hook-trick-and-WeakMap-fallback-for-frozen-promises.md) — full source ingest.

## Ingest scope

Cycle 225 (chat-lane): full 240-line ingest as one section. Companion files in @endo/init (`node-async_hooks-patch.js` 4 lines + `node-async-local-storage-patch.js` 98 lines) are referenced but not deep-ingested. The async-hooks shim is the §pre-lockdown-property-installation discipline distinct from but parallel to §freeze-not-harden-with-named-correctness-argument.
