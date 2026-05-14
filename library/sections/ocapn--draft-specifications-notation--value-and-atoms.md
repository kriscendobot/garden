---
title: Notation for Value and Atoms (Boolean, Integer, Float64, String, Symbol, ByteArray)
source: draft-specifications/Notation.md
source_repo: kriscendobot/ocapn
source_commit: e5e153554321895fc7e8c47d4b3741f82ad7adb2
source_date: 2025-06-19
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, marshal, pass-style]
status: current
notes: Parallel to ocapn--draft-specifications-model--atom-types (the semantics). Read this for how Atoms appear in the spec; read Model for what they mean.
---

> Abstract: How the spec writes each Value type. Parallel to Model.md atom-types but covering the wire-format-notation rather than the type semantics. The actual type definitions are in Model.md; this section is how those types appear in spec prose.

## Value

A representation of any expressible value in an OCapN message.

- _abstract-value_: _abstract-boolean_ / _abstract-integer_ /
  _abstract-float64_ / _abstract-symbol_ / _abstract-string_ /
  _abstract-byte-array_ / _abstract-struct_ /
  _abstract-list_ / _abstract-record_
- _concrete-value_: _concrete-boolean_ / _concrete-integer_ /
  _concrete-float64_ / _concrete-symbol_ / _concrete-string_ /
  _concrete-byte-array_ / _concrete-struct_ /
  _concrete-list_ / _concrete-record_

## Boolean

A value that is either true or false.

> Examples:
> - `f` corresponds to `f`.
> - `t` corresponds to `t`.

- _abstract-boolean_: `f` / `t` :: Corresponding to false and true respectively.
- _concrete-boolean_: `f` / `t`

## Integer

An arbitrary precision signed integer.

> Examples:
> - `42` corresponds to `42+`.
> - `-1` corresponds to `1-`.
> - `0` corresponds to `0+`.

- _abstract-integer_: _sign_? _integer-digits_
- _sign_: `+` / `-`
- _integer-digits_: ( `0` / ( `1` - `9` ) _digit_* )
- _concrete-integer_: _integer-digits_ _sign_

## Float64

An IEEE 754 64-bit floating point number.

> Examples:
> - `nan` corresponds to the bytes 44 (`"D"`), 7f, f8, 00, 00, 00, 00, 00, 00
>   in hexadecimal.

- _abstract-float64_: _abstract-float64-number_ / ( _sign_? `inf` ) / `nan`
- _abstract-float64-number_: _abstract-integer_ `.` _digit_* /
  _sign_? `.` _digit_+ :: Corresponding to the nearest expressible concrete IEEE
  754 64-bit floating point number, rounding ties to even.
- _concrete-float64_: `D` followed by the corresponding 8 bytes of an IEEE 754
  64-bit floating point number.

## String

A sequence of [Unicode](https://www.unicode.org/standard/standard.html) code
points excluding surrogates (U+D800-U+DFFF).

> Example: `"twine"` corresponds to `5"twine`.

- _abstract-string_: `"` _abstract-character_ * `"`
- _abstract-character_:: _any printable ASCII character except `"` or `\`_ ::
  note that spaces are printable
- _concrete-string_: _length_ `"` _bytes_
- _length_: _integer-digits_ :: The number of bytes in _bytes_ as ASCII decimal
  digits.
- _bytes_: _byte_* :: The bytes of the string in UTF-8 encoding.

We do not attempt to capture strings with embedded quotes or non-ASCII Unicode
characters in the abstract notation, but all Unicode strings excluding
surrogates (U+D800-U+DFFF) are expressible in the concrete representation.

## Symbol

A sequence of Unicode code points excluding surrogates (U+D800-U+DFFF).

> Example: `'fleur-de-lis` corresponds to `12'fleur-de-lis`.

- _abstract-symbol_: `'` _name_
- _name_: _alpha_ ( _alpha_ / _digit_ / `-` / `:` )*
- _alpha_: ( `a` - `z` ) / ( `A` - `Z` )
- _digit_: `0` - `9`
- _concrete-symbol_: _length_ `'` _bytes_
- _bytes_: _byte_* :: The bytes of the symbol in UTF-8 encoding.

We do not attempt to capture symbols with arbitrary Unicode characters in the
abstract notation, but all Unicode strings excluding surrogates (U+D800-U+DFFF)
are expressible in the concrete representation.

## ByteArray

An array of 8-bit bytes.

> Example: `:b0b5c0ffeefacade` corresponds to the bytes of `8`, `:`, b0, b5,
> c0, ff, ee, fa, ca, de in ASCII and hexadecimal.

- _abstract-byte-array_: `:` _hex_
- _hex_: ( _hex-digit_ _hex-digit_ )*
- _hex-digit_: _digit_ / ( `a` - `f` ) :: Corresponding to a _byte_ of _bytes_.
- _concrete-byte-array_: _length_ `:` _bytes_ :: The number of bytes in _bytes_
  and the _bytes_.

We do not attempt to capture byte arrays with non-space ASCII characters in the
abstract notation, but all byte arrays are expressible in the concrete
representation.


Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
