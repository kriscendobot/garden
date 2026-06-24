---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §encoder-reverse — `passableSymbolForName`
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

```js
export const passableSymbolForName = name => {
  typeof name === 'string' ||
    Fail`${q(name)} must be a string, not ${q(typeof name)}`;
  const match = AtAtPrefixPattern.exec(name);
  if (match) {
    const suffix = match[1];
    if (suffix.startsWith('@@')) {
      return Symbol.for(suffix);
    } else {
      const sym = Symbol[suffix];
      if (typeof sym === 'symbol') {
        return sym;
      }
      Fail`Reserved for well known symbol ${q(suffix)}: ${q(name)}`;
    }
  }
  return Symbol.for(name);
};
```

The §three-case-parser mirrors the encoder:

1. **No `@@` prefix** → registered symbol via
   `Symbol.for(name)`.
2. **`@@` prefix + suffix starts with `@@`** → registered
   symbol whose name starts with `@@`, *shifted*: return
   `Symbol.for(suffix)` (one fewer `@@`).
3. **`@@` prefix + suffix is a well-known name** → return
   `Symbol[suffix]`.
4. **`@@` prefix + suffix is *not* a well-known name** →
   **throw**.

The §forward-compatibility-via-throw discipline (the most
structurally interesting decode-side move):

> *Otherwise, if name begins with `"@@"` it may encode a
> registered symbol from a future version of JavaScript, but
> it is not one we can decode yet, so throw.*

The §future-symbol-throws posture: the wire form might encode
a well-known symbol from a *future* version of JavaScript
that this realm doesn't yet have. Rather than silently
treating it as a registered symbol (which would *lose
identity* if the realm later upgrades), the decoder *refuses*
the encoding. The §throw-rather-than-lose-identity
discipline.

The alternative — *silently fall through to `Symbol.for`* —
would have a subtle bug: the receiver's realm might
*currently* not know `Symbol.futureSymbol` but might *later*
gain it; messages received before the upgrade would map to
registered symbols, while messages received after would map
to well-known symbols, breaking equality.
