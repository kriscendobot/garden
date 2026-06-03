---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
---

# Four predicate-assertion pairs and Atom as passable-leaf subset with `Not even Passable` two-level rejection

> *the AtomStyle cases ... Not even Passable: ${err}: ${val}*
>
> — `packages/pass-style/src/typeGuards.js` lines 129 and 118

`typeGuards.js` (153 lines) is the **user-facing type-guard
surface** for @endo/pass-style. Defines `isCopyArray`,
`isByteArray`, `isRecord`, `isRemotable`, their `assertX`
counterparts, plus `isAtom` / `assertAtom` for the
*passable-leaf subset*. Last touched 2025-09-15 by Mark S.
Miller in commit `7408280d9f`. Imports only `passStyleOf`
from the sibling file (cycle 71) and `Fail` / `q` /
`hideAndHardenFunction` from `@endo/errors`.

## The §four predicate-assertion pairs — one-line dispatch to passStyleOf

The first four exports are *one-line* dispatches to cycle
71's `passStyleOf`:

| Predicate | Assertion | passStyle string |
|-----------|-----------|------------------|
| `isCopyArray(arr)` | `assertCopyArray(arr, 'Alleged array')` | `'copyArray'` |
| `isByteArray(arr)` | `assertByteArray(arr, 'Alleged byteArray')` | `'byteArray'` |
| `isRecord(record)` | `assertRecord(record, 'Alleged record')` | `'copyRecord'` |
| `isRemotable(remotable)` | `assertRemotable(remotable, 'Alleged remotable')` | `'remotable'` |

The §one-line-dispatch-pattern: `passStyleOf(val) === '<style>'`
is the entire predicate body. Each assertion adds the standard
`Fail` template-literal with the rejected `passStyle` reported.

The §`Alleged X` default-name discipline: each assertion has
an `optNameOfX = 'Alleged X'` second parameter. The
§default-name-for-anonymous-throw idiom — the error message
says *Alleged record must be a pass-by-copy record* when the
caller didn't bother to name the parameter. The §`Alleged:`-
prefix-as-default-name parallel to cycle 136's `make-far.js`
*Alleged: Foo* iface convention (allegations are *unverified
claims*).

## The §single most structurally interesting move — §hideAndHardenFunction on every export

> *Every single one of the eight exports gets
> `hideAndHardenFunction`, not just the assertions.*

The §all-predicates-and-assertions-hide-name discipline. This
is a *departure* from the cycle 134 / 138 / 142 pattern
where only *assertion* functions were hidden:

- **Cycle 134** (`remotable.js`): only `assertIface` is
  hidden; `isObjectRemotable` etc. retain their `.name`.
- **Cycle 138** (`safe-promise.js`): only `assertSafePromise`
  is hidden; `isSafePromise` retains its `.name`.
- **Cycle 142** (`passStyle-helpers.js`): only assertion-like
  predicates hidden (`confirmPassStyle`, `confirmTagRecord`,
  `confirmFunctionTagRecord`); raw lookups (`getTag`,
  `isPrimitive`) retain `.name`.
- **Cycle 148** (`symbol.js`): only `assertPassableSymbol`
  hidden; `isPassableSymbol` etc. retain `.name`.

**typeGuards.js does it differently**: every export — `isX`
*and* `assertX` *and* `isAtom` *and* `assertAtom` — gets
`hideAndHardenFunction`. The §user-facing-thin-wrapper
discipline: these are *meant* to be invoked as named
references in stack traces from user code, where their
identity is *uninformative* (the user already knows what
they're checking). The wrappers' identity adds noise.

The §wrapper-identity-irrelevant observation: a one-line
`val => passStyleOf(val) === 'copyArray'` is *less* informative
in a stack trace than the *caller's* identity. Hiding the
wrapper concentrates the trace on the calling site.

This is one of the few @endo files where the §hide-everything
rather than §hide-only-assertions discipline applies. Worth
noting as a *style departure* in the otherwise-consistent
hide-only-assertion pattern across the rest of @endo/pass-style.

## The §Atom concept — the §passable-leaf subset

The most structurally interesting *concept* in the file is
`Atom`. The `confirmAtom` switch enumerates the **eight
AtomStyle cases**:

```js
case 'undefined':
case 'null':
case 'boolean':
case 'number':
case 'bigint':
case 'string':
case 'byteArray':
case 'symbol': {
  return true;
}
```

The §AtomStyle-as-passable-leaf-subset observation: Atoms
are the *passable values without composition or identity*:

- **`undefined` / `null`** — singleton sentinels.
- **`boolean`** — two-element set `{true, false}`.
- **`number`** — IEEE-754 double (plus NaN handling per
  cycle 84 rankOrder).
- **`bigint`** — arbitrary-precision integer.
- **`string`** — UTF-16 string.
- **`byteArray`** — immutable raw bytes (pass-by-copy
  binary).
- **`symbol`** — well-known or registered (per cycle 148's
  Hilbert-Hotel encoding).

§Excluded-from-Atom: `copyArray`, `copyRecord`, `tagged`
(*composite*); `remotable`, `error`, `promise` (have
*identity or state outside the pass-style tree*).

The §Atom-vs-Passable distinction matters for code that wants
*content-only* values — values that can be compared, hashed,
serialized without needing a marshal table or remotable
identity. The §marshal-table-free property: Atoms encode and
decode *without* any per-session state.

The §`/types.js` import of `Atom` confirms the type exists at
the @endo/pass-style API surface; this file's `isAtom` and
`assertAtom` exports give it predicates.

## The §`confirmAtom` private with §Not-even-Passable two-level rejection

```js
const confirmAtom = (val, reject) => {
  let passStyle;
  try {
    passStyle = passStyleOf(val);
  } catch (err) {
    return reject && reject`Not even Passable: ${q(err)}: ${val}`;
  }
  switch (passStyle) { ... }
};
```

The §two-level-rejection discipline names *two* failure modes
in the diagnostic:

1. **Not Passable at all**: `passStyleOf` *throws* when given
   a non-Passable. The try/catch wraps that; the rejection
   message says `Not even Passable: <error>: <val>`. The §`Not
   even Passable`-prefix-for-pre-passable-failure shape.
2. **Passable but not Atom**: the switch's `default` case
   rejects with `A <passStyle> cannot be an atom: <val>`. The
   value *has* a pass-style; it's just not in the Atom subset.

The §two-different-error-prefixes-discriminate-cause discipline:
the caller (and the user reading the error) can distinguish
*"this isn't even @endo-pass-style-valid"* from *"this is
pass-style-valid but not an Atom"*. Different bugs need
different fixes.

The §`reject &&` short-circuit short-form (cycle 102's
Rejector trio pattern): when `reject = false` (silent /
predicate mode), the `&&` evaluates to `false` and short-
circuits without building the template-literal string. When
`reject = Fail` (throw mode), the `&&` evaluates `Fail` to
build and throw the error.

## The §predicate-assertion pair via `confirmAtom`

```js
export const isAtom = val => confirmAtom(val, false);
hideAndHardenFunction(isAtom);

export const assertAtom = val => {
  confirmAtom(val, Fail);
};
hideAndHardenFunction(assertAtom);
```

The §`isAtom = confirm(val, false)` + `assertAtom = confirm(val, Fail)`
pattern is cycle 102's checkKey/Is/Assert trio applied to
*Atom*. (The Atom file gets only the *predicate* + *assertion*
exports; cycle 102's `keys/checkKey.js` adds an internal
`confirmX(val, reject)` that's also exported, plus a
WeakSet memo.)

§No-memo-for-Atom: unlike `keys/checkKey.js`'s `keyMemo`
WeakSet, `confirmAtom` doesn't memo. The check is *cheap* —
one passStyleOf call + a switch fall-through. Memoization
would add overhead with no payoff.

## The §unsurprising-not-clever shape

This file is *intentionally simple*. The complexity is
elsewhere:

- `passStyleOf` (cycle 71) does the heavy classification.
- `harden`, `Fail`, `q`, `hideAndHardenFunction` come from
  outside.
- Type narrowing in the JSDoc `@returns` clauses gives
  TypeScript inference; the runtime behavior is straightforward
  switch + comparison.

The §thin-wrappers-over-passStyleOf observation: this file
*republishes* the passStyleOf-as-string mechanism as
type-narrowing predicates. The library-grade API is here; the
*classification engine* is in cycle 71.

The §expected-imports-only discipline: the file imports *only*
`passStyleOf` and the error/harden primitives. Nothing else.
No marshal, no patterns, no exo. The §minimal-dependency-
surface keeps this layer at the *bottom* of the @endo
dependency stack.

## Related sections

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passStyle-classifier-internals]]
  — the classifier this file's predicates dispatch to.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — the remotable definition that backs `isRemotable`'s answer.
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — the foundational helpers this file's predicates indirectly
  depend on.
- cycle 148
  [[endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw]]
  — the symbol-passability test that `passStyleOf` consults
  for the `symbol` case in the Atom switch.
- cycle 102
  [[endo--packages-patterns-src-keys-checkKey-js--patterns-Keys-Collections-validation-trio]]
  — the Confirm/Is/Assert trio pattern this file's `isAtom`
  +`assertAtom` follow.
