---
title: Symbol
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
notes: Cross-reference: library/sections/endo--pkg-pass-style-readme--pass-styles.md enumerates the pass-style side; library/sections/endo--pkg-marshal-readme--beyond-json.md describes smallcaps's wire-format choices.
parent: ocapn--draft-specifications-model--atom-types
---

A sequence of Unicode code points excluding surrogates (U+D800-U+DFFF).
Symbols are distinguished from [String](#string)s by type, not content.

> - **Guile**: symbols `'name`
> - **JavaScript**: an object with two own properties:
>   for the registered symbol key `passStyle`, the value is the string
>   `symbol`; and
>   for the well-known symbol `toStringTag`, the value is a string consisting
>   of the code points of the symbol.
>   ```js
>   ({
>     [Symbol.for('passStyle')]: 'symbol',
>     [Symbol.toStringTag]: 'name',
>   })
>   ```
> - **Python**: `Symbol('name')` where `Symbol` is imported from `ocapn`.
>
> A symbol's content must be expressible in UTF-8.
> Some two-byte Unicode encodings, as in JavaScript strings, can contain
> 16-bit surrogate code _units_ in the range from 0xD800-0xDFFF.
> Pairs of surrogate code units correspond to a single Unicode code _point_
> greater than or equal to U+10000 and can be expressed in UTF-8.
> However unpaired or lone surrogates have no valid expression in any UTF
> and so cannot be carried by OCapN.
>
> Tracking: https://github.com/ocapn/ocapn/issues/46
>
> Although OCapN uses the name Symbol, not all languages have an appropriate,
> corresponding, native symbol type and may use a representation that is not the
> language’s symbol.
>
> For example, JavaScript has three kinds of symbol, none of which is an ideal
> representation of an OCapN symbol.
> - Some implementations of JavaScript retain registered symbols indefinitely,
>   which exposes a registry stuffing vulnerability.
> - Anonymous symbols with the same description are not equal in JavaScript.
>   Although OCapN pass-invariant equality does not correspond to any JavaScript
>   equality for all types, a reasonable developer might be confused or misled by
>   intuition.
> - Well-known symbols might inadvertently elevate language-specific protocols
>   to OCapN protocols, imposing on other languages’ implementations of OCapN.
>
> So, it follows that a JavaScript implementation might reasonably use an object
> envelope around a string, which would make OCapN’s pass-invariant equality
> at least correspond to some common JavaScript deep equality operators
> such as Ava's `t.deepEqual`.
> OCapN symbols may correspond to language symbols in languages where an
> unreachable symbol is eligible for unobservable garbage collection. But not
> JavaScript.
>
> OCapN supports one operator for delivering both function application and
> method invocation.
> By convention, method invocation is equivalent to function application, where
> the first argument is a symbol followed by the remaining arguments.
>
> However, like symbols in Guile, symbols are first-class values and can appear
> anywhere values appear, including any argument position, inside a container,
> or as a promise fulfillment value or rejection reason.

For purposes of [Pass Invariant Equality](#pass-invariant-equality), a pair of
Symbols are equal if they have the same quantity of Unicode code points and
have the same respective Unicode code points in order.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
