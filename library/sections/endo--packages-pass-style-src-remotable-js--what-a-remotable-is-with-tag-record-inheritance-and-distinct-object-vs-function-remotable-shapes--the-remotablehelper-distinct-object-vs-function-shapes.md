---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §RemotableHelper — distinct object-vs-function shapes
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §exported `RemotableHelper` is the PassStyleHelper that
cycle 71's `passStyleOf.js` dispatches to for
`pass-style === 'remotable'`. The interesting structure is
`confirmCanBeValid`: it branches on `typeof candidate`:

- **`'object'`**: *every own property (regardless of
  enumerability) must have a function value*. No accessors
  (*cannot serialize Remotables with accessors like X*). No
  non-method properties (*cannot serialize Remotables with
  non-methods like X*). No PASS_STYLE shadowing (*A pass-by-remote
  cannot shadow PASS_STYLE*). The `@@toStringTag` is exempt
  (validated via `confirmIface`).

- **`'function'`** (Far functions): *Far functions cannot be
  methods, and cannot have methods*. The function must have *only*
  `.name` (string), `.length` (number), and optionally
  `@@toStringTag` (string via `confirmIface`). The §`...restDescs`
  destructure followed by `restKeys.length === 0` check enforces
  *exactly these three* properties — *Far functions unexpected
  properties besides .name and .length*.

The §two-distinct-shapes discipline is the design's central
asymmetry:

- **Object remotables**: a *bag of methods* + `@@toStringTag`.
  Methods don't carry PASS_STYLE (per `canBeMethod`); the object
  itself does.
- **Function remotables (Far functions)**: a *single callable* +
  metadata. No methods can hang off it; *Far functions cannot
  have methods*.

The §Far-functions-cannot-be-methods-and-cannot-have-methods
discipline rules out the recursive case (a Far function with
methods that are themselves Far functions). The two shapes are
*mutually exclusive* — an object remotable is *not* a callable;
a Far function is *not* a bag of properties.
