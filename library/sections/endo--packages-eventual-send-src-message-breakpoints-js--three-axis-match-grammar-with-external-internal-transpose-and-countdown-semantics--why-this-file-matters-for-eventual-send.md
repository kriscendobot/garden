---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: Why this file matters for eventual-send
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The file integrates with E() and HandledPromise (cycle 66 §handler-
protocol) to provide *debugger-friendly* eventual-send dispatch.
The caller pattern (visible in `E.js` and `handled-promise.js`):

```js
if (tester && tester.shouldBreakpoint(recipient, methodName)) {
  // eslint-disable-next-line no-debugger
  debugger;
}
```

The §`if (tester)` short-circuit makes the breakpoint check
*zero-cost when the env var isn't set* — `makeMessageBreakpointTester`
returns `undefined` in that case. *Pay-only-for-what-you-use*
debugger integration.

The *async-call-debugging-pain-point* this file solves: in
eventual-send, the actual delivery happens *later than the call
site*, often after an async hop. Breakpointing at the call site is
useless; you need to break at the *receiver's method dispatch
point*. This file lets the user say *break on the third call to
`.send` on any object tagged `'wallet'`* via a JSON env var, with
no code modification.
