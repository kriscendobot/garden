---
source: packages/eventual-send/src/local.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-06-03
re-ingested: 2026-06-15
ingested_by: scholar (cycle 132) + liaison (cycle 352)
section_count: 2
status: current
notes: |
  Twenty-fifth comment-fragment ingest. 139-line file by Kris
  Kowal in commit `e56bf00f` — same coordinated-update wave as
  cycles 108, 110, 115, 118, 123, 125 (the `e56bf00f` cluster
  spans exo-makers, copySet, copyBag, exo-tools, merge-set-
  operators, merge-bag-operators, and now local.js). Direct
  consumer of cycle 130's `makeMessageBreakpointTester`.

  Three exports correspond to HandledPromise's three local
  dispatches:
    - `localApplyFunction(recipient, args)` — eventual function
      call `E(recipient)(...args)`
    - `localApplyMethod(recipient, methodName, args)` — eventual
      method call `E(recipient).methodName(...args)`; when
      methodName is null/undefined, dispatches to
      `localApplyFunction` (the §base-case-bottom-out-to-apply-
      functions discipline)
    - `localGet(t, key)` — eventual property access `E.get(t,
      key)`; simplest of the three, just `t[key]`

  Plus the public `getMethodNames(val)` introspection helper.

  §makeMessageBreakpointTester consumer: instantiated at module
  load with env-option name `ENDO_DELIVERY_BREAKPOINTS`. Two
  identical debugger-breakpoint blocks (in localApplyFunction
  and localApplyMethod) carry identical inline comments:
  *Stopped at a breakpoint on this delivery of an eventual
  method call so that you can step *into* the following `apply`
  in order to see the method call as it happens. Or step *over*
  to see what happens after the method call returns*. The
  §STEP-INTO-APPLY-comment-pair is the *user-facing affordance*
  — when the debugger pauses, the inline comment tells the
  developer exactly what to do next.

  §The placement-at-the-actual-delivery-point: breakpoints fire
  right before the `apply` call, not at the call site. This
  solves cycle 130's *async-call-debugging-pain-point*: the
  eventual-send call site is somewhere else in the codebase,
  often after an async hop; the debugger pauses at the
  receiver's dispatch so the developer can inspect the
  recipient's state at the moment of dispatch.

  §getMethodNames prototype-walk: while-loop collects names
  across the chain into a Set (deduplicates); four structurally
  interesting moves:
    (1) §Set-to-deduplicate across prototype layers;
    (2) §Test-val-name-rather-than-layer-name — *in case a
        method is overridden by a non-method, test `val[name]`
        rather than `layer[name]`* (respect subclass overrides);
    (3) §Stop-at-Object-prototype — `while (layer !== null &&
        layer !== Object.prototype)` doesn't enumerate
        `Object.prototype`'s methods (toString, hasOwnProperty,
        etc.) — the §don't-leak-Object-prototype-methods
        discipline;
    (4) §Primitive-early-exit — `if (isPrimitive(val)) break`
        stops the walk when value is a primitive.
  §compareStringified sort *prioritizes symbols as earlier than
  strings* — symbol-keyed methods sort before string-named.

  §isPrimitive duplication TODO: *Consolidate with isPrimitive
  that's currently in @endo/pass-style. Layering constraints
  make this tricky, which is why we haven't yet figured out how
  to do this.* The *cyclic-dependency-between-packages* problem
  prevents consolidation; the duplication is the *acknowledged-
  cost-of-layering* discipline.

  §freeze-not-harden at top level: *The top level of the
  eventual send modules can be evaluated before ses creates
  `harden`, and so cannot rely on `harden` at top level*. The
  §evaluation-ordering-constraint — harden is a capability
  provided by SES at runtime; eventual-send evaluates before
  SES lockdown completes. Same constraint cycle 130's
  message-breakpoints.js exhibits.

  §Error-message-shows-available-method-names UX: when a method
  doesn't exist, the error *names what the recipient does have*
  via getMethodNames call: *target has no method "foo", has
  ["bar", "baz", "qux"]*. The introspection helper is both a
  public API and an *internal debugging affordance*.

  §ntypeof helper: *null is its own type* — returns `'null'`
  instead of JavaScript's famous `typeof null === 'object'`.
  Used in error messages so the user sees *typeof target is
  "null"* rather than *"object"*.

  Cycle 132 was nominally comments-lane (cycle 131 was the
  final endopi-* ingest closing the family at 9/9). Papers-lane
  has been blocked for 26+ consecutive cycles. With this ingest
  the eventual-send package now has five files in the library:
  cycle 66's handled-promise §handler-protocol, three track-turns
  sections (cycle 79 et al), cycle 130's message-breakpoints, and
  this cycle's local.js — together covering the eventual-send
  local-dispatch surface.
---

> Abstract: `packages/eventual-send/src/local.js` (139 lines, Kris
> Kowal, commit `e56bf00f` — same coordinated-update wave as
> cycles 108/110/115/118/123/125) is the *local-delivery primitive
> layer* for HandledPromise dispatch to non-remote recipients.
> Direct consumer of cycle 130's `makeMessageBreakpointTester`.
>
> Three exports correspond to HandledPromise's three local
> dispatches: `localApplyFunction` (function-apply), `localApply-
> Method` (method-apply; bottoms out to localApplyFunction when
> methodName is null/undefined), `localGet` (property-get). Plus
> `getMethodNames(val)` public introspection helper.
>
> §makeMessageBreakpointTester consumer at module load with
> env-option name `ENDO_DELIVERY_BREAKPOINTS`. Two identical
> debugger blocks with §STEP-INTO-APPLY-comment-pair as inline
> user affordance. §The placement-at-the-actual-delivery-point
> solves cycle 130's *async-call-debugging-pain-point*: pauses at
> the receiver's dispatch so the developer can inspect the
> recipient at the moment of dispatch.
>
> §getMethodNames walks the prototype chain with four disciplines:
> (1) §Set-to-deduplicate; (2) §Test-val-name-rather-than-layer-
> name (respect subclass overrides); (3) §Stop-at-Object-prototype
> (don't leak built-in methods); (4) §Primitive-early-exit.
> §compareStringified sort *prioritizes symbols as earlier than
> strings*.
>
> §isPrimitive duplication TODO names the §cyclic-dependency-
> between-packages problem (eventual-send is foundational;
> pass-style depends on it; consolidating would loop).
> §freeze-not-harden at top level — same evaluation-ordering-
> constraint as cycle 130 (eventual-send evaluates before SES
> lockdown completes).
>
> §Error-message-shows-available-method-names UX: *target has no
> method "foo", has ["bar", "baz", "qux"]* — the introspection
> helper is both public API and internal debugging affordance.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection](../sections/endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection.md) | eventual-send | current |

Tight 139-line file. The three local-dispatch primitives +
getMethodNames introspection + debugger integration all serve one
mechanism (HandledPromise local-dispatch). One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@e56bf00f` (`master`) via
  the local bare-clone. Same commit as cycles 108 (exo-makers.js),
  110 (copySet.js), 115 (copyBag.js), 118 (exo-tools.js), 123
  (merge-set-operators.js), 125 (merge-bag-operators.js).
- Last touched 2026-02-24 by Kris Kowal in commit `e56bf00f`.
- Verified file existence and structure via the local bare-clone:
  139 lines + 3 exported local-dispatch primitives + 1 exported
  introspection helper + 3 private helpers (isPrimitive,
  compareStringified, ntypeof) + 1 module-level breakpoint-tester
  instantiation.
- **Twenty-fifth comment-fragment ingest.** Pairs with cycle 130's
  `message-breakpoints.js` (this file's `onDelivery` consumer) and
  with cycle 66's `handled-promise.js` §handler-protocol (the
  HandledPromise handler that dispatches to these primitives for
  local recipients).
- Cycle 132 was nominally **comments-lane** (cycle 131 was the
  final endopi-* ingest closing the family at 9/9). Papers-lane
  has been blocked for **26+ consecutive cycles** due to lack of
  PDF-fetching infrastructure.
- One cohesion-honest section.
