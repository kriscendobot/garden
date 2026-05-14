---
title: Passables: kindOf and passStyleOf levels of abstraction
source: packages/patterns/docs/marshal-vs-patterns-level.md
source_repo: endojs/endo
source_commit: 4c2d33c799f2
source_date: 2025-05-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, marshal, pass-style]
status: current
---

> Abstract: Frames the two-level type system: pass-style is the transport-level discipline (what marshal cares about); kindOf is the patterns-level discipline (what M.* matchers care about). Same value can have different pass-style and kind. The document is one of the foundational pieces by Mark Miller (erights) on the design rationale.

# Passables: `kindOf` and `passStyleOf` levels of abstraction

We have three very distinct abstraction levels in our system in which to describe the passable data types and the operations on them. On the left is the higher ***`kindOf`*** level, containing the passable data types and operations of concern to the normal application programmer. A document intended for those application programmers would explain the `kindOf` level in a self contained manner. This is not that document.

In the middle is the lower ***`passStyleOf`*** level of abstraction, which defines the [core data model of the language-independent OCapN protocol]((https://github.com/ocapn/ocapn/issues/5#issuecomment-1549012122)). The `passStyleOf` level provides the data types and operations used to implement the `kindOf` level, but without being specific to the `kindOf` level. The OCapN core data types, the `passStyleOf` level, and the [`@endo/pass-style`](https://www.npmjs.com/package/@endo/pass-style) and [`@endo/marshal`](https://www.npmjs.com/package/@endo/marshal) packages can support independent co-existing higher layers like this `kindOf` level.

On the right is the *JavaScript* level, explaining how these map onto JavaScript language. This mapping determines how JavaScript values round trip or not through the protocol. Only hardened JavaScript values can be passable. The mapping of protocol concepts to JavaScript should serve as an example of how to map the protocol onto the concepts of other languages.

| Operation      | `kindOf` level                            | `passStyleOf` level  | JavaScript level                                            |
| -------------- | ----------------------------------------- | -------------------- | ----------------------------------------------------------- |
| Classification | `kindOf(p)`<br>`M.key()`<br>`M.pattern()` | `passStyleOf(p)`     | `typeof j`                                                  |
| Equivalence    | `keyEQ(k1,k2)`                            |                      | `j1 === j2`<br>`Object.is(j1,j2)`<br>`sameValueZero(j1,j2)` |
| Ordering       | `compareKeys(k1,k2)`<br>`M.gte(k)`        | `compareRank(p1,p2)` | `j1 <= j2`<br>`[...values].sort((j1,j2) => compare(j1,j2))` |

Where the parameters
   * `j`, `j1`, and `j2` are any JavaScript values.
   * `p`, `p1`, and `p2` are any Passables, a subset of JavaScript values.
   * `k`, `k1`, and `k2` are any Keys, a subset of Passables.



Source: [packages/patterns/docs/marshal-vs-patterns-level.md](https://github.com/endojs/endo/blob/4c2d33c799f2/packages/patterns/docs/marshal-vs-patterns-level.md) at commit `4c2d33c7`.
