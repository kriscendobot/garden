---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §single most structurally interesting move — §badArray-Proxy-traps-on-slot-access
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

The `parse` function passes a *proxy that pretends to be an
empty array* as the `slots` argument to `unserialize`:

```js
const badArrayHandler = harden({
  get: (_target, name, _receiver) => {
    if (name === 'length') {
      return 0;
    }
    throw Fail`Marshal's parse must not encode any slot positions ${name}`;
  },
});

const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

The §badArray-Proxy-traps-on-slot-access discipline. Why a
proxy instead of just passing `[]`?

- **`unserialize({ body, slots: [] })`** would *silently
  accept* slot-bearing input — the decoder would look up
  `slots[42]`, get `undefined`, and produce a value with an
  undefined-where-a-remotable-belongs (a confusing later
  error).
- **`unserialize({ body, slots: badArray })`** *immediately
  errors* with `Marshal's parse must not encode any slot
  positions 42` — pointing at the *actual* offending input
  position.

The §loud-failure-when-input-violates-contract discipline:
the proxy converts a *silent type confusion* into a
*specific, actionable error message*.

The §length-returns-zero-everything-else-throws shape:
marshal's decoder may call `slots.length` (legitimate; should
return 0); any other property access *must be* a slot lookup
(numeric index or `0`/`1`/`2`/...) — none of which should
happen on slot-free input.
