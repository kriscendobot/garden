---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §message-breakpoint integration — cycle 130's tester here
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

```js
const onSend = makeMessageBreakpointTester('ENDO_SEND_BREAKPOINTS');
```

The §onSend factory binds at module load. Cycle 130's
[[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose]]
documents the tester factory. The §`ENDO_SEND_BREAKPOINTS` env-option
is the *sender* axis (cycle 132's local.js binds the *delivery* axis
as `ENDO_DELIVERY_BREAKPOINTS`).

In the per-method dispatch:

```js
if (onSend && onSend.shouldBreakpoint(recipient, propertyKey)) {
  // eslint-disable-next-line no-debugger
  debugger; // LOOK UP THE STACK
  // Stopped at a breakpoint on eventual-send of a method-call
  // message, so that you can walk back on the stack to see how we
  // came to make this eventual-send
}
```

The §placement-at-the-call-site (vs cycle 132's
placement-at-the-actual-delivery-point) — the breakpoint stops
*before* `applyMethod` runs, so the developer can *walk back the
stack* to see how the eventual-send originated. The §LOOK-UP-THE-
STACK comment-as-debugger-instruction pattern.

The §two-mode tester discipline: `onSend.shouldBreakpoint(recipient,
propertyKey)` for method calls; `onSend.shouldBreakpoint(recipient,
undefined)` for direct function calls (no propertyKey). Cycle 130's
three-axis match grammar's *method '*'* wildcard handles the
undefined case.

The §`if (onSend && ...)` short-circuit honors cycle 130's
§zero-cost-when-unset property — `onSend` is `undefined` when the env
var is unset; the second operand never evaluates.
