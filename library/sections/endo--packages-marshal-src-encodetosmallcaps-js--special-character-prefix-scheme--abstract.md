---
title: Abstract
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "34-77"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Smallcaps' reserved special-character range (BANG `!` 33 to DASH `-` 45) and the prefix assignments that turn JSON strings into a tagged representation"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme
---

Smallcaps' core design move is to **reserve a contiguous range of
ASCII characters (33-45, `!` through `-`) as string-prefix sigils**,
turning a JSON string into either a literal string (when its first
char is outside the reserved range) or a tagged value (when its
first char is in the range). The longform JSDoc above
`startsSpecial` enumerates the currently-assigned sigils (`!` for
escaped string, `+` / `-` for bigints, `#` for manifest constants
and tag-property prefixes, `%` for passable symbols, `$` for
remotables, `&` for promises) and the future-reserved ones
(`"`, `'`, `(`, `)`, `*`, `,`). The choice of a *contiguous* range
matters: leading-character ASCII order on a tagged value sorts the
same way the unprefixed value would in a sorted-key index, which
preserves the marshal-side canonical ordering invariant when the
encoding is later JSON-stringified. The scheme replaces the older
capdata `@qclass` tagged-object form (one fewer level of nesting,
roughly half the wire bytes for primitives) at the cost of a
constrained reserved range that future smallcaps versions cannot
expand without breaking string round-trip.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L34-L77) at commit `e56bf00f`.
