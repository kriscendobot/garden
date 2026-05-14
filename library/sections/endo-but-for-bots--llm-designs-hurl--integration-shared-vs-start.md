---
title: Integration — %URL% on start, %SharedURL% on shared (Date-style split + lockdown opt-in + cross-compartment instanceof)
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
notes: The Date-style split (initialGlobalPropertyNames vs sharedGlobalPropertyNames) is the canonical SES pattern for "host-provided powered constructor + powerless variant" — same as %Date% / %SharedDate%, %Symbol% / %SharedSymbol%, %Error% / %SharedError%, %RegExp% / %SharedRegExp%. The "shared prototype across compartments" choice is the cross-compartment-instanceof tradeoff; the alternative (distinct chains) is flagged in open questions.
---

> Abstract: `packages/ses/src/permits.js` distinguishes three relevant buckets: **universalPropertyNames** (powerless data + constructors on every global), **initialGlobalPropertyNames** (powered variants on the start compartment only — Date, Error, RegExp, Math), **sharedGlobalPropertyNames** (tamed powerless variants on every post-lockdown compartment). `URL.createObjectURL`/`revokeObjectURL` are ambient authority the start compartment can reasonably keep but shared compartments must not see — exactly the Date-style split. **Chosen integration**: `%URL%` on `initialGlobalPropertyNames` (start compartment, bound to `globalThis.URL`, includes createObjectURL/revokeObjectURL); `%SharedURL%` on `sharedGlobalPropertyNames` (every shared compartment, bound to `globalThis.URL`, omits the blob methods). Both share the same `prototype` value so `instanceof URL` works across the boundary. **Lockdown opt-in `urlBlobMethods: 'remove'`** collapses the split for embeddings with no blob-URL use (server-side, XS, Electron main process): the start compartment's URL also gets `%SharedURL%` permits. Default `'keepOnInitialGlobal'` because removing a host-provided method is more disruptive than introducing a second bound name. **Cross-compartment instanceof**: shared prototype is the simplest fix; cost is that `Foo.constructor === URL` gets a different answer depending on origin compartment. Alternative (distinct prototype chains, push burden onto cross-compartment helpers) is flagged in open questions. Recommend shared-prototype unless maintainer prefers strict separation.

## Design

### Integration: full `URL` on the start compartment, tamed `%SharedURL%` on shared compartments

`packages/ses/src/permits.js` distinguishes three relevant buckets:

- `universalPropertyNames`: powerless data and constructors that live on every global (the start compartment and every compartment created after lockdown).
- `initialGlobalPropertyNames`: the powered variants that live only on the start compartment (`Date`, `Error`, `RegExp`, `Math`).
- `sharedGlobalPropertyNames`: the tamed, powerless variants of those same names, installed on every compartment created after lockdown.

`URL.createObjectURL` and `URL.revokeObjectURL` are ambient authority that the start compartment can reasonably keep (a host application often needs to mint blob URLs from its own data) but which shared compartments must not see. This is exactly the `Date`-style split: the start compartment keeps the host's full `URL`; every shared compartment receives a tamed constructor under the same name `URL` that omits the dangerous static methods. SES names the tamed intrinsic `%SharedURL%`, mirroring the existing `%SharedSymbol%`, `%SharedDate%`, `%SharedError%`, and `%SharedRegExp%` intrinsics on `sharedGlobalPropertyNames`.

The chosen integration is therefore:

- **`%URL%` on `initialGlobalPropertyNames`** (start compartment only), bound to `globalThis.URL`. Full host shape, including `createObjectURL` and `revokeObjectURL`. Hardened in place; the static methods themselves remain callable.
- **`%SharedURL%` on `sharedGlobalPropertyNames`** (every shared compartment), bound to `globalThis.URL`. The constructor permits omit `createObjectURL` and `revokeObjectURL`. `%URL%` and `%SharedURL%` share the same `prototype` value so that an instance constructed in either compartment is `instanceof URL` in either compartment.

Consumer code in any compartment continues to write `new URL(...)`; the start compartment's `URL` is the powered binding and every shared compartment's `URL` is the tamed binding.

This mirrors the way SES handles `Date`: the powered constructor lives on `initialGlobalPropertyNames`, the powerless variant on `sharedGlobalPropertyNames`, both produced from the same host intrinsic during the intrinsics-collection pass.

#### Lockdown opt-in to conflate `%URL%` and `%SharedURL%`

A class of embeddings has no use for `createObjectURL` even on the start compartment (server-side, XS, an Electron main process that will never load a `Blob`). For these embeddings, an opt-in lockdown option collapses the split:

```js
lockdown({
  // ... other options ...
  urlBlobMethods: 'remove',  // default: 'keepOnInitialGlobal'
});
```

When `urlBlobMethods: 'remove'`, the start compartment's `URL` is also bound to `%SharedURL%`, and `createObjectURL` / `revokeObjectURL` are removed everywhere. This restores the simpler "`URL === URL` across compartments" model for embeddings that want it.

The default is `'keepOnInitialGlobal'` because removing a host-provided method from the start compartment is more disruptive than introducing a second bound name.

#### Cross-compartment `instanceof`

Because `%URL%` and `%SharedURL%` share the same `prototype` value, a URL constructed on the start compartment and passed to a shared compartment satisfies `x instanceof URL` there (where `URL` is the shared compartment's tamed binding). A URL constructed in a shared compartment and passed back to the start compartment likewise satisfies `x instanceof URL` there (where `URL` is the start compartment's powered binding).

This is an **open question**: shared identity at the prototype level is the simplest fix, but it means the two constructor functions are distinct values, and any code that compares `Foo.constructor === URL` will get a different answer depending on where the value originated. The alternative is to make `%URL%` and `%SharedURL%` distinct prototype chains and accept that `instanceof URL` is unreliable across the boundary; that pushes the burden onto cross-compartment helper libraries. Recommend the shared-prototype approach unless the maintainer prefers the strict separation.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
