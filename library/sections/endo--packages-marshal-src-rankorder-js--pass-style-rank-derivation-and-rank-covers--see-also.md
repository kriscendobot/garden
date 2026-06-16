---
title: See also
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "107-148"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "How rankOrder.js sorts and walks passStylePrefixes to derive per-PassStyle rank index and rank cover; the BMP/printable-ASCII assumption on prefixes; the multi-character-prefix sortedness assertion; why getPassStyleCover advertises that the cover may be an overestimate (no smallest/biggest bigint forces bounding by adjacent style boundaries)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers
---

- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the source-of-truth table this section reads; its source-order matches what `passStyleRanks` extracts via sort + index.
- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — sibling section in the same source; uses `passStyleRanks[leftStyle].index` to rank values of different PassStyles against each other.
- [`endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics`](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) — sibling section; explains how `compareNumerics` is then used to compare two `passStyleRanks[...].index` integers when PassStyles differ.
- [[rank-order-preserving-encoding]] — the concept page; the derivation here is the in-memory dual of the bytes-on-the-wire prefix table.
- [[pass-invariant-handle-equality]] — adjacent concept; the per-PassStyle equality discipline that motivates the per-PassStyle rank discipline.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L107-L148) at commit `2e933309`.
