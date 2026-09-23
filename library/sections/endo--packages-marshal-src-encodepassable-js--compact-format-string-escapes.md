---
title: The compactOrdered format's `!`-prefixed escape scheme for ASCII control characters, space-as-array-terminator, and the `^`/`_` array-marker pair
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
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes--abstract.md)
- [Body](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes--body.md)
- [Translation](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes--translation.md)
- [See also](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes--see-also.md)

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L249-L330) at commit `c423ed37`.
