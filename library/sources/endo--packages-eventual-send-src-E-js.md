---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/E.js
source_line_range: 1-273
file_commit: c88bc8311fee4965558a357d5dc6b5842ac65ffb
file_commit_date: 2026-04-07
file_commit_author: Turadg Aleahmad
comment_subject: E proxy-handler trio with this-receiver check and freezable-not-hardened proxy targets
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-second comment-fragment ingest (cycle 146). The
  user-facing surface of `@endo/eventual-send` — the file that
  exports `makeE(HandledPromise) → E` and produces the `E(x)`
  proxy used throughout @endo and Agoric.

  501 lines total; substantive code 1-273; rest is JSDoc
  typedefs. Last substantive touch 2026-04-07 by Turadg
  Aleahmad (TS any-short-circuit fix in commit `c88bc8311`);
  previous substantive touch by Kris Kowal in cycle 108's
  coordinated-update commit `e56bf00f` (@endo/harden adoption).

  Three-proxy-handler trio: `makeEProxyHandler` (E(x)) /
  `makeESendOnlyProxyHandler` (E.sendOnly(x)) /
  `makeEGetProxyHandler` (E.get(x)). All extend a shared
  §baseFreezableProxyHandler whose four meta-traps (set /
  isExtensible / setPrototypeOf / deleteProperty) all return
  `false`. §Return-false-not-throw preserves strict-mode
  invariants.

  Single most structurally interesting move: §this-receiver-
  check via concise-method-syntax. The dispatched function
  rejects with *Unexpected receiver* if `this !== receiver`,
  preventing method-detach attacks (`const m = E(x).method`
  doesn't work). §Concise-method-syntax-not-arrow gives the
  function its own `this`; §avoid-function-syntax keeps it
  non-constructable. §Computed-property-key-preserves-name
  idiom (`{ [propertyKey](...) { ... } }[propertyKey]`).
  §`@ts-expect-error` for microsoft/TypeScript#50319.

  §funcTarget + §objTarget — *`freeze` but not `harden` the
  proxy target so it remains trapping*. The §stabilize-
  discipline reference to packages/ses/docs/preparing-for-
  stabilize.md: a hardened object is fully-sealed and the V8
  Proxy short-circuit might bypass meta-traps. The proxies
  must intercept every property access, so targets stay
  `freeze`d, not `harden`ed, *and the comment specifies they
  should not be shared outside the module*.

  §Message-breakpoint integration: `onSend =
  makeMessageBreakpointTester('ENDO_SEND_BREAKPOINTS')` binds
  at module load. Cycle 130's tester. §Placement-at-the-call-
  site (vs cycle 132's placement-at-the-actual-delivery-point)
  — breakpoint stops *before* `applyMethod` runs so the
  developer can walk back the stack. §LOOK-UP-THE-STACK
  comment-as-debugger-instruction pattern. §`if (onSend && ...)`
  short-circuit honors cycle 130's zero-cost-when-unset.

  §Three-handler-asymmetry: EProxyHandler returns the
  HandledPromise; SendOnly returns `undefined` and validates
  via `||-Fail` synchronous throw (no return promise to
  reject); EGet has no `apply` trap (just `has` + `get`).
  §SendOnly-fire-and-forget + cycle 100's GC-driven rejection
  tracking is what catches lost SendOnly rejections.

  §makeE factory: §callable-with-methods discipline — E is
  both a function and an object. `harden(assign(fn, methods))`
  shape. Five-surface API: E(x).method() / E(x)() / E.get(x)
  / E.resolve(x) / E.sendOnly(x).method() / E.when(x, onf,
  onr).

  §E.when-wraps-trackTurns idiom: `trackTurns([onfulfilled,
  onrejected])` from cycle 90 annotates callbacks for cycle
  96's console.js causal-chain rendering.

  §has-trap-pretends-everything-exists discipline: identical
  in all three handlers. §unknown-shape-of-remote — `E(x)` has
  no type-level knowledge of what `x` is.

  §JSDoc-typedefs section (lines 277-501) types the runtime
  shape: ~20 typedefs including FarRef, DataOnly, ERef,
  EReturn, EResult, EAwaitedResult, ECallableReturn, ECallable,
  EMethods, EGetters, ESendOnlyCallable, ESendOnlyMethods,
  ESendOnlyCallableOrMethods, ECallableOrMethods, FilteredKeys,
  PickCallable, RemoteFunctions, LocalRecord, EPromiseKit,
  EOnly. §`0 extends (1 & T)` any-detector idiom propagates
  `any` cleanly (added in cycle 145's last touch). §TODO
  references microsoft/TypeScript#61838.

  Dependency cluster ties this file to four previously-
  ingested files: cycle 66 (HandledPromise handler protocol),
  cycle 90 (trackTurns), cycle 130 (message-breakpoints),
  cycle 132 (local.js — receiver-side breakpoint sister).
  Cycle 108's @endo/harden migration touched this file too.

  Cycle 146 was nominally papers-lane (cycle 145 was designs).
  Papers-lane blocked 40+ consecutive cycles; pivoted to
  comments-lane.
---

> Abstract: `E.js` (501 lines; substantive code 1-273; rest
> JSDoc) is the **user-facing surface** of `@endo/eventual-
> send`. Exports `makeE(HandledPromise) → E` — the proxy used
> as `E(x).method(...)` throughout @endo and Agoric.
>
> Three-proxy-handler trio (`makeEProxyHandler` / `makeESendOnlyProxyHandler`
> / `makeEGetProxyHandler`) sharing a §baseFreezableProxyHandler
> whose four meta-traps return false.
>
> **Single most structurally interesting move**: §this-
> receiver-check via concise-method-syntax — rejects with
> *Unexpected receiver* if `this !== receiver`. Prevents
> method-detach attacks. §Concise-method-syntax-not-arrow
> + §avoid-function-syntax + §computed-property-key-preserves-
> name + §`@ts-expect-error` for TS#50319.
>
> §funcTarget + §objTarget — *freeze-not-harden* so the proxy
> remains trapping. §Stabilize-discipline reference.
>
> §Message-breakpoint integration with cycle 130's tester;
> §placement-at-the-call-site (vs cycle 132's at-delivery).
>
> §makeE factory: callable-with-methods (E is both function
> and object). Five-surface API. §E.when-wraps-trackTurns
> from cycle 90.
>
> §JSDoc-typedefs section (lines 277-501) types ~20 surfaces.
> §`0 extends (1 & T)` any-detector idiom (added in commit
> `c88bc8311`).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets](../sections/endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets.md) | eventual-send, hardened-javascript, captp | current |

One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `c88bc8311fee4965558a357d5dc6b5842ac65ffb`) via the local
  bare-clone.
- Last substantive touch 2026-04-07 by Turadg Aleahmad in
  commit `c88bc8311` ("fix(eventual-send): short-circuit any
  in RemoteFunctions, PickCallable, ECallableOrMethods").
- Previous substantive touch by Kris Kowal in cycle 108's
  coordinated-update commit `e56bf00f` (Adopt @endo/harden).
- **Thirty-second comment-fragment ingest.**
- Cycle 146 was nominally **papers-lane** (cycle 145 was
  designs). Papers-lane has been blocked for **40+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle
  146 pivoted to comments-lane.
- One cohesion-honest section.
