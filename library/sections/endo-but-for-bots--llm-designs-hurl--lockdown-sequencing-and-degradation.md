---
title: Lockdown sequencing + degradation on hosts without URL
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: "No new lockdown phase" is the load-bearing constraint — the shim hooks into existing intrinsics-collection + whitelisting pipeline, not a new one. The XS-degradation path uses the same skip-when-missing logic that already handles other absent intrinsics. The `sampleHiddenIntrinsics` helper guards against `URLSearchParams` being absent.
---

> Abstract: **Lockdown sequencing** — no new lockdown phase needed: (1) `getGlobalIntrinsics` collects `URL` + `URLSearchParams` from the host global; (2) intrinsics-installation routes the host's `URL` into `%URL%` on `initialGlobalPropertyNames` (start compartment) AND into `%SharedURL%` on `sharedGlobalPropertyNames` (post-lockdown compartments) — both bound to `globalThis.URL`, constructor functions sharing the same `prototype` value; (3) `getAnonymousIntrinsics` (already the home of `%IteratorPrototype%`, `%AsyncIteratorPrototype%`) gains a `sampleHiddenIntrinsics` call for the URL search-params iterator prototype; (4) the whitelist pass walks the permits graph, the `%SharedURL%` row removes `createObjectURL`/`revokeObjectURL` from the shared binding, the `%URL%` row leaves them on the start compartment (unless `urlBlobMethods: 'remove'` is set, in which case `%SharedURL%` applies to start compartment too). **Sampling and degradation on hosts without URL**: `packages/ses/src/intrinsics.js`'s `sampleGlobals(globalThis, universalPropertyNames)` already tolerates missing properties — a permit absent on the global is simply skipped. On XS (where `URL` and `URLSearchParams` are not defined), lockdown proceeds without them; compartments observe their absence exactly as today. Iterator-prototype sampling guards against `URLSearchParams` being absent: a `sampleHiddenIntrinsics` helper that checks `typeof globalObject.URLSearchParams === 'function'` before constructing the probe instance.

### Sampling and degradation on hosts without `URL`

`packages/ses/src/intrinsics.js`'s `sampleGlobals(globalThis, universalPropertyNames)` already tolerates missing properties: a permit whose name is absent on the global is simply skipped. The shim relies on this behavior. On XS, where `URL` and `URLSearchParams` are not defined, lockdown proceeds without them and compartments observe their absence exactly as they do today.

The iterator-prototype sampling step must guard against the `URLSearchParams` constructor being absent. A small helper:

```js
const sampleHiddenIntrinsics = globalObject => {
  const intrinsics = { __proto__: null };
  if (typeof globalObject.URLSearchParams === 'function') {
    const params = new globalObject.URLSearchParams();
    intrinsics['%URLSearchParamsIteratorPrototype%'] =
      Object.getPrototypeOf(params.entries());
  }
  return intrinsics;
};
```

The result merges into the intrinsics map before the whitelist pass.

### Lockdown sequencing

The new permits and the iterator-prototype sampler hook into the existing `intrinsics.js` flow with no new lockdown phase:

1. `getGlobalIntrinsics` collects `URL` and `URLSearchParams` from the host global.
2. The intrinsics-installation step routes the host's `URL` into the `%URL%` intrinsic on `initialGlobalPropertyNames` (start compartment, bound to `globalThis.URL`) and into a second intrinsic `%SharedURL%` on `sharedGlobalPropertyNames` (post-lockdown compartments, also bound to `globalThis.URL`). Both intrinsics reference constructor functions that share the same `prototype` value.
3. `getAnonymousIntrinsics` (already the home of `%IteratorPrototype%`, `%AsyncIteratorPrototype%`, etc.) gains a call to `sampleHiddenIntrinsics` for the URL search-params iterator.
4. The whitelist pass walks the permits graph. The `%SharedURL%` permits row removes `createObjectURL` and `revokeObjectURL` from the shared binding. The `%URL%` permits row leaves them in place on the start compartment unless the `urlBlobMethods: 'remove'` lockdown option is set, in which case the `%SharedURL%` permits row applies to the start compartment too.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
