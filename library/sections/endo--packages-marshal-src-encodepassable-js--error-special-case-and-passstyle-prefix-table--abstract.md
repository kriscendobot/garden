---
title: Abstract
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "584-665, 869-911"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "Why `encodePassable` extracts an error-special-case before the per-PassStyle switch (diagnostic-priority over Passable-validation); the canonical `passStylePrefixes` table whose ordering matches the rankOrder PassStyle order; the `|` ordinal-mapping prefix reserved outside the cover range; the Array.prototype.sort-driven choice to put `undefined` last"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table
---

`encodePassable.js`'s inner encoder begins with **an `isErrorLike(passable)`
fast-path** that calls the error encoder before the per-PassStyle
`switch`, so that errors which are not valid Passables (e.g.,
because they are not frozen) can still produce diagnostic-bearing
encodings rather than throw at `passStyleOf`. The same shape is in
the sister `encodeToSmallcaps.js`; the rationale is the
*diagnostic-information-over-validation* priority rule that
appears in several places across marshal. The file also exports a
**canonical `passStylePrefixes` table** that names the first
character of each PassStyle's encoding (`v` null, `z` undefined,
`f` number, `s` string, `b` boolean, `np` bigint, `a` byteArray,
`y` symbol, `[^` copyArray, `r` remotable, `?` promise, `!` error,
`(` copyRecord, `:` tagged). The table's ordering is the same as
`rankOrder.js`'s PassStyle ordering and `rankOrder.js` imports the
table for this purpose. One row, `bigint: 'np'`, is two characters
because both `n` (negative) and `p` (non-negative) are valid first
bytes for the bigint cover. Outside the table, **`|` is reserved**
as the prefix for ordinal-mapping keys used in the keyed-store
substrate; `|` is positioned above every encoding's first byte so
ordinal keys always sort above value keys. The comment also names
the **Array.prototype.sort-induced** placement of `undefined` last
in the table.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L598-L911) at commit `c423ed37`.
