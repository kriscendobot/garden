---
section: E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
source: endo--packages-eventual-send-src-E-js
topics: [eventual-send, hardened-javascript, captp]
status: current
title: The §dependency-cluster
parent: endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets
---

`E.js` ties together multiple previously-ingested files:

- **HandledPromise** — cycle 66's
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  provides the `applyMethod` / `applyFunction` / `get` / `*SendOnly`
  static methods this file dispatches to. `E.js` is the *user-facing
  surface*; `handled-promise.js` is the *handler protocol*.
- **trackTurns** — cycle 90's
  [[endo--packages-eventual-send-src-track-turns-js--causal-console-instrument-with-globalThis-assert-deferral-and-detailsNote-rendering]]
  provides the callback-annotation machinery `E.when` uses.
- **makeMessageBreakpointTester** — cycle 130's
  [[endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose]]
  provides the env-option-driven breakpoint tester all three handlers
  consult.
- **@endo/harden** — cycle 108's coordinated-update commit `e56bf00f`
  migrated this file from `globalThis.harden` to `@endo/harden`
  import.

Sister to cycle 132's
[[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-and-debugger-breakpoint-integration]]:
this file's §placement-at-the-call-site for the breakpoint mirrors
that file's §placement-at-the-actual-delivery-point. Two breakpoint
gates, two env vars, two perspectives on the same eventual-send.
