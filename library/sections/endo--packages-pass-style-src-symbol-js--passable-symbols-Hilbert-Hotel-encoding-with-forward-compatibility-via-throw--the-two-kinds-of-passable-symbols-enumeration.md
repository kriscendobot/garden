---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §two-kinds-of-passable-symbols enumeration
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
export const isPassableSymbol = sym =>
  typeof sym === 'symbol' &&
  (typeof Symbol.keyFor(sym) === 'string' || wellKnownSymbolNames.has(sym));
```

Two cases:

1. **Registered symbols**: created via `Symbol.for(name)`;
   `Symbol.keyFor(sym)` returns the registration string.
2. **Well-known symbols**: static symbol values on the
   `Symbol` constructor (`Symbol.iterator`, `Symbol.toStringTag`,
   `Symbol.asyncIterator`, etc.). Each is a *singleton* with
   identity across all realms (per the JS spec).

§Excluded: `Symbol(description)` symbols (anonymous, per-call
unique). These cannot be reliably round-tripped through wire-
form because the description isn't an identifier.

The §registered-via-keyFor + §well-known-via-Map-lookup
discipline: two different host APIs answer the
*is-this-passable* question; the predicate composes them with
OR.
