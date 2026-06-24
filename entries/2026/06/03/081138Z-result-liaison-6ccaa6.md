---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--6ccaa6
ts: 2026-06-03T08:11:38Z
ref_id: 6ccaa6
---

# Cycle 146 result — packages/eventual-send/src/E.js (thirty-second comment-fragment ingest)

Cycle 146 of the librarian arc. Nominally papers-lane (cycle 145 was
designs-lane); papers-lane has been blocked for **40+ consecutive
cycles**. Pivoted to comments-lane.

## Source

`endo/packages/eventual-send/src/E.js` (501 lines total; substantive
code 1-273; rest JSDoc typedefs). Last substantive touch 2026-04-07
by Turadg Aleahmad in commit `c88bc8311` ("fix(eventual-send):
short-circuit any in RemoteFunctions, PickCallable,
ECallableOrMethods"). Previous substantive touch by Kris Kowal in
cycle 108's coordinated-update commit `e56bf00f` (Adopt @endo/harden).

The **user-facing surface** of `@endo/eventual-send` — exports
`makeE(HandledPromise) → E`, the proxy used as `E(x).method(...)`
throughout @endo and Agoric code.

## Structural moves captured

- **Three-proxy-handler trio**: `makeEProxyHandler` (E(x)) /
  `makeESendOnlyProxyHandler` (E.sendOnly(x)) /
  `makeEGetProxyHandler` (E.get(x)) sharing
  §baseFreezableProxyHandler (four meta-traps return `false`).

- **§this-receiver-check via concise-method-syntax** — the single
  most structurally interesting move. Dispatched function rejects
  with *Unexpected receiver* if `this !== receiver`, preventing
  method-detach attacks. §Concise-method-syntax-not-arrow gives the
  function its own `this`; §avoid-function-syntax keeps it
  non-constructable; §computed-property-key-preserves-name idiom.

- **§funcTarget + §objTarget** — *`freeze` but not `harden` the
  proxy target so it remains trapping*. §Stabilize-discipline
  reference to packages/ses/docs/preparing-for-stabilize.md. A
  hardened target might trigger V8 Proxy short-circuits and bypass
  meta-traps; the proxies *must* intercept every property access.

- **§Message-breakpoint integration** with cycle 130's tester
  (`ENDO_SEND_BREAKPOINTS`). §Placement-at-the-call-site (vs cycle
  132's at-delivery). §LOOK-UP-THE-STACK comment-as-debugger-
  instruction. §Zero-cost-when-unset short-circuit honors cycle 130's
  property.

- **§Three-handler-asymmetry** — EProxyHandler returns the
  HandledPromise; SendOnly returns `undefined` and *synchronously
  throws* via `||-Fail` (no return promise to reject); EGet has no
  `apply` trap. §SendOnly-fire-and-forget — cycle 100's GC-driven
  rejection-tracking catches lost SendOnly rejections.

- **§makeE factory**: §callable-with-methods discipline — E is both
  a function and an object via `harden(assign(fn, methods))`.
  Five-surface API. §E.when-wraps-trackTurns from cycle 90.

- **§JSDoc-typedefs section** (lines 277-501) types ~20 surfaces
  (FarRef, DataOnly, ERef, EReturn, EResult, EAwaitedResult,
  ECallableReturn, ECallable, EMethods, EGetters, ESendOnlyCallable,
  ESendOnlyMethods, ESendOnlyCallableOrMethods, ECallableOrMethods,
  FilteredKeys, PickCallable, RemoteFunctions, LocalRecord,
  EPromiseKit, EOnly). §`0 extends (1 & T)` any-detector idiom
  (added in 2026-04-07 commit).

## Dependency cluster

Ties this file to four previously-ingested files:

- cycle 66 ([[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]])
- cycle 90 (trackTurns)
- cycle 130 (message-breakpoints)
- cycle 132 (local.js — receiver-side breakpoint sister)
- cycle 108's @endo/harden migration touched this file too

## Output summary

- **Source slug**: `endo--packages-eventual-send-src-E-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets.md`
- **Topics**: eventual-send, hardened-javascript, captp
- **Library totals**: 650 sections from 191 source documents
- **Lane rotation**: nominally papers-lane (40+ consecutive blocks);
  pivoted to comments-lane

Cycle 146 closes. Schedule next wake 1500s for cycle 147.
