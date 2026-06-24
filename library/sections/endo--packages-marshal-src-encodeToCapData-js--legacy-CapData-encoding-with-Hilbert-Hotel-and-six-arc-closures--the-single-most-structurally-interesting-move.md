---
title: The single most structurally interesting move
source: endo--packages-marshal-src-encodeToCapData-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
ingest-cycle: 328
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique
  - the-named-QCLASS-special-property-name
  - the-named-canonical-encoding-via-sorted-property-names
  - the-named-canonical-encoding-needed-for-equality
  - the-named-three-encoder-options-with-default-rejectors
  - the-named-dontEncode-family-of-default-rejectors
  - the-named-encodeRecur-callback-parameter
  - the-named-switch-on-passStyleOf
  - the-named-special-case-NaN-Infinity-and-minus-Infinity
  - the-named-bigint-encoded-as-digits-string
  - the-named-symbol-encoded-via-passableSymbolForName
  - the-named-error-special-case-at-root-not-passable
  - the-named-Recur-name-suffix-for-recursive-helper
  - the-named-byteArray-TODO
  - the-named-CapData-vs-smallcaps-format-evolution
  - nineteen-cycles-with-named-pivot-domain-stay
  - eleven-named-packages-in-the-pivot-cluster
  - twenty-two-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-cycle-328
  - the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close
  - two-cycles-with-named-Hilbert-Hotel-encoding
  - four-cycles-with-named-Object-destructure
parent: endo--packages-marshal-src-encodeToCapData-js--legacy-CapData-encoding-with-Hilbert-Hotel-and-six-arc-closures
---

**§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — the QCLASS discriminator (`'@qclass'`) reserves a property name that can never appear in a natural copyRecord. But what if a *real* copyRecord legitimately has `@qclass` as a property name? The file (line 165-184) applies the **Hilbert-Hotel encoding**:

```js
case 'copyRecord': {
  if (hasOwn(passable, QCLASS)) {
    // Hilbert hotel
    const { [QCLASS]: qclassValue, ...rest } = passable;
    const result = {
      [QCLASS]: 'hilbert',
      original: encodeToCapDataRecur(qclassValue),
    };
    if (ownKeys(rest).length >= 1) {
      result.rest = encodeToCapDataRecur(freeze(rest));
    }
    return result;
  }
  // ... normal copyRecord encoding
}
```

The trick: when a copyRecord has its own `@qclass` property, wrap the whole thing in another QCLASS-discriminator (`'hilbert'`) that has *two* sub-properties: `original` (the natural value of `@qclass`) and `rest` (everything else). The decoder recognizes the `'hilbert'` discriminator and reconstructs the original copyRecord by un-shifting.

**§two-cycles-with-named-Hilbert-Hotel-encoding** — cycle 148 ingested @endo/pass-style/src/symbol.js which used the same Hilbert-Hotel technique to reserve `@@`-prefixed strings as well-known symbol names while still allowing `@@`-prefixed strings as registered symbol names. Cycle 328 applies it to QCLASS. Two distinct applications of the *same encoding technique* in two different files. First-explicit-observation as a tier-3 meta-pattern: **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when a reserved-discriminator collides with a natural value, shift everything by one level of indirection.

The name "Hilbert Hotel" comes from David Hilbert's thought experiment about a hotel with infinitely many rooms that can always accommodate one more guest by shifting all existing guests up by one. The encoding shifts the *meaning* up by one level when the *form* would otherwise collide.
