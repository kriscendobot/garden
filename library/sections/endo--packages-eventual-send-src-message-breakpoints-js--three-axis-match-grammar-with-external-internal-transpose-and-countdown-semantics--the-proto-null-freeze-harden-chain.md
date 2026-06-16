---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: "The §`__proto__: null` + freeze + harden chain"
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The file uses *both* `__proto__: null` and `freeze`:

- **`__proto__: null`** on the internal BreakpointTable records
  prevents accidental prototype-key matches (e.g.,
  `breakpointsTable['hasOwnProperty']` would otherwise return a
  method, not `undefined`).

- **`freeze`** on the three exported functions
  (`getBreakpoints`, `setBreakpoints`, `shouldBreakpoint`) and on
  the returned `breakpointTester` object — *callers cannot
  replace the methods* on the tester.

The two disciplines together: *no prototype-pollution lookup
hazards in the internal table*; *no method-replacement on the
external API*. Both are SES-compatible (this file doesn't use
`harden` — it predates the `@endo/harden` migration that cycles
108 + 110 + 115 + 118 + 123 + 125 all used).

The §`@ts-expect-error confused by __proto__` comments (twice)
acknowledge a TypeScript limitation: TS doesn't understand the
prototype-null pattern as creating a typed Record, so the
declarations need explicit narrowing.
