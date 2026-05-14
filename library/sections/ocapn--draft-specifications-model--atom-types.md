---
title: Atom types (Undefined, Null, Boolean, Integer, Float64, String, Symbol, ByteArray)
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
---

> Abstract: All 8 atom types in the upstream protocol's value model. Maps to pass-style as follows: OCapN Undefined ↔ pass-style undefined; OCapN Null ↔ pass-style null; OCapN Boolean ↔ pass-style boolean; OCapN Integer + Float64 (split into two atoms in OCapN, with Float64 carrying NaN/Infinity semantics) ↔ pass-style number + bigint (Endo merges integers into the JS number atom unless they exceed safe-integer range, in which case bigint applies); OCapN String ↔ pass-style string; OCapN Symbol ↔ pass-style symbol (with well-known + registered restrictions); OCapN ByteArray ↔ no pass-style equivalent (Endo conveys ByteArrays via tagged values wrapping Uint8Array). The integer/float split is the most notable disagreement: OCapN keeps them distinct at the wire level; Endo's smallcaps wire format encodes JS numbers and BigInts but does not separately tag float-vs-integer.

## Undefined

A value representing the absence of a value.

> - **Guile**: `*unspecified*`
> - **JavaScript**: `undefined`
> - **Python**: `None`

If a JavaScript implementation of OCapN receives a [Struct](#struct) with an
Undefined value for some key, the struct must be represented as an object
that owns a property with the value `undefined` for that key.

> Consequently, `JSON.stringify` for the same OCapN struct will omit the
> property from the generated JSON object.

For purposes of [Pass Invariant Equality](#pass-invariant-equality),
there is only one Undefined value and it is equal to itself.

## Null

([JSON](#json-invariants))

A value representing `null` as distinct from `undefined` for the purpose
of maintaining [JSON Invariants](#json-invariants).

> - **Guile**: tentatively `json-null` (*imported*)
> - **JavaScript** and **JSON**: `null`
> - **Python**: `Null` (*imported*)

If a JavaScript implementation of OCapN receives a [Struct](#struct) with
a Null value for some key, the struct must be represented as an object
that owns a property with the value `null` for that key.

> Consequently, `JSON.stringify` for the same OCapN struct will have
> a property with the value `null` in the generated JSON object.

For purposes of [Pass Invariant Equality](#pass-invariant-equality),
there is only one Null value and it is equal to itself.

## Boolean

([JSON](#json-invariants))

A value that is either true or false.

> - **Guile**: `#f`, `#t`
> - **JavaScript** and **JSON**: `false`, `true`
> - **Python**: `False`, `True`

For purposes of [Pass Invariant Equality](#pass-invariant-equality),
the values True and False are equal only to their respective selves.

## Integer

An arbitrary precision signed integer.

> - **Guile**: `-1`, `0`, `1`
> - **JavaScript**: `-1n`, `0n`, `1n`
> - **Python**: `-1`, `0`, `1`
>
> Note: We achieved consensus on the name `Integer` at the
> [November 14, 2023 meeting]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md).

For purposes of [Pass Invariant Equality](#pass-invariant-equality), every
Integer value is only equal to Integer values that represent the same
arithmetic integer.

## Float64

([JSON](#json-invariants))

An IEEE 754 64-bit floating point number.

OCapN preserves the distinction between +0 and -0.

| Language       | Negative | Positive |
|----------------|---------:|---------:|
| **Guile**      | `-0.0`   | `0.0`    |
| **JavaScript** | `-0`     | `0`      |
| **Python**     | `-0.0`   | `0.0`    |

OCapN preserves positive and negative infinity.

| Language       | Negative        | Positive       |
|----------------|----------------:|---------------:|
| **Guile**      | `-inf.0`        | `+inf.0`       |
| **JavaScript** | `-Infinity`     | `Infinity`     |
| **Python**     | `float('-inf')` | `float('inf')` |

OCapN collapses the complete set of NaN values to a single abstract NaN.

OCapN provides no support for other floating point precisions.

> - **Guile**: `+nan.0`
> - **JavaScript**: `NaN`
> - **Python**: `float('nan')`
>
> Tracking: https://github.com/ocapn/ocapn/issues/58
>
> OCapN round-trips all floating point numbers representable within IEEE 754
> binary64, except that OCapN considers all NaNs as equivalent, that is, as jointly
> representing a single abstract NaN value.
> So, any concrete NaN representation may validly round trip even if it results
> in a different concrete representation.
> However, we encourage use of a canonical representation for NaN.
>
> Concretely, the canonical NaN is `0x7ff8_0000_0000_0000`, though this is not
> a concern of the abstract syntax and data model.
>
> All real and finite double precision floating point numbers participate in the
> JSON subset of OCapN.
> We expect OCapN-compatible JSON codecs, including the JavaScript `JSON` codec,
> to round-trip all numbers except NaNs, infinities, and negative zero, but all
> other numbers expressible with an IEEE 754 double-precision float to survive a
> round trip without loss of precision.
> We also do not expect integers expressed with higher precision in JSON to
> survive a round-trip through an OCapN-compatible JSON codec.
>
> Consensus on preserving -0:
> - As of May 16, @erights insisted that -0 round trip to 0 https://github.com/ocapn/ocapn/issues/5#issuecomment-1550020450
> - On May 23, @zenhack proposed preserving -0 https://github.com/ocapn/ocapn/issues/5#issuecomment-1560116857
> - We converged out of band and Agoric has committed to preserving -0 https://github.com/endojs/endo/issues/1602

For purposes of [Pass Invariant Equality](#pass-invariant-equality):
- Every finite Float64 is equal to any other Float64 with the same bitwise
  representation.
- Every infinite Float64 is equal to any other infinite Float64 of the same
  sign.
- There is only one NaN value and it is equal to itself.

> JavaScript's `Object.is` is consistent with Pass Invariant Equality, whereas
> `==` and `===` are not.

## String

([JSON](#json-invariants)†)

A sequence of Unicode code points excluding surrogates (U+D800-U+DFFF).
Strings are distinguished from [Symbols](#symbol) by type, not content.

> - **Guile**: `""`
> - **JavaScript**: `''`
> - **Python**: `''`
>
> †Strings participate in the [JSON subset](#json-invariants) of OCapN except
> any strings that contain surrogate code points.
>
> A string's content must be expressible in UTF-8.
> Some two-byte Unicode encodings, as in JavaScript strings, can contain
> 16-bit surrogate code _units_ in the range from 0xD800-0xDFFF.
> Pairs of surrogate code units correspond to a single Unicode code _point_
> greater than or equal to U+10000 and can be expressed in UTF-8.
> However unpaired or lone surrogates have no valid expression in any UTF
> and so cannot be carried by OCapN.
>
> Notes: [January 2024 meeting
> notes](https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2024-01-09.md)
> record that we agreed that strings can only be well-formed Unicode, that is,
> cannot contain unpaired surrogate code points.
> For JavaScript, if a string does not pass [the `isWellFormed`
> predicate](https://github.com/tc39/proposal-is-usv-string), then it is not a
> Passable string.

For purposes of [Pass Invariant Equality](#pass-invariant-equality), a pair of
Strings are equal if they have the same quantity of Unicode code points and
have the same respective Unicode code points in order.

## Symbol

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

## ByteArray

An array of 8-bit bytes.

> - **Guile**: `#vu8()`
> - **JavaScript**: `new ArrayBuffer()`
> - **Python**: `b''`
>
> Tracking: https://github.com/ocapn/ocapn/issues/48
>
> At the [November 14, 2023]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md)
> meeting, we agreed to settle on the prefix "byte" and agreed to decide at the
> next meeting based on a [reactji poll]
> (https://github.com/ocapn/ocapn/issues/48#issuecomment-1811097196).
>
> [January 2024 meeting
> notes](https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2024-01-09.md)
> record that we agreed on ByteArray because it was the winner of the poll, and
> we had already agreed to resolve this specific issue by poll among these
> three choices.
>
> The JavaScript representation of a ByteArray is an `ArrayBuffer` which may
> be made immutable with the proposed JavaScript [Immutable
> ArrayBuffer](https://github.com/tc39/proposal-immutable-arraybuffer) feature.

For purposes of [Pass Invariant Equality](#pass-invariant-equality), a pair of
ByteArrays are equal if they have the same quantity of bytes and have the same
respective bytes in order.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
