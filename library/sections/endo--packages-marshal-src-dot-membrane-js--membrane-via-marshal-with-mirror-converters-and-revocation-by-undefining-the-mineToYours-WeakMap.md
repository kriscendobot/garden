---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
---

# Membrane via marshal with mirror converters and revocation by undefining the mineToYours WeakMap

> *// We use mineIf rather than mine so that mine is not
> accessible after revocation. This gives the correct error
> behavior, but may not actually enable mine to be gc'ed,
> depending on the JS engine.*
>
> — `packages/marshal/src/dot-membrane.js` §remotable case

`dot-membrane.js` (164 lines, Turadg Aleahmad-last-touched
2026-04-24 in commit `ec42cb7b`) is the *full membrane*
implementation that exports `makeDotMembraneKit(target) →
{proxy, revoke}`. The structural surprise: the membrane is
built by *running marshal twice* (once each direction). Marshal's
serialize / unserialize pair *is* the membrane-crossing
mechanism.

## The §dot-membrane-via-marshal idiom

The §opening imports are the most structurally interesting line:

```js
import { makeMarshal } from './marshal.js';
```

A membrane built on top of *the serialization layer*. The
§serialize-and-then-unserialize-in-the-other-direction pattern
is the *bridge*: any value `mine` on this side becomes `yours`
on the other side via:

1. Serialize `mine` (using *this* converter's `convertMineToYours`
   for capability references)
2. Unserialize the result (using the *mirror* converter's
   `convertYoursToMine` for capability references)

Capability references survive *both* operations because each
converter's `convertSlotToVal` (the unserialize callback) is the
*other* converter's `convertYoursToMine`. The two converters
form a *pair* that maps capabilities through the membrane in
both directions.

## The §mirror-converter recursive setup

The §makeConverter factory takes an optional `mirrorConverter`:

```js
const makeConverter = (mirrorConverter = undefined) => {
  // ... create this converter ...
  if (mirrorConverter === undefined) {
    mirrorConverter = makeConverter(converter);
    optInnerRevoke = mirrorConverter.myRevoke;
  }
  const {
    mineToYours: yoursToMine,
    convertMineToYours: convertYoursToMine,
    myUnserialize: yourUnserialize,
    pass: passBack,
  } = mirrorConverter;
  return converter;
};
```

The §self-referential-pair pattern: the outer call to
`makeConverter()` creates one converter; that converter calls
`makeConverter(converter)` *recursively* to create its mirror,
passing itself as the mirror's mirror. The recursive call sees
`mirrorConverter !== undefined`, so it doesn't recurse further —
it just *destructures* the outer converter's fields under
mirror-side names.

The §destructure-the-mirror-into-other-names pattern: from the
mirror, this converter extracts:

- `mineToYours: yoursToMine` — the mirror's *mine-to-yours*
  WeakMap is *our* *yours-to-mine* WeakMap.
- `convertMineToYours: convertYoursToMine` — the mirror's
  *forward* converter is *our* *reverse* converter.
- `myUnserialize: yourUnserialize` — the mirror's unserialize
  is the *deserialization on the other side*.
- `pass: passBack` — the mirror's `pass` operation goes the
  *other way*.

The §every-mirror-name-is-the-other-direction discipline.

## The §pass + passBack symmetric pair

The §pass function (defined on this converter) does *mine →
serialize → unserialize as yours*:

```js
const pass = mine => {
  const myCapData = mySerialize(mine);
  const yours = yourUnserialize(myCapData);
  return yours;
};
```

The §`passBack` is the mirror's `pass` — it goes *yours → mine*.

Inside the §remotable case's method wrappers:

```js
const myMethodToYours = (optVerb) => (...yourArgs) => {
  const mineIf = passBack(yours);  // yours → mine
  const myArgs = passBack(harden(yourArgs));  // yours → mine
  let myResult;
  try {
    myResult = optVerb === undefined ? mineIf(...myArgs) : mineIf[optVerb](...myArgs);
  } catch (myReason) {
    throw pass(myReason);  // mine → yours
  }
  return pass(myResult);  // mine → yours
};
```

The §args-cross-back / §result-crosses-forward pattern: when
the other side calls a wrapped method, the arguments are *theirs*
(need to come back as *mine* for the actual call); the result and
exceptions are *mine* (need to go *forward* as *theirs*).

## The §revocation via undefining the mineToYours WeakMap

The §`myRevoke(reasonString)` function:

```js
const myRevoke = reasonString => {
  assert.typeof(reasonString, 'string');
  mineToYours = undefined;
  optReasonString = reasonString;
  if (optInnerRevoke) {
    optInnerRevoke(reasonString);
  }
};
```

The §undefine-the-cache trick: setting `mineToYours = undefined`
makes the next call to `convertMineToYours` *throw*:

```js
if (mineToYours === undefined) {
  throw harden(ReferenceError(`Revoked: ${optReasonString}`));
}
```

The §two-step-revocation: revoking *this* side also calls
`optInnerRevoke(reasonString)` which is the *mirror's revoke*.
A single `revoke()` call propagates to both sides of the membrane,
preventing any further passage.

## The §mineIf-vs-mine GC-friendliness comment

The §inline comment names a *not-quite-resolved* hazard:

> *We use mineIf rather than mine so that mine is not accessible
> after revocation. This gives the correct error behavior, but
> may not actually enable mine to be gc'ed, depending on the JS
> engine.*

The §mineIf-vs-mine renaming: `mineIf = passBack(yours)`. After
revocation, `passBack` throws, so `mineIf` is never assigned;
the original `mine` is unreferenced from the wrapper closure
(it was never captured directly — only `yours` is captured, and
the conversion goes *through* `passBack`).

The §GC-friendliness-may-vary observation: even though the
*reference* is gone, JS engines may still keep `mine` alive via
the closure (escape analysis varies). The §TODO suggests a more
explicit decoupling:

> *TODO Could rewrite to keep scopes more separate, so
> post-revoke gc works more often.*

The §honest-not-yet-perfect discipline: the revocation is
*functionally correct* (post-revoke calls throw); it's
*operationally imperfect* (the wrapped capabilities may not get
GC'd until the wrappers themselves are reachable).

## The §two-level metaReason error handling for promises

The §promise case has a *defensive* error chain:

```js
E.when(
  mine,
  myFulfillment => yourResolve(pass(myFulfillment)),
  myReason => yourReject(pass(myReason)),
)
  .catch(metaReason =>
    // This can happen if myFulfillment or myReason is not passable.
    // TODO verify that metaReason must be my-side-safe, or rather,
    // that the passing of it is your-side-safe.
    yourReject(pass(metaReason)),
  )
  .catch(metaMetaReason =>
    // In case metaReason itself doesn't pass
    yourReject(metaMetaReason),
  );
```

The §three-level-fallback discipline:

1. **Normal path**: fulfillment or rejection passes through
   `pass()` and resolves/rejects the mirror promise.
2. **`pass()` itself fails** (e.g., myFulfillment isn't passable):
   catch with `pass(metaReason)` — try to pass the *reason for
   the failure*.
3. **`pass(metaReason)` also fails**: catch with the raw
   metaMetaReason — give up on passing and reject with whatever
   we've got.

The §each-level-might-throw discipline acknowledges that *every*
membrane-crossing can fail; the three-level chain ensures the
mirror promise *always* settles, even if every passable check
fails.

The §TODO note:

> *TODO verify that metaReason must be my-side-safe, or rather,
> that the passing of it is your-side-safe.*

The §verify-side-safety-of-error-paths discipline: errors from
the membrane machinery might *themselves* contain references that
shouldn't cross. The current code rejects without that
verification; future work would tighten.

## The §Far-functions-have-no-static-methods assumption

The §remotable case:

```js
if (typeof mine === 'function') {
  // NOTE: Assumes that a far function has no "static" methods. This
  // is the current marshal design, but revisit this if we change our
  // minds.
  yours = Far(iface, myMethodToYours());
} else {
  const myMethodNames = getRemotableMethodNames(mine);
  const yourMethods = myMethodNames.map(name => [
    name,
    myMethodToYours(name),
  ]);
  yours = Far(iface, fromEntries(yourMethods));
}
```

The §two-cases match cycle 134's §two-distinct-shapes:

- **Far function**: a single callable, no methods. The wrapper
  is the §`myMethodToYours()` call-pattern (no `optVerb`).
- **Object remotable**: a bag of methods. The wrapper enumerates
  `getRemotableMethodNames(mine)` (cycle 134's introspection) and
  builds a method-by-method translation table.

The §Far-functions-have-no-static-methods assumption is the
§current-marshal-design discipline acknowledged: *NOTE: Assumes
that a far function has no "static" methods. This is the current
marshal design, but revisit this if we change our minds.*

## The §temporal-dead-zone hack

```js
const convertSlotToVal = (
  slot,
  optIface = /** @type {string | undefined} */ (undefined),
) => convertYoursToMine(slot, optIface);
const { serialize: mySerialize, unserialize: myUnserialize } = makeMarshal(
  convertMineToYours,
  convertSlotToVal,
);
// ...
const { ..., convertMineToYours: convertYoursToMine, ... } = mirrorConverter;
```

The §inline comment:

> *We need to pass this while convertYoursToMine is still in
> temporal dead zone, so we wrap it in convertSlotToVal.*

`convertYoursToMine` is destructured *after* `makeMarshal` is
called. The §temporal-dead-zone-wrapper indirection lets us
*reference* `convertYoursToMine` in a function that's *defined
before* `convertYoursToMine` is bound. When the wrapper is
*called*, the binding is set.

The §arrow-function-captures-the-binding-not-the-value pattern:
JS arrow functions don't evaluate body expressions until invoked,
so `() => convertYoursToMine(...)` works even when defined
before the binding exists.

## The §makeDotMembraneKit one-line export

```js
export const makeDotMembraneKit = target => {
  const converter = makeConverter();
  return harden({
    proxy: converter.wrap(target),
    revoke: converter.myRevoke,
  });
};
```

The §two-method-kit shape: `{proxy, revoke}`. The user gets a
*wrapped target* and a *revocation method*. Calling `revoke()`
disables the membrane permanently.

The §`wrap = target => passBack(target)` operation: `target` is
*mine*; `passBack` makes it *yours*; the result is what the
caller hands to the untrusted recipient.

## How this file integrates the marshal + pass-style + eventual-
send substrate

`dot-membrane.js` is the *crown jewel* of the @endo/marshal
package — it shows that marshal's serialization machinery, when
*paired with itself*, becomes a full membrane:

- **Marshal** (cycles 67/68/69 et al.) — the serialize /
  unserialize foundation
- **Pass-style** (cycles 71/87/134/136/138/140/142) — the
  classification + Far + remotable construction
- **Eventual-send** (cycles 66/130/132) — `E.when` for promise
  bridging

Together they give a *full-capability-passing membrane* with
*revocation*. The §full-membrane-from-serialization observation
is the structural delight of the design: *the same machinery that
sends capabilities over a network suffices to wrap capabilities
in a local revocable proxy*.

## Related sections

- cycle 67 (marshal's serialize/unserialize)
  [[endo--packages-marshal-src-marshal-js--dual-format-body-discriminator]]
  — the `makeMarshal(convertSlotToVal, convertValToSlot)`
  factory this file uses twice (once per direction).
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — the §two-distinct-shapes (object remotable vs Far function)
  that this file's §remotable case branches on.
- cycle 136
  [[endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline]]
  — the `Far(iface, ...)` constructor this file uses to build
  the proxy-side wrappers.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — the `getMethodNames` source whose wrapped form
  (`getRemotableMethodNames` from cycle 134) this file uses for
  method-by-method translation.
- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the `E.when` machinery this file's §promise case uses to
  resolve mirror promises across the membrane.
