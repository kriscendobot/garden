---
title: §The-reset-hook-trick
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
if (promiseData) {
  // ...
  const resetHook = createHook({});
  resetHook.enable();
  resetHook.disable();
} else if (length) {
  // process._rawDebug('No candidates matched');
}
```

§Enable-then-immediately-disable-a-no-op-hook. §The-side-effect: it disables Node's internal promise init hook that would otherwise §fire-on-promises-created-in-this-turn-even-after-the-bootstrapHook-is-disabled.

§The-honest-comment:

> Normally all promise hooks are disabled in a subsequent microtask. That means Node versions that modify promises at init will still trigger our proto hooks for promises created in this turn. The following trick will disable the internal promise init hook.

§Followed-by-a-known-exception:

> However, only do this for destroy modifying versions, since some versions only modify promises if no destroy hook is requested, and do not correctly reset the internal init promise hook in those case. (e.g. v14.16.2)

§Borrowable-pattern: §the-`enable()-then-disable()`-no-op-trick reuses §a-platform-API's-side-effect-without-the-API's-purpose. §The-trick-is-conditional + §named-Node-version-where-it-doesn't-work (v14.16.2).

§Sibling to cycle 217 @endo/errors' §two-comment-out-lines (`'bare'` + `'makeError'`) — both designs §named-tolerance-for-a-specific-runtime-version. §Cycle-225-is-the-sixth-member of §runtime-version-or-environment-compat-hacks-and-disclosures family.

§Six-different-runtime-version-or-environment-compat-hacks-and-disclosures family:
| Cycle | Source | Hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |
| 225 | @endo/init/node-async_hooks | Node v14.16.2 destroyed-hook-exception |

§Six-different-environments. §The-pattern-now-spans-bigint-literals + babel-defaults + Node-streams + SES-versions + Node-ESM + Node-async_hooks.
