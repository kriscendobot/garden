---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: The §makeMessageBreakpointTester consumer
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The module-level instantiation:

```js
const onDelivery = makeMessageBreakpointTester('ENDO_DELIVERY_BREAKPOINTS');
```

This is the *direct consumer* of cycle 130's message-breakpoints
factory. The env-option name is `ENDO_DELIVERY_BREAKPOINTS`. The
§env-option-yields-undefined-when-unset discipline from cycle 130
applies: `onDelivery` is `undefined` if the env var is unset; the
caller's `if (onDelivery && onDelivery.shouldBreakpoint(...))`
check makes the breakpoint cost zero when disabled.

The §two debugger-breakpoint blocks (in `localApplyFunction` and
`localApplyMethod`) are *identical in shape* and carry *identical
inline comments*:

```js
if (onDelivery && onDelivery.shouldBreakpoint(recipient, methodName)) {
  // eslint-disable-next-line no-debugger
  debugger; // STEP INTO APPLY
  // Stopped at a breakpoint on this delivery of an eventual method
  // call so that you can step *into* the following `apply` in order
  // to see the method call as it happens. Or step *over* to see what
  // happens after the method call returns.
}
const result = apply(fn, recipient, args);
```

The §STEP-INTO-APPLY-comment-pair is the *user-facing affordance*:
when the debugger pauses, the developer reads the comment and
knows *exactly what to do next* — step into the `apply` to see the
call, step over to see the return. The §inline-help discipline.

The placement (right before the `apply` call) is structurally
important: the breakpoint fires *at the actual delivery point*,
not at the call site. This solves cycle 130's *async-call-
debugging-pain-point*: the eventual-send call site is somewhere
else in the codebase, often after an async hop; the debugger
pauses *at the receiver's dispatch* so the developer can inspect
the recipient's state at the moment of dispatch.
