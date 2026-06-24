---
title: Body
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
parent: endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension
---

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
