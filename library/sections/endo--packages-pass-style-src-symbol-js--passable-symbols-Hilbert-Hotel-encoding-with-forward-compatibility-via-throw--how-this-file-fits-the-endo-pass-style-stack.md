---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: How this file fits the @endo/pass-style stack
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

- **`packages/pass-style/src/passStyleOf.js`** (cycle 71)
  dispatches `typeof === 'symbol'` to `isPassableSymbol` from
  this file.
- **`packages/marshal/src/encodeToSmallcaps.js`** (cycle 69)
  and **`encodePassable.js`** (cycle 81) both use
  `nameForPassableSymbol` to convert symbols to wire form.
- **`@endo/marshal`'s decoder** uses `passableSymbolForName`
  to reconstruct symbols on the receiving end.
- The §`@@`-prefix convention propagates through cycle 134's
  `remotable.js` (where `@@toStringTag` is the only allowed
  symbol property on remotables).
