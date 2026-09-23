---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §confirmTagRecord factory — *object-vs-function variants*
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

The §makeConfirmTagRecord factory parameterizes by *proto-check*
and produces two specialized predicates:

```js
const makeConfirmTagRecord = confirmProto => {
  const confirmTagRecord = (tagRecord, expectedPassStyle, reject) => {
    return (
      (!isPrimitive(tagRecord) || reject`A non-object cannot be a tagRecord`) &&
      (isFrozen(tagRecord) || reject`A tagRecord must be frozen`) &&
      (!isArray(tagRecord) || reject`An array cannot be a tagRecord`) &&
      confirmPassStyle(
        tagRecord,
        confirmOwnDataDescriptor(tagRecord, PASS_STYLE, false, reject)?.value,
        expectedPassStyle,
        reject,
      ) &&
      (typeof confirmOwnDataDescriptor(
        tagRecord,
        Symbol.toStringTag,
        false,
        reject,
      )?.value === 'string' || reject`...must be a string`) &&
      confirmProto(tagRecord, getPrototypeOf(tagRecord), reject)
    );
  };
  return harden(confirmTagRecord);
};

export const confirmTagRecord = makeConfirmTagRecord(
  (val, proto, reject) =>
    proto === objectPrototype ||
    reject`A tagRecord must inherit from Object.prototype`,
);

export const confirmFunctionTagRecord = makeConfirmTagRecord(
  (val, proto, reject) =>
    proto === functionPrototype ||
    (proto !== null && getPrototypeOf(proto) === functionPrototype) ||
    reject`For functions, a tagRecord must inherit from Function.prototype`,
);
```

The §two-variants encode the §object-vs-function tag-record
distinction:

- **`confirmTagRecord`** — for object tag records; proto must
  be `Object.prototype`.
- **`confirmFunctionTagRecord`** — for function tag records;
  proto must be `Function.prototype` (or one level of subclass:
  `getPrototypeOf(proto) === functionPrototype`).

The §parameterize-the-proto-check-only discipline: all *other*
checks (non-primitive, frozen, non-array, PASS_STYLE match,
@@toStringTag string) are identical; only the *proto* check
differs. The §factory-pattern lets the two variants share the
same logic.

Cycle 134's `confirmRemotableProtoOf` calls into these via the
RemotableHelper. The §object-vs-function shape (cycle 134's
two-distinct-shapes discipline) is partially *factored out* into
the proto-check parameter.
