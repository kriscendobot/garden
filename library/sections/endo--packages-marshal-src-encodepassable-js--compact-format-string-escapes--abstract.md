---
title: Abstract
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "249-330"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "The compactOrdered encoding moves array element-terminator escaping from per-element to per-string: control characters and the array-element terminator are escaped at the string level via a contiguous-range mapping that preserves lexicographic order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes
---

The `compactOrdered` format encodes strings with a per-character
escape scheme that **maps each character in the contiguous ASCII
range [0x00..0x21] (the C0 controls plus space and exclamation)
to a respective character in [0x21..0x40, 0x5F, 0x7C] preceded by
`!`**. The mapping is chosen so that the relative lexicographic
order of escaped sequences agrees with the order of the original
characters, which is what lets the encoded form be embedded
directly inside a space-terminated array element without losing
the sort-order invariant. Space (the array element terminator in
`compactOrdered`) escapes to `!_`; exclamation (the escape prefix
itself) escapes to `!|`; `^` (the array-start marker) escapes to
`_@`; `_` (the array-end escape) escapes to `__`. The escape table
exists at module scope as a sparse `stringEscapes` array indexed
by code point. The `legacyOrdered` format uses identity
encoding for strings (escapes are done at the array level, not the
string level); the two-format split is a design refinement that
trades expansion ratio against rules-by-position complexity.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L249-L330) at commit `c423ed37`.
