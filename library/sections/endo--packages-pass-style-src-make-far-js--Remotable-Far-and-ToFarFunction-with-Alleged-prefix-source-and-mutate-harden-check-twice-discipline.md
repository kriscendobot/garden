---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
---

# Remotable, Far, and ToFarFunction — Alleged: prefix source, mutate-harden-check-twice

> *Mutates the input argument! But `Remotable`*
> *  * requires the object to be mutable*
> *  * does further mutations,*
> *  * hardens the mutated object before returning it.*
> *so this mutation is not unprecedented. But it is surprising!*
>
> — `packages/pass-style/src/make-far.js` §Far JSDoc

`make-far.js` (221 lines, Kris Kowal-last-touched 2026-02-24 in
commit `57100aa0`) is the *constructor* layer for remotables —
direct companion to cycle 134's `remotable.js` (which *validates*
what this file constructs). Three exports — `Remotable`, `Far`,
`ToFarFunction` — plus the `GET_METHOD_NAMES = '__getMethodNames__'`
meta-method constant.

## The §makeRemotableProto helper — *inherits from the original
prototype*

The private §`makeRemotableProto(remotable, iface)` function
creates a new prototype object with `PASS_STYLE = 'remotable'`
and `@@toStringTag = iface` as own properties, inheriting from
the *original* prototype of the input:

```js
return harden(
  create(oldProto, {
    [PASS_STYLE]: { value: 'remotable' },
    [Symbol.toStringTag]: { value: iface },
  }),
);
```

The §discipline: *ensure it always inherits from something. The
original prototype of `remotable` if there was one, or
`Object.prototype` otherwise.* The §strict-original-prototype
invariant:

- **Object remotables**: original proto must be `objectPrototype`
  (or null, normalized to `objectPrototype`). *For now,
  remotables cannot inherit from anything unusual.*
- **Far functions**: original proto must be `functionPrototype`
  OR `getPrototypeOf(oldProto) === functionPrototype` (allowing
  one level of class-prototype inheritance). *Far functions must
  originally inherit from Function.prototype.*

The §narrowness-of-allowed-prototype-chains discipline. Future
PRs may relax this; today the discipline is strict.

## The §mutate-harden-check-twice fail-fast pattern

The §`Remotable(iface, props, remotable)` function's structural
core is the *mutate-harden-and-check-twice* pattern:

```js
const mutateHardenAndCheck = target => {
  setPrototypeOf(target, remotableProto);
  harden(target);
  assertCanBeRemotable(target);
};

// Fail fast: check a fresh remotable to see if our rules fit.
mutateHardenAndCheck({});

// Actually finish the new remotable.
mutateHardenAndCheck(remotable);
```

The §fail-fast-via-fresh-object discipline: *first* call
`mutateHardenAndCheck({})` with a *fresh empty object* to test if
the rules fit; *then* mutate the real remotable. The §reason: if
something is structurally wrong (e.g., `remotableProto` itself
fails validation), the failure surfaces on a *throwaway* object
before the caller's real remotable gets mutated.

This is the §dry-run-then-commit pattern. The fresh `{}` is
*equivalent* to the real `remotable` for the purposes of the
check; if the throwaway fails, the real one would too. The §cost
is one extra harden of an ephemeral object; the §benefit is *the
caller's remotable doesn't get mutated mid-failure*.

## The §already-frozen check via comparison-against-fresh

The §already-frozen guard:

```js
isFrozen(remotable) === isFrozen({})
  || Fail`Remotable ${remotable} is already frozen`;
```

The §inline comment names the rationale:

> *Recall that isFrozen always returns true when using lockdown
> with hardenTaming set to the deprecated `'unsafe'` option.*

Under `hardenTaming: 'unsafe'`, *every object's `isFrozen` returns
true* — so a direct `!isFrozen(remotable)` check would always
fail. The §comparison-against-fresh discipline: compare against
`isFrozen({})` so we check *relative* frozen-ness. Under safe
lockdown, `isFrozen({})` returns false and the check works
normally; under unsafe lockdown, both return true and the check
becomes vacuously equal (no check, but also no spurious
rejection).

The §pattern-for-detecting-environment-quirks discipline: don't
hard-code an expected return value; compare against a *fresh
control sample*.

## The §iface = 'Alleged: name' allegation discipline

The §`Far(farName, remotable)` function is the *user-facing
convenience*:

```js
return Remotable(`Alleged: ${farName}`, undefined, r);
```

This is the *source* of the `'Alleged: '` prefix that cycle 134's
`confirmIface` validates against, and cycle 130's `simplifyTag`
strips for matching. The §three-piece prefix-handling discipline:

- **make-far.js** (this cycle) — *produces* the prefix in `Far()`.
- **remotable.js** (cycle 134) — *requires* the prefix in
  `confirmIface()`.
- **message-breakpoints.js** (cycle 130) — *strips* the prefix in
  `simplifyTag()` for tag-matching.

The §Remotable JSDoc names the *allegation-not-attestation*
discipline:

> *We include the "Alleged" or "DebugName" as a reminder that we
> do not yet have SwingSet or Comms Vat support for ensuring this
> is according to the vat hosting the object. Currently, Alice
> can tell Bob about Carol, where VatA (on Alice's behalf)
> misrepresents Carol's `iface`. VatB and therefore Bob will then
> see Carol's `iface` as misrepresented by VatA.*

The §canonical-allegation-not-attestation hazard: the iface is
*the originating vat's claim about the object's identity*, not
*a verified attestation*. A relay vat can lie. The `'Alleged: '`
prefix is the visible *reminder* that consumers must not over-
trust the iface.

The §"DebugName: " prefix is the alternative — used when the name
is *purely for debugging*, not for any kind of identity. cycle
130's simplifyTag strips both.

## The §GET_METHOD_NAMES auto-method — modeled on
GET_INTERFACE_GUARD

The §GET_METHOD_NAMES constant:

```js
export const GET_METHOD_NAMES = '__getMethodNames__';
```

The §inline-help-comment names the lineage:

> *Modeled on `GET_INTERFACE_GUARD` from `@endo/exo`.*

Cycle 118's `exo-tools.js` section 2's §GET_INTERFACE_GUARD
auto-installation pattern is the precedent. *Every exo class
gets a runtime-introspection point* — this design extends the
same pattern to *every Far object*.

The §HAZARD comment:

> *HAZARD: Beware that an exo's interface can change across an
> upgrade, so remotes that cache it can become stale.*

The §interface-cache-staleness-across-upgrades caveat: the
returned method list is *a snapshot at one point*; if the
remotable is upgraded, the snapshot is wrong.

The §getMethodNamesMethod is *thisful*:

```js
const getMethodNamesMethod = harden({
  [GET_METHOD_NAMES]() {
    return getMethodNames(this);
  },
})[GET_METHOD_NAMES];
```

The §JSDoc comment:

> *Note that `getMethodNamesMethod` is a thisful method! It must
> be so that it works as expected with far-object inheritance.*

The §thisful-for-inheritance discipline: if `getMethodNamesMethod`
captured the outer `remotable` value, subclass remotables would
see *the parent's methods, not their own*. By using `this`, the
method correctly walks the prototype chain of the *receiver*,
giving subclasses their full method set.

The §descriptor:

```js
const getMethodNamesDescriptor = harden({
  value: getMethodNamesMethod,
  enumerable: false,
  configurable: false,
  writable: false,
});
```

`enumerable: false` keeps `__getMethodNames__` *out of normal
key enumeration* (so it doesn't pollute `Object.keys` results);
`configurable: false` + `writable: false` make it *unalterable*
once installed.

## The §Far adds GET_METHOD_NAMES only for object remotables

The §`Far(farName, remotable)` body:

```js
const r = remotable === undefined ? ({}) : remotable;
if (typeof r === 'object' && !(GET_METHOD_NAMES in r)) {
  // This test excludes far functions, since we currently consider them
  // to only have a call-behavior, with no callable methods.
  Object.defineProperty(r, GET_METHOD_NAMES, getMethodNamesDescriptor);
}
return Remotable(`Alleged: ${farName}`, undefined, r);
```

Two conditions: `typeof r === 'object'` (Far functions excluded)
*and* `!(GET_METHOD_NAMES in r)` (skip if already installed —
inheritance case).

The §far-functions-have-no-methods discipline echoes cycle 134's
§two-distinct-shapes (*Far functions cannot be methods, and
cannot have methods*). Far functions don't need
`__getMethodNames__` because they have no methods to enumerate.

## The §ToFarFunction — *for functions from elsewhere*

The §`ToFarFunction(farName, func)` function:

```js
export const ToFarFunction = (farName, func) => {
  if (getInterfaceOf(func) !== undefined) {
    return func;
  }
  return Far(farName, (...args) => func(...args));
};
```

The §JSDoc names the use case:

> *Coerce `func` to a far function that preserves its call
> behavior. If it is already a far function, return it. Otherwise
> make and return a new far function that wraps `func` and
> forwards calls to it. This works even if `func` is already
> frozen. `ToFarFunction` is to be used when the function comes
> from elsewhere under less control. For functions you author in
> place, better to use `Far` on their function literal directly.*

Two structurally interesting disciplines:

1. **§Wrap-only-when-needed**: if `func` is already a far
   function (`getInterfaceOf(func) !== undefined`), return it
   directly. *No double-wrapping*. The check uses cycle 134's
   `getInterfaceOf` to detect existing remotability.

2. **§Works-even-if-func-is-already-frozen**: *Remotable*
   requires the object to be mutable; a frozen `func` can't be
   marked. The wrapping arrow function `(...args) => func(...args)`
   is *a fresh function* (mutable, not yet remotable) that
   forwards calls to the original. The original `func` doesn't
   need to be mutated.

The §better-Far-when-you-can advice:

> *For functions you author in place, better to use `Far` on
> their function literal directly.*

ToFarFunction's wrap adds *one indirection* (the forwarding
arrow). For functions the author controls, applying `Far()`
directly avoids the indirection.

## How this file completes the pass-style remotable surface

The pass-style remotable surface now spans four files in the
library:

- cycle 71 — `passStyleOf.js` (dispatch by pass-style; calls
  cycle 134's RemotableHelper for `'remotable'` values)
- cycle 87 — `error.js` (three sections — error passability)
- cycle 134 — `remotable.js` (the *validator*; what counts as a
  remotable; tag-record inheritance; confirmRemotableProtoOf
  recursive walk)
- **cycle 136 (this cycle)** — `make-far.js` (the *constructor*;
  Remotable/Far/ToFarFunction; produces what remotable.js
  validates)

Together they form *the pass-style remotable surface*: how a
remotable is constructed, how it's recognized, what its prototype
chain looks like, and how its iface is named (with the
allegation-not-attestation prefix discipline).

## Related sections

- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — the *validator* this file's constructor produces values for.
  This file *creates* the tag-record-rooted prototype chain;
  cycle 134's `confirmRemotableProtoOf` *validates* it.
- cycle 130
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics]]
  — `simplifyTag` strips the `'Alleged: '` / `'DebugName: '`
  prefix this file's `Far()` produces.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — `getMethodNames` is what `__getMethodNames__` calls. The
  §thisful method discipline is what lets subclass remotables
  see their full method set.
- cycle 118 section 2
  [[endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation]]
  — the §`GET_INTERFACE_GUARD` auto-installation pattern this
  file's `GET_METHOD_NAMES` is modeled on. The exo and remotable
  surfaces both install a meta-method for runtime introspection.
- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that handles the `PASS_STYLE = 'remotable'`
  marker this file installs in `makeRemotableProto`.
