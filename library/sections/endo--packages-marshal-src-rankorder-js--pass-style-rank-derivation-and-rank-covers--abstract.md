---
title: Abstract
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

`rankOrder.js` derives its **per-PassStyle rank table** (the
`passStyleRanks` record) by walking `encodePassable.js`'s canonical
`passStylePrefixes` table in ascending-prefix order and computing
two things for each PassStyle: a small integer `index` (its
position in the sort, which is the actual rank order across
PassStyles) and a `cover` (a `[low, high)` pair of bracket strings
whose lexicographic comparison places every encoded value of that
PassStyle between them). The derivation rests on three assumptions
the code asserts inline: that all prefixes lie in the Basic
Multilingual Plane (so code-unit order matches code-point order),
that prefixes consist of printable ASCII (0x20-0x7E) in practice,
and that multi-character prefixes are themselves sorted (so taking
the first character as the cover's low bound and the
successor-of-the-last as the cover's high bound is a valid range).
The companion **`getPassStyleCover` exporter** prefaces its return
with a comment warning that **the cover may be an overestimate**:
because there is no smallest or biggest bigint, the bigint cover
must extend down through some adjacent style's high end and up
through some adjacent style's low end, capturing values of the
adjacent styles that a range query then has to filter out. The
overestimate is the price of using a fixed lexicographic range
rather than a per-PassStyle equality check.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L107-L148) at commit `2e933309`.
