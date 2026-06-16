---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §error-message-shows-available-method-names UX
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

`localApplyMethod`'s "method not found" branch:

```js
const fn = recipient[methodName];
if (fn === undefined) {
  assert.fail(
    X`target has no method ${q(methodName)}, has ${q(
      getMethodNames(recipient),
    )}`,
    TypeError,
  );
}
```

The §helpful-error-message discipline — when a method doesn't
exist, the error *names what the recipient *does* have*. The user
sees:

> `target has no method "foo", has ["bar", "baz", "qux"]`

Not the bare *target has no method "foo"*. The use of
`getMethodNames` here makes the introspection helper *both* a
public API and an *internal debugging affordance*. The list lets
the user spot typos (`"baz"` when they meant `"bar"`) at the
error site.
