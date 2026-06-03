---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
---

# PASS_STYLE symbol typed as string literal and confirmTagRecord factory for object-vs-function tag records

> *Typed as the string literal `'Symbol(passStyle)'` rather than
> as `unique symbol`, to keep the type nameable across module
> boundaries. The runtime value is still `Symbol.for('passStyle')`
> — JS computed property keys accept any value, so `obj[PASS_STYLE]`
> indexing is unchanged.*
>
> — `packages/pass-style/src/passStyle-helpers.js` §PASS_STYLE JSDoc

`passStyle-helpers.js` (212 lines, Turadg Aleahmad-last-touched
2026-04-15 in commit `c05c9a88` — newer than the
coordinated-update `e56bf00f` cluster) is the *foundational
helpers* file that other pass-style files import from. The
`PASS_STYLE` symbol export, the `confirmTagRecord` /
`confirmFunctionTagRecord` predicates, and the typedArray-brand-
check helper all originate here.

## The single most structurally interesting move — §PASS_STYLE as
typed-string-literal hack

The §PASS_STYLE declaration is the *load-bearing TypeScript hack*:

```js
export const PASS_STYLE = /** @type {'Symbol(passStyle)'} */ (
  /** @type {unknown} */ (Symbol.for('passStyle'))
);
```

The §rationale block:

> *Without this, declaration emit in downstream packages whose
> inferred types structurally contain `[PASS_STYLE]` (via
> `PassStyled`, `ExtractStyle`, etc.) fails with TS4023 / TS9006,
> because `unique symbol` bindings are only nameable via their
> original declaration module — which consumers have no reason
> to import directly.*

The §TypeScript-`unique symbol`-limitation: TypeScript's
`unique symbol` type can only be *named via its declaring
module*. If `@endo/exo` infers a type that contains
`{ [PASS_STYLE]: 'remotable' }`, and that type is emitted in its
declaration files, downstream consumers of `@endo/exo` get
TS4023 / TS9006 errors because they can't *name* PASS_STYLE
without importing this file.

The §workaround: lie about the type. *The runtime value is still
`Symbol.for('passStyle')`* (so dictionary lookup works the same);
the *static type* is the string `'Symbol(passStyle)'` (which is
nameable everywhere). The §JS-computed-property-keys-accept-any-
value observation makes the workaround safe: `obj[PASS_STYLE]`
works regardless of the static type because JS coerces the key
expression at runtime.

The §narrow-the-type-where-it-matters discipline: cycles 71 / 134
/ 136 / 138 / 140 all use `PASS_STYLE` to dispatch on pass-style;
the type-lie doesn't affect their runtime behavior, only their
declaration emit.

## The §typedArrayPrototype-getter-extraction at module load

The §module-prologue extracts a getter from `Uint8Array`'s
prototype's prototype:

```js
const typedArrayPrototype = getPrototypeOf(Uint8Array.prototype);
const typedArrayToStringTagDesc = getOwnPropertyDescriptor(
  typedArrayPrototype,
  toStringTagSymbol,
);
assert(typedArrayToStringTagDesc);
const getTypedArrayToStringTag = typedArrayToStringTagDesc.get;
assert(typeof getTypedArrayToStringTag === 'function');
```

The §extract-the-built-in-TypedArray-toStringTag-getter
discipline. The TypedArray prototype chain is:
`Uint8Array.prototype → %TypedArray%.prototype → Object.prototype`.
The `%TypedArray%.prototype` (accessed via
`getPrototypeOf(Uint8Array.prototype)`) has a `@@toStringTag`
getter that *only returns a string for actual TypedArrays*. The
§assert + `assert(typeof === 'function')` proves the assumption
at module load — if the host's TypedArray hierarchy doesn't have
the expected getter, lockdown fails loudly.

The §brand-check-via-getter pattern (Design Decision implicit):

```js
export const isTypedArray = object => {
  const tag = apply(getTypedArrayToStringTag, object, []);
  return tag !== undefined;
};
```

The §inline comment: *Duplicates packages/ses/src/make-hardener.js
to avoid a dependency*. The §don't-depend-on-ses discipline:
@endo/pass-style is more foundational than @endo/ses; rather than
import the helper, duplicate it. The §cost-of-the-duplication is
maintenance burden if the SES version drifts.

## The §isPrimitive / §isObject pair with §XS-cost warning

```js
export const isPrimitive = val =>
  // Safer would be `Object(val) !== val` but is too expensive on XS.
  // So instead we use this adhoc set of type tests. But this is not safe in
  // the face of possible evolution of the language. Beware!
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The §inline-help comment is the *load-bearing warning*:

> *Safer would be `Object(val) !== val` but is too expensive on
> XS. So instead we use this adhoc set of type tests. But this is
> not safe in the face of possible evolution of the language.
> Beware!*

The §safer-but-slower-on-XS trade-off: `Object(val)` boxes
primitives, then strict-comparing against the original detects
primitives reliably even if new primitive types are introduced
(e.g., a future ECMAScript adds a new primitive). But XS
(JavaScript engine used by some Endo deployments) makes
`Object(val)` expensive — *expensive enough* that the trade-off
goes the other way.

The §current-implementation is *adhoc set of type tests*:
falsy-or-not-object-and-not-function. *But this is not safe in
the face of possible evolution of the language.* If JavaScript
adds a new primitive type that's neither falsy nor
`typeof !== 'object' && typeof !== 'function'`, this check would
fail. The §Beware comment is the explicit acknowledgement.

§isObject is the boolean dual:

```js
export const isObject = val =>
  !!val && (typeof val === 'object' || typeof val === 'function');
```

The §deprecation marker:

> *@deprecated use `!isPrimitive` instead*

The §isObject-deprecated-prefer-`!isPrimitive` discipline. Both
functions exist for backward compatibility; new code uses
`!isPrimitive(val)`.

## The §confirmOwnDataDescriptor four-condition check

```js
export const confirmOwnDataDescriptor = (
  candidate,
  propName,
  shouldBeEnumerable,
  reject,
) => {
  const desc = getOwnPropertyDescriptor(candidate, propName);
  return (desc !== undefined || reject`property expected: ...`) &&
    (hasOwn(desc, 'value') || reject`must not be an accessor: ...`) &&
    (shouldBeEnumerable
      ? desc.enumerable || reject`must be an enumerable property: ...`
      : !desc.enumerable || reject`must not be an enumerable property: ...`)
    ? desc
    : undefined;
};
```

The §four-condition own-data-descriptor-check:

1. **Property exists**: `desc !== undefined`.
2. **Data property, not accessor**: `hasOwn(desc, 'value')`.
3. **Enumerability matches** (passed as `shouldBeEnumerable` arg).
4. *(Implicit)*: the descriptor returns successfully or
   `undefined` on failure.

The §desc-or-undefined return shape: the function *both* returns
the descriptor *and* serves as a predicate (via short-circuit
evaluation of the `&&` chain). Callers can pattern-match on
`undefined` for failure.

## The §confirmTagRecord factory — *object-vs-function variants*

The §makeConfirmTagRecord factory parameterizes by *proto-check*
and produces two specialized predicates:

```js
const makeConfirmTagRecord = confirmProto => {
  const confirmTagRecord = (tagRecord, expectedPassStyle, reject) => {
    return (
      (!isPrimitive(tagRecord) || reject`A non-object cannot be a tagRecord`) &&
      (isFrozen(tagRecord) || reject`A tagRecord must be frozen`) &&
      (!isArray(tagRecord) || reject`An array cannot be a tagRecord`) &&
      confirmPassStyle(
        tagRecord,
        confirmOwnDataDescriptor(tagRecord, PASS_STYLE, false, reject)?.value,
        expectedPassStyle,
        reject,
      ) &&
      (typeof confirmOwnDataDescriptor(
        tagRecord,
        Symbol.toStringTag,
        false,
        reject,
      )?.value === 'string' || reject`...must be a string`) &&
      confirmProto(tagRecord, getPrototypeOf(tagRecord), reject)
    );
  };
  return harden(confirmTagRecord);
};

export const confirmTagRecord = makeConfirmTagRecord(
  (val, proto, reject) =>
    proto === objectPrototype ||
    reject`A tagRecord must inherit from Object.prototype`,
);

export const confirmFunctionTagRecord = makeConfirmTagRecord(
  (val, proto, reject) =>
    proto === functionPrototype ||
    (proto !== null && getPrototypeOf(proto) === functionPrototype) ||
    reject`For functions, a tagRecord must inherit from Function.prototype`,
);
```

The §two-variants encode the §object-vs-function tag-record
distinction:

- **`confirmTagRecord`** — for object tag records; proto must
  be `Object.prototype`.
- **`confirmFunctionTagRecord`** — for function tag records;
  proto must be `Function.prototype` (or one level of subclass:
  `getPrototypeOf(proto) === functionPrototype`).

The §parameterize-the-proto-check-only discipline: all *other*
checks (non-primitive, frozen, non-array, PASS_STYLE match,
@@toStringTag string) are identical; only the *proto* check
differs. The §factory-pattern lets the two variants share the
same logic.

Cycle 134's `confirmRemotableProtoOf` calls into these via the
RemotableHelper. The §object-vs-function shape (cycle 134's
two-distinct-shapes discipline) is partially *factored out* into
the proto-check parameter.

## The §three deprecated exports — backward-compat carry-forward

The file exports *three deprecated* names:

1. **`hasOwnPropertyOf = hasOwn`** — *@deprecated Use
   `Object.hasOwn` instead*. The §pass-through-deprecation
   discipline: still works; new code uses the standard.

2. **`isObject`** — *@deprecated use `!isPrimitive` instead*.
   The §double-negative-clarity-issue: `!isPrimitive` makes the
   asymmetry of the check visible at the call site.

3. **`assertChecker`** — *@deprecated Use `Fail` with confirm/
   reject pattern instead*. The §rejector-pattern-replaces-
   checker-pattern observation: the old `Checker` callback
   shape (which throws or returns true) has been replaced by
   the *rejector* pattern (a callback that *returns false* with
   a message, used in `&&` chains). Cycles 134, 138, 140 all
   use the rejector pattern; this file's older API is the
   *legacy entry point*.

The §carry-forward-with-deprecation discipline: the three names
stay exported for compatibility; the JSDoc marks them as
deprecated; new code uses the modern alternatives.

## The §hideAndHardenFunction applied to predicates

Four predicates use `hideAndHardenFunction` (not plain `harden`):

- `isPrimitive`
- `isObject`
- `isTypedArray`
- `assertChecker`

The §reason (cycle 134, 136, 138 established): assertion-like
functions hide their `.name` from stack traces to reduce
information leak. The §predicates-are-assertion-adjacent
discipline applies the same hide-and-harden treatment.

## How this file serves the wider pass-style cluster

This file is the *root* of the pass-style helper graph:

- cycle 71 (`passStyleOf.js`) imports `PASS_STYLE`, `isPrimitive`,
  `confirmTagRecord`, `confirmFunctionTagRecord` to classify
  values.
- cycle 134 (`remotable.js`) imports `confirmTagRecord`,
  `confirmFunctionTagRecord` for the recursive proto-walk.
- cycle 136 (`make-far.js`) imports `PASS_STYLE` to install the
  pass-style tag on remotables.
- cycle 138 (`safe-promise.js`) doesn't import directly but uses
  the same `hideAndHardenFunction` pattern.
- cycle 140 (`deeplyFulfilled.js`) imports `getTag` to read the
  `@@toStringTag` from CopyTagged values.

The §helper-root position: this file's exports are *used by*
nearly every pass-style file. Touching it has wide blast
radius; the §`@deprecated` discipline tracks what's safe to
remove vs what must stay for compatibility.

## Related sections

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that imports `PASS_STYLE`, `isPrimitive`,
  `confirmTagRecord` from this file.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — uses `confirmTagRecord` and `confirmFunctionTagRecord` for
  the §recursive proto walk; the §two-distinct-shapes
  discipline is partially *factored out* into this file's
  §two-variants of confirmTagRecord.
- cycle 136
  [[endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline]]
  — installs `PASS_STYLE = 'remotable'` on the prototype during
  `Remotable()` setup.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — uses the same `hideAndHardenFunction` pattern this file
  applies to predicates.
- cycle 140
  [[endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level]]
  — imports `getTag` for the §tagged case in the deeply-fulfilled
  recursion.
