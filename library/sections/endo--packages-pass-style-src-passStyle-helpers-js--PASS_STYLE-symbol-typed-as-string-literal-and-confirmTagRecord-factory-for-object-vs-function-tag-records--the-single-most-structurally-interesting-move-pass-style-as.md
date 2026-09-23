---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The single most structurally interesting move — §PASS_STYLE as
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

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
