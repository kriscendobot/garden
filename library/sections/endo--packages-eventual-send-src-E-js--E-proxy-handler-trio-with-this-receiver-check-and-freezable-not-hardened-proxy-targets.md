---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
---

# E proxy-handler trio with this-receiver check and freezable-not-hardened proxy targets

> *In order to be `this` sensitive it is defined using concise method
> syntax rather than as an arrow function. To ensure the function is
> not constructable, it also avoids the `function` syntax.*
>
> — `packages/eventual-send/src/E.js` line 53-55

`E.js` (501 lines total; substantive code lines 1-273, the rest is
JSDoc typedefs) is the **user-facing surface** of `@endo/eventual-
send`. Exports a single factory `makeE(HandledPromise) → E` that
returns the `E` proxy used as `E(x).method(...)` throughout @endo and
Agoric code. Last touched 2026-04-07 by Turadg Aleahmad in commit
`c88bc8311fee` (a TypeScript any-short-circuit fix); previous
substantive touch by Kris Kowal in cycle 108's coordinated-update
commit `e56bf00f2` (Adopt @endo/harden migration).

## The §three-proxy-handler trio + §base discipline

The file defines three proxy handlers and a shared base:

```js
const baseFreezableProxyHandler = {
  set(_target, _prop, _value) { return false; },
  isExtensible(_target) { return false; },
  setPrototypeOf(_target, _value) { return false; },
  deleteProperty(_target, _prop) { return false; },
};
```

The §baseFreezableProxyHandler discipline: four meta-traps (`set` /
`isExtensible` / `setPrototypeOf` / `deleteProperty`) all return
`false`. The proxy *acts as if frozen* even though the target is not
hardened. The §return-false-not-throw discipline preserves the
strict-mode invariants (writing to a non-writable property *throws*
in strict mode, but the Proxy meta-trap returning `false` is the
*correct* signal for "no").

Three concrete handlers extend the base:

- `makeEProxyHandler(recipient, HandledPromise)` — `E(x)`: method-
  call dispatch.
- `makeESendOnlyProxyHandler(recipient, HandledPromise)` —
  `E.sendOnly(x)`: fire-and-forget method-call (returns `undefined`).
- `makeEGetProxyHandler(x, HandledPromise)` — `E.get(x)`: property-
  get dispatch.

## The §single most structurally interesting move — §this-receiver check via concise-method-syntax

The `get` trap returns a function that performs a `this`-identity
check:

```js
get: (_target, propertyKey, receiver) => {
  return harden({
    [propertyKey](...args) {
      if (this !== receiver) {
        return HandledPromise.reject(
          makeError(X`Unexpected receiver for "${q(propertyKey)}" method of E(${q(recipient)})`),
        );
      }
      // ...
      return HandledPromise.applyMethod(recipient, propertyKey, args);
    },
  }[propertyKey]);
}
```

The §this-receiver-check discipline: the returned function *must* be
called as `E(x).method(...args)`. If anyone detaches it via
`const m = E(x).method; m(...args)`, the detached call rejects with
*Unexpected receiver*. The §detach-protection discipline.

The §concise-method-syntax-not-arrow discipline (file's own comment):
*defined using concise method syntax rather than as an arrow function
... `this`-sensitive*. Arrow functions don't have their own `this`.
Concise method syntax `{ [propertyKey](...args) { ... } }[propertyKey]`
produces a function whose `this` is the receiver at call time.

The §avoid-function-syntax discipline (same comment): *To ensure the
function is not constructable*. ES6 `function` declarations have a
`[[Construct]]` internal slot; concise methods don't. The
§non-constructable-via-syntax-choice trick: callers cannot
`new E(x).method(...)`.

The §computed-property-key-preserves-name idiom: `{ [propertyKey](...) { ... } }[propertyKey]`
produces a function whose `name` is the property key. Better stack
traces.

The §`@ts-expect-error` for TS#50319 (microsoft/TypeScript#50319)
acknowledges TypeScript can't yet narrow the type of a computed-key
method access.

## The §funcTarget vs §objTarget — §freeze-but-not-harden discipline

```js
const funcTarget = freeze(() => {});
const objTarget = freeze({ __proto__: null });
```

The §freeze-not-harden discipline. Comment:

> *`freeze` but not `harden` the proxy target so it remains trapping.
> Thus, it should not be shared outside this module.*
>
> *See https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md*

The §stabilize-discipline reference: a *hardened* object is `freeze`d
+ all properties recursively `freeze`d + the prototype `freeze`d *and
permanently sealed against future stabilization*. The Proxy mechanism
in V8 has an optimization: when the *target* is fully sealed,
property-access can short-circuit some Proxy meta-trap dispatch (this
is the *stabilization* work in progress). A *hardened* target would
trigger this short-circuit — but the E proxy's *whole point* is to
intercept every property access. So `funcTarget` and `objTarget`
stay only `freeze`d, never `harden`ed, *and* the comment specifies
that *they should not be shared outside this module* (because callers
might harden them).

§Two-targets-one-purpose: `funcTarget` (callable; for the
`apply` trap) and `objTarget` (object; for the `get` trap on `E.get`).
The choice of target shape determines what `typeof` reports and
whether the proxy is callable.

## The §message-breakpoint integration — cycle 130's tester here

```js
const onSend = makeMessageBreakpointTester('ENDO_SEND_BREAKPOINTS');
```

The §onSend factory binds at module load. Cycle 130's
[[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose]]
documents the tester factory. The §`ENDO_SEND_BREAKPOINTS` env-option
is the *sender* axis (cycle 132's local.js binds the *delivery* axis
as `ENDO_DELIVERY_BREAKPOINTS`).

In the per-method dispatch:

```js
if (onSend && onSend.shouldBreakpoint(recipient, propertyKey)) {
  // eslint-disable-next-line no-debugger
  debugger; // LOOK UP THE STACK
  // Stopped at a breakpoint on eventual-send of a method-call
  // message, so that you can walk back on the stack to see how we
  // came to make this eventual-send
}
```

The §placement-at-the-call-site (vs cycle 132's
placement-at-the-actual-delivery-point) — the breakpoint stops
*before* `applyMethod` runs, so the developer can *walk back the
stack* to see how the eventual-send originated. The §LOOK-UP-THE-
STACK comment-as-debugger-instruction pattern.

The §two-mode tester discipline: `onSend.shouldBreakpoint(recipient,
propertyKey)` for method calls; `onSend.shouldBreakpoint(recipient,
undefined)` for direct function calls (no propertyKey). Cycle 130's
three-axis match grammar's *method '*'* wildcard handles the
undefined case.

The §`if (onSend && ...)` short-circuit honors cycle 130's
§zero-cost-when-unset property — `onSend` is `undefined` when the env
var is unset; the second operand never evaluates.

## The §has-trap-pretends-everything-exists discipline

```js
has: (_target, _p) => {
  // We just pretend everything exists.
  return true;
}
```

The §pretend-everything-exists discipline. Comment is identical in
all three handlers. Since the proxy doesn't know which methods the
remote *actually* has (the remote could be anything; only at
dispatch-time does the actual receiver decide), `has` returns `true`
unconditionally.

This is the §unknown-shape-of-remote discipline: `E(x)` has no
type-level knowledge of what `x` is. The `has` trap respects this by
saying *yes* to every key.

## The §three-handler-asymmetry — return vs. void

The three handlers differ only in *what `apply` and the dispatched
method do*:

| Handler | `apply` returns | dispatched method returns |
|---------|-----------------|---------------------------|
| `makeEProxyHandler` | `HandledPromise.applyFunction(recipient, argArray)` | `HandledPromise.applyMethod(recipient, propertyKey, args)` |
| `makeESendOnlyProxyHandler` | `HandledPromise.applyFunctionSendOnly(recipient, argsArray); return undefined` | `HandledPromise.applyMethodSendOnly(recipient, propertyKey, args); return undefined` |
| `makeEGetProxyHandler` | (n/a; no apply trap) | `HandledPromise.get(x, prop)` |

The §SendOnly-fire-and-forget discipline: returns `undefined`
synchronously; doesn't return a promise. Used when the caller doesn't
care about the result *and* doesn't want to keep a promise pinned in
memory.

The §unhandled-rejection-consequence-of-SendOnly: because no promise
is returned, rejections cannot propagate. Cycle 100's
`unhandled-rejection.js` is the related GC-driven rejection-tracking
that catches these.

The §`makeESendOnlyProxyHandler` validation discipline: instead of
returning a rejected promise on receiver mismatch, it *throws*
synchronously via the `||-Fail` short-circuit:

```js
this === receiver ||
  Fail`Unexpected receiver for "${q(propertyKey)}" method of E.sendOnly(${q(recipient)})`;
```

The §throw-not-reject-in-SendOnly is correct: there's no return
promise to reject, so the failure must be synchronous.

## The §makeE factory — the §E-as-callable-with-extra-methods shape

```js
const makeE = HandledPromise => {
  return harden(assign(
    x => new Proxy(funcTarget, makeEProxyHandler(x, HandledPromise)),
    {
      get: x => new Proxy(objTarget, makeEGetProxyHandler(x, HandledPromise)),
      resolve: HandledPromise.resolve,
      sendOnly: x => new Proxy(funcTarget, makeESendOnlyProxyHandler(x, HandledPromise)),
      when: (x, onfulfilled, onrejected) =>
        HandledPromise.resolve(x).then(...trackTurns([onfulfilled, onrejected])),
    },
  ));
};
```

The §callable-with-methods discipline: `E` is both a function (you
call `E(x)`) *and* an object with methods (`E.get`, `E.resolve`,
`E.sendOnly`, `E.when`). Implemented via `assign(fn, methods)` then
`harden(...)`.

§Five-surface api:

- `E(x).method(...)` — eventual method call (returns promise)
- `E(x)(...)` — eventual function call
- `E.get(x).prop` — eventual property get
- `E.resolve(x)` — convert to handled promise (= `HandledPromise.resolve(x)`)
- `E.sendOnly(x).method(...)` — fire-and-forget method
- `E.when(x, onf, onr)` — `resolve(x).then(onf, onr)` with cycle 90's
  trackTurns wrapping

The §E.when-wraps-trackTurns idiom: `trackTurns([onfulfilled,
onrejected])` annotates the callbacks so cycle 90's track-turns.js
can produce the causal-chain error annotations cycle 96's
console.js renders.

## The §dependency-cluster

`E.js` ties together multiple previously-ingested files:

- **HandledPromise** — cycle 66's
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  provides the `applyMethod` / `applyFunction` / `get` / `*SendOnly`
  static methods this file dispatches to. `E.js` is the *user-facing
  surface*; `handled-promise.js` is the *handler protocol*.
- **trackTurns** — cycle 90's
  [[endo--packages-eventual-send-src-track-turns-js--causal-console-instrument-with-globalThis-assert-deferral-and-detailsNote-rendering]]
  provides the callback-annotation machinery `E.when` uses.
- **makeMessageBreakpointTester** — cycle 130's
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose]]
  provides the env-option-driven breakpoint tester all three handlers
  consult.
- **@endo/harden** — cycle 108's coordinated-update commit `e56bf00f`
  migrated this file from `globalThis.harden` to `@endo/harden`
  import.

Sister to cycle 132's
[[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-and-debugger-breakpoint-integration]]:
this file's §placement-at-the-call-site for the breakpoint mirrors
that file's §placement-at-the-actual-delivery-point. Two breakpoint
gates, two env vars, two perspectives on the same eventual-send.

## The §JSDoc typedefs (lines 277-501) — §the type-level shape of E

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

## Related sections

- cycle 66
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — HandledPromise's handler protocol that this file's proxies
  dispatch to.
- cycle 90
  [[endo--packages-eventual-send-src-track-turns-js--causal-console-instrument-with-globalThis-assert-deferral-and-detailsNote-rendering]]
  — trackTurns: the callback-annotation `E.when` wraps.
- cycle 130
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose]]
  — the breakpoint tester all three handlers consult.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-and-debugger-breakpoint-integration]]
  — sister file: this file gates the *sender*-side breakpoint at the
  call site; that file gates the *receiver*-side at delivery.
- cycle 100
  [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — the unhandled-rejection-tracking that catches SendOnly's lost
  rejections.
