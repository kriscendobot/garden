---
title: Pass-by-Presence vs Pass-by-Copy
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style, capability-security]
status: current
---

> Abstract: Pass-by-copy values cross the wire as data (their contents serialize). Pass-by-presence values (remotables) cross as a slot reference; the receiving side reconstructs a local proxy that forwards method calls back to the sender's original. The classification is determined by pass-style: copyArray, copyRecord, primitive, error are pass-by-copy; remotable is pass-by-presence.

## Pass-by-Presence vs Pass-by-Copy

`marshal` relies upon `@endo/pass-style` to distinguish between objects that are
pass-by-presence and those that are pass-by-copy.

To qualify as pass-by-presence, all properties of an object (and of all objects
in its inheritance hierarchy) must be methods, not data. Pass-by-presence objects
are usually treated as having identity (assuming the `convertValToSlot` and
`convertSlotToVal` callbacks behave well), so passing the same object through
multiple calls will result in multiple references to the same output object.

To qualify as pass-by-copy, all properties of an object must be string-named and
enumerable and not accessors and not methods: their values can be primitives such
as bigints, booleans, `null`, numbers, and strings, and they can be arrays and
pass-by-copy objects, but they cannot be functions. In addition, the object must
inherit directly from `Object.prototype`. Pass-by-copy objects are not treated as
having identity: `fromCapData` does not produce the same output object for
multiple appearances of the same pass-by-copy serialization.

Mixed objects having both methods and data properties are rejected.

Empty objects (which vacuously satisfy requirements for both pass-by-presence and
pass-by-copy) are treated as pass-by-copy, although it is also possible to use
`Far` (from `@endo/far`) for creating empty marker objects which _can_ be
compared for identity and are especially useful as WeakMap keys in the "rights
amplification" pattern.


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
