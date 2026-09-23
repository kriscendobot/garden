---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §Atom concept — the §passable-leaf subset
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

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
