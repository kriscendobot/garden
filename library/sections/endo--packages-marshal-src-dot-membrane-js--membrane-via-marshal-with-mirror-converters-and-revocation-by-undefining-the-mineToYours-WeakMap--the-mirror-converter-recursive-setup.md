---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §mirror-converter recursive setup
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §makeConverter factory takes an optional `mirrorConverter`:

```js
const makeConverter = (mirrorConverter = undefined) => {
  // ... create this converter ...
  if (mirrorConverter === undefined) {
    mirrorConverter = makeConverter(converter);
    optInnerRevoke = mirrorConverter.myRevoke;
  }
  const {
    mineToYours: yoursToMine,
    convertMineToYours: convertYoursToMine,
    myUnserialize: yourUnserialize,
    pass: passBack,
  } = mirrorConverter;
  return converter;
};
```

The §self-referential-pair pattern: the outer call to
`makeConverter()` creates one converter; that converter calls
`makeConverter(converter)` *recursively* to create its mirror,
passing itself as the mirror's mirror. The recursive call sees
`mirrorConverter !== undefined`, so it doesn't recurse further —
it just *destructures* the outer converter's fields under
mirror-side names.

The §destructure-the-mirror-into-other-names pattern: from the
mirror, this converter extracts:

- `mineToYours: yoursToMine` — the mirror's *mine-to-yours*
  WeakMap is *our* *yours-to-mine* WeakMap.
- `convertMineToYours: convertYoursToMine` — the mirror's
  *forward* converter is *our* *reverse* converter.
- `myUnserialize: yourUnserialize` — the mirror's unserialize
  is the *deserialization on the other side*.
- `pass: passBack` — the mirror's `pass` operation goes the
  *other way*.

The §every-mirror-name-is-the-other-direction discipline.
