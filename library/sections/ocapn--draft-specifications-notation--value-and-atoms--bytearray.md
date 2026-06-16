---
title: ByteArray
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
parent: ocapn--draft-specifications-notation--value-and-atoms
---

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
