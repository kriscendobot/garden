---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §base-case-bottom-out-to-apply-functions discipline
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

`localApplyMethod`'s opening branch:

```js
if (methodName === undefined || methodName === null) {
  // Base case; bottom out to apply functions.
  return localApplyFunction(recipient, args);
}
```

The §undefined-or-null-methodName-treated-as-function-apply
discipline: when HandledPromise's `applyMethod` handler is called
with a null/undefined methodName, the operation degenerates to
function-apply. The two operations share the same code path; the
distinction is *whether there's a method name to look up*.
