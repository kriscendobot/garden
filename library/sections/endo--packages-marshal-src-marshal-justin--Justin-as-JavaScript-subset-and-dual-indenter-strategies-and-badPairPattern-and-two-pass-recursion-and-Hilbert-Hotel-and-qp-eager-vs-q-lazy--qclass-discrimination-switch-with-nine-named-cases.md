---
title: §QCLASS-discrimination switch with §nine-named-cases
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

```js
switch (rawTree['@qclass']) {
  case 'undefined': /* ... */
  case 'NaN': /* ... */
  case 'Infinity': /* ... */
  case '-Infinity': /* ... */
  case 'bigint': /* ... */
  case '@@asyncIterator': /* ... */
  case 'symbol': /* ... */
  case 'tagged': /* ... */
  case 'slot': /* ... */
  case 'hilbert': /* ... */
  case 'error': /* ... */
  default: assert.fail(X`unrecognized ${q(QCLASS)} ${q(qclass)}`, TypeError);
}
```

§Eleven-named-QCLASS-cases dispatched in a switch with §unrecognized-qclass-throws-TypeError default. §Borrowable-pattern: §a-string-discriminator-keyword (the `'@qclass'` field) + §explicit-switch-cases + §default-throws.

§The `'@@asyncIterator'` case has a §TODO:

```
case '@@asyncIterator': {
  // TODO deprecated. Eventually remove.
  return out.next('Symbol.asyncIterator');
}
```

§Borrowable-pattern: §TODO-deprecated-eventually-remove + §still-handles-it-for-backward-compat. §The-renderer-doesn't-emit-the-`'@@asyncIterator'`-form-anymore + §but-it-decodes-it-when-encountered.
