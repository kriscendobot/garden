---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §typedArrayPrototype-getter-extraction at module load
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

The §module-prologue extracts a getter from `Uint8Array`'s
prototype's prototype:

```js
const typedArrayPrototype = getPrototypeOf(Uint8Array.prototype);
const typedArrayToStringTagDesc = getOwnPropertyDescriptor(
  typedArrayPrototype,
  toStringTagSymbol,
);
assert(typedArrayToStringTagDesc);
const getTypedArrayToStringTag = typedArrayToStringTagDesc.get;
assert(typeof getTypedArrayToStringTag === 'function');
```

The §extract-the-built-in-TypedArray-toStringTag-getter
discipline. The TypedArray prototype chain is:
`Uint8Array.prototype → %TypedArray%.prototype → Object.prototype`.
The `%TypedArray%.prototype` (accessed via
`getPrototypeOf(Uint8Array.prototype)`) has a `@@toStringTag`
getter that *only returns a string for actual TypedArrays*. The
§assert + `assert(typeof === 'function')` proves the assumption
at module load — if the host's TypedArray hierarchy doesn't have
the expected getter, lockdown fails loudly.

The §brand-check-via-getter pattern (Design Decision implicit):

```js
export const isTypedArray = object => {
  const tag = apply(getTypedArrayToStringTag, object, []);
  return tag !== undefined;
};
```

The §inline comment: *Duplicates packages/ses/src/make-hardener.js
to avoid a dependency*. The §don't-depend-on-ses discipline:
@endo/pass-style is more foundational than @endo/ses; rather than
import the helper, duplicate it. The §cost-of-the-duplication is
maintenance burden if the SES version drifts.
