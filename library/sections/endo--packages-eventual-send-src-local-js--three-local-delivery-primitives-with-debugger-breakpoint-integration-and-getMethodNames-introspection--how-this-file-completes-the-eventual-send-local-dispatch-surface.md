---
section: three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
source: endo--packages-eventual-send-src-local-js
topics: [eventual-send]
status: current
title: How this file completes the eventual-send local-dispatch surface
parent: endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection
---

The eventual-send package now has *five files* in the library:

- cycle 66 — `handled-promise.js` §handler-protocol (the
  *HandledPromise handler protocol* surface)
- three §track-turns.js sections (one per ingest cycle)
- cycle 130 — `message-breakpoints.js`
- **cycle 132 (this cycle)** — `local.js`

Together they cover the eventual-send local-dispatch surface:
HandledPromise dispatches incoming eventual sends to *either*
remote handlers OR these `localApply*` primitives; track-turns
captures the *causal cross-turn provenance*;
message-breakpoints provides the *debugger-pause* surface; this
file is the *connect-the-handler-to-the-actual-call* layer.
