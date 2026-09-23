---
id: e-data-types
aliases: [E scalar types, E primitive data types, float64, E integer bignum, E char, ConstList, ConstMap, FlexList, FlexMap, EList, EMap, E collections, E Tables, Coordinate Spaces E, capability-mediated IO, File-object E, URI expression E]
topics: [e-language, pass-style, capability-security]
status: draft
---

# e-data-types

E's catalog of primitive data: the four immutable **scalars** (`integer` as an
arbitrary-precision bignum, `float64` as the IEEE double, `boolean`, `char`) plus
`null`; the **collections** (the constant/flexible by list/map Tables two-by-two —
`ConstList` / `ConstMap` / `FlexList` / `FlexMap` over the `EList` / `EMap`
interfaces — with `String` as a `ConstList` of `char`, plus Coordinate Spaces and
the open category of objects that act like collections); and **IO** as
capability-mediated access (a granted `File`-object, a URI expression) rather than
ambient open-by-path. The constant scalars and `ConstList` / `ConstMap` are E's
selfless, pass-by-copy-between-vats data; the flexible collections are selfish
(identity-compared, pass-by-reference). This is the data-type floor under the
`e-language` corpus and the direct ancestor of Endo marshal's primitive
pass-styles and of the no-ambient-authority IO discipline.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights--elang-scalars--scalar-data-types](../sections/erights--elang-scalars--scalar-data-types.md) | E's four immutable scalars plus null; arbitrary-precision integer, IEEE float64; all pass-by-copy across the network. |
| [erights--elang-collect--collections-tables-spaces-and-the-for-loop](../sections/erights--elang-collect--collections-tables-spaces-and-the-for-loop.md) | The ConstList/ConstMap/FlexList/FlexMap Tables two-by-two over EList/EMap, Coordinate Spaces, directory-as-collection, and the shared `for` loop. |
| [erights--elang-io--io-map-uri-and-text-file](../sections/erights--elang-io--io-map-uri-and-text-file.md) | E IO as capability-mediated: granted File-objects and URI expressions, not ambient open-by-path; ancestor of Endo's no-ambient-authority IO. |
| [erights--elang-quick-ref--idioms-quick-reference](../sections/erights--elang-quick-ref--idioms-quick-reference.md) | The quick-reference card naming the four ConstList/ConstMap/FlexList/FlexMap collections among E's idioms. |

## See also

- [[selfless-and-selfish-objects]] — why the constant scalars and ConstList/ConstMap are selfless (pass-by-copy) and the flexible collections selfish (pass-by-reference).
- [[pass-by-construction]] — E's PassByCopy / PassByProxy / PassByConstruction passing taxonomy that these data types instantiate.
- [[object-sameness]] — E's equality taxonomy, which governs how these values compare under `==`.
- [[e-language]] — the language these data types belong to.
