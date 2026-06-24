---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "86-911"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "Rank-order-preserving encoding for keyed-store keys: per-PassStyle encoders that map Passables to byte strings whose lexicographic order matches PassStyle rank order; dual `legacyOrdered` / `compactOrdered` formats; `passStylePrefixes` canonical table; error-special-case rooted in the diagnostic-priority rule"
source_authors: [Mark S. Miller, Chip Morningstar, Kris Kowal, Richard Gibson, Michael FIG, Turadg Aleahmad, Mathieu Hofman]
ingested: 2026-05-29
ingested_by: scholar
section_count: 5
status: current
notes: |
  Fifth comment-fragment ingest (cycle 81), following the
  marshal.js precedent from cycle 74. Five sections distilled
  from the longform comments throughout `encodePassable.js`:
  the rank-order-preserving primitives for numbers (bit-complement)
  and bigints (Elias-delta with sign-aware alphabets); the
  contiguous-range string-escape table that preserves lexicographic
  order; the dual array encodings (legacyOrdered NUL-terminator
  + SOH-escape vs. compactOrdered space-terminator + pre-escaped
  strings) and the double-decode embeddability verify check that
  defends compactOrdered's framing on user-supplied remotable /
  promise / error encoders; the error-special-case at the encoding
  root (diagnostic priority) and the canonical `passStylePrefixes`
  table whose ordering coordinates per-PassStyle rank order with
  the cover machinery (with the `|` ordinal-mapping prefix
  reserved outside the cover range and the Array.prototype.sort-
  induced placement of `undefined` last).
---

## Abstract

`packages/marshal/src/encodePassable.js` is the rank-order-preserving
encoder for `@endo/marshal`'s keyed-store substrate. Where
`encodeToSmallcaps.js` (cycle 69) targets *JSON-shape* round-trip,
this file targets *lexicographic byte order matches PassStyle rank
order*: the encoded form of two Passables compares as strings in
the same direction the original values compare under PassStyle
rank ordering. The longform comments document the five non-obvious
design moves the implementation rests on: a **sign-aware bit-
complement** that maps IEEE-754 doubles to sort-order-preserving
hex strings with a lockdown-independent NaN canonicalization; a
**variant Elias-delta encoding** for bigints with `#`/`~` sign-
aware unary alphabets and ten's-complement digit encoding; a
**contiguous-range string-escape table** that maps `[0x00..0x21]`
to `[0x21..0x40]`-via-`!`-prefix while preserving lexicographic
order (the `compactOrdered` format); a **dual array-encoding
split** (legacyOrdered with NUL-terminator and SOH-escape vs.
compactOrdered with space-terminator and pre-escaped strings)
plus a double-decode framing-verification on user-supplied
remotable / promise / error encoders; and a **canonical
`passStylePrefixes` table** with first-byte prefixes for each
PassStyle whose source-order matches `rankOrder.js`'s ordering,
extended at the encoder root by an `isErrorLike` diagnostic-
priority special case. The comments are the canonical source for
all five claims.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [number-encoding-binary64-bit-complement](../sections/endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) | marshal, pass-style | current |
| [bigint-encoding-elias-delta-with-sign-aware-alphabets](../sections/endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) | marshal, pass-style | current |
| [compact-format-string-escapes](../sections/endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) | marshal, pass-style | current |
| [dual-array-encodings-and-double-decode-verify](../sections/endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify.md) | marshal, pass-style | current |
| [error-special-case-and-passstyle-prefix-table](../sections/endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) | marshal, pass-style | current |

## Provenance

- File last modified 2026-04-07 by Mark S. Miller (committed
  through endojs/endo's mainline history).
- File-specific commit `e6192056a5d7ff5acb084f6a58dca3663aa9943e`
  (captured 2026-05-29 by `git --git-dir=worktrees/endojs-endo.git
  log -1 --format=%H master -- packages/marshal/src/encodePassable.js`).
- Comments authored across the file's history by Mark S. Miller,
  Chip Morningstar, Kris Kowal, Richard Gibson, Michael FIG,
  Turadg Aleahmad, and Mathieu Hofman. The file's substrate
  goes back to the original `@agoric/store`'s `encodePassable.js`;
  the file in `@endo/marshal` is the post-migration form with
  the `compactOrdered` format added (PR #1260).

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js) at commit `e6192056`.
