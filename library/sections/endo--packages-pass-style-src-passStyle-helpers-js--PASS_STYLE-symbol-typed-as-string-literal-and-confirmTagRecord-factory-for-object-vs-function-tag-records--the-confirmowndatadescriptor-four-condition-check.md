---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §confirmOwnDataDescriptor four-condition check
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

```js
export const confirmOwnDataDescriptor = (
  candidate,
  propName,
  shouldBeEnumerable,
  reject,
) => {
  const desc = getOwnPropertyDescriptor(candidate, propName);
  return (desc !== undefined || reject`property expected: ...`) &&
    (hasOwn(desc, 'value') || reject`must not be an accessor: ...`) &&
    (shouldBeEnumerable
      ? desc.enumerable || reject`must be an enumerable property: ...`
      : !desc.enumerable || reject`must not be an enumerable property: ...`)
    ? desc
    : undefined;
};
```

The §four-condition own-data-descriptor-check:

1. **Property exists**: `desc !== undefined`.
2. **Data property, not accessor**: `hasOwn(desc, 'value')`.
3. **Enumerability matches** (passed as `shouldBeEnumerable` arg).
4. *(Implicit)*: the descriptor returns successfully or
   `undefined` on failure.

The §desc-or-undefined return shape: the function *both* returns
the descriptor *and* serves as a predicate (via short-circuit
evaluation of the `&&` chain). Callers can pattern-match on
`undefined` for failure.
