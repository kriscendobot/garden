---
title: §Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family
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

| Cycle | Source | Hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |
| 225 | @endo/init/node-async_hooks | Node v14.16.2 destroyed-hook-exception + WeakMap-fallback-for-frozen-promises |

§Six-different-environments. §The-pattern-now-spans-bigint-literals + babel-defaults + Node-streams + SES-versions + Node-ESM + Node-async_hooks-with-frozen-promises.
