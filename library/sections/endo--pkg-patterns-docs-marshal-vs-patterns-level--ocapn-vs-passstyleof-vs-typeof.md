---
title: OCapN vs Endo passStyleOf vs JavaScript typeof
source: packages/patterns/docs/marshal-vs-patterns-level.md
source_repo: endojs/endo
source_commit: 4c2d33c799f2
source_date: 2025-05-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, marshal, pass-style, ocapn]
status: current
---

> Abstract: Three abstraction levels of JS values: typeof (the JS-language primitive), passStyleOf (Endo's marshal-level classification with the 8 pass styles), OCapN protocol kinds (the wire-format categories OCapN distinguishes). Each level subsumes the next in detail; the document traces the mappings between them.

## OCapN *vs* Endo `passStyleOf` *vs* JavaScript `typeof`

The OCapN language-independent ocap protocol is in flux. As of May 20 2023, the best draft of the OCapN data model is [the thread starting here](https://github.com/ocapn/ocapn/issues/5#issuecomment-1549012122). Although the Endo `passStyleOf` names differ, the taxonomy and data models will be the same. The [`@endo/pass-style`](https://www.npmjs.com/package/@endo/pass-style) package defines the language binding of this abstract data model to JavaScript language values, which are therefore considered *Passable values*.

|            | OCapN name    | `passStyleOf`  | `typeof`                 | JS notes                      |
|------------|---------------|----------------|--------------------------|-------------------------------|
| Atoms      |               |                |                          |                               |
|            | Null          | `"null"`       | `"object"`               | null                          |
|            | Undefined     | `"undefined"`  | `"undefined"`            |                               |
|            | Boolean       | `"boolean"`    | `"boolean"`              |                               |
|            | Float64       | `"number"`     | `"number"`               | Only one zero, only one NaN   |
|            | SignedInteger | `"bigint"`     | `"bigint"`               |                               |
|            | Symbol        | `"symbol"`     | `"symbol"` -> `"object"` | will represent as JS object   |
|            | String        | `"string"`     | `"string"`               | surrogate confusion (TBD)     |
|            | ByteArray     | `"byteArray"`  | `"object"`               | Immutable ArrayBuffer         |
| Containers |               |                |                          |                               |
|            | Sequence      | `"copyArray"`  | `"object"`               | Array                         |
|            | Struct        | `"copyRecord"` | `"object"`               | POJO                          |
|            | Tagged        | `"tagged"`     | `"object"`               | Tagged/CopyTagged             |
| Capability |               |                |                          |                               |
|            |               | `"remotable"`  | `"function"`             | Remotable function            |
|            |               | `"remotable"`  | `"object"`               | Remotable object with methods |
|            |               | `"remotable"`  | `"object"`               | Remote Presence               |
|            |               | `"promise"`    | `"object"`               | Promise                       |
| Others     |               |                |                          |                               |
|            | Error         | `"error"`      | `"object"`               | Error                         |

The [`@endo/marshal`](https://www.npmjs.com/package/@endo/marshal) package defines encodings of the data model for purposes of serialization and transmission.
It also defines a "rank order" over all Passable values (a [total preorder](https://en.wikipedia.org/wiki/Weak_ordering) in which different values are always comparable but can be tied for the *same rank*) that can be used for sorting but is not intended to make sense for an application programmer.

The [`@endo/patterns`](https://www.npmjs.com/package/@endo/patterns) package defines the `kindOf` taxonomy, which includes additional containers, Keys and Patterns, and a `compareKeys` [partial order](https://en.wikipedia.org/wiki/Partially_ordered_set) over Keys that is designed to be meaningful and useful to the applications programmer.


Source: [packages/patterns/docs/marshal-vs-patterns-level.md](https://github.com/endojs/endo/blob/4c2d33c799f2/packages/patterns/docs/marshal-vs-patterns-level.md) at commit `4c2d33c7`.
