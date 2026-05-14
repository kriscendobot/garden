---
title: Comparison to @endo/url + tests + compatibility + phases + decisions + open questions
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, repository-governance]
status: current
notes: The "tame inside SES, not as an external shim" decision is the load-bearing structural call — folding into SES intrinsics pipeline avoids opt-in fragmentation AND avoids duplicating the whitelisting machinery in a per-package shim. The "no polyfill in this design" decision keeps XS users without URL but accepts a future @endo/url polyfill as a layerable addition. All three phases are S-sized.
---

> Abstract: **Comparison to original `@endo/url` package proposal**: earlier sketch was an `@endo/url` package with `shim.js` for `@endo/init`; each consumer would opt in by importing the shim before lockdown. Two drawbacks: (1) opt-in fragmentation — some compartments would have URL, others not, depending on whether the shim loaded before lockdown; library authors can't rely on URL being present; (2) out-of-band intrinsic — a URL installed by external shim is not visited by `intrinsics.js`'s permits graph, so the iterator-prototype problem must be solved with bespoke duplicate-whitelisting code. **Folding into SES**: every compartment gets the appropriate constructor; existing permits/whitelist pipeline does the taming in one place. **Residual `@endo/url` use case**: a polyfill for hosts (XS) wanting a JS URL implementation — separate design, out of scope here; would compose cleanly (polyfill installs URL on globalThis before lockdown; SES permits then tame it). **Test plan**: 9 tests covering presence on start + shared compartments, shared prototype + cross-compartment instanceof, `urlBlobMethods: 'remove'` opt-in, frozen-everything, iterator-prototype tampering rejection, round-trip semantics, host without URL degradation, XS smoke test. **Compatibility**: code monkey-patching URL throws (must do it before lockdown like other intrinsics); browser blob-URL workflow broken — must obtain createObjectURL from host pre-lockdown and explicitly endow into the compartment that needs it (this is the explicit goal: moving ambient authority to deliberate capability); `lib.dom.d.ts` typedefs declare the removed methods, will compile-but-fail-at-runtime in downstream packages (no fix here; downstream adds capability shims); `URLSearchParams` iterable-arg constructor not new attack surface (all major host impls consume the iterable strictly and store string copies). **Phases**: all S-sized — Phase 1 permits + sampling, Phase 2 tests + changeset, Phase 3 downstream audit (grep for `URL.createObjectURL` / `URL.revokeObjectURL` / `new URL(` in compartment code). **7 design decisions** + 2 open questions (synthetic-intrinsic name; cross-compartment instanceof direction).

### Comparison to the original `@endo/url` package proposal

The earlier sketch proposed an `@endo/url` package with a `shim.js` for `@endo/init`. Each package consumer would opt in by importing the shim before calling `lockdown()`. That approach has two drawbacks:

1. **Opt-in fragmentation.** Some compartments would have `URL`, others would not, depending on whether the shim was loaded before lockdown. Library authors cannot rely on `URL` being present in the compartments their code runs in.

2. **Out-of-band intrinsic.** A `URL` installed by `@endo/url/shim.js` is not visited by `intrinsics.js`'s permits graph, so the iterator-prototype problem must be solved inside the shim with bespoke code that duplicates SES's whitelisting machinery.

Folding the work into the SES intrinsics pipeline (`%URL%` on `initialGlobalPropertyNames`, `%SharedURL%` on `sharedGlobalPropertyNames`, both bound to `globalThis.URL`) solves both: every compartment in every embedding gets the appropriate constructor, and the existing permits/whitelist pipeline does the taming in one place. The cost is a small, host-dependent contribution to the SES bundle and to lockdown time, but the contribution is paid only when the host actually provides `URL`.

A residual case for an `@endo/url` package remains: a polyfill for hosts (XS) that want a JavaScript `URL` implementation. That is a separate design and out of scope here. The vetted shim and a future polyfill compose: the polyfill installs `URL` on `globalThis` before lockdown, and the SES permits then tame it like any other host-provided `URL`.

### Test plan

Tests live under `packages/ses/test/`.

1. **Presence on the start compartment.** `globalThis.URL` is a function after lockdown. `'createObjectURL' in URL` and `'revokeObjectURL' in URL` are both `true` (default `urlBlobMethods: 'keepOnInitialGlobal'`).
2. **Presence on shared compartments.** In a fresh compartment created post-lockdown, `compartment.evaluate('typeof URL')` returns `'function'` when the host provides URL, `'undefined'` otherwise. Same for URLSearchParams. `'createObjectURL' in compartment.globalThis.URL` is `false`.
3. **Shared prototype across compartments.** Start compartment's `URL.prototype === shared.URL.prototype`. An instance constructed on one side satisfies `instanceof URL` on the other.
4. **Lockdown opt-in `urlBlobMethods: 'remove'`.** When `lockdown({ urlBlobMethods: 'remove' })`, `'createObjectURL' in URL` is `false` on the start compartment. Start and shared `URL` are `===`.
5. **Frozen.** `Object.isFrozen(URL)`, `URL.prototype`, `URLSearchParams.prototype`, and `Object.getPrototypeOf(new URLSearchParams().entries())` all `true`.
6. **Iterator-prototype tampering rejected.** `Object.getPrototypeOf(new URLSearchParams().entries()).next = () => {}` throws (frozen). Second compartment unaffected.
7. **Round-trip semantics preserved.** `new URL('http://example.com/a?b=1').searchParams.get('b') === '1'`.
8. **Host without URL.** Test deletes `globalThis.URL` + `globalThis.URLSearchParams` before lockdown; no throw, no bindings post-lockdown.
9. **XS smoke test.** Existing XS runner exercises (2) and (8) on a host that never provided URL.

### Compatibility considerations

- **Code that monkey-patches `URL`** (e.g., `URL.foo = ...`) throws after lockdown; mutation must precede lockdown (same rule as every other intrinsic). Note in changeset.
- **Code that uses `URL.createObjectURL`**: browser blob-URL workflow broken in any compartment whose URL came from SES. Code that needs `createObjectURL` must obtain it from the host before lockdown and explicitly endow a wrapper into the compartment that needs it. **This is the explicit goal**: dangerous method moved from ambient authority to deliberate capability.
- **Type definitions**: `lib.dom.d.ts` declares `createObjectURL`/`revokeObjectURL` as static methods. Downstream packages compile against `lib.dom.d.ts` will compile but fail at runtime under SES. No fix here; downstream adds capability shims.
- **URLSearchParams constructor accepting iterables**: takes a sequence of `[name, value]` pairs. A malicious iterable whose `next()` mutates shared state isn't a new attack surface — all major host impls consume strictly and store string copies. Worth noting in test plan.

## Related work

| Design | Relationship |
|---|---|
| `base64-native-fallthrough.md` | Same family: tame and dispatch to native intrinsics inside SES rather than re-implement in JS. |
| `hex-package.md` | Same family: ponyfill-shim pattern around a TC39 native. The URL shim is the SES-internal analogue. |

## Phases

**Phase 1: Permits and sampling (S)** — extend `permits.js` with `%URL%` + `%SharedURL%` + `%URLSearchParams%` + `%URLSearchParamsIteratorPrototype%`; plumb `urlBlobMethods` opt-in; extend `get-anonymous-intrinsics.js` (or equivalent) for iterator-prototype sampling; update whitelist pass if needed.

**Phase 2: Tests and changeset (S)** — test cases from the plan; changeset describing tamed intrinsics + `urlBlobMethods` option + removed methods + host-without-URL behavior.

**Phase 3: Downstream audit (S)** — grep monorepo for `URL.createObjectURL` and `URL.revokeObjectURL` (none should remain in code that runs under SES); grep for `new URL(` in compartment-running code (newly enabled, candidates for simplification).

## Design Decisions

1. **`%URL%` on start, `%SharedURL%` on shared.** Date-style split — smallest change that captures both intents (host app keeps powered binding; shared compartments get powerless variant). Both bound to `globalThis.URL` so consumer code is identical. Naming follows `%SharedSymbol%`/`%SharedDate%`/`%SharedError%`/`%SharedRegExp%` precedent.
2. **Lockdown opt-in to conflate.** `urlBlobMethods: 'remove'` collapses for embeddings with no blob use; default keeps host-provided start shape.
3. **Tame inside SES, not as an external shim.** Iterator-prototype hazard is an SES whitelisting concern; centralizing in `permits.js` avoids duplicating whitelisting machinery.
4. **TextEncoder/TextDecoder split to sibling design.** Same source issue but no implementation overlap.
5. **No polyfill in this design.** XS users continue without URL; a future `@endo/url` polyfill can layer cleanly.
6. **Permit `URL.parse`, `URL.canParse`, iterator prototype's `[Symbol.toStringTag]`.** Pure helpers admitted; absence on older hosts handled by skip-when-missing.
7. **Bundle-size impact negligible.** Tens of lines of permits + one sampler + one boolean check. No measurement required.

## Open questions

1. **Synthetic-intrinsic name**: `%URLSearchParamsIteratorPrototype%` mirrors the `%IteratorPrototype%` convention. Shorter alternative?
2. **Cross-compartment `instanceof`**: shared-prototype is the recommendation (single prototype value across compartments → instanceof works); cost is `Foo.constructor === URL` gives different answers depending on origin compartment. Alternative: distinct prototype chains, push burden onto cross-compartment helpers.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
