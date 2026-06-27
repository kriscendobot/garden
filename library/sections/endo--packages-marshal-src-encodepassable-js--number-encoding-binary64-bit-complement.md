---
title: Encoding IEEE-754 doubles so that lexicographic byte order matches numeric order, with lockdown-independent NaN canonicalization
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "86-158"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "IEEE-754 double-to-bits encoding with sign-aware bit-complement so the base-16 ASCII of the bytes sorts lexicographically in the same order the floats sort numerically; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement--abstract.md)
- [Body](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement--body.md)
- [Translation](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement--translation.md)
- [See also](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement--see-also.md)

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L86-L158) at commit `c423ed37`.
