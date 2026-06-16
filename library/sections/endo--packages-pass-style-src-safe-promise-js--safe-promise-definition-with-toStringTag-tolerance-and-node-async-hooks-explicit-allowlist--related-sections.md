---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: Related sections
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatcher that depends on this file's
  safe-promise invariant when promises cross handler boundaries.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — the local-delivery primitives that *trust* the safe-promise
  invariant when calling `apply()`.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — uses `hideAndHardenFunction(assertIface)` for the same
  stack-trace-name-hiding rationale this file applies to
  `isSafePromise`/`assertSafePromise`.
- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that *doesn't* classify promises as a pass-
  style; the safe-promise discipline is *adjacent* to pass-style
  rather than *inside* it.
