---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §JSDoc typedefs (lines 277-501) — §the type-level shape of E
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

Lines 277-501 are JSDoc typedefs that *type* the runtime shape:

- `FarRef<Primary, Local>` — far-reference brand
- `DataOnly<T>` — record-of-non-callable-properties
- `ERef<T>` — `T | PromiseLike<T>` (cycle 66's eventual-or-not idiom)
- `EReturn<T>` — `Awaited<ReturnType<T>>` for callable T
- `EResult<T>` — `Awaited<T>` (alias)
- `EAwaitedResult<T>` — *Experimental* recursive remote-mapping
- `ECallableReturn<T>` — eventual-callable return type
- `ECallable<T>` — callable signature with promise return
- `EMethods<T>` — record of callables → eventual-callables
- `EGetters<T>` — record of T → record of `Promise<Awaited<T[P]>>`
- `ESendOnlyCallable<T>` — SendOnly variant: returns `Promise<void>`
- `ESendOnlyMethods<T>` — record of SendOnly callables
- `ESendOnlyCallableOrMethods<T>` — union of callable + methods
- `ECallableOrMethods<T>` — union of callable + methods
- `FilteredKeys<T, U>` — keys of T whose values extend U
- `PickCallable<T>` — root callable or record of callable properties
- `RemoteFunctions<T>` — *callable-properties of a remotable*
- `LocalRecord<T>` — *local properties of a remotable*
- `EPromiseKit<R>` — `{ promise: Promise<R>, settler: Settler<R> }`
- `EOnly<T>` — *near-but-must-use-E* type marker

The §`0 extends (1 & T)` any-detector idiom (lines 326, 345, 401,
413, 442, 455): TypeScript can't otherwise distinguish `any` from
other types. `(1 & T)` is `any` if T is `any`; `0 extends any` is
true. Used to *propagate `any` cleanly* rather than collapsing
through distributive Pick<any, string>. Cycle 145's last touch
(commit `c88bc8311`) added this idiom in multiple places.

The §`TODO: Figure out a way to map generic callable return types`
comment (line 353) references microsoft/TypeScript#61838 — without
that, `E(startGovernedUpgradable)` in agoric-sdk doesn't propagate
the start function type. The §honest-acknowledgment-of-TS-limitations
discipline.
