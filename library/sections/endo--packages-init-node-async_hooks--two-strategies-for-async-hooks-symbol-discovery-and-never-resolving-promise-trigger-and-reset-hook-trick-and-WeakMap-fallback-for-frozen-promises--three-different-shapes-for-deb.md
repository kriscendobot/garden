---
title: §Three-different-shapes-for-debug-instrumentation-in-production-code
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

| Cycle | Source | Mechanism |
|-------|--------|-----------|
| 90 | track-turns.js | §`__HIDE_`-prefix on function names (hides from stack traces) |
| 130 | message-breakpoints.js | §env-option-gated breakpoint tester (active only when ENV var set) |
| 225 | node-async_hooks.js | §commented-out-debug-prints (inactive but easy to reactivate) |

§Three-different-approaches: hide-from-trace + opt-in-via-env + comment-then-uncomment.
