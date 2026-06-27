---
title: See also
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

- [`endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify`](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify.md) — the array-encoding side of the legacy/compact split; this section is the string-escape side. Both sections together explain why `compactOrdered` is more efficient and how the two formats coexist.
- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the bit-complement strategy for numbers is the same sort-order-preservation discipline applied at the bit level; this section applies it at the byte level.
- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — smallcaps' `!`-prefix Hilbert-hotel escape is the sister scheme in a different encoding family. Both reserve `!` as the escape prefix; smallcaps reserves a contiguous range `!..-` for sigils (and uses `!` to escape data strings whose leading character would collide), while compactOrdered reserves a different contiguous range and a different mapping target.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the marshal README's framing of why marshal encodings exist; this section is one specific encoding's mechanism.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L249-L330) at commit `c423ed37`.
