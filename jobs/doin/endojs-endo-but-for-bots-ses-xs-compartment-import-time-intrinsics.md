---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `master`, per the endojs/endo#3322 lineage of PR #1349). Open a DRAFT PR fixing a SES-for-XS hardening hole found while fixing PR #1349 (https://github.com/endojs/endo-but-for-bots/pull/1349).

Defect: on XS, the post-lockdown `Compartment` is `adaptCompartmentConstructors(NativeStartCompartment, ShimStartCompartment, harden)` (`packages/ses/src-xs/lockdown-shim.js`), and `ShimStartCompartment` is built with `getGlobalIntrinsics(globalThis, …)` at module import time (`packages/ses/src-xs/compartment.js:39-43`). On Node, `lockdown()` rebuilds the compartment constructor from the lockdown intrinsics (`src/lockdown.js` `setGlobalObjectMutableProperties`). So on XS, a universal global replaced or deleted between `import 'ses'` and `lockdown()` leaks the import-time (feral, never-hardened) value into every child compartment.

Reproducer (bundle with the `xs` tag like `packages/ses/scripts/generate-test-xs.js`, run under xst):
```js
import 'ses';
delete globalThis.TextEncoder;
lockdown();
const T = new Compartment().evaluate('TextEncoder');
print(typeof T, Object.isFrozen(T), Object.isFrozen(T.prototype)); // function false false
```
Expected: `undefined` (Node behavior, see `packages/ses/test/text-encoder-decoder-missing.test.js`), or at minimum a hardened object. Fix so XS samples compartment global intrinsics at lockdown (as Node does), add an XS smoke assertion, and a changeset (patch, `ses`). Once fixed, PR #1349's `_xs-delete-text-codecs.js` pre-import module could be folded back into the fixture after `import 'ses'`; mention that in the PR, don't edit #1349.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T09:56:41Z
