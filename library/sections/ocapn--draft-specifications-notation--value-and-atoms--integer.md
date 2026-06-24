---
title: Integer
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

An arbitrary precision signed integer.

> Examples:
> - `42` corresponds to `42+`.
> - `-1` corresponds to `1-`.
> - `0` corresponds to `0+`.

- _abstract-integer_: _sign_? _integer-digits_
- _sign_: `+` / `-`
- _integer-digits_: ( `0` / ( `1` - `9` ) _digit_* )
- _concrete-integer_: _integer-digits_ _sign_

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
