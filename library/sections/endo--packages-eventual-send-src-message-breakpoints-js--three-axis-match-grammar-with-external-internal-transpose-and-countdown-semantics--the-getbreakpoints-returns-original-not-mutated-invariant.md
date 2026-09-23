---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §getBreakpoints-returns-original-not-mutated invariant
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The §getBreakpoints / §setBreakpoints / §shouldBreakpoint trio
maintains a subtle invariant:

- `getBreakpoints()` returns the *user-configured* JSON
  (decrements are *not* visible).
- `setBreakpoints(newBreakpoints)` re-installs from a new (or
  same) JSON.
- `shouldBreakpoint(recipient, methodName)` mutates the *internal*
  table's countdowns *without* mutating the external `breakpoints`
  variable.

The separation lets the user inspect the original configuration
even after many shouldBreakpoint calls have decremented the
internal countdowns. *Re-installing the same JSON resets the
countdowns* — `setBreakpoints()` with no arguments uses the stored
breakpoints, effectively rebuilding the table:

```js
const setBreakpoints = (newBreakpoints = breakpoints) => {
  ...
};
```

The §default-argument-to-stored-breakpoints idiom makes
`setBreakpoints()` *both* a configure-from-new and a
reset-countdowns call.
