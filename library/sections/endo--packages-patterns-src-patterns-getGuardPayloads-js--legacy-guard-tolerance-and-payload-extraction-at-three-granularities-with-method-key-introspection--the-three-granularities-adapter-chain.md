---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: The §three-granularities adapter chain
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

The file builds the legacy-tolerance adapters bottom-up:

1. **`LegacyAwaitArgGuardShape` + `getAwaitArgGuardPayload`** —
   the leaf granularity. Pre-1712 shape: `{ klass: 'awaitArg',
   argGuard }`. The extractor: if it matches the legacy shape,
   strip the `klass` and return the rest; otherwise assert the
   current `AwaitArgGuard` shape and return its `.payload`.

2. **`LegacySyncMethodGuardShape` + `LegacyAsyncMethodGuardShape`
   + `LegacyMethodGuardShape` + `getMethodGuardPayload`** — the
   middle granularity. Pre-1712 method guards had a `klass:
   'methodGuard'` + `callKind: 'sync'|'async'` shape. The extractor:
   if current shape, return `.payload`; if legacy shape, destructure
   it, *for async-call recursively adapt the argGuards via
   `adaptLegacyArgGuard`*, harden, and re-validate against
   `MethodGuardPayloadShape` (the §mustMatch ensure-the-adaptation-
   succeeded post-check).

3. **`LegacyInterfaceGuardShape` + `getInterfaceGuardPayload`** —
   the top granularity. Pre-1712 interface guards had `klass:
   'Interface'` + `interfaceName` + `methodGuards` (which were
   themselves legacy method guards). The extractor: if current
   shape, return `.payload`; if legacy shape, destructure +
   `objectMap(methodGuards, adaptMethodGuard)` to recursively adapt
   each method guard + harden + re-validate against
   `InterfaceGuardPayloadShape`.

The §pattern repeats at each level: *match-current-or-legacy →
destructure → recursively-adapt-children → harden → re-validate*.
The re-validation is the *internal-consistency-check-after-
adaptation* discipline.
