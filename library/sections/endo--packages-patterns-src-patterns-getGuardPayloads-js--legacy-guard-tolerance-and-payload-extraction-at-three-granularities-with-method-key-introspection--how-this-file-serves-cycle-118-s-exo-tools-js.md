---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: How this file serves cycle 118's exo-tools.js
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

The connection back to cycle 118:

- Cycle 118 section 2's `defendPrototype` calls
  `getInterfaceGuardPayload(interfaceGuard)` to extract:
  `interfaceName`, `methodGuards`, `symbolMethodGuards`,
  `defaultGuards`, `sloppy`.

- Cycle 118 section 2's symmetric listDifference validation
  iterates over the keys returned by *both this file's
  `methodGuards` and `symbolMethodGuards`* — those are the keys
  that interface declares, which must match what behavior
  implements.

- Cycle 118 section 2's `GET_INTERFACE_GUARD` auto-installation
  stores the interface guard itself on the prototype; later
  introspection callers use *this file's `getInterfaceMethodKeys`*
  to enumerate the methods.

- Cycle 118 section 2's `sloppy: true` aliased to `defaultGuards:
  'passable'` matches *this file's `LegacyInterfaceGuardShape`*'s
  optional `sloppy: M.boolean()` and `defaultGuards: M.or(M.undefined(),
  'passable', 'raw')` fields.

The two files together form the *exo defendPrototype +
guard-payload-adapter* pair. Cycle 118 is what consumes; this
cycle is what enables consumption regardless of which release
emitted the guard.
