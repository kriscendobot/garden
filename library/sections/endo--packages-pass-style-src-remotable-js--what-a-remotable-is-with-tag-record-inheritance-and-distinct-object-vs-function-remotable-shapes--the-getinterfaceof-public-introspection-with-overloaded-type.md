---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §getInterfaceOf — public introspection with overloaded type
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §public introspection function:

```js
export const getInterfaceOf = val => {
  if (
    isPrimitive(val) ||
    val[PASS_STYLE] !== 'remotable' ||
    !confirmRemotable(val, false)
  ) {
    return undefined;
  }
  return getTag(val);
};
```

The §TypeScript-overload typedef:

```ts
{
  <T extends string>(val: PassStyled<any, T>): T;
  (val: any): InterfaceSpec | undefined;
}
```

The §two-signatures: given a `PassStyled<any, T>` value, return
the *narrowed-to-T* tag string; given anything else, return
`InterfaceSpec | undefined`. The discipline lets typed callers
recover the *literal interface tag* from a `PassStyled<any, 'Foo'>`
without an explicit cast.
