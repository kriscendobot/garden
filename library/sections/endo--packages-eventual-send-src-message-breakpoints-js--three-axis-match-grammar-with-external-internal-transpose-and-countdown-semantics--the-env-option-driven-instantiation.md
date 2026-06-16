---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §env-option-driven instantiation
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The factory takes an `optionName`:

```js
export const makeMessageBreakpointTester = optionName => {
  let breakpoints = JSON.parse(getEnvironmentOption(optionName, 'null'));

  if (breakpoints === null) {
    return undefined;
  }
  ...
};
```

The §env-option-yields-undefined-when-unset discipline — *if the
env var isn't set, the tester is `undefined` rather than a no-op
tester*. The §caller can check `if (tester)` and skip the
shouldBreakpoint call entirely. The *zero-cost-when-unset*
property.

The `getEnvironmentOption(optionName, 'null')` call uses
`@endo/env-options`'s configurable env-option lookup. The
factory's *single-argument-is-an-env-var-name* discipline: the
factory doesn't read a fixed env var; *callers name what to
read*. This lets multiple breakpoint testers exist in parallel for
different concerns (e.g., E-eventual-sends vs HandledPromise
applies).
