---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: "The §every: always-true short-circuit"
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The PassStyleHelper interface (cycle 71's framework) requires an
`every(passable, fn)` method that iterates the passable's
internal structure. Remotables have no internal pass-style
structure — they're *leaves* in the pass-style tree. So:

```js
every: (_passable, _fn) => true,
```

The §leaf-no-iteration discipline. Remotables are opaque from
pass-style's perspective; their internal state is *not* enumerated
or recursed into.
