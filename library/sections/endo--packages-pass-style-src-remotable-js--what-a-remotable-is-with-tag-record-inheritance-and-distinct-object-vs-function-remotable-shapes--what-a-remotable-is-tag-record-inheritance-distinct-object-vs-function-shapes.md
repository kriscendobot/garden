---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: What a remotable is — tag-record inheritance + distinct object-vs-function shapes
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

> *For a function to be a valid method, it must not be passable.
> Otherwise, we risk confusing pass-by-copy data carrying far
> functions with attempts at far objects with methods.*
>
> — `packages/pass-style/src/remotable.js` §canBeMethod JSDoc

`remotable.js` (305 lines, Kris Kowal-last-touched 2026-02-24 in
commit `e56bf00f` — same coordinated-update wave as cycles 108,
110, 115, 118, 123, 125, 132) is the *what-counts-as-a-remotable*
predicate layer. The file exports the `RemotableHelper`
PassStyleHelper (cycle 71's `passStyleOf.js` dispatches to this
for `pass-style === 'remotable'` values), plus four public
predicates: `canBeMethod`, `getRemotableMethodNames`,
`assertIface`, `getInterfaceOf`.
