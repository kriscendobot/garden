---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §`unpassableSymbolForName` escape hatch
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
export const unpassableSymbolForName = name => Symbol(name);
```

§One-line export: given a name, produce an *anonymous* symbol
with that description. The §escape-hatch-for-when-passable-
isn't-needed discipline: callers who *want* a symbol but
don't need it to round-trip through marshal can use this
shortcut.

Not `harden`ed because `Symbol(name)` produces a fresh
symbol per call; there's no shared mutable state.
