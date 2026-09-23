---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §stringify-discards-the-empty-slots-array
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
const stringify = val => serialize(val).body;
```

The marshal `serialize` returns `{ body: string, slots: [] }`.
For slot-free input, `slots` is *always* `[]`. The
§discard-the-empty-slots-array idiom: `stringify` returns
*just the body string*, which is `parse`'s expected input
format.

The §symmetric-API-via-asymmetric-bodies observation:

- **stringify**: input is Passable; output is string.
- **parse**: input is string; output is Passable.

The asymmetry is in the *intermediate*: serialize produces
`{body, slots}`; we throw away the slots. Parse needs `{body,
slots}` to call unserialize; we synthesize the empty (but
trap-on-access) slots envelope.
