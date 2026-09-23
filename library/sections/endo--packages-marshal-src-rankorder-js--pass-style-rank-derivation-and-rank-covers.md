---
title: "`passStyleRanks` derivation and `getPassStyleCover`: deriving the per-PassStyle integer rank and the lexicographic prefix cover from the canonical `passStylePrefixes` table; why RankCovers may be overestimates that need filtering"
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "107-148"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "How rankOrder.js sorts and walks passStylePrefixes to derive per-PassStyle rank index and rank cover; the BMP/printable-ASCII assumption on prefixes; the multi-character-prefix sortedness assertion; why getPassStyleCover advertises that the cover may be an overestimate (no smallest/biggest bigint forces bounding by adjacent style boundaries)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L107-L148) at commit `337d16a8`.
