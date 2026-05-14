---
title: Usage
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

> Abstract: Calling marshal: makeMarshal returns a {toCapData, fromCapData} pair. toCapData serializes a JS value to {body, slots} where slots are capability references resolved by application-supplied convertValToSlot/convertSlotToVal callbacks; fromCapData reverses the process. The body is a JSON-encoded smallcaps string.

## Usage

This module exports a `makeMarshal()` function, which can be called with two
optional callbacks (`convertValToSlot` and `convertSlotToVal`), and returns
an object with `toCapData` and `fromCapData` properties. Each callback defaults
to the identity function.

```js
import '@endo/init';
import { makeMarshal } from '@endo/marshal';

const m = makeMarshal();
const o = harden({a: 1});
const s = m.toCapData(o);
console.log(s);
// { body: '{"a":1}', slots: [] }
const o2 = m.fromCapData(s);
console.log(o2);
// { a: 1 }
console.log(o1 === o2);
// false
```

Additionally, this module exports a `makePassableKit` function for encoding into
and decoding from a directly-serialized format in which string comparison
corresponds with arbitrary value comparison (cf.
[Patterns: Rank order and key order](https://github.com/endojs/endo/blob/master/packages/patterns/README.md#rank-order-and-key-order).
Rather than accepting `convertValToSlot` and `convertSlotToVal` functions and
keeping a "slots" side table, `makePassableKit` expects
{encode,decode}{Remotable,Promise,Error} functions that directly convert between
instances of the respective pass styles and properly-formatted encodings
(in which Remotable encodings start with "r", Promise encodings start with "?",
Error encodings start with "!", and all other details are left to the provided
functions).
`makePassableKit` supports two variations of this format: "legacyOrdered" and
"compactOrdered". The former is the default for historical reasons (see
https://github.com/endojs/endo/pull/1594 for background) but the latter is
preferred for its better handling of deep structure. The ordering guarantees are
upheld within each format variation, but not across them (i.e., it is not
correct to treat a string comparison of legacyOrdered vs. compactOrdered as a
corresponding value comparison).


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
