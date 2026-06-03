---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
---

# Three local-delivery primitives with debugger breakpoint integration and getMethodNames introspection

> *Stopped at a breakpoint on this delivery of an eventual method
> call so that you can step *into* the following `apply` in order
> to see the method call as it happens. Or step *over* to see what
> happens after the method call returns.*
>
> — `packages/eventual-send/src/local.js` §localApplyMethod inline comment

`local.js` (139 lines, Kris Kowal-last-touched 2026-02-24 in
commit `e56bf00f`) is the *local-delivery primitive layer* for
HandledPromise dispatch to non-remote recipients. The file exports
three primitives — `localApplyFunction`, `localApplyMethod`,
`localGet` — plus the public `getMethodNames` introspection helper.
Direct consumer of cycle 130's `makeMessageBreakpointTester`.

## The §three-primitives surface

The three exports correspond to HandledPromise's three local
dispatches:

- **`localApplyFunction(recipient, args)`** — eventual function
  call: `E(recipient)(...args)` when `recipient` is a function.
- **`localApplyMethod(recipient, methodName, args)`** — eventual
  method call: `E(recipient).methodName(...args)`. When
  `methodName === undefined || null`, dispatches to
  `localApplyFunction` (the *base case; bottom out to apply
  functions* discipline).
- **`localGet(t, key)`** — eventual property access: `E.get(t,
  key)`. The simplest of the three: just `t[key]`.

The §three-primitives-mirror-the-three-eventual-send-shapes
discipline: `E(x)(args)` (function-apply), `E(x).m(args)`
(method-apply), `E.get(x, k)` (property-get) are the three
operations HandledPromise's `applyFunction`/`applyMethod`/`get`
handlers dispatch.

## The §base-case-bottom-out-to-apply-functions discipline

`localApplyMethod`'s opening branch:

```js
if (methodName === undefined || methodName === null) {
  // Base case; bottom out to apply functions.
  return localApplyFunction(recipient, args);
}
```

The §undefined-or-null-methodName-treated-as-function-apply
discipline: when HandledPromise's `applyMethod` handler is called
with a null/undefined methodName, the operation degenerates to
function-apply. The two operations share the same code path; the
distinction is *whether there's a method name to look up*.

## The §makeMessageBreakpointTester consumer

The module-level instantiation:

```js
const onDelivery = makeMessageBreakpointTester('ENDO_DELIVERY_BREAKPOINTS');
```

This is the *direct consumer* of cycle 130's message-breakpoints
factory. The env-option name is `ENDO_DELIVERY_BREAKPOINTS`. The
§env-option-yields-undefined-when-unset discipline from cycle 130
applies: `onDelivery` is `undefined` if the env var is unset; the
caller's `if (onDelivery && onDelivery.shouldBreakpoint(...))`
check makes the breakpoint cost zero when disabled.

The §two debugger-breakpoint blocks (in `localApplyFunction` and
`localApplyMethod`) are *identical in shape* and carry *identical
inline comments*:

```js
if (onDelivery && onDelivery.shouldBreakpoint(recipient, methodName)) {
  // eslint-disable-next-line no-debugger
  debugger; // STEP INTO APPLY
  // Stopped at a breakpoint on this delivery of an eventual method
  // call so that you can step *into* the following `apply` in order
  // to see the method call as it happens. Or step *over* to see what
  // happens after the method call returns.
}
const result = apply(fn, recipient, args);
```

The §STEP-INTO-APPLY-comment-pair is the *user-facing affordance*:
when the debugger pauses, the developer reads the comment and
knows *exactly what to do next* — step into the `apply` to see the
call, step over to see the return. The §inline-help discipline.

The placement (right before the `apply` call) is structurally
important: the breakpoint fires *at the actual delivery point*,
not at the call site. This solves cycle 130's *async-call-
debugging-pain-point*: the eventual-send call site is somewhere
else in the codebase, often after an async hop; the debugger
pauses *at the receiver's dispatch* so the developer can inspect
the recipient's state at the moment of dispatch.

## The §getMethodNames prototype-walk

The §`getMethodNames(val)` function walks the prototype chain
collecting all method names:

```js
export const getMethodNames = val => {
  let layer = val;
  const names = new Set(); // Set to deduplicate
  while (layer !== null && layer !== Object.prototype) {
    const descs = getOwnPropertyDescriptors(layer);
    for (const name of ownKeys(descs)) {
      // In case a method is overridden by a non-method,
      // test `val[name]` rather than `layer[name]`
      if (typeof val[name] === 'function') {
        names.add(name);
      }
    }
    if (isPrimitive(val)) {
      break;
    }
    layer = getPrototypeOf(layer);
  }
  return harden([...names].sort(compareStringified));
};
```

Four structurally interesting moves:

1. **§Set-to-deduplicate** — `new Set()` accumulates names across
   prototype layers; duplicates (same name on multiple layers)
   are dropped.

2. **§Test-val-name-rather-than-layer-name** — the inline comment
   says it: *In case a method is overridden by a non-method, test
   `val[name]` rather than `layer[name]`*. If a base class
   declares a method but a subclass overrides it with a string,
   the name *should not appear* in the method list. The lookup
   must go through `val` to respect overrides.

3. **§Stop-at-Object-prototype** — `while (layer !== null && layer
   !== Object.prototype)` doesn't walk into `Object.prototype`'s
   methods (`toString`, `hasOwnProperty`, etc.). The
   §don't-leak-Object-prototype-methods discipline.

4. **§Primitive-early-exit** — `if (isPrimitive(val)) break` —
   stops walking when the value is a primitive (string, number,
   etc.). Primitives have access to their wrapper-object methods,
   but those shouldn't be enumerated as method names of the
   primitive itself.

The §`compareStringified` sort *prioritizes symbols as earlier
than strings* — symbol-keyed methods (like
`Symbol.toStringTag`) sort before string-named methods.

## The §isPrimitive duplication and the §layering-constraints TODO

The file's §opening TODO:

> *TODO Consolidate with `isPrimitive` that's currently in
> `@endo/pass-style`. Layering constraints make this tricky, which
> is why we haven't yet figured out how to do this.*

The §layering-constraint observation is the *cyclic-dependency-
between-packages* problem. `@endo/eventual-send` is foundational
(HandledPromise is built on top of it); `@endo/pass-style` depends
on it transitively; consolidating `isPrimitive` into one place
would create a dependency cycle. The duplication is the
*acknowledged-cost-of-layering* discipline.

The §local `isPrimitive` definition:

```js
const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The *short-circuit-on-falsy-first* pattern handles
`null`/`undefined`/`0`/`false`/`''` quickly (returning truthy =
they're primitives). The remaining check eliminates objects and
functions.

## The §freeze-not-harden at top level

The §opening comment for `getMethodNames`:

```js
// The top level of the eventual send modules can be evaluated
// before ses creates `harden`, and so cannot rely on `harden` at
// top level.
freeze(getMethodNames);
```

The §evaluation-ordering-constraint: `harden` is a *capability
provided by SES at runtime*; the eventual-send module evaluates
*before SES lockdown completes*, so top-level code can't call
`harden`. The §workaround: use `Object.freeze` at top level;
deeper-frozen objects (inside `getMethodNames`'s `harden([...names].sort(...))`)
*can* use `harden` because they execute later.

Same constraint cycle 130's message-breakpoints.js exhibits — both
files use `freeze` at the top level (decorating the exported
functions) but `harden` inside function bodies.

## The §error-message-shows-available-method-names UX

`localApplyMethod`'s "method not found" branch:

```js
const fn = recipient[methodName];
if (fn === undefined) {
  assert.fail(
    X`target has no method ${q(methodName)}, has ${q(
      getMethodNames(recipient),
    )}`,
    TypeError,
  );
}
```

The §helpful-error-message discipline — when a method doesn't
exist, the error *names what the recipient *does* have*. The user
sees:

> `target has no method "foo", has ["bar", "baz", "qux"]`

Not the bare *target has no method "foo"*. The use of
`getMethodNames` here makes the introspection helper *both* a
public API and an *internal debugging affordance*. The list lets
the user spot typos (`"baz"` when they meant `"bar"`) at the
error site.

## The §ntypeof helper — *null is its own type*

The §opening helper:

```js
const ntypeof = specimen => (specimen === null ? 'null' : typeof specimen);
```

JavaScript's `typeof null === 'object'` is famous; this helper
returns `'null'` instead. The §`X` template-tag uses `q(ntypeof(...))`
in error messages so the user sees *Cannot deliver "foo" to target;
typeof target is "null"* rather than *typeof target is "object"*.

The §error-message-correctness-fix discipline applied at the
inline level.

## How this file completes the eventual-send local-dispatch surface

The eventual-send package now has *five files* in the library:

- cycle 66 — `handled-promise.js` §handler-protocol (the
  *HandledPromise handler protocol* surface)
- three §track-turns.js sections (one per ingest cycle)
- cycle 130 — `message-breakpoints.js`
- **cycle 132 (this cycle)** — `local.js`

Together they cover the eventual-send local-dispatch surface:
HandledPromise dispatches incoming eventual sends to *either*
remote handlers OR these `localApply*` primitives; track-turns
captures the *causal cross-turn provenance*;
message-breakpoints provides the *debugger-pause* surface; this
file is the *connect-the-handler-to-the-actual-call* layer.

## Related sections

- cycle 130
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics]]
  — the breakpoint-tester factory this file's `onDelivery`
  consumer instantiates.
- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise handler that dispatches to these primitives
  for local recipients.
- cycle 79
  [[endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model]]
  — the cross-turn provenance that wraps these primitives' calls
  with `Caused by:` annotations.
- cycle 92
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the `isPrimitive` consolidation target named in this file's
  TODO; layering constraints prevent it today.
