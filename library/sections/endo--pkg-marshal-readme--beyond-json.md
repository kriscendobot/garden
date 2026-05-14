---
title: Beyond JSON
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
---

> Abstract: Smallcaps extends JSON to encode types JSON cannot: undefined, NaN, Infinity, BigInt, Symbol (well-known), Error (with cause-tree), and capability references (as slot indexes). The encoding is a string-only JSON wire format; type tags use prefix characters in string positions to disambiguate.

## Beyond JSON

`marshal` uses special values to represent both Presences and data which cannot
be expressed directly in JSON. These special values are usually strings with
reserved prefixes in the preferred "smallcaps" encoding, but in the original
encoding were objects with a property named `@qclass`. For example:

```js
import '@endo/init';
import { makeMarshal } from '@endo/marshal';

// Smallcaps encoding.
const m1 = makeMarshal(undefined, undefined, { serializeBodyFormat: 'smallcaps' });
console.log(m1.toCapData(NaN));
// { body: '#"#NaN"', slots: [] }

// Original encoding.
const m2 = makeMarshal();
console.log(m2.toCapData(NaN));
// { body: '{"@qclass":"NaN"}', slots: [] }
```


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
