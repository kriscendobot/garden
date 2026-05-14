---
title: Container: Tagged
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, marshal, pass-style]
status: current
notes: Cross-reference: library/sections/endo--pkg-pass-style-readme--maketagged.md describes the Endo construction.
---

> Abstract: OCapN Tagged: a (tag, payload) pair where tag is a Symbol and payload is any value. Maps directly to pass-style tagged (created via makeTagged). Tag-symbol restrictions match the OCapN Symbol atom restrictions.

## Tagged

A pair consisting of a tag and a [Value](#value).
The tag must be a [String](#string).

> OCapN provides a small number of container types with minimal semantics.
> Tags allow protocols to emerge from values annotated to indicate a richer
> variety of semantics.
> For example, an arbitrary-precision decimal number might be represented as a
> Tagged with a tag of "decimal" and a value that is a decimal
> [String](#string) such as "3.14" (or alternatively, a value that is a
> two-element [List](#list) of significand and decimal exponent
> [Integers](#integer) such as [314, -2]).
>
> - **Guile**: currently a Guile record labeled `'(make-tagged 'tagName 10)` (**imported**)
> - **JavaScript**: an object with three own properties:
>   for the registered symbol key `passStyle`, the value is the string `tagged`;
>   for the well-known symbol key `toStringTag`, the value is the tag;
>   for the string key `payload`, the value is the tagged value.
>   ```js
>   ({
>     [Symbol.for('passStyle')]: 'tagged',
>     [Symbol.toStringTag]: 'tagName',
>     payload
>   })
>   ```
> - **Python**: `Tagged('tagName', value)` where `tag` is a `string` and `Tagged` is
>   imported from `ocapn`.
>
> OCapN tagged data have a single value (are not variadic) [November 14, 2023]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md)
>
> What are tagged values for? https://github.com/ocapn/ocapn/issues/52

Tagged values are equal or Equal for the purposes of [Pass Invariant
Equality](#pass-invariant-equality) if the tag and value are Equal,
transitively.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
