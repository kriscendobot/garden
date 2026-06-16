---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §freeze-not-harden at top level
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The §opening comment for `getMethodNames`:

```js
// The top level of the eventual send modules can be evaluated
// before ses creates `harden`, and so cannot rely on `harden` at
// top level.
freeze(getMethodNames);
```

The §evaluation-ordering-constraint: `harden` is a *capability
provided by SES at runtime*; the eventual-send module evaluates
*before SES lockdown completes*, so top-level code can't call
`harden`. The §workaround: use `Object.freeze` at top level;
deeper-frozen objects (inside `getMethodNames`'s `harden([...names].sort(...))`)
*can* use `harden` because they execute later.

Same constraint cycle 130's message-breakpoints.js exhibits — both
files use `freeze` at the top level (decorating the exported
functions) but `harden` inside function bodies.
