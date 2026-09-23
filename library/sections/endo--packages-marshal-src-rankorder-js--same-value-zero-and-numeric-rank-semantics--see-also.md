---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "19-22, 33-46, 95-115, 218-237"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why marshal's rank-order equality is sameValueZero (Map/Set's equality, with NaN equal to NaN and -0 equal to 0); why compareNumerics places NaN last and self-equal; why -0 collapses to 0 in marshal's distributed semantics; why the ENDO_RANK_STRINGS environment option exists (utf16-code-unit-order vs unicode-code-point-order vs error-if-order-choice-matters)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics
---

- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the per-style number encoder whose lexicographic-on-encoded-bytes property requires `compareNumerics`-compatible numeric rank order; the NaN canonicalization in the encoder pairs with the NaN-last-and-self-equal rule here.
- [`endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets`](endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) — bigint encoding's sort-preservation property matches `compareNumerics` for the bigint case (NaN logic degenerate; trivial less-than).
- [`endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers`](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers.md) — sibling section in the same source; how the `passStyleRanks` derivation works and why covers may be overestimates.
- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — where these primitives plug in: the inner comparator's per-PassStyle cases call `compareNumerics` for numbers/bigints and use `sameValueZero` as the up-front tie predicate.
- [[rank-order-preserving-encoding]] — the concept page; the equality predicate and the numeric rank rule are the in-memory dual of the bytes-on-the-wire rank-preservation property.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L19-L237) at commit `337d16a8`.
