---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: Related sections
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

- cycle 67 (marshal's serialize/unserialize)
  [[endo--packages-marshal-src-marshal-js--dual-format-body-discriminator]]
  — the `makeMarshal(convertSlotToVal, convertValToSlot)`
  factory this file uses twice (once per direction).
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — the §two-distinct-shapes (object remotable vs Far function)
  that this file's §remotable case branches on.
- cycle 136
  [[endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline]]
  — the `Far(iface, ...)` constructor this file uses to build
  the proxy-side wrappers.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — the `getMethodNames` source whose wrapped form
  (`getRemotableMethodNames` from cycle 134) this file uses for
  method-by-method translation.
- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the `E.when` machinery this file's §promise case uses to
  resolve mirror promises across the membrane.
