---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §`confirmAtom` private with §Not-even-Passable two-level rejection
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

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
