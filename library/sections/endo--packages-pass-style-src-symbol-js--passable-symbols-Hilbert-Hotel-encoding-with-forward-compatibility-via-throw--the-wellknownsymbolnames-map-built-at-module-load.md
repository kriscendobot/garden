---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §`wellKnownSymbolNames` Map built at module load
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
const wellKnownSymbolNames = new Map(
  ownKeys(Symbol)
    .filter(name => typeof name === 'string' && typeof Symbol[name] === 'symbol')
    .filter(name => {
      !name.startsWith('@@') ||
        Fail`Did not expect Symbol to have a symbol-valued property name starting with "@@" ${q(name)}`;
      return true;
    })
    .map(name => [Symbol[name], `@@${name}`]),
);
```

The §Symbol-introspection-at-module-load discipline. Iterate
`ownKeys(Symbol)`; keep only string keys whose value is *a
symbol*; assert no well-known symbol's *name* starts with
`@@`; map each well-known symbol to its `@@`-prefixed wire
form.

The Map's keys are the *symbol values* themselves; lookup is
*identity-based* (`Map.has(sym)` matches the symbol singleton).
The §identity-keyed-Map discipline.

The §`!startsWith('@@') || Fail` invariant is the **single
host-platform precondition** that makes the Hilbert-Hotel
encoding sound. If the host platform ever introduces a
well-known symbol with a `@@`-prefixed *name* (e.g. `Symbol.atAt`
exposed as `Symbol['@@atAt']`), this module *fails loudly at
load time* rather than silently corrupting the encoding.

The §fail-at-load-not-at-use discipline: the invariant is
checked *once*, at module evaluation, when the realm's
`Symbol` constructor is examined. Future encodings/decodings
trust the invariant.
