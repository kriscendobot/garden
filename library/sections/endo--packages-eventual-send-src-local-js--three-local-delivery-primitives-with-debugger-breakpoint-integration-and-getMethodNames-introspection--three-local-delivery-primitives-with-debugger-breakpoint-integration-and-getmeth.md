---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: Three local-delivery primitives with debugger breakpoint integration and getMethodNames introspection
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

> *Stopped at a breakpoint on this delivery of an eventual method
> call so that you can step *into* the following `apply` in order
> to see the method call as it happens. Or step *over* to see what
> happens after the method call returns.*
>
> — `packages/eventual-send/src/local.js` §localApplyMethod inline comment

`local.js` (139 lines, Kris Kowal-last-touched 2026-02-24 in
commit `e56bf00f`) is the *local-delivery primitive layer* for
HandledPromise dispatch to non-remote recipients. The file exports
three primitives — `localApplyFunction`, `localApplyMethod`,
`localGet` — plus the public `getMethodNames` introspection helper.
Direct consumer of cycle 130's `makeMessageBreakpointTester`.
