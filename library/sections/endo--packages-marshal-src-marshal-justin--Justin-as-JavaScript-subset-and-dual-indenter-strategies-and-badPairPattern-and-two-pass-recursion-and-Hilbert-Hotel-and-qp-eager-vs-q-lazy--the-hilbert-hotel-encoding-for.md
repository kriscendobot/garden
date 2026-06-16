---
title: §The-Hilbert-Hotel-encoding for records containing `@qclass` key
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
---

§Records-that-themselves-contain-an-`@qclass`-key are §encoded-via-the-Hilbert-Hotel-pattern:

```js
case 'hilbert': {
  const { original, rest } = rawTree;
  'original' in rawTree ||
    Fail`Invalid Hilbert Hotel encoding ${rawTree}`;
  prepare(original);
  if ('rest' in rawTree) {
    // ... validate rest is non-null non-array non-QCLASS object ...
    for (const name of names) {
      typeof name === 'string' ||
        Fail`Property name ${name} of ${rawTree} must be a string`;
      prepare(rest[name]);
    }
  }
}
```

§The-Hilbert-Hotel-encoding makes room for the special `@qclass` property by §shifting it into an `'original'` slot + §everything-else into a `'rest'` slot.

§Borrowable-pattern: §the-Hilbert-Hotel-encoding for §wire-format-keys-that-collide-with-application-data-keys. §Cycle-148-symbol.js uses the same name for symbol-encoding; §cycle-229-marshal-justin uses it for record-encoding. §Two-different-instances of the same naming inspiration.
