---
title: Body
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "77-153 (makeRepairError and repairError construction)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The `makeRepairError` function is the package's response to a
  V8-specific (and Hermes / FaceBook-flavored) capability-leakage channel:
  Error instances have an own `stack` accessor property whose getter, if
  exposed unchanged on a frozen error, can be invoked by an attacker to
  *communicate arbitrary capabilities through the stack internal slot
  of arbitrary frozen objects*. The comment is unusual in naming the
  channel as *undeniable* — the getter is identical across all errors in
  the same realm, so an attacker who obtains one error's getter can read
  any other error's stack. The repair construction (lines 116-149) walks
  the same-realm-getter-equality observation that justifies replacing
  the getter with a data property containing the resolved stack string;
  and acknowledges the *call-getter-during-harden* hazard ("which seems
  dangerous; but we're only calling the problematic getter whose
  hazards we think we understand").
parent: endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair
---

### The undeniable channel

The V8-specific own-stack-accessor problem is named without euphemism:

> We should otherwise only encounter this case on V8 and possibly immitators like FaceBook's Hermes because of its problematic error own stack accessor behavior, which creates an undeniable channel for communicating arbitrary capabilities through the stack internal slot of arbitrary frozen objects.

The structural picture:

- V8 attaches an *own* `stack` accessor property to each Error instance. The accessor has a `[[Get]]` and `[[Set]]` whose implementations are realm-internal.
- The same getter is shared across all errors in the same realm — *within the same realm, all these accessor properties have the same getter and have the same setter*.
- An attacker who obtains the getter from *one* error can call it on *any other* error in the realm via `Function.prototype.call`. The call returns the stack string of the *target* error.
- The stack string contains call-site information that includes function names, file paths, and (in some engines) closure values — *arbitrary capabilities through the stack internal slot of arbitrary frozen objects*. *Undeniable* means: hardening / freezing the error does not close this channel, because the channel is *the getter itself*, not the error's mutable state.

This is a substantial capability-security hazard. A peer who receives a frozen Error across a marshal boundary can extract diagnostic information that the sender did not intend to send — including potentially identifying information about the sender's filesystem layout, function names, and execution context.

### The engine comparison

The block names the other engines for comparison:

> Note that FF/SpiderMonkey, Moddable/XS, and the error stack proposal all inherit a stack accessor property from Error.prototype, which is great. That case needs no heroics to secure.

The engines that inherit the accessor from `Error.prototype` (rather than carrying an own accessor on each instance) are safe by construction: the prototype-level accessor can be tamed once (by SES at lockdown time) and the change applies to all errors. The own-accessor case (V8, Hermes) cannot be tamed prototype-up; each error must be individually repaired.

### The structural insight that justifies the repair

The repair relies on a key structural observation:

> In the V8 case as we understand it, all errors have an own stack accessor property, but within the same realm, all these accessor properties have the same getter and have the same setter. This is therefore the case that we repair.

Because the getter is *reference-identical* across all errors in the same realm, the repair can:

1. Capture the canonical getter once (by reading the property descriptor of a sample Error).
2. For each error to be repaired, check if its own `stack` accessor's getter is reference-identical to the canonical getter (and configurable).
3. If yes, replace the accessor with a *data property* containing the result of calling the getter.

The reference-identity check is cheap and unambiguous. If the getter does not match the canonical one (perhaps because user code installed a custom stack property on this error), the repair conservatively does not touch it — the error will then fail to validate as passable, and the safety invariant holds.

### The forward-compatibility concern

The block flags:

> Also, we expect tht the captureStackTrace proposal to create more cases where error objects have own "stack" getters.
> https://github.com/tc39/proposal-error-capturestacktrace

The TC39 `Error.captureStackTrace` proposal would standardize the V8-style own-stack-accessor pattern, meaning more engines might carry the pattern in the future. The pass-style package's repair construction would need to extend to cover those engines too. The block names the proposal explicitly so a future reader investigating an unexpected stack-accessor case knows where to look.

(`tht` is a typo for `that` in the source; the library preserves it verbatim.)

### The call-getter-during-harden hazard

The repair itself acknowledges a hazard that it explicitly accepts:

```js
defineProperty(error, 'stack', {
  // NOTE: Calls getter during harden, which seems dangerous.
  // But we're only calling the problematic getter whose
  // hazards we think we understand.
  value: apply(feralStackGetter, error, []),
});
```

Calling a getter during `harden` is *normally* dangerous because a malicious getter could mutate state, expose capabilities, or run arbitrary code at a point where the harden is iterating over the object's properties. The repair accepts this hazard because *we control which getter is being called* — only the canonical realm-internal V8 stack getter, whose hazards are known and bounded (it returns a string derived from the engine's stack-frame internal slots, with no side effects on the JavaScript heap).

The comment's two-line structure is the standard *acknowledge-the-hazard-then-bound-it* idiom: NOTE names the hazard; the next sentence names the bound that makes accepting the hazard safe.

### The two safety conditions

Two further conditions guard the repair:

**Condition 1: the accessor must be configurable.**

```js
if (
  stackDesc &&
  stackDesc.get === feralStackGetter &&
  stackDesc.configurable
) {
```

If the own-stack-accessor is *non-configurable*, the repair cannot replace it via `defineProperty`. The block explains the conservative fallback:

> Can only repair if it is configurable. Otherwise, leave unrepaired, in which case it will not be judged passable, avoiding a safety problem.

An un-repaired error fails the passable-error validation (because its `stack` property is an accessor rather than a string data property), so the error simply does not cross the marshal boundary. The channel is closed by *exclusion* rather than by *repair*.

**Condition 2: the accessor must be the expected canonical accessor.**

```js
if (
  errorStackDesc === undefined ||
  typeof typeErrorStackDesc.get !== 'function' ||
  typeErrorStackDesc.get !== errorStackDesc.get ||
  typeof typeErrorStackDesc.set !== 'function' ||
  typeErrorStackDesc.set !== errorStackDesc.set
) {
  throw TypeError(
    'Unexpected Error own stack accessor functions (PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR)',
  );
}
```

If TypeError and Error own-stack accessors differ from each other, or have different getter/setter shapes than expected, the repair construction *throws*. The error code `PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` is intentionally documented with a link to a SES error-code document:

> See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md

This is the *fail-loud-when-the-environment-is-unexpected* idiom: rather than silently allow an unexpected configuration through (where the repair would be incomplete or incorrect), the package fails to load and points the developer at documentation that explains the expected configurations.

### The hardenIsNoop gate

The repair is only constructed when `hardenIsNoop(harden)` returns true:

```js
export const makeRepairError = () => {
  if (!hardenIsNoop(harden)) {
    return undefined;
  }
  // ... full construction below
};
```

Under safe-mode lockdown, `harden` actually freezes errors, which closes the stack-accessor channel by the prototype's own freeze. The repair is therefore *only needed* when `hardenTaming: "unsafe"` is in effect (or an equivalent fake harden that does not freeze). The block names this case in the property-validation function:

> This point is unreachable unless the candidate is mutable and the platform is V8 or like V8 creates errors with an own "stack" getter or setter, which would otherwise make them non-passable. This should only occur with lockdown using unsafe hardenTaming or an equivalent fake, non-actually-freezing harden. Under these circumstances only, passStyleOf alters an object as a side effect, converting the "stack" property to a data value.

The repair is *contingent infrastructure* — present only when the configuration warrants it. Under safe lockdown, `repairError` is `undefined` and the property-validation never tries to call it.
