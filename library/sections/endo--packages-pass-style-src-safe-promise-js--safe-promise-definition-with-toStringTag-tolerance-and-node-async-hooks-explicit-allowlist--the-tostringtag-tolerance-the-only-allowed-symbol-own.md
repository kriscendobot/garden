---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §@@toStringTag-tolerance — the only allowed symbol own
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

property

The §confirmPromiseOwnKeys function exists because *some*
symbol-named own properties are allowed:

```js
const unknownKeys = keys.filter(
  key => typeof key !== 'symbol' || !hasOwn(Promise.prototype, key),
);
```

The §filter-out-symbols-on-Promise.prototype discipline: any
symbol-named key that's *also* on `Promise.prototype` is treated
as a *potential override* and validated separately (via
`checkSafeOwnKey`); other symbols are unknown and reject.

The §three-property toStringTag invariant in `checkSafeOwnKey`:

> *Explicitly tolerate a `toStringTag` symbol-named
> non-enumerable data property whose value is a string.*

Three sub-conditions for an own `@@toStringTag`:

1. Must be a *data property* (not an accessor): `hasOwn(tagDesc,
   'value')`.
2. Value must be a *string*: `typeof tagDesc.value === 'string'`.
3. Must be *non-enumerable*: `!tagDesc.enumerable`.

The §TODO note:

> *TODO should we also enforce anything on the contents of the
> string, such as that it must start with `'Promise'`?*

The current implementation accepts *any* string; future PRs may
narrow.
