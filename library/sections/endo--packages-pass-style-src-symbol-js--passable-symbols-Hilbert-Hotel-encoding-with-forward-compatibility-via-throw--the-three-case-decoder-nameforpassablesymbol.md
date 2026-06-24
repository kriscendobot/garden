---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §three-case-decoder — `nameForPassableSymbol`
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
export const nameForPassableSymbol = sym => {
  const name = Symbol.keyFor(sym);
  if (name === undefined) {
    return wellKnownSymbolNames.get(sym);
  }
  if (name.startsWith('@@')) {
    return `@@${name}`;
  }
  return name;
};
```

Three cases:

1. **`keyFor` returns `undefined`** → not registered. Fall
   back to the well-known-name Map. If it's not there, returns
   `undefined` (non-passable, e.g. `Symbol("foo")`).
2. **Registered with `@@`-prefix** → shift one room: prepend
   another `@@`.
3. **Registered without `@@`** → name as-is.

§Returns-undefined-for-non-passable: the encoder gracefully
declines to handle anonymous symbols rather than throwing.
Callers check the result.
