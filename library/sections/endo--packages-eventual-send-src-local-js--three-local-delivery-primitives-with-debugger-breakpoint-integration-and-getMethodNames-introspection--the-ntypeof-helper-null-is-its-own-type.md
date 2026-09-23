---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §ntypeof helper — *null is its own type*
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The §opening helper:

```js
const ntypeof = specimen => (specimen === null ? 'null' : typeof specimen);
```

JavaScript's `typeof null === 'object'` is famous; this helper
returns `'null'` instead. The §`X` template-tag uses `q(ntypeof(...))`
in error messages so the user sees *Cannot deliver "foo" to target;
typeof target is "null"* rather than *typeof target is "object"*.

The §error-message-correctness-fix discipline applied at the
inline level.
