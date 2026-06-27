---
title: See also
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

- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the sister fixed-width double encoder applies the same sort-order goal via bit-complement; this section is the variable-width arbitrary-precision analog.
- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the `bigint: 'np'` row of the prefix table is what coordinates this encoding with the inter-PassStyle sort order; `n` and `p` both belong to the bigint cover, and they sort negative-before-positive within the table.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the marshal README's framing of JSON-incompatible primitives includes bigints; this section's encoding is the rank-order-preserving form, sibling to smallcaps' `+`/`-` prefix form.
- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the smallcaps wire format encodes bigints under the `+` and `-` sigils, in *human-readable decimal* form. Smallcaps targets JSON-shape rather than sort-order; the two encoders make different tradeoffs.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L160-L247) at commit `c423ed37`.
