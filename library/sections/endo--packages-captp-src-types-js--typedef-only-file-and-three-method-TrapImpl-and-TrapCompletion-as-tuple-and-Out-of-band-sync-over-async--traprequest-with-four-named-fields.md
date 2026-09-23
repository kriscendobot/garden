---
title: §`TrapRequest` with four named fields
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
/**
 * @typedef TrapRequest the argument to TrapGuest
 * @property {keyof TrapImpl} trapMethod
 * @property {CapTPSlot} slot
 * @property {Array<any>} trapArgs
 * @property {() => Required<Iterator<void, void, any>>} startTrap
 */
```

§Four-named-fields: §trapMethod + §slot + §trapArgs + §startTrap. §The-`startTrap`-field-is-a-callback-not-a-value: §the-TrapGuest-calls-startTrap-to-begin-the-out-of-band-process.

§`keyof TrapImpl`-as-trapMethod-type: §the-trapMethod-IS-a-key-of-the-TrapImpl-interface (i.e., one of 'applyFunction' | 'applyMethod' | 'get'); §the-`keyof`-utility-type-encodes-the-dependency-between-TrapRequest-and-TrapImpl. §When-a-protocol-field-must-be-one-of-an-interface's-keys, §use-`keyof InterfaceName`-not-a-string-union.

§Defense-by-construction-via-`keyof`: §adding-a-method-to-TrapImpl-automatically-extends-the-allowed-trapMethod-values + §removing-a-method-from-TrapImpl-causes-a-type-error-everywhere-trapMethod-is-used-with-the-removed-name. §First-explicit-observation in library of §`keyof InterfaceName`-as-defense-by-construction-against-string-union-drift.
