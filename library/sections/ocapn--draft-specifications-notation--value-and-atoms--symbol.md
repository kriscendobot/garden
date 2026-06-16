---
title: Symbol
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

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
