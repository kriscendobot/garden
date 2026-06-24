---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: How this file integrates the cycle 132 + cycle 130 + cycle 71 layers
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The file connects *three previously-ingested layers*:

- **cycle 71** (`passStyleOf.js`) dispatches to this file's
  `RemotableHelper.confirmCanBeValid` for any value with
  `PASS_STYLE === 'remotable'`.
- **cycle 132** (`local.js`) provides `getMethodNames`; this file
  re-exports as `getRemotableMethodNames`.
- **cycle 130** (`message-breakpoints.js`) strips the
  `'Alleged: '` / `'DebugName: '` prefixes this file *requires*.

Together they form the *what-a-remotable-is + how-to-discover-its-
methods + how-to-name-them-for-debugging* triple. Each layer is
clean of the others; the composition is at the boundary.
