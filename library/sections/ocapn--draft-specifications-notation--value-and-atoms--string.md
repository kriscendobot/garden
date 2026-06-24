---
title: String
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

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
