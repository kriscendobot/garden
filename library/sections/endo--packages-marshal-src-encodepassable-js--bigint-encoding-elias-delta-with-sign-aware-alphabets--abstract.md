---
title: Abstract
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "160-247"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "Variant Elias-delta encoding of bigints with sign-aware unary-prefix alphabets and ten's-complement digit encoding so positive and negative bigints of arbitrary magnitude sort in their natural numeric order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets
---

`encodePassable.js`'s bigint encoder uses a variant of Elias delta
coding to represent an arbitrary-precision integer as three
concatenated components: a **unary count of decimal digits**, the
**decimal digit count itself**, and the **decimal digits of the
number** (with a separating colon to disambiguate the boundary
between the count-of-digits and the digits). To preserve numeric
sort order under lexicographic string comparison, the encoder
**uses different unary-prefix characters for negative and positive
values**: type `n` followed by repeats of `#` (which sorts before
decimal digits) for negative values, type `p` followed by repeats
of `~` (which sorts after decimal digits) for positive and zero
values. For negative values it additionally encodes each decimal
digit as its **ten's complement** so that larger absolute values
of negatives encode to lexicographically smaller strings (because
larger negatives are numerically smaller). The design produces a
single rank-order-preserving representation across the full
unbounded bigint range, complementing the fixed-width double
encoding in the sibling section.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L160-L247) at commit `c423ed37`.
