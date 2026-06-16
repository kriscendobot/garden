---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §single TODO — *enable function breakpointing*
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The §shouldBreakpoint procedure carries one TODO:

```js
if (methodName === undefined || methodName === null) {
  // TODO enable function breakpointing
  return false;
}
```

The §current-state: only method invocations are breakpoint-able;
function-as-target calls (where there's no method name to match)
are silently skipped. The future-work direction is to *match on
function identity or function name* — but the JSDoc's match
grammar above doesn't yet have a typedef for that case.
