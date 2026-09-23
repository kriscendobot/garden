---
title: §The-Hilbert-Hotel encoding (third instance in library)
source-slug: endo--packages-marshal-src-encodeToCapData
section-id: QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
---

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
  // ...
}
```

§Third-instance-of-Hilbert-Hotel-naming-in-library:

| Cycle | Source | Purpose |
|-------|--------|---------|
| 148 | @endo/pass-style/symbol.js | shift well-known symbols into `@@`-prefix space |
| 229 | @endo/marshal/marshal-justin.js | decode @qclass-bearing records |
| 231 | @endo/marshal/encodeToCapData.js | encode @qclass-bearing records |

§Three-different-applications-of-the-same-naming-inspiration. §Cycle-148-is-at-the-symbol-encoding-layer; cycles-229+231-are-at-the-record-encoding-layer + §cycle-229-decodes + §cycle-231-encodes.

§The-`freeze(rest)`-note in the comment names §why-the-explicit-freeze-is-needed:

> The `freeze` here is needed anyway, because the `rest` is freshly constructed by the `...` above, and we're using it as input in another call to `encodeToCapData`.

§Borrowable-pattern: §when-spreading-a-frozen-object-into-a-new-object-the-result-is-not-frozen + §the-explicit-freeze-restores-the-invariant.
