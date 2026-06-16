---
title: Float64
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

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
