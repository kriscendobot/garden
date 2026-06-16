---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §hideAndHardenFunction asymmetry
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

Only `assertPassableSymbol` gets `hideAndHardenFunction`:

```js
export const assertPassableSymbol = sym =>
  isPassableSymbol(sym) ||
  Fail`Only registered symbols or well-known symbols are passable: ${q(sym)}`;
hideAndHardenFunction(assertPassableSymbol);
```

Whereas `isPassableSymbol` / `nameForPassableSymbol` /
`passableSymbolForName` get plain `harden`. The §hide-only-
assertion-functions discipline — same as cycle 134's
remotable.js, cycle 138's safe-promise.js, cycle 142's
passStyle-helpers.js: assertion functions hide their `.name`
from stack traces because the assertion's identity adds noise
to the call-site trace; the non-assertion exports retain
their name.
