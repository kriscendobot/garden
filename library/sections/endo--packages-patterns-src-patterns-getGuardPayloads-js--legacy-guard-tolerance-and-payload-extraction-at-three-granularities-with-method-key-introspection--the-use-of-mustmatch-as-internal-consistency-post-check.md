---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: The §use of mustMatch as *internal-consistency-post-check*
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

The §`mustMatch(payload, MethodGuardPayloadShape,
'internalMethodGuardAdaptor')` and `mustMatch(payload,
InterfaceGuardPayloadShape, 'internalInterfaceGuardAdaptor')` calls
at the end of the adapter functions are the *check-that-our-
reconstruction-is-internally-consistent* invariants. The
third-argument label tags the failure for debugging — if the
adapter produces a malformed payload, the error names the source
(the *adapter-name-in-error-trace* discipline).

This is *Hoare-logic-style postcondition-on-an-adapter* — the
adapter promises to produce a valid payload, and the runtime
checks that promise on every call.
