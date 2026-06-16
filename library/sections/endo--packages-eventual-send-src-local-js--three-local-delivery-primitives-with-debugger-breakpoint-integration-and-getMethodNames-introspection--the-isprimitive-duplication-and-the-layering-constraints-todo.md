---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §isPrimitive duplication and the §layering-constraints TODO
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The file's §opening TODO:

> *TODO Consolidate with `isPrimitive` that's currently in
> `@endo/pass-style`. Layering constraints make this tricky, which
> is why we haven't yet figured out how to do this.*

The §layering-constraint observation is the *cyclic-dependency-
between-packages* problem. `@endo/eventual-send` is foundational
(HandledPromise is built on top of it); `@endo/pass-style` depends
on it transitively; consolidating `isPrimitive` into one place
would create a dependency cycle. The duplication is the
*acknowledged-cost-of-layering* discipline.

The §local `isPrimitive` definition:

```js
const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The *short-circuit-on-falsy-first* pattern handles
`null`/`undefined`/`0`/`false`/`''` quickly (returning truthy =
they're primitives). The remaining check eliminates objects and
functions.
