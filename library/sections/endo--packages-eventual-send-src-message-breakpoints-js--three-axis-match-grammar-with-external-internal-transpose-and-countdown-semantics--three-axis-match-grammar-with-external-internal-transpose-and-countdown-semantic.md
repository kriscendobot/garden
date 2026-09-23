---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: Three-axis match grammar with external↔internal transpose and countdown semantics
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

> *A star `'*'` will always breakpoint. Otherwise, the string must
> be a non-negative integer. Once that is zero, always breakpoint.
> Otherwise decrement by one each time it matches until it reaches
> zero.*
>
> — `packages/eventual-send/src/message-breakpoints.js` §MatchCountdown JSDoc

`message-breakpoints.js` (179 lines, Mark Miller-last-touched
2024-01-13 in commit `b191aaf3`) is the *runtime-configurable
breakpoint tester* for E()-mediated eventual-send dispatch. The
file exports a single factory, `makeMessageBreakpointTester`, that
reads an env-option-named JSON record and produces a tester with
`getBreakpoints` / `setBreakpoints` / `shouldBreakpoint` methods.
