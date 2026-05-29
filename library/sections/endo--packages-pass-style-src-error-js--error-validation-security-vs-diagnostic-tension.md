---
title: The security-vs-diagnostic-preservation tension in passable-error validation (isErrorLike lets malformed errors stay diagnostic; assertError attaches the validity complaints as notes); the four-property allowlist (message, stack, cause, errors) with the recursive-passable-error rules for cause and errors; the passStyleOf side-effect under unsafe-hardenTaming
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "184-362 (isErrorLike + confirmRecursivelyPassableErrorPropertyDesc + confirmRecursivelyPassableError + ErrorHelper)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The block-level rationale for `isErrorLike` (lines 213-225) sets the
  *security-vs-diagnostic-preservation* tension that drives the rest of
  the file: prefer to let an error continue to function as a diagnostic
  even when it is not fully passable, by attaching the validity
  complaints as *notes* on the error rather than swallowing the
  original diagnostic. The implementation then enforces a strict
  four-property own-data-property allowlist (`message`, `stack`,
  `cause`, `errors`) via `confirmRecursivelyPassableErrorPropertyDesc`,
  with `cause` recursing as a single passable error and `errors`
  recursing as a copyArray-of-passable-errors. A subtle
  passStyleOf-side-effect under unsafe-hardenTaming is noted: invoking
  `confirmRecursivelyPassableError` *alters* the candidate by calling
  the stack-accessor repair from the previous section.
---

## Abstract

The block beginning at line 213 names the design tension that drives error-validation: *Validating error objects are passable raises a tension between security vs preserving diagnostic information*. The package's resolution: prefer to let the error-like test succeed even when the error would not strictly validate, so marshal can use the malformed error as the *top-level error to report from*; the validity diagnostics that `assertError` would have produced are then *attached as notes* to the malformed error rather than thrown. *A malformed error is passable by itself, but not as part of a passable structure.* The strict validation surface is implemented as a **four-property own-data-property allowlist**: `message` (string), `stack` (string), `cause` (recursive passable error), `errors` (copyArray of recursive passable errors). The four-property allowlist is the *positive spec*; any other own property fails as *extra unpassed property*. The validation function `confirmRecursivelyPassableError` requires (a) the candidate is error-like (`instanceof Error`); (b) the prototype is the prototype of a registered error constructor (with name in the `errorConstructors` Map covering `Error`, `EvalError`, `RangeError`, `ReferenceError`, `SyntaxError`, `TypeError`, `URIError`, plus `AggregateError` conditionally); (c) the candidate has an own `message` string property; (d) every own property satisfies the per-property validation. Crucially, the validation function *also* invokes `repairError` as a side effect when `repairError !== undefined` (i.e. under unsafe-hardenTaming): *Under these circumstances only, passStyleOf alters an object as a side effect, converting the "stack" property to a data value.* The side-effect is explicitly disclaimed in the comment because *side-effect during `passStyleOf`* would normally be a defensive-consistency violation; the disclaimer scopes it to the unsafe-hardenTaming configuration only. The block also names a `getErrorConstructor` cautionary note: the constructor returned by the function might be `AggregateError`, which has different construction parameters from the other error constructors, so *use `makeError` which encapsulates this non-uniformity*. The file concludes with the `ErrorHelper` PassStyleHelper export that wires `confirmErrorLike` as `confirmCanBeValid` and `confirmRecursivelyPassableError` as the recursive-validation surface.

## Body

### The security-vs-diagnostic-preservation tension

The rationale block on `isErrorLike` (lines 213-225) is the file's most quotable claim about *what passable-error validation must trade off*:

> Validating error objects are passable raises a tension between security vs preserving diagnostic information. For errors, we need to remember the error itself exists to help us diagnose a bug that's likely more pressing than a validity bug in the error itself. Thus, whenever it is safe to do so, we prefer to let the error-like test succeed and to couch these complaints as notes on the error.
>
> To resolve this, such a malformed error object will still pass `isErrorLike` so marshal can use this for top level error to report from, even if it would not actually validate.
> Instead, the diagnostics that `assertError` would have reported are attached as notes to the malformed error. Thus, a malformed error is passable by itself, but not as part of a passable structure.

The tension framing in three layers:

- **The diagnostic-priority claim**: *the error itself exists to help us diagnose a bug that's likely more pressing than a validity bug in the error itself*. The bug-being-reported takes precedence over a validity-bug-in-the-error.
- **The two-tier passability**: a malformed error is *passable by itself* (so marshal can carry it across as a top-level error report) but *not as part of a passable structure* (so it cannot be embedded in a CopyRecord or Tagged structure where the structure's validity depends on the error being well-formed).
- **The notes-as-diagnostic mechanism**: validity complaints become *notes* attached to the error, not exceptions thrown that would replace the diagnostic. The error keeps its identity as a bug-report; the validity issues become annotations.

This tension is the *defensive-consistency-aware* resolution of the trade-off. Strict validation would throw the original diagnostic away; permissive validation would let a malformed error suborn the passable invariant. The notes-on-malformed-error solution preserves both: the original error reaches the verifier, and the validity issues are reported as supplementary information.

### The four-property allowlist

The `confirmRecursivelyPassableErrorPropertyDesc` function (lines 240-300) implements the strict positive spec: error own properties must be one of *exactly four* recognized property names, each with its own per-property rules.

```js
switch (propName) {
  case 'message':
  case 'stack': {
    return (
      typeof value === 'string' ||
      (reject && reject`Passable Error ${q(propName)} own property must be a string: ${value}`)
    );
  }
  case 'cause': {
    return confirmRecursivelyPassableError(value, passStyleOfRecur, reject);
  }
  case 'errors': {
    if (!Array.isArray(value) || passStyleOfRecur(value) !== 'copyArray') {
      return reject && reject`Passable Error ${q(propName)} own property must be a copyArray: ${value}`;
    }
    return value.every(err =>
      confirmRecursivelyPassableError(err, passStyleOfRecur, reject),
    );
  }
  default: {
    break;
  }
}
return reject && reject`Passable Error has extra unpassed property ${q(propName)}`;
```

The structural breakdown:

- **`message`** must be a *data property* with a *string* value. Required (line 336: *must have an own "message" string property*).
- **`stack`** must be a *data property* with a *string* value. Optional — its absence does not fail the validation; its presence as an accessor or non-string fails.
- **`cause`** must be a *recursively passable error*. The recursive call lets `cause` itself be a passable error with its own `message`, `stack`, `cause`, and `errors` chain.
- **`errors`** must be a *copyArray* (validated via `passStyleOfRecur`) whose elements are *each recursively passable errors*. This handles `AggregateError`'s `.errors` property.
- **Any other own property** fails as `extra unpassed property`. The default branch is the explicit catchall.

The *enumerable* check (line 246) is the additional guard:

```js
if (desc.enumerable) {
  return reject && reject`Passable Error ${q(propName)} own property must not be enumerable: ${desc}`;
}
```

Error own properties on `message` / `stack` / etc. are normally *non-enumerable* in standard engine implementations. The validation enforces this: an enumerable error own property is a sign of either user-instrumentation or engine deviation, and the validation rejects it.

The *data property* check (line 254):

```js
if (!hasOwn(desc, 'value')) {
  return reject && reject`Passable Error ${q(propName)} own property must be a data property: ${desc}`;
}
```

Accessor properties (with `get`/`set` rather than `value`) are rejected. This is the validation pair to the §2 V8-stack-accessor repair: under unsafe-hardenTaming, the stack accessor gets repaired to a data value before this check; under safe lockdown, the stack property is already inherited from `Error.prototype` and never owned.

### The error-constructor registry

The `errorConstructors` Map (lines 159-182) lists the recognized error classes:

```js
const errorConstructors = new Map([
  ['Error', Error],
  ['EvalError', EvalError],
  ['RangeError', RangeError],
  ['ReferenceError', ReferenceError],
  ['SyntaxError', SyntaxError],
  ['TypeError', TypeError],
  ['URIError', URIError],
  // ['AggregateError', AggregateError],  // conditional
]);

if (typeof AggregateError !== 'undefined') {
  errorConstructors.set('AggregateError', AggregateError);
}
```

The block names a coordination hazard:

> TODO: Maintenance hazard: Coordinate with the list of errors in the SES whilelist.

(*whilelist* is a typo for *whitelist*; preserved verbatim.)

The `AggregateError` registration is conditional because some platforms predate the proposal. The condition is wrapped in a `typeof AggregateError !== 'undefined'` check, the standard idiom for *use-if-the-platform-has-it*. The comment block links the conditional to the issue `https://github.com/endojs/endo/issues/550`.

The `getErrorConstructor` function (lines 184-195) returns the registered constructor by name:

```js
/**
 * Because the error constructor returned by this function might be
 * `AggregateError`, which has different construction parameters
 * from the other error constructors, do not use it directly to try
 * to make an error instance. Rather, use `makeError` which encapsulates
 * this non-uniformity.
 */
export const getErrorConstructor = name => errorConstructors.get(name);
```

The cautionary note is the *non-uniformity-disclaimer*: AggregateError's constructor takes an *iterable of errors* as its first parameter (the `errors` array), which is different from the other error constructors that take a *message string* first. A naïve `new errConstructor(message)` would fail for `AggregateError`; `makeError` (defined elsewhere in `@endo/errors`) encapsulates the per-class construction logic.

### The recursive validation orchestrator

`confirmRecursivelyPassableError` (lines 308-352) orchestrates the per-error check:

```js
export const confirmRecursivelyPassableError = (candidate, passStyleOfRecur, reject) => {
  if (!confirmErrorLike(candidate, reject)) {
    return false;
  }
  const proto = getPrototypeOf(candidate);
  const { name } = proto;
  const errConstructor = getErrorConstructor(name);
  if (errConstructor === undefined || errConstructor.prototype !== proto) {
    return reject && reject`Passable Error must inherit from an error class .prototype: ${candidate}`;
  }
  if (repairError !== undefined) {
    // This point is unreachable unless the candidate is mutable and the
    // platform is V8 or like V8 creates errors with an own "stack" getter or
    // setter, which would otherwise make them non-passable.
    // This should only occur with lockdown using unsafe hardenTaming or an
    // equivalent fake, non-actually-freezing harden.
    // Under these circumstances only, passStyleOf alters an object as a side
    // effect, converting the "stack" property to a data value.
    repairError(candidate);
  }
  const descs = getOwnPropertyDescriptors(candidate);
  if (!('message' in descs)) {
    return reject && reject`Passable Error must have an own "message" string property: ${candidate}`;
  }
  return entries(descs).every(([propName, desc]) =>
    confirmRecursivelyPassableErrorPropertyDesc(propName, desc, passStyleOfRecur, reject),
  );
};
```

The check sequence:

1. **Is it error-like?** `confirmErrorLike` does `candidate instanceof Error`. If not, fail.
2. **Does its prototype match a registered error class?** Look up `proto.name` in `errorConstructors`. If the name is unknown OR the registered constructor's `.prototype` does not match this candidate's prototype, fail with *must inherit from an error class .prototype*.
3. **Repair if needed.** Under unsafe-hardenTaming, call `repairError` to convert the V8 own-stack-accessor to a data property. The block names this as a *passStyleOf side effect* — normally `passStyleOf` is pure, but in this case it alters the candidate. The disclaimer scopes the side effect to unsafe-hardenTaming only.
4. **Does it have a `message` own property?** If not, fail.
5. **Validate every own property descriptor.** Iterate through all own properties and call `confirmRecursivelyPassableErrorPropertyDesc`.

The order matters: error-like check is cheap; prototype match next; repair (potentially mutating!) only when needed; then strict property validation. If any earlier check fails, the candidate is not repaired — *we don't mutate something we've already rejected*.

### The passStyleOf side-effect — a defensive-consistency disclaimer

The most subtle comment in this section names a *defensive-consistency violation* the package accepts under specific configurations:

> Under these circumstances only, passStyleOf alters an object as a side effect, converting the "stack" property to a data value.

Normally `passStyleOf` is *pure*: it classifies a value without mutating it. The side effect violates this defensive-consistency expectation. The disclaimer narrows the violation to *unsafe-hardenTaming or an equivalent fake harden*; under safe lockdown, `repairError === undefined` and the side effect never occurs. The acceptance of the violation under specific configurations is the *deliberate-controlled-risk* pattern: name the violation, name the conditions under which it occurs, name why it is acceptable under those conditions.

The conditions for acceptance:

- Under safe lockdown, `harden` freezes the error, and the stack accessor is closed by freeze. The repair is unnecessary; the side effect does not occur.
- Under unsafe-hardenTaming, `harden` does not freeze. The error is mutable. The side effect (converting the accessor to a data property) is a *less-mutable-than-the-input* transformation, so the side effect does not weaken any caller's invariant. The caller's error was already mutable.

### The ErrorHelper export

The file's final export wires everything as a `PassStyleHelper`:

```js
export const ErrorHelper = harden({
  styleName: 'error',
  confirmCanBeValid: confirmErrorLike,
  assertRestValid: (candidate, passStyleOfRecur) =>
    confirmRecursivelyPassableError(candidate, passStyleOfRecur, Fail),
});
```

The two slots correspond to the *two-tier passability*:

- **`confirmCanBeValid: confirmErrorLike`** is the lenient first-pass test: *is this thing error-like enough to be carried as a top-level error report?* Used when marshal needs to know if it can use the candidate as a top-level error.
- **`assertRestValid: (candidate, passStyleOfRecur) => confirmRecursivelyPassableError(candidate, passStyleOfRecur, Fail)`** is the strict full-validation: *does this error satisfy the four-property allowlist with the recursive cause/errors checks?* Used when marshal needs to embed the error in a passable structure.

The `Fail` callback in `assertRestValid` is the throw-on-fail variant of `confirmRecursivelyPassableError`'s `reject` parameter. With `Fail`, validity diagnostics throw immediately; with `false`, they return `false` quietly; with a custom `reject` function, they accumulate as a chain of validity complaints.

## Connection to the wider library

This section is the **canonical worked example of *two-tier passability with diagnostic-preservation*** at the error-handling boundary. Three threads:

1. **The diagnostic-priority claim generalizes.** When validation must trade off between *reject* and *attach-validity-notes*, the standard answer is *attach-notes-and-let-the-primary-diagnostic-survive*. The error.js block names the principle explicitly.
2. **The four-property allowlist + recursive descent pattern is reusable.** Any passable structure that wraps other passables (records, arrays, errors with `cause`/`errors`) should follow the same shape: own-property allowlist + recursive validation + clear *extra unpassed property* failure.
3. **The deliberate-controlled-risk disclaimer pattern.** The passStyleOf-side-effect comment is the canonical form for naming a defensive-consistency violation, the conditions that scope it, and the rationale that makes it acceptable under those conditions.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Two-tier passability (isErrorLike + assertError) | A *positive spec* for *can-be-used-as-top-level-report* and a *strict spec* for *embedded-in-structure*. The two-tier pattern lets diagnostic and structural validation coexist. |
| Attach validity complaints as notes | Use `@endo/errors`'s note-attachment machinery rather than throwing; preserve the original diagnostic. |
| Four-property allowlist + recursive descent | The standard passable-validation discipline; analogous to copyRecord's enumerable-string-keys + recursive-passable-value rule. |
| Error-constructor registry + AggregateError-non-uniformity disclaimer | The error-class enumeration is the SES whitelist; AggregateError's construction-parameter divergence is captured in `makeError`. |
| passStyleOf side-effect under unsafe-hardenTaming | A deliberately-accepted defensive-consistency violation, scoped to a specific lockdown configuration. The disclaimer is the contract. |
| TODO: Maintenance hazard: Coordinate with the list of errors in the SES whilelist | The known cross-package coupling that the file's maintainer must remember when adding new error classes. |

## See also

- [[hardened-javascript]] (topic) — SES is the substrate; the SES whitelist coordination is a maintenance hazard the comment flags.
- [[pass-style]] (topic) — the package; the error validation is one of many per-pass-style validations.
- [[errors]] (topic) — error handling; this block is the *passable-error* corner.
- [[marshal]] (topic) — marshal consumes `ErrorHelper.confirmCanBeValid` and `ErrorHelper.assertRestValid` at the wire-boundary.
- [[capability-security]] (topic) — the diagnostic-preservation discipline is a capability-security trade-off: do not weaken diagnostics by being overzealous about structural-validity.
- `endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations` — the first section: the host-configuration regimes this validation runs under.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` — the second section: the repair that this section invokes as a side-effect under unsafe-hardenTaming.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` — adjacent comment-fragment: why marshal deliberately does not put the stack on the wire (the structural complement to the validity-as-notes discipline).

## Common confusions

- **"A malformed error is invalid."** Not in this package's framing. A malformed error is *passable by itself but not as part of a passable structure*. It can be the top-level error in a marshal report; it cannot be embedded in a CopyRecord's `value` slot. The two-tier passability is the explicit resolution.
- **"The four-property allowlist is restrictive — what about subclasses with extra properties?"** The allowlist is *intentionally* restrictive. A subclass with extra own properties either (a) needs the subclass to be registered as an error constructor in `errorConstructors` AND its properties need to be in the per-property switch, OR (b) the subclass author must use `cause` to wrap a base-error and put the extra information in the `cause` chain. The strict allowlist prevents extra properties from leaking authority across a marshal boundary.
- **"The `passStyleOf` side-effect is a bug."** It is a *deliberate, scoped, disclaimed* violation. Under safe lockdown, no side effect occurs. Under unsafe-hardenTaming, the side effect is to make the error *more* passable than it would otherwise be (by converting an accessor to a data property), so the caller's invariants are preserved. The disclaimer is the contract; the configuration is the scope.
- **"`AggregateError` is just another error class."** Construction-parameter-wise, it is not: `new AggregateError([errors], message)` vs `new Error(message)`. The `getErrorConstructor` disclaimer is the explicit warning; `makeError` is the consumer-side abstraction that encapsulates the difference.
- **"`isErrorLike` is too lenient."** It is *intentionally* lenient. The whole rationale block is the explanation: a less lenient `isErrorLike` would throw away diagnostic information; the strict validation is in `assertError` (or `confirmRecursivelyPassableError(_, Fail)`). The two functions are *complementary*, not redundant.
- **"The TODO about SES whitelist coordination is a defect."** It is a *recorded coupling*. The maintenance hazard is real (adding a new error class requires updating both `errorConstructors` in error.js and the SES whitelist), but the TODO is the documented record of the coupling rather than an attempt to eliminate it.
